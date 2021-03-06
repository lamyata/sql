CREATE procedure [dbo].[CreateProductSIDCompany]
	@ProductCode nvarchar(50),
	@SidCode nvarchar(10),
	@OperationTypes nvarchar(10),
	@SidSequence int,
	@SidDefault nvarchar(255) = null
as
	declare @ProductId int
	declare @ProductSidId int
	declare @OperationType int
	declare @SidId int
	declare @CompanyId int
begin

set nocount on

select @ProductId = PRODUCT_ID from WMS_PRODUCT where CODE like @ProductCode
select @SidId = SID_ID from WMS_SID where CODE like @SidCode
select @CompanyId = COMPANYNR from COMPANY where CODE like @SidDefault

INSERT INTO [dbo].[PRODUCT_STORAGE_IDENTIFIER_TEMP]
		([PRODUCT_ID]
		,[SID_ID]
		,[SID_DEFAULT]
		,[SID_SEQUENCE]
		,[IS_MANDATORY]
		,[CREATE_USER]
		,[CREATE_TIMESTAMP]
		,[UPDATE_USER]
		,[UPDATE_TIMESTAMP])
	VALUES
		(@ProductId
		,@SidId
		,@CompanyId
		,@SidSequence
		,0
		,'script'
		,getdate()
		,'script'
		,getdate())
select @ProductSidId = SCOPE_IDENTITY();

if CHARINDEX('L', @OperationTypes) > 0
begin
	select @OperationType = OPERATION_TYPE_ID from OPERATION_TYPE where DESCRIPTION like 'Loading'
	INSERT INTO [dbo].[PRODUCT_SID_OPERATION_TYPE]
			([PRODUCT_SID_ID]
			,[OPERATION_TYPE_ID])
		VALUES
			(@ProductSidId
			,@OperationType)
end
if CHARINDEX('D', @OperationTypes) > 0
begin
	select @OperationType = OPERATION_TYPE_ID from OPERATION_TYPE where DESCRIPTION like 'Discharging'
	INSERT INTO [dbo].[PRODUCT_SID_OPERATION_TYPE]
			([PRODUCT_SID_ID]
			,[OPERATION_TYPE_ID])
		VALUES
			(@ProductSidId
			,@OperationType)
end
if CHARINDEX('S', @OperationTypes) > 0
begin
	select @OperationType = OPERATION_TYPE_ID from OPERATION_TYPE where DESCRIPTION like 'StockChange'
	INSERT INTO [dbo].[PRODUCT_SID_OPERATION_TYPE]
			([PRODUCT_SID_ID]
			,[OPERATION_TYPE_ID])
		VALUES
			(@ProductSidId
			,@OperationType)
end

set nocount off

end