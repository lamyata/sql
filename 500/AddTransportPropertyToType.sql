create proc AddTransportPropertyToType
	@InternalCompanyCode nvarchar(50),
	@TransportPropertyCode nvarchar(10),
	@TransportTypeCode nvarchar(10),
	@Sequence int
as
	declare @TransportTypeId int
	declare @TransportPropertyId int
begin

set nocount on

select @TransportTypeId = tt.TRANSPORT_TYPE_ID from TRANSPORT_TYPE tt, COMPANY c where tt.INTERNAL_COMPANY_NR = c.COMPANYNR and c.CODE = @InternalCompanyCode and tt.CODE = @TransportTypeCode
select @TransportPropertyId = TRANSPORT_PROPERTY_ID from TRANSPORT_PROPERTY where CODE = @TransportPropertyCode

INSERT INTO [dbo].[TRANSPORT_PROPERTY_DF]
	([TRANSPORT_TYPE_ID]
	,[TRANSPORT_PROPERTY_ID]
	,[MANDATORY]
	,[DEFAULT_VALUE]
	,[CREATE_USER]
	,[CREATE_TIMESTAMP]
	,[UPDATE_USER]
	,[UPDATE_TIMESTAMP]
	,[SEQUENCE])
VALUES
	(@TransportTypeId
	,@TransportPropertyId
	,0 -- MANDATORY
	,null -- DEFAULT_VALUE, nvarchar(255)
	,'system'
	,getdate()
	,'system'
	,getdate()
	,@Sequence
	)

set nocount off
end
go
------------------------------------------------------
create proc CreateOperation
	@OperationCode nvarchar(50),
	@InternalCompanyCode nvarchar(50),
	@OperationTypeDescription nvarchar(250),
	@OperationName nvarchar(250) = null,
	@OperationDescription nvarchar(250) = null
as
	declare @OperationId int
begin

set nocount on
INSERT INTO [dbo].[OPERATION]
           ([NAME]
           ,[DESCRIPTION]
           ,[CODE]
           ,[INTERNAL_COMPANY_ID]
           ,[TYPE_ID]
           ,[STATUS]
           ,[CREATE_USER]
           ,[CREATE_TIMESTAMP]
           ,[UPDATE_USER]
           ,[UPDATE_TIMESTAMP])
     SELECT
           @OperationName
           ,@OperationDescription
           ,@OperationCode
           ,c.COMPANYNR
           ,ot.OPERATION_TYPE_ID
           ,0
           ,'system'
           ,getdate()
           ,'system'
           ,getdate()
	FROM
		COMPANY c, OPERATION_TYPE ot
	WHERE
		c.CODE = @InternalCompanyCode and
		ot.[DESCRIPTION] = @OperationTypeDescription

	set @OperationId = SCOPE_IDENTITY();

if @OperationTypeDescription = 'Discharging'
	INSERT INTO [dbo].[DISCHARGING_OPERATION]
			   ([DISCHARGING_OPERATION_ID]
			   ,[CREATE_USER]
			   ,[CREATE_TIMESTAMP]
			   ,[UPDATE_USER]
			   ,[UPDATE_TIMESTAMP])
		 VALUES
			   (@OperationId
			   ,'system'
			   ,getdate()
			   ,'system'
			   ,getdate())
if @OperationTypeDescription = 'Loading'
INSERT INTO [dbo].[LOADING_OPERATION]
           ([LOADING_OPERATION_ID]
           ,[CREATE_USER]
           ,[CREATE_TIMESTAMP]
           ,[UPDATE_USER]
           ,[UPDATE_TIMESTAMP])
     VALUES
           (@OperationId
           ,'system'
			,getdate()
			,'system'
			,getdate())
if @OperationTypeDescription = 'StockChange'
INSERT INTO [dbo].[STOCK_CHANGE_OPERATION]
           ([STOCK_CHANGE_OPERATION_ID]
           ,[CREATE_USER]
           ,[CREATE_TIMESTAMP]
           ,[UPDATE_USER]
           ,[UPDATE_TIMESTAMP])
     VALUES
           (@OperationId
			,'system'
			,getdate()
			,'system'
			,getdate())

set nocount off
end
go
-------------------------------------------------------

create proc InsertProductUnit
	@UnitCode nvarchar(50),
	@UnitCoeff decimal(16,8),
	@MesurementUnitDescription nvarchar(50)
as
begin

	set nocount on;

	INSERT INTO [dbo].[PRODUCT_UNIT]
		 ([UNIT_ID]
		 ,[COEF]
		 ,[CREATE_USER]
		 ,[CREATE_TIMESTAMP]
		 ,[UPDATE_USER]
		 ,[UPDATE_TIMESTAMP]
		 ,[DEFAULT_MEASUREMENT_UNIT_ID])
		SELECT
		 UNIT_ID
		 ,@UnitCoeff
		 ,'script'
		 ,getdate()
		 ,'script'
		 ,getdate()
		 ,MEASUREMENT_UNIT_ID
		FROM
			UNIT u, MEASUREMENT_UNIT mu
		WHERE
			u.CODE = @UnitCode and
			mu.[DESCRIPTION] = @MesurementUnitDescription

	return SCOPE_IDENTITY();

	set nocount off;

