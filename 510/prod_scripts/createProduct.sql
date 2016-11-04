CREATE procedure [dbo].[CreateProduct]
	@ProductCode nvarchar(50),
	@ShortDesc nvarchar(50),
	@ProductGroupCode char(5),
	@ProductTypeDescription nvarchar(50),
	@BarcodeTypeDescription nvarchar(50),
	@StorageUnitCode nvarchar(50),
	@StorageUnitCoeff decimal(16,8),
	@ExtraUnit1Code nvarchar(50),
	@ExtraUnit1Coeff decimal (16, 8),
	@ExtraUnit1MesurementUnitDescription nvarchar(50),
	@ExtraUnit2Code nvarchar(50),
	@ExtraUnit2Coeff decimal (16, 8),
	@ExtraUnit2MesurementUnitDescription nvarchar(50),
	@BaseUnitCode nvarchar(50) = 'PC'
as
	declare @ProductGroupId int
	declare @ProductTypeId int
	declare @BarcodeTypeId int
	declare @BaseUnitId int
	declare @BaseProductUnitId int
	declare @ProductId int
	declare @StorageUnitId int
	declare @StorageProductUnitId int
	declare @ExtraUnit1Id int
	declare @ExtraUnit1DefaultMeasurementUnitId int
	declare @ExtraUnit2Id int
	declare @ExtraUnit2DefaultMeasurementUnitId int
	declare @InternalCompanyId int
	declare @Extra1ProductUnitId int
	declare @Extra2ProductUnitId int
begin

set nocount on

select top 1 @InternalCompanyId = COMPANYNR from NSCOMPANY order by COMPANYNR
select @ProductGroupId = PRODUCT_GROUP_ID from WMS_PRODUCT_GROUP where CODE like @ProductGroupCode
select @ProductTypeId = PRODUCT_TYPE_ID from WMS_PRODUCT_TYPE where DESCRIPTION like @ProductTypeDescription
select @BarcodeTypeId = [BARCODE_TYPE_ID] from WMS_BARCODE_TYPE where DESCRIPTION like @BarcodeTypeDescription
select @BaseUnitId = UNIT_ID from WMS_UNIT where CODE like @BaseUnitCode
select @StorageUnitId = UNIT_ID from WMS_UNIT where CODE like @StorageUnitCode
select @ExtraUnit1Id = UNIT_ID from WMS_UNIT where CODE like @ExtraUnit1Code
select @ExtraUnit1DefaultMeasurementUnitId = MEASUREMENT_UNIT_ID from MEASUREMENT_UNIT where DESCRIPTION like @ExtraUnit1MesurementUnitDescription
select @ExtraUnit2Id = UNIT_ID from WMS_UNIT where CODE like @ExtraUnit2Code
select @ExtraUnit2DefaultMeasurementUnitId = MEASUREMENT_UNIT_ID from MEASUREMENT_UNIT where DESCRIPTION like @ExtraUnit1MesurementUnitDescription

INSERT INTO [dbo].[PRODUCT_UNIT_TEMP]
	 ([UNIT_ID]
	 ,[COEF]
	 ,[CREATE_USER]
	 ,[CREATE_TIMESTAMP]
	 ,[UPDATE_USER]
	 ,[UPDATE_TIMESTAMP])
	VALUES
	 (@BaseUnitId
	 ,null -- COEF
	 ,'script'
	 ,getdate()
	 ,'script'
	 ,getdate())
select @BaseProductUnitId = SCOPE_IDENTITY()

INSERT INTO [dbo].[PRODUCT_UNIT_TEMP]
	 ([UNIT_ID]
	 ,[COEF]
	 ,[CREATE_USER]
	 ,[CREATE_TIMESTAMP]
	 ,[UPDATE_USER]
	 ,[UPDATE_TIMESTAMP])
	VALUES
	 (@StorageUnitId
	 ,@StorageUnitCoeff
	 ,'script'
	 ,getdate()
	 ,'script'
	 ,getdate())
select @StorageProductUnitId = SCOPE_IDENTITY()

INSERT INTO [dbo].[PRODUCT_UNIT_TEMP]
	 ([UNIT_ID]
	 ,[COEF]
	 ,[CREATE_USER]
	 ,[CREATE_TIMESTAMP]
	 ,[UPDATE_USER]
	 ,[UPDATE_TIMESTAMP]
	 ,[DEFAULT_MEASUREMENT_UNIT_ID])
	VALUES
	 (@ExtraUnit1Id
	 ,@ExtraUnit1Coeff
	 ,'script'
	 ,getdate()
	 ,'script'
	 ,getdate()
	 ,@ExtraUnit1DefaultMeasurementUnitId)
select @Extra1ProductUnitId = SCOPE_IDENTITY()

INSERT INTO [dbo].[PRODUCT_UNIT_TEMP]
	 ([UNIT_ID]
	 ,[COEF]
	 ,[CREATE_USER]
	 ,[CREATE_TIMESTAMP]
	 ,[UPDATE_USER]
	 ,[UPDATE_TIMESTAMP]
	 ,[DEFAULT_MEASUREMENT_UNIT_ID])
	VALUES
	 (@ExtraUnit2Id
	 ,@ExtraUnit2Coeff
	 ,'script'
	 ,getdate()
	 ,'script'
	 ,getdate()
	 ,@ExtraUnit2DefaultMeasurementUnitId)
select @Extra2ProductUnitId = SCOPE_IDENTITY()


