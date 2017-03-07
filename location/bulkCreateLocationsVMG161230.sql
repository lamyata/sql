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
		   ,'sys161230'
		   ,getdate()
		   ,'sys161230'
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

exec MakeLocation 'X7A21', 'X7A21', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A22', 'X7A22', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A23', 'X7A23', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A24', 'X7A24', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A25', 'X7A25', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A26', 'X7A26', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A27', 'X7A27', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A28', 'X7A28', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A29', 'X7A29', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A30', 'X7A30', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A31', 'X7A31', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A32', 'X7A32', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A33', 'X7A33', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A34', 'X7A34', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A35', 'X7A35', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A36', 'X7A36', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A37', 'X7A37', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A38', 'X7A38', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A39', 'X7A39', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A40', 'X7A40', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A41', 'X7A41', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A42', 'X7A42', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A43', 'X7A43', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A44', 'X7A44', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A45', 'X7A45', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A46', 'X7A46', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A47', 'X7A47', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A48', 'X7A48', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A49', 'X7A49', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A50', 'X7A50', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A51', 'X7A51', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A52', 'X7A52', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A53', 'X7A53', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A54', 'X7A54', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A55', 'X7A55', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A56', 'X7A56', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A57', 'X7A57', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A58', 'X7A58', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A59', 'X7A59', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A60', 'X7A60', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A61', 'X7A61', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A62', 'X7A62', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7A63', 'X7A63', 'Position', 'X7A', 'IC_VMHZP'
exec MakeLocation 'X7B21', 'X7B21', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B22', 'X7B22', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B23', 'X7B23', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B24', 'X7B24', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B25', 'X7B25', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B26', 'X7B26', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B27', 'X7B27', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B28', 'X7B28', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B29', 'X7B29', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B30', 'X7B30', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B31', 'X7B31', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B32', 'X7B32', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B33', 'X7B33', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B34', 'X7B34', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B35', 'X7B35', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B36', 'X7B36', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B37', 'X7B37', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B38', 'X7B38', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B39', 'X7B39', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B40', 'X7B40', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B41', 'X7B41', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B42', 'X7B42', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B43', 'X7B43', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B44', 'X7B44', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B45', 'X7B45', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B46', 'X7B46', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B47', 'X7B47', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B48', 'X7B48', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B49', 'X7B49', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B50', 'X7B50', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B51', 'X7B51', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B52', 'X7B52', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B53', 'X7B53', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B54', 'X7B54', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B55', 'X7B55', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B56', 'X7B56', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7B57', 'X7B57', 'Position', 'X7B', 'IC_VMHZP'
exec MakeLocation 'X7C21', 'X7C21', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C22', 'X7C22', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C23', 'X7C23', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C24', 'X7C24', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C25', 'X7C25', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C26', 'X7C26', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C27', 'X7C27', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C28', 'X7C28', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C29', 'X7C29', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C30', 'X7C30', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C31', 'X7C31', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C32', 'X7C32', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C33', 'X7C33', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C34', 'X7C34', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C35', 'X7C35', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C36', 'X7C36', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C37', 'X7C37', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C38', 'X7C38', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C39', 'X7C39', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C40', 'X7C40', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C41', 'X7C41', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C42', 'X7C42', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C43', 'X7C43', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C44', 'X7C44', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C45', 'X7C45', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C46', 'X7C46', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C47', 'X7C47', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C48', 'X7C48', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C49', 'X7C49', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C50', 'X7C50', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C51', 'X7C51', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C52', 'X7C52', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C53', 'X7C53', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C54', 'X7C54', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C55', 'X7C55', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C56', 'X7C56', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7C57', 'X7C57', 'Position', 'X7C', 'IC_VMHZP'
exec MakeLocation 'X7D21', 'X7D21', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D22', 'X7D22', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D23', 'X7D23', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D24', 'X7D24', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D25', 'X7D25', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D26', 'X7D26', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D27', 'X7D27', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D28', 'X7D28', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D29', 'X7D29', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D30', 'X7D30', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D31', 'X7D31', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D32', 'X7D32', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D33', 'X7D33', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D34', 'X7D34', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D35', 'X7D35', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D36', 'X7D36', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D37', 'X7D37', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D38', 'X7D38', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D39', 'X7D39', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D40', 'X7D40', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D41', 'X7D41', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D42', 'X7D42', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D43', 'X7D43', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D44', 'X7D44', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D45', 'X7D45', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D46', 'X7D46', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D47', 'X7D47', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D48', 'X7D48', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D49', 'X7D49', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D50', 'X7D50', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D51', 'X7D51', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D52', 'X7D52', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D53', 'X7D53', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D54', 'X7D54', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D55', 'X7D55', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D56', 'X7D56', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7D57', 'X7D57', 'Position', 'X7D', 'IC_VMHZP'
exec MakeLocation 'X7E21', 'X7E21', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E22', 'X7E22', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E23', 'X7E23', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E24', 'X7E24', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E25', 'X7E25', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E26', 'X7E26', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E27', 'X7E27', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E28', 'X7E28', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E29', 'X7E29', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E30', 'X7E30', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E31', 'X7E31', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E32', 'X7E32', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E33', 'X7E33', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E34', 'X7E34', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E35', 'X7E35', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E36', 'X7E36', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E37', 'X7E37', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E38', 'X7E38', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E39', 'X7E39', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E40', 'X7E40', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E41', 'X7E41', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E42', 'X7E42', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E43', 'X7E43', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E44', 'X7E44', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E45', 'X7E45', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E46', 'X7E46', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E47', 'X7E47', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E48', 'X7E48', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E49', 'X7E49', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E50', 'X7E50', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E51', 'X7E51', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E52', 'X7E52', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E53', 'X7E53', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E54', 'X7E54', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E55', 'X7E55', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E56', 'X7E56', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E57', 'X7E57', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E58', 'X7E58', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E59', 'X7E59', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7E60', 'X7E60', 'Position', 'X7E', 'IC_VMHZP'
exec MakeLocation 'X7F21', 'X7F21', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F22', 'X7F22', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F23', 'X7F23', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F24', 'X7F24', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F25', 'X7F25', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F26', 'X7F26', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F27', 'X7F27', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F28', 'X7F28', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F29', 'X7F29', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F30', 'X7F30', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F31', 'X7F31', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F32', 'X7F32', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F33', 'X7F33', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F34', 'X7F34', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F35', 'X7F35', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F36', 'X7F36', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F37', 'X7F37', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F38', 'X7F38', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F39', 'X7F39', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F40', 'X7F40', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F41', 'X7F41', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F42', 'X7F42', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F43', 'X7F43', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F44', 'X7F44', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F45', 'X7F45', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F46', 'X7F46', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F47', 'X7F47', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F48', 'X7F48', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F49', 'X7F49', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F50', 'X7F50', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F51', 'X7F51', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F52', 'X7F52', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F53', 'X7F53', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F54', 'X7F54', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F55', 'X7F55', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F56', 'X7F56', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F57', 'X7F57', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F58', 'X7F58', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F59', 'X7F59', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F60', 'X7F60', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F61', 'X7F61', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F62', 'X7F62', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F63', 'X7F63', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F64', 'X7F64', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F65', 'X7F65', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F66', 'X7F66', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F67', 'X7F67', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F68', 'X7F68', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F69', 'X7F69', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F70', 'X7F70', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F71', 'X7F71', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F72', 'X7F72', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F73', 'X7F73', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F74', 'X7F74', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F75', 'X7F75', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F76', 'X7F76', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F77', 'X7F77', 'Position', 'X7F', 'IC_VMHZP'
exec MakeLocation 'X7F78', 'X7F78', 'Position', 'X7F', 'IC_VMHZP'
go

DROP PROCEDURE [dbo].[MakeLocation]
go