end
go

CREATE proc AddExtraUnitToProduct
	@ProductCode nvarchar(50),
	@UnitCode nvarchar(50),
	@UnitCoeff decimal(16,8),
	@MesurementUnitDescription nvarchar(50)
as
	declare @ExtraProductUnitId int
begin

	set nocount on
				
	exec @ExtraProductUnitId = InsertProductUnit @UnitCode, @UnitCoeff, @MesurementUnitDescription					
					 
	if not @ExtraProductUnitId is null
	INSERT INTO [dbo].[PRODUCT_EXTRA_UNIT]
		 ([PRODUCT_ID]
		 ,[EXTRA_UNIT_ID])
		SELECT
		 PRODUCT_ID
		 ,@ExtraProductUnitId
		FROM PRODUCT
		WHERE CODE = @ProductCode
					 
	set nocount off

end
go

CREATE proc AddStorageUnitToProduct
	@ProductCode nvarchar(50),
	@StorageUnitCode nvarchar(50),
	@StorageUnitCoeff decimal(16,8)
as
	declare @StorageProductUnitId int
begin

	set nocount on

	exec @StorageProductUnitId = InsertProductUnit @StorageUnitCode, @StorageUnitCoeff, null					

	if not @StorageProductUnitId is null
	INSERT INTO [dbo].[PRODUCT_STORAGE_UNIT]
		 ([PRODUCT_ID]
		 ,[STORAGE_UNIT_ID])
		SELECT
		 PRODUCT_ID
		 ,@StorageProductUnitId
		FROM PRODUCT
		WHERE CODE = @ProductCode

	set nocount off

end
go

CREATE proc CreateProduct
	@InternalCompanyCode nvarchar(50),
	@ProductCode nvarchar(50),
	@ShortDesc nvarchar(50),
	@ProductGroupCode char(5),
	@ProductTypeDescription nvarchar(50),
	@BarcodeTypeDescription nvarchar(50),
	@BaseUnitCode nvarchar(50)
as
	declare @ProductGroupId int
	declare @ProductTypeId int
	declare @BarcodeTypeId int
	declare @BaseUnitId int
	declare @BaseProductUnitId int
	declare @ProductId int
	declare @InternalCompanyId int
begin

set nocount on

select @InternalCompanyId = COMPANYNR from COMPANY where CODE like @InternalCompanyCode
select @ProductGroupId = PRODUCT_GROUP_ID from PRODUCT_GROUP where CODE like @ProductGroupCode
select @ProductTypeId = PRODUCT_TYPE_ID from PRODUCT_TYPE where [DESCRIPTION] like @ProductTypeDescription
select @BarcodeTypeId = [BARCODE_TYPE_ID] from BARCODE_TYPE where [DESCRIPTION] like @BarcodeTypeDescription

exec @BaseProductUnitId = InsertProductUnit @BaseUnitCode, null, null

INSERT INTO [dbo].[PRODUCT]
	 ([PRODUCT_GROUP_ID]
	 ,[PRODUCT_TYPE_ID]
	 ,[CODE]
	 ,[SHORT_DESC]
	 ,[LONG_DESC]
	 ,[COMPANYNR]
	 ,[STATUS]
	 ,[BARCODE_TYPE_ID]
	 ,[CREATE_USER]
	 ,[CREATE_TIMESTAMP]
	 ,[UPDATE_USER]
	 ,[UPDATE_TIMESTAMP]
	 ,[BASE_UNIT_ID])
	VALUES
	 (@ProductGroupId
	 ,@ProductTypeId
	 ,@ProductCode
	 ,@ShortDesc
	 ,null -- LONG_DESC
	 ,null -- customer
	 ,1 -- Status: 0 unknown 1 active 2 NotActive
	 ,@BarcodeTypeId
	 ,'script' -- CREATE_USER
	 ,getdate()
	 ,'script' -- UPDATE_USER
	 ,getdate()
	 ,@BaseProductUnitId)
select @ProductId = SCOPE_IDENTITY()

INSERT INTO [dbo].[PRODUCT_INT_COMPANY]
	 ([PRODUCT_ID]
	 ,[INT_COMPANYNR]
	 ,[CREATE_USER]
	 ,[CREATE_TIMESTAMP]
	 ,[UPDATE_USER]
	 ,[UPDATE_TIMESTAMP])
	VALUES
	 (@ProductId
	 ,@InternalCompanyId
	 ,'script'
	 ,getdate()
	 ,'script'
	 ,getdate())
					 
set nocount off

end
go