INSERT INTO [dbo].[WMS_PRODUCT]
	 ([PRODUCT_GROUP_ID]
	 ,[PRODUCT_TYPE_ID]
	 ,[CODE]
	 ,[SHORT_DESC]
	 ,[LONG_DESC]
	 ,[REPLACEMENT_ID]
	 ,[COMPANYNR]
	 ,[STOCK_LEVEL]
	 ,[STATUS]
	 ,[BARCODE_TYPE_ID]
	 ,[BARCODE]
	 ,[GROSS_USED]
	 ,[GROSS_MANDATORY]
	 ,[NET_USE]
	 ,[NET_MANDATORY]
	 ,[LENGTH_USED]
	 ,[LENGTH_MANDATORY]
	 ,[WIDTH_USED]
	 ,[WIDTH_MANDATORY]
	 ,[HEIGHT_USED]
	 ,[HEIGHT_MANDATORY]
	 ,[CUBAGE_USED]
	 ,[CUBAGE_MANDATORY]
	 ,[CREATE_USER]
	 ,[CREATE_TIMESTAMP]
	 ,[UPDATE_USER]
	 ,[UPDATE_TIMESTAMP]
	 ,[DEFAULT_RESERVATION_METHOD]
	 ,[STOCK_CALCULATION]
	 ,[ADMT_USE]
	 ,[ADMT_MANDATORY]
	 ,[VOLUME_USE]
	 ,[VOLUME_MANDATORY]
	 ,[GROSS_MASK]
	 ,[NET_MASK]
	 ,[ADMT_MASK]
	 ,[VOLUME_MASK]
	 ,[CUSTOMS_IO_UNIT]
	 ,[CUSTOMS_BASE_UNIT]
	 ,[CUSTOMS_GROSS_WEIGHT]
	 ,[CUSTOMS_NET_WEIGHT]
	 ,[CUSTOMS_ADMT]
	 ,[CUSTOMS_VOLUME]
	 ,[BASE_UNIT_ID])
	VALUES
	 (@ProductGroupId
	 ,@ProductTypeId
	 ,@ProductCode
	 ,@ShortDesc
	 ,null -- LONG_DESC
	 ,null -- REPLACEMENT_ID
	 ,null -- customer
	 ,1 -- StockLevel: 0 unknown 1 OneUnit 2 TwoUnits
	 ,1 -- Status: 0 unknown 1 active 2 NotActive
	 ,@BarcodeTypeId
	 ,null -- BARCODE
	 ,0 -- GROSS_USED
	 ,0 -- GROSS_MANDATORY
	 ,0 -- NET_USE
	 ,0 -- NET_MANDATORY
	 ,0 -- LENGTH_USED
	 ,0 -- LENGTH_MANDATORY
	 ,0 -- WIDTH_USED
	 ,0 -- WIDTH_MANDATORY
	 ,0 -- HEIGHT_USED
	 ,0 -- HEIGHT_MANDATORY
	 ,0 -- CUBAGE_USED
	 ,0 -- CUBAGE_MANDATORY
	 ,'script' -- CREATE_USER
	 ,getdate()
	 ,'script' -- UPDATE_USER
	 ,getdate()
	 ,0 -- DefaultReservationMethod: 0 Unknown, 1 Manual, 2 Fifo, 3 Lifo
	 ,0 -- StockCalculation: 0 Unknown, 1 ProductConfiguration, 2 RuleOfThree, 3 NoCalculation
	 ,0 -- ADMT_USE
	 ,0 -- ADMT_MANDATORY
	 ,0 -- VOLUME_USE
	 ,0 -- VOLUME_MANDATORY
	 ,null -- GROSS_MASK
	 ,null -- NET_MASK
	 ,null -- ADMT_MASK
	 ,null -- VOLUME_MASK
	 ,0 -- CUSTOMS_IO_UNIT
	 ,0 -- CUSTOMS_BASE_UNIT
	 ,0 -- CUSTOMS_GROSS_WEIGHT
	 ,0 -- CUSTOMS_NET_WEIGHT
	 ,0 -- CUSTOMS_ADMT
	 ,0 -- CUSTOMS_VOLUME
	 ,@BaseProductUnitId)
select @ProductId = SCOPE_IDENTITY()

INSERT INTO [dbo].[WMS_PRODUCT_INT_COMPANY]
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

-- PRODUCT_STORAGE_UNIT
INSERT INTO [dbo].[PRODUCT_STORAGE_UNIT]
	 ([PRODUCT_ID]
	 ,[STORAGE_UNIT_ID])
	VALUES
	 (@ProductId
	 ,@StorageProductUnitId)
					 
-- PRODUCT_EXTRA_UNIT
INSERT INTO [dbo].[PRODUCT_EXTRA_UNIT]
	 ([PRODUCT_ID]
	 ,[EXTRA_UNIT_ID])
	VALUES
	 (@ProductId
	 ,@Extra1ProductUnitId)

INSERT INTO [dbo].[PRODUCT_EXTRA_UNIT]
	 ([PRODUCT_ID]
	 ,[EXTRA_UNIT_ID])
	VALUES
	 (@ProductId
	 ,@Extra2ProductUnitId)
					 
/* INSERT INTO [dbo].[PRODUCT_LOCATION]
	 ([PRODUCT_ID]
	 ,[LOCATION_ID])
	VALUES
	 (<PRODUCT_ID, int,>
	 ,<LOCATION_ID, int,>)					 
*/					 
					 
set nocount off

end
