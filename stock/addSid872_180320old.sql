declare @updateUser varchar(15) = 'la180320';
declare @FujiProductGroupId int = (select PRODUCT_GROUP_ID from PRODUCT_GROUP where CODE = 'FUJI');
declare @FujiQualifSidId int = (select STORAGE_IDENTIFIER_ID from STORAGE_IDENTIFIER where CODE = 'FUJI_QUALIF');

declare @maxSequences table (ProdId int, Seq int)
insert into @maxSequences
	select psi.PRODUCT_ID, max(psi.SID_SEQUENCE)
	from PRODUCT_STORAGE_IDENTIFIER psi join PRODUCT_GROUP_PRODUCT pgp on psi.PRODUCT_ID = pgp.PRODUCT_ID and pgp.PRODUCT_GROUP_ID = @FujiProductGroupId
	group by psi.PRODUCT_ID 

INSERT INTO [dbo].[PRODUCT_STORAGE_IDENTIFIER]
           ([PRODUCT_ID]
           ,[SID_ID]
           ,[SID_SEQUENCE]
           ,[IS_MANDATORY]
           ,[CREATE_USER]
           ,[CREATE_TIMESTAMP]
           ,[UPDATE_USER]
           ,[UPDATE_TIMESTAMP])
     SELECT
           PRODUCT_ID
           ,@FujiQualifSidId
           ,ms.Seq + 10
           ,0 -- IS_MANDATORY
           ,@updateUser
		   ,GETDATE()
		   ,@updateUser
		   ,GETDATE()
	FROM PRODUCT_GROUP_PRODUCT pgp, @maxSequences ms
	WHERE pgp.PRODUCT_GROUP_ID = @FujiProductGroupId
	AND ms.ProdId = pgp.PRODUCT_ID

INSERT INTO [dbo].[PRODUCT_SID_OPERATION_TYPE]
        ([PRODUCT_SID_ID]
        ,[OPERATION_TYPE_ID])
    SELECT
		psi.PRODUCT_STORAGE_IDENTIFIER_ID,
		ot.OPERATION_TYPE_ID
	FROM PRODUCT_STORAGE_IDENTIFIER psi, PRODUCT_GROUP_PRODUCT pgp, OPERATION_TYPE ot
	WHERE psi.PRODUCT_ID = pgp.PRODUCT_ID and pgp.PRODUCT_GROUP_ID = @FujiProductGroupId and psi.SID_ID = @FujiQualifSidId
		and ot.[DESCRIPTION] = 'Additional'		

INSERT INTO [dbo].[STOCK_INFO_SID]
        ([SID_ID]
        ,[STOCK_INFO_CONFIG_ID]
        ,[CREATE_USER]
        ,[CREATE_TIMESTAMP]
        ,[UPDATE_USER]
        ,[UPDATE_TIMESTAMP])
     SELECT
		@FujiQualifSidId
		,sic.STOCK_INFO_CONFIG_ID
		,@updateUser
		,GETDATE()
		,@updateUser
		,GETDATE()
	FROM PRODUCT_STORAGE_IDENTIFIER psi, PRODUCT_GROUP_PRODUCT pgp, STOCK_INFO_CONFIG sic
	WHERE psi.PRODUCT_ID = pgp.PRODUCT_ID and pgp.PRODUCT_GROUP_ID = @FujiProductGroupId and psi.SID_ID = @FujiQualifSidId
		and psi.PRODUCT_ID = sic.PRODUCT_ID
		
exec [dbo].[TOGGLE_NONCLUSTERED_INDEXES_FOR_TABLE] 'STOCK_INFO_CONFIG', 0

-- Update SIC key + Hash
update sic
set @new_key = (
		'{"IC":' + ISNULL(CAST(sic.INTERNAL_COMPANY_ID as nvarchar), @nullString) + 
		',"O":'  + ISNULL(CAST(sic.OWNER_ID as nvarchar), @nullString) + 
		',"P":'  + ISNULL(CAST(sic.PRODUCT_ID as nvarchar), @nullString) +
		',"L":'  + ISNULL(CAST(sic.LOCATION_ID as nvarchar), @nullString) + 
		',"BU":'  + ISNULL(CAST(sic.BASE_UNIT_ID as nvarchar), @nullString) + 
		',"TN":"'  + ISNULL(sic.TRACKING_NUMBER, @emptyString)  + '"' +
		',"IN":"'  + ISNULL(sic.INVENTORY_NUMBER, @emptyString)  + '"' +
		',"LOT":"'  + ISNULL(sic.LOT, @emptyString)  + '"' +
		',"PD":'  + ISNULL(CONVERT(nvarchar, sic.PRODUCTION_DATE, 112), @nullString) + 
		',"ED":'  + ISNULL(CONVERT(nvarchar, sic.EXPIRY_DATE, 112), @nullString) + 
		',"DI":'  + ISNULL(CONVERT(nvarchar, sic.DATE_IN, 112), @nullString) + 
		',"ST":'  + CAST(sic.STATUS as nvarchar) +
		',"SU":'  + ISNULL(CAST(sic.STORAGE_UNIT_ID as nvarchar), @nullString) + 
		',"ITN":"'  + ISNULL(sic.ITEM_NUMBER, @emptyString)  + '"' +
		',"PU":"'  + ISNULL(sic.PACKAGING_UNIT, @emptyString)  + '"' +
		',"SHU":"'  + ISNULL(sic.PICKING_LIST, @emptyString)  + '"' +
		',"EU":['  + ISNULL([dbo].[JOIN_SIC_EXTRA_UNITS](sic.STOCK_INFO_CONFIG_ID), @emptyString) + ']' +  
		',"S":['  + ISNULL([dbo].[JOIN_SIC_SIDS](sic.STOCK_INFO_CONFIG_ID), @emptyString) + ']}'),
	sic._KEY_ = @new_key,
	sic.HASH_KEY = CAST(hashbytes('SHA1', @new_key) AS BINARY(20))
FROM STOCK_INFO_CONFIG sic, PRODUCT_GROUP_PRODUCT pgp
WHERE sic.PRODUCT_ID = pgp.PRODUCT_ID and pgp.PRODUCT_GROUP_ID = @FujiProductGroupId

exec [dbo].[TOGGLE_NONCLUSTERED_INDEXES_FOR_TABLE] 'STOCK_INFO_CONFIG', 1

-- after that rebuild stock and reservations indexes