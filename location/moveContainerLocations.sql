CREATE PROCEDURE [dbo].[MakeLocation]
	@Address nvarchar(20),
	@Code nvarchar(15),
	@LocationTypeName nvarchar(100),
	@ParentAddress nvarchar(20),
	@IcCompanyCode nvarchar(20)
AS
	declare @LocationTypeId int
	declare @ParentId int
	declare @HierarchiLevel int = 0
	declare @Path nvarchar(250)
	declare @PlainPath nvarchar(250)
BEGIN

	if exists (select 1 from [LOCATION] where ADDRESS = @Address) return
	
	select @LocationTypeId = LOCATION_TYPE_ID from LOCATION_TYPE where NAME = @LocationTypeName

	select
		@ParentId = LOCATION_ID,
		@HierarchiLevel = HIERARCHY_LEVEL + 1,
		@PlainPath = IsNull([PLAIN_PATH],'|') + CODE +'|',
		@Path = IsNull([PATH],'|') + cast(LOCATION_ID as nvarchar(20)) + '|'
	from
		LOCATION
	where
		[ADDRESS] = @ParentAddress

	INSERT INTO [dbo].[LOCATION]
			([CODE]
			,[ADDRESS]
			,[STATUS]
			,[HAS_CHILDREN]
			,[LOCATION_TYPE_ID]
			,[HIERARCHY_LEVEL]
			,[PARENT_ID]
			,[PATH]
			,[PLAIN_PATH]
			,[CREATE_USER]
			,[CREATE_TIMESTAMP]
			,[UPDATE_USER]
			,[UPDATE_TIMESTAMP])
	 VALUES
		   (@Code
		   ,@Address
		   ,0
		   ,0
		   ,@LocationTypeId
		   ,@HierarchiLevel
		   ,@ParentId
		   ,@Path
		   ,@PlainPath
		   ,'sys170110'
		   ,getdate()
		   ,'sys170110'
		   ,getdate())

	-- Update parent's "HasChildren" property
	UPDATE LOCATION
	SET HAS_CHILDREN = 1
	WHERE LOCATION_ID IN
	(
		SELECT PARENT_ID FROM LOCATION
		WHERE STATUS = 0 AND PARENT_ID IS NOT NULL AND PARENT_ID = @ParentId
		GROUP BY PARENT_ID
	)
	
	insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID])
	select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS =@Address and c.CODE = @IcCompanyCode

END
go


declare @cntRootLocationAddress nvarchar(20) = 'CONTAINERS'
declare @sysLocationAddress nvarchar(20) = 'System'

exec MakeLocation @sysLocationAddress, 'SYS', 'System', null, 'IC_AXL'

declare @cntRootLocationId int = (select LOCATION_ID from LOCATION where ADDRESS = @cntRootLocationAddress);
declare @sysLocationId int = (select LOCATION_ID from LOCATION where ADDRESS = @sysLocationAddress);

declare @notUsedLocationIds table (ID int)
insert into @notUsedLocationIds select LOCATION_ID from LOCATION l where PARENT_ID = @cntRootLocationId
	and not exists (select * from STOCK_INFO_CONFIG where LOCATION_ID = l.LOCATION_ID)
delete nu from @notUsedLocationIds nu join LOADING_ORDER_ITEM loi on nu.ID = loi.LOCATION_ID;
delete nu from @notUsedLocationIds nu join DISCHARGING_ORDER_ITEM doi on nu.ID = doi.LOCATION_ID;

delete lpv from LOCATION_PROP_VALUE lpv join @notUsedLocationIds nu on lpv.LOCATION_ID = nu.ID;
delete lic from LOCATION_INTERNAL_COMPANY lic join @notUsedLocationIds nu on lic.LOCATION_ID = nu.ID
delete l from LOCATION l join @notUsedLocationIds nu on l.LOCATION_ID = nu.ID

update LOCATION set
	PARENT_ID = @sysLocationId,
	[PATH] = '|' + cast(@sysLocationId as nvarchar(20)) + '|',
	PLAIN_PATH = '|SYS|',
	UPDATE_USER = 'sys170117',
	UPDATE_TIMESTAMP = getdate()
where PARENT_ID = @cntRootLocationId

drop proc [dbo].[MakeLocation]