CREATE proc #CreateProduct
	@ProductCode nvarchar(50),
	@ShortDesc nvarchar(50),
	@ProductGroupCode char(5),
	@ProductTypeDescription nvarchar(50),
	@BarcodeTypeDescription nvarchar(50),
	@BaseUnitCode nvarchar(50),
	@StorageUnitCode nvarchar(50) = null,
	@StorageUnitCoeff decimal(16,8) = 0,
	@ExtraUnit1Code nvarchar(50) = null,
	@ExtraUnit1Coeff decimal (16, 8) = 0,
	@ExtraUnit1MesurementUnitDescription nvarchar(50) = null,
	@ExtraUnit2Code nvarchar(50) = null,
	@ExtraUnit2Coeff decimal (16, 8) = 0,
	@ExtraUnit2MesurementUnitDescription nvarchar(50) = null
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

if not exists (select * from PRODUCT_KIT where CODE = @ProductCode)
begin
	return
end

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

if not @StorageUnitId is null
begin
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
end

if not @ExtraUnit1Id is null
begin
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
end

if  not @ExtraUnit2Id is null
begin
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
end

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
if not @StorageProductUnitId is null
INSERT INTO [dbo].[PRODUCT_STORAGE_UNIT]
	 ([PRODUCT_ID]
	 ,[STORAGE_UNIT_ID])
	VALUES
	 (@ProductId
	 ,@StorageProductUnitId)
					 
-- PRODUCT_EXTRA_UNIT
if not @Extra1ProductUnitId is null
INSERT INTO [dbo].[PRODUCT_EXTRA_UNIT]
	 ([PRODUCT_ID]
	 ,[EXTRA_UNIT_ID])
	VALUES
	 (@ProductId
	 ,@Extra1ProductUnitId)

if not @Extra2ProductUnitId is null
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
go


exec #CreateProduct '00601301','E-TECH S 380 28.8 KW (OTHERS)','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',250,'Kg','Gross',250,'Kg'
exec #CreateProduct '00624201','E-TECH P 57 (V07)','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',123,'Kg','Gross',123,'Kg'
exec #CreateProduct '00624301','E-TECH P 115 (V07)','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',123,'Kg','Gross',123,'Kg'
exec #CreateProduct '00624401','E-TECH P 144 (V07)','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',141,'Kg','Gross',141,'Kg'
exec #CreateProduct '00624501','E-TECH P 259 (V07)','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',200,'Kg','Gross',200,'Kg'
exec #CreateProduct '00624801','E-TECH P 201 (V07)','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',204,'Kg','Gross',204,'Kg'
exec #CreateProduct '00628501','E-TECH W 15 (TRI)','ACV','FP','SerialNr_Code_PY','PCS','PAL',6,'Net',45,'Kg','Gross',45,'Kg'
exec #CreateProduct '00628601','E-TECH W 22 (TRI)','ACV','FP','SerialNr_Code_PY','PCS','PAL',6,'Net',45.6,'Kg','Gross',45.6,'Kg'
exec #CreateProduct '00628801','E-TECH W 09 (TRI)','ACV','FP','SerialNr_Code_PY','PCS','PAL',6,'Net',45,'Kg','Gross',45,'Kg'
exec #CreateProduct '00628901','E-TECH W 28 (TRI)','ACV','FP','SerialNr_Code_PY','PCS','PAL',6,'Net',45,'Kg','Gross',45,'Kg'
exec #CreateProduct '00629001','E-TECH W 36 (TRI)','ACV','FP','SerialNr_Code_PY','PCS','PAL',6,'Net',45,'Kg','Gross',45,'Kg'
exec #CreateProduct '00630101','E-TECH W 09 (MONO)','ACV','FP','SerialNr_Code_PY','PCS','PAL',6,'Net',45,'Kg','Gross',45,'Kg'
exec #CreateProduct '00630201','E-TECH W 15 (MONO)','ACV','FP','SerialNr_Code_PY','PCS','PAL',6,'Net',45,'Kg','Gross',45,'Kg'
exec #CreateProduct '00649201','E-TECH S 160 TRI V13','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',119,'Kg','Gross',119,'Kg'
exec #CreateProduct '00649301','E-TECH S 160 MONO V13','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',119,'Kg','Gross',119,'Kg'
exec #CreateProduct '00649401','E-TECH S 240 TRI V13','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',150,'Kg','Gross',150,'Kg'
exec #CreateProduct '00649501','E-TECH S 380 TRI','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',250,'Kg','Gross',250,'Kg'
exec #CreateProduct '01131113','N-mini','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',70,'Kg','Gross',70,'Kg'
exec #CreateProduct '01647001','HEAT MASTER 200 F RIELL + CRT/BRNR/CHMNY','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',511,'Kg','Gross',511,'Kg'
exec #CreateProduct '01647401','N1 V13','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',116,'Kg','Gross',116,'Kg'
exec #CreateProduct '01647501','N2 V13','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',129,'Kg','Gross',129,'Kg'
exec #CreateProduct '01647601','N3 V13','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',167,'Kg','Gross',167,'Kg'
exec #CreateProduct '01647701','BNE 1 V13','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',184,'Kg','Gross',184,'Kg'
exec #CreateProduct '01647801','BNE 2 V13','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',199,'Kg','Gross',199,'Kg'
exec #CreateProduct '02646801','HEAT MASTER 71 V13','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',313,'Kg','Gross',313,'Kg'
exec #CreateProduct '02646901','HEAT MASTER 101 V13','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',387,'Kg','Gross',387,'Kg'
exec #CreateProduct '02646913','HEAT MASTER 101 V13 NL','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',387,'Kg','Gross',387,'Kg'
exec #CreateProduct '02647001','HEAT MASTER 201 + CRT/BRNR/CHMNEY','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',511,'Kg','Gross',511,'Kg'
exec #CreateProduct '02647013','HEAT MASTER 201 NL + CRT/BRNR/CHMNY','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',511,'Kg','Gross',511,'Kg'
exec #CreateProduct '03604401','HEAT MASTER 101 PROPANE','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',385,'Kg','Gross',385,'Kg'
exec #CreateProduct '03626501','PRESTIGE 18 Solo MK3 GP PROPANE','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',56,'Kg','Gross',56,'Kg'
exec #CreateProduct '03626601','PRESTIGE 32 Solo MK3 GP PROPANE','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',58,'Kg','Gross',58,'Kg'
exec #CreateProduct '03627601','PRESTIGE 18 EXCELLENCE MK3 GP PROPANE','ACV','FP','SerialNr_Code_PY','PCS','PAL',2,'Net',80,'Kg','Gross',80,'Kg'
exec #CreateProduct '03627701','PRESTIGE 32 EXCELLENCE MK3 GP PROPANE','ACV','FP','SerialNr_Code_PY','PCS','PAL',2,'Net',80,'Kg','Gross',80,'Kg'
exec #CreateProduct '03627901','HEAT MASTER 25 C PROPANE','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',149,'Kg','Gross',149,'Kg'
exec #CreateProduct '03642401','HEAT MASTER 25 TC PROPANE','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',170,'Kg','Gross',170,'Kg'
exec #CreateProduct '03642501','HEAT MASTER 45 TC PROPANE','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',169,'Kg','Gross',169,'Kg'
exec #CreateProduct '03642601','HEAT MASTER 120 TC PROPANE','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',324,'Kg','Gross',324,'Kg'
exec #CreateProduct '03646301','HEAT MASTER 35 TC V13 PROPANE','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',169,'Kg','Gross',169,'Kg'
exec #CreateProduct '03646401','HEAT MASTER 85 TC V13 PROPANE','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',318,'Kg','Gross',318,'Kg'
exec #CreateProduct '03646501','HEAT MASTER 70 TC V13 PROPANE','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',318,'Kg','Gross',318,'Kg'
exec #CreateProduct '03649601','HEAT MASTER 25 C V13 PROPANE','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',162,'Kg','Gross',162,'Kg'
exec #CreateProduct '03651401','Heat Master 25 TC LG V14','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',166,'Kg','Gross',166,'Kg'
exec #CreateProduct '04120101','CA 100 + CRATE','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',374,'Kg','Gross',374,'Kg'
exec #CreateProduct '04120201','CA 150 + CRATE','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',421,'Kg','Gross',421,'Kg'
exec #CreateProduct '04120301','CA 200 + CRATE','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',538,'Kg','Gross',538,'Kg'
exec #CreateProduct '04120401','CA 250 + CRATE','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',709,'Kg','Gross',709,'Kg'
exec #CreateProduct '04120501','CA 300 + CRATE','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',785,'Kg','Gross',785,'Kg'
exec #CreateProduct '04120601','CA 350 + CRATE','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',850,'Kg','Gross',850,'Kg'
exec #CreateProduct '04120701','CA 400 + CRATE','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',1069,'Kg','Gross',1069,'Kg'
exec #CreateProduct '04120801','CA 500 + CRATE','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',1154,'Kg','Gross',1154,'Kg'
exec #CreateProduct '04120901','CA 600 + CRATE','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',1346,'Kg','Gross',1346,'Kg'
exec #CreateProduct '04121001','CA 700 + CRATE','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',1480,'Kg','Gross',1480,'Kg'
exec #CreateProduct '04121101','CA 800 + CRATE','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',1670,'Kg','Gross',1670,'Kg'
exec #CreateProduct '04121201','CA 900 + CRATE','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',2005,'Kg','Gross',2005,'Kg'
exec #CreateProduct '04121301','CA 1000 + CRATE','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',2120,'Kg','Gross',2120,'Kg'
exec #CreateProduct '04633201','DELTA PRO S 25','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',151,'Kg','Gross',151,'Kg'
exec #CreateProduct '04633301','DELTA PRO S 45','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',176,'Kg','Gross',176,'Kg'
exec #CreateProduct '04633401','DELTA PRO S 55','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',195,'Kg','Gross',195,'Kg'
exec #CreateProduct '04633501','DELTA PRO PACK 25','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',207,'Kg','Gross',207,'Kg'
exec #CreateProduct '04633601','DELTA PRO PACK 45','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',231,'Kg','Gross',231,'Kg'
exec #CreateProduct '04646601','HEAT MASTER 60 N V13','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',216,'Kg','Gross',216,'Kg'
exec #CreateProduct '04646701','HEAT MASTER 30 N V13','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',216,'Kg','Gross',216,'Kg'
exec #CreateProduct '04646801','HEAT MASTER 70 N V13','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',297,'Kg','Gross',297,'Kg'
exec #CreateProduct '04646901','HEAT MASTER 100 N V13','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',359,'Kg','Gross',359,'Kg'
exec #CreateProduct '04647001','HEAT MASTER 200 N V13 + CRATE + CHIMNEY','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',550,'Kg','Gross',550,'Kg'
exec #CreateProduct '05130601','N2 CONDENS WITHOUT BURNER','ACV','FP','SerialNr_Code_PY','PCS','PAL',2,'Net',150,'Kg','Gross',150,'Kg'
exec #CreateProduct '05130901','BNE2 CONDENS WITHOUT BURNER','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',227,'Kg','Gross',227,'Kg'
exec #CreateProduct '05610501','PRESTIGE 50 SOLO (OTHERS)','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',68,'Kg','Gross',68,'Kg'
exec #CreateProduct '05626501','Prestige 18 Solo MK3','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',58,'Kg','Gross',58,'Kg'
exec #CreateProduct '05626601','Prestige 32 Solo MK3','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',58,'Kg','Gross',58,'Kg'
exec #CreateProduct '05627601','Prestige 18 Excellence MK3','ACV','FP','SerialNr_Code_PY','PCS','PAL',2,'Net',80,'Kg','Gross',80,'Kg'
exec #CreateProduct '05627701','Prestige 32 Excellence MK3','ACV','FP','SerialNr_Code_PY','PCS','PAL',2,'Net',80,'Kg','Gross',80,'Kg'
exec #CreateProduct '05629801','PRESTIGE 50 SOLO MK4','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',58,'Kg','Gross',58,'Kg'
exec #CreateProduct '05629901','PRESTIGE 75 SOLO MK4','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',63,'Kg','Gross',63,'Kg'
exec #CreateProduct '05630001','PRESTIGE 120 SOLO MK4','ACV','FP','SerialNr_Code_PY','PCS','PAL',2,'Net',98,'Kg','Gross',98,'Kg'
exec #CreateProduct '05642401','HEAT MASTER 25 TC','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',170,'Kg','Gross',170,'Kg'
exec #CreateProduct '05642501','HEAT MASTER 45 TC','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',169,'Kg','Gross',169,'Kg'
exec #CreateProduct '05642513','HEAT MASTER 45 TC NL','ACV','FP','SerialNr_Code_PY','PCS', null, 0 --------------------------------------------------------------------------
exec #CreateProduct '05642601','HEAT MASTER 120 TC','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',324,'Kg','Gross',324,'Kg'
exec #CreateProduct '05642613','HEAT MASTER 120 TC NL','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',324,'Kg','Gross',324,'Kg'
exec #CreateProduct '05646301','HEAT MASTER 35 TC V13','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',169,'Kg','Gross',169,'Kg'
exec #CreateProduct '05646313','HEAT MASTER 35 TC V13 NL','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',169,'Kg','Gross',169,'Kg'
exec #CreateProduct '05646401','HEAT MASTER 85 TC V13','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',318,'Kg','Gross',318,'Kg'
exec #CreateProduct '05646413','HEAT MASTER 85 TC V13 NL','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',318,'Kg','Gross',318,'Kg'
exec #CreateProduct '05646501','HEAT MASTER 70 TC V13','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',318,'Kg','Gross',318,'Kg'
exec #CreateProduct '05647901','PRESTIGE 24 Solo MK4','ACV','FP','SerialNr_Code_PY','PCS', null, 0
exec #CreateProduct '05648001','PRESTIGE 32 Solo MK4','ACV','FP','SerialNr_Code_PY','PCS', null, 0
exec #CreateProduct '05648101','PRESTIGE 24 Excellence MK4','ACV','FP','SerialNr_Code_PY','PCS', null, 0
exec #CreateProduct '05648201','PRESTIGE 32 Excellence MK4','ACV','FP','SerialNr_Code_PY','PCS', null, 0
exec #CreateProduct '05648301','PRESTIGE 30/45 Combi MK4','ACV','FP','SerialNr_Code_PY','PCS', null, 0
exec #CreateProduct '05648401','PRESTIGE 100 Solo MK4','ACV','FP','SerialNr_Code_PY','PCS','PAL',2,'Net',95,'Kg','Gross',95,'Kg'
exec #CreateProduct '05649601','HEAT MASTER 25 C V13','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',162,'Kg','Gross',162,'Kg'
exec #CreateProduct '05650201','PRESTIGE 50 SOLO MK4','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',55,'Kg','Gross',55,'Kg'
exec #CreateProduct '05651401','Heat Master 25 TC V14 ','ACV','FP','SerialNr_Code_PY','PCS','PAL',1,'Net',166,'Kg','Gross',166,'Kg'
exec #CreateProduct '06202101','ECO 160','ACV','FP','SerialNr_Code_PY','PCS','PAL',6,'Net',57,'Kg','Gross',57,'Kg'
exec #CreateProduct '06508001','SMART 320L DUPLEX DARK GREY','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',112,'Kg','Gross',112,'Kg'
exec #CreateProduct '06508101','SMART 420L DUPLEX DARK GREY','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',145,'Kg','Gross',145,'Kg'
exec #CreateProduct '06508201','SMART 600L DUPLEX DARK GREY','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',205,'Kg','Gross',205,'Kg'
exec #CreateProduct '06509701','SLEW 160 DUPLEX DARK GREY','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',65,'Kg','Gross',65,'Kg'
exec #CreateProduct '06510701','HRs 321 DUPLEX + kit d''emballage','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',107,'Kg','Gross',107,'Kg'
exec #CreateProduct '06510801','HRs 601 DUPLEX + kit d''emballage','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',192,'Kg','Gross',192,'Kg'
exec #CreateProduct '06602401','SMART 100L DARK GREY','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',43,'Kg','Gross',43,'Kg'
exec #CreateProduct '06602501','SMART 130L DARK GREY','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',48.5,'Kg','Gross',48.5,'Kg'
exec #CreateProduct '06602601','SMART 160L DARK GREY','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',56,'Kg','Gross',56,'Kg'
exec #CreateProduct '06602701','SMART 210L DARK GREY','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',66.5,'Kg','Gross',66.5,'Kg'
exec #CreateProduct '06602801','SMART 240L DARK GREY','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',77.5,'Kg','Gross',77.5,'Kg'
exec #CreateProduct '06605201','SLE 300L DARK GREY','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',84,'Kg','Gross',84,'Kg'
exec #CreateProduct '06618501','SMART 320L DARK GREY','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',115,'Kg','Gross',115,'Kg'
exec #CreateProduct '06618594','SMART 320L DARK GREY (UK)','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',112,'Kg','Gross',112,'Kg'
exec #CreateProduct '06618601','SMART 420L DARK GREY','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',142,'Kg','Gross',142,'Kg'
exec #CreateProduct '06618694','SMART 420L DARK GREY (UK)','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',145,'Kg','Gross',145,'Kg'
exec #CreateProduct '06618801','SLE 130L DARK GREY','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',45,'Kg','Gross',45,'Kg'
exec #CreateProduct '06618901','SLE 160L DARK GREY','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',51.5,'Kg','Gross',51.5,'Kg'
exec #CreateProduct '06619001','SLE 210L DARK GREY','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',62.5,'Kg','Gross',62.5,'Kg'
exec #CreateProduct '06619101','SLE 240L DARK GREY','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',75,'Kg','Gross',75,'Kg'
exec #CreateProduct '06619301','SMART 600L DARK GREY','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',218,'Kg','Gross',218,'Kg'
exec #CreateProduct '06623501','SLEW 100 DARK GREY','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',45,'Kg','Gross',45,'Kg'
exec #CreateProduct '06623601','SLEW 130 DARK GREY','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',50,'Kg','Gross',50,'Kg'
exec #CreateProduct '06623701','SLEW 160 DARK GREY','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',58,'Kg','Gross',58,'Kg'
exec #CreateProduct '06623801','SLEW 210 DARK GREY','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',66,'Kg','Gross',66,'Kg'
exec #CreateProduct '06623901','SLEW 240 DARK GREY','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',75,'Kg','Gross',75,'Kg'
exec #CreateProduct '06624601','SLME 400 DARK GREY','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',111,'Kg','Gross',111,'Kg'
exec #CreateProduct '06624901','SLME 120 DARK GREY','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',63,'Kg','Gross',63,'Kg'
exec #CreateProduct '06625101','SLME 200 DARK GREY','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',72,'Kg','Gross',72,'Kg'
exec #CreateProduct '06625201','SLME 300 DARK GREY','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',114,'Kg','Gross',114,'Kg'
exec #CreateProduct '06625301','SLME 800 DARK GREY+ kit emballage','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',220,'Kg','Gross',220,'Kg'
exec #CreateProduct '06627301','SLE + 210 DARK GREY','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',63.5,'Kg','Gross',63.5,'Kg'
exec #CreateProduct '06627401','SLE + 240 DARK GREY','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',77.5,'Kg','Gross',77.5,'Kg'
exec #CreateProduct '06627501','SLE + 300 DARK GREY','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',84.5,'Kg','Gross',84.5,'Kg'
exec #CreateProduct '06628001','DRAIN-BACK 200L STD','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',60,'Kg','Gross',60,'Kg'
exec #CreateProduct '06631201','COMFORT 100L','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',35,'Kg','Gross',35,'Kg'
exec #CreateProduct '06631301','COMFORT 130L','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',39,'Kg','Gross',39,'Kg'
exec #CreateProduct '06631401','COMFORT 160L','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',45,'Kg','Gross',45,'Kg'
exec #CreateProduct '06631501','COMFORT 210L','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',58,'Kg','Gross',58,'Kg'
exec #CreateProduct '06631601','COMFORT 240L','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',68,'Kg','Gross',68,'Kg'
exec #CreateProduct '06632101','HRi 321','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',160,'Kg','Gross',160,'Kg'
exec #CreateProduct '06632201','HRi 601','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',280,'Kg','Gross',280,'Kg'
exec #CreateProduct '06632301','HRi 800','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',346,'Kg','Gross',346,'Kg'
exec #CreateProduct '06632801','HRs 321 + kit d''emballage','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',107,'Kg','Gross',107,'Kg'
exec #CreateProduct '06632901','HRs 601 + kit d''emballage','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',192,'Kg','Gross',192,'Kg'
exec #CreateProduct '06633001','HRs 800 + kit d''emballage','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',271,'Kg','Gross',271,'Kg'
exec #CreateProduct '06633101','HRs 1000 + kit d''emballage','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',317,'Kg','Gross',317,'Kg'
exec #CreateProduct '06633701','LCA 500 1CO TP 110mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',177,'Kg','Gross',177,'Kg'
exec #CreateProduct '06633801','LCA 750 1CO TP 110mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',256,'Kg','Gross',256,'Kg'
exec #CreateProduct '06633901','LCA 1000 1CO TP 110mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',326,'Kg','Gross',326,'Kg'
exec #CreateProduct '06634001','LCA 1500 1CO TP 110mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',458,'Kg','Gross',458,'Kg'
exec #CreateProduct '06634101','LCA 2000 1CO TP 110mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',489,'Kg','Gross',489,'Kg'
exec #CreateProduct '06634201','LCA 2500 1CO TP 110mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',640,'Kg','Gross',640,'Kg'
exec #CreateProduct '06634301','LCA 3000 1CO TP 110mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',662,'Kg','Gross',662,'Kg'
exec #CreateProduct '06634401','LCA 500 TP 110mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',124,'Kg','Gross',124,'Kg'
exec #CreateProduct '06634501','LCA 750 TP 110mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',231,'Kg','Gross',231,'Kg'
exec #CreateProduct '06634601','LCA 1000 TP 110mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',247,'Kg','Gross',247,'Kg'
exec #CreateProduct '06634701','LCA 1500 TP 110mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',365,'Kg','Gross',365,'Kg'
exec #CreateProduct '06634801','LCA 2000 TP 110mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',394,'Kg','Gross',394,'Kg'
exec #CreateProduct '06634901','LCA 2500 TP 110mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',521,'Kg','Gross',521,'Kg'
exec #CreateProduct '06635001','LCA 3000 TP 110mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',548,'Kg','Gross',548,'Kg'
exec #CreateProduct '06635101','LCA 500 2CO TP 110mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',176,'Kg','Gross',176,'Kg'
exec #CreateProduct '06635201','LCA 750 2CO TP 110mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',295,'Kg','Gross',295,'Kg'
exec #CreateProduct '06635301','LCA 1000 2CO TP 110mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',317,'Kg','Gross',317,'Kg'
exec #CreateProduct '06635401','LCA 1500 2CO TP 110mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',428,'Kg','Gross',428,'Kg'
exec #CreateProduct '06635501','LCA 2000 2CO TP 110mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',453,'Kg','Gross',453,'Kg'
exec #CreateProduct '06635601','LCA 2500 2CO TP 110mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',605,'Kg','Gross',605,'Kg'
exec #CreateProduct '06635701','LCA 3000 2CO TP 110mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',645,'Kg','Gross',645,'Kg'
exec #CreateProduct '06635801','LCA 500 P','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',112,'Kg','Gross',112,'Kg'
exec #CreateProduct '06635901','LCA 750 P','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',157,'Kg','Gross',157,'Kg'
exec #CreateProduct '06636001','LCA 1000 P','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',192,'Kg','Gross',192,'Kg'
exec #CreateProduct '06636101','LCA 1500 P','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',314,'Kg','Gross',314,'Kg'
exec #CreateProduct '06636201','LCA 2000 P','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',330,'Kg','Gross',330,'Kg'
exec #CreateProduct '06636301','LCA 2500 P','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',516,'Kg','Gross',516,'Kg'
exec #CreateProduct '06636401','LCA 3000 P','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',536,'Kg','Gross',536,'Kg'
exec #CreateProduct '06636501','LCA 300 1CO TP 110mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',127,'Kg','Gross',127,'Kg'
exec #CreateProduct '06636601','LCA 300 TP 110mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',96,'Kg','Gross',96,'Kg'
exec #CreateProduct '06636701','LCA 300 2CO TP 110mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',139,'Kg','Gross',139,'Kg'
exec #CreateProduct '06636801','LCA 300 P','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',93,'Kg','Gross',93,'Kg'
exec #CreateProduct '06637101','LCA 750 1CO TH 400mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',295,'Kg','Gross',295,'Kg'
exec #CreateProduct '06637201','LCA 1000 1CO TH 400mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',362,'Kg','Gross',362,'Kg'
exec #CreateProduct '06637301','LCA 1500 1CO TH 400mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',500,'Kg','Gross',500,'Kg'
exec #CreateProduct '06637401','LCA 2000 1CO TH 400mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',531,'Kg','Gross',531,'Kg'
exec #CreateProduct '06637501','LCA 2500 1CO TH 400mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',678,'Kg','Gross',678,'Kg'
exec #CreateProduct '06637601','LCA 3000 1CO TH 400mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',700,'Kg','Gross',700,'Kg'
exec #CreateProduct '06637901','LCA 750 TH 400mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',231,'Kg','Gross',231,'Kg'
exec #CreateProduct '06638001','LCA 1000 TH 400mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',283,'Kg','Gross',283,'Kg'
exec #CreateProduct '06638101','LCA 1500 TH 400mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',406,'Kg','Gross',406,'Kg'
exec #CreateProduct '06638201','LCA 2000 TH 400mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',430,'Kg','Gross',430,'Kg'
exec #CreateProduct '06638301','LCA 2500 TH 400mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',559,'Kg','Gross',559,'Kg'
exec #CreateProduct '06638401','LCA 3000 TH 400mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',586,'Kg','Gross',586,'Kg'
exec #CreateProduct '06638701','LCA 750 2CO TH 400mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',295,'Kg','Gross',295,'Kg'
exec #CreateProduct '06638801','LCA 1000 2CO TH 400mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',345,'Kg','Gross',345,'Kg'
exec #CreateProduct '06638901','LCA 1500 2CO TH 400mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',428,'Kg','Gross',428,'Kg'
exec #CreateProduct '06639001','LCA 2000 2CO TH 400mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',453,'Kg','Gross',453,'Kg'
exec #CreateProduct '06639101','LCA 2500 2CO TH 400mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',605,'Kg','Gross',605,'Kg'
exec #CreateProduct '06639201','LCA 3000 2CO TH 400mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',645,'Kg','Gross',645,'Kg'
exec #CreateProduct '06639301','HEAT PUMP LCA 500 TP 110mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',253,'Kg','Gross',253,'Kg'
exec #CreateProduct '06639401','HEAT PUMP LCA 750 TP 110mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',334,'Kg','Gross',334,'Kg'
exec #CreateProduct '06639501','HEAT PUMP LCA 1000 TP 110mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',366,'Kg','Gross',366,'Kg'
exec #CreateProduct '06639601','HEAT PUMP LCA 1500 TP 110mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',470,'Kg','Gross',470,'Kg'
exec #CreateProduct '06639701','HEAT PUMP LCA 2000 TP 110mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',510,'Kg','Gross',510,'Kg'
exec #CreateProduct '06639901','HEAT PUMP LCA 750 TH 400mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',368,'Kg','Gross',368,'Kg'
exec #CreateProduct '06640001','HEAT PUMP LCA 1000 TH 400mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',400,'Kg','Gross',400,'Kg'
exec #CreateProduct '06640101','HEAT PUMP LCA 1500 TH 400mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',470,'Kg','Gross',470,'Kg'
exec #CreateProduct '06640201','HEAT PUMP LCA 2000 TH 400mm','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',510,'Kg','Gross',510,'Kg'
exec #CreateProduct '06642701','COMFORT E 100','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',41,'Kg','Gross',41,'Kg'
exec #CreateProduct '06642801','COMFORT E 130','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',45,'Kg','Gross',45,'Kg'
exec #CreateProduct '06642901','COMFORT E 160','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',52,'Kg','Gross',52,'Kg'
exec #CreateProduct '06643001','COMFORT E 210','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',62,'Kg','Gross',62,'Kg'
exec #CreateProduct '06643101','COMFORT E 240','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',72,'Kg','Gross',72,'Kg'
exec #CreateProduct '06648501','JUMBO 800 + CRATE + 2 INSULATION ROLLS','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',382,'Kg','Gross',382,'Kg'
exec #CreateProduct '06648601','JUMBO 1000 + CRATE + 3 INSULATION ROLLS','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',454,'Kg','Gross',454,'Kg'
exec #CreateProduct '06650301','IWH 100','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',35,'Kg','Gross',35,'Kg'
exec #CreateProduct '06650401','IWH 130','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',39,'Kg','Gross',39,'Kg'
exec #CreateProduct '06650501','IWH 160','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',45,'Kg','Gross',45,'Kg'
exec #CreateProduct '06650601','IWH 210','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',58,'Kg','Gross',58,'Kg'
exec #CreateProduct '06650701','IWH 240','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',68,'Kg','Gross',68,'Kg'
exec #CreateProduct '06651301','SLME 600 + kit emballage','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',180,'Kg','Gross',180,'Kg'
exec #CreateProduct '07235401','HL E 100','ACV','FP','SerialNr_Code_PY','PCS','PAL',6,'Net',39,'Kg','Gross',39,'Kg'
exec #CreateProduct '07235801','HL E 240','ACV','FP','SerialNr_Code_PY','PCS','PAL',6,'Net',74,'Kg','Gross',74,'Kg'
exec #CreateProduct '07640301','ACV Glass BL 50 1200','ACV','FP','SerialNr_Code_PY','PCS','PAL',12,'Net',26,'Kg','Gross',26,'Kg'
exec #CreateProduct '07640401','ACV GLASS BL 75 1200','ACV','FP','SerialNr_Code_PY','PCS','PAL',12,'Net',31,'Kg','Gross',31,'Kg'
exec #CreateProduct '07640501','ACV GLASS BL 100 1200','ACV','FP','SerialNr_Code_PY','PCS','PAL',8,'Net',37,'Kg','Gross',37,'Kg'
exec #CreateProduct '07640601','ACV GLASS BL 150 1800','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',51,'Kg','Gross',51,'Kg'
exec #CreateProduct '07640701','ACV GLASS BL 200 2400','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',67,'Kg','Gross',67,'Kg'
exec #CreateProduct '07640801','ACV GLASS BL 100H 1200','ACV','FP','SerialNr_Code_PY','PCS','PAL',8,'Net',42,'Kg','Gross',42,'Kg'
exec #CreateProduct '07640901','ACV GLASS BL 150H 1800','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',57,'Kg','Gross',57,'Kg'
exec #CreateProduct '07641001','ACV GLASS BL 200H 2400','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',75,'Kg','Gross',75,'Kg'
exec #CreateProduct '07641101','ACV GLASS BL 150S 1800','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',80,'Kg','Gross',80,'Kg'
exec #CreateProduct '07641201','ACV GLASS BL 200S 2400','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',89,'Kg','Gross',89,'Kg'
exec #CreateProduct '07641301','ACV GLASS ST50m 1200','ACV','FP','SerialNr_Code_PY','PCS','PAL',12,'Net',25,'Kg','Gross',25,'Kg'
exec #CreateProduct '07641401','ACV GLASS ST75m 2400','ACV','FP','SerialNr_Code_PY','PCS','PAL',12,'Net',34,'Kg','Gross',34,'Kg'
exec #CreateProduct '07641501','ACV GLASS ST100m 2400','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',39,'Kg','Gross',39,'Kg'
exec #CreateProduct '07641601','ACV GLASS ST150m 2400','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',54,'Kg','Gross',54,'Kg'
exec #CreateProduct '07641701','ACV GLASS ST200m 2400','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',68,'Kg','Gross',68,'Kg'
exec #CreateProduct '07641801','ACV GLASS ST150m/tri 2400','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',54,'Kg','Gross',54,'Kg'
exec #CreateProduct '07641901','ACV GLASS ST200m/tri 2400','ACV','FP','SerialNr_Code_PY','PCS','PAL',4,'Net',68,'Kg','Gross',68,'Kg'
exec #CreateProduct '07642001','ACV GLASS ST150sm/tri 2400','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',80,'Kg','Gross',80,'Kg'
exec #CreateProduct '07642101','ACV GLASS ST200sm/tri 2400','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',88,'Kg','Gross',88,'Kg'
exec #CreateProduct '07642201','ACV GLASS ST300sm/tri 3000','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',104,'Kg','Gross',104,'Kg'
exec #CreateProduct '07647101','ACV Glass HP 300','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',130,'Kg','Gross',130,'Kg'
exec #CreateProduct '07647201','ACV Glass HP 300C','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',154,'Kg','Gross',154,'Kg'
exec #CreateProduct '07650801','ACV Glass BL 10S','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',9.2,'Kg','Gross',9.2,'Kg'
exec #CreateProduct '07650901','ACV Glass BL 15S','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',9.95,'Kg','Gross',9.95,'Kg'
exec #CreateProduct '07651001','ACV Glass BL 30','ACV','FP','SerialNr_Code_PY','PCS', null, 0,'Net',13.5,'Kg','Gross',13.5,'Kg'
exec #CreateProduct '08048007','Kompakt solo HR24','ACV','FP','SerialNr_Code_PY','PCS','PAL',6,'Net',40,'Kg','Gross',40,'Kg'
exec #CreateProduct '08048017','Kompakt solo HR 30','ACV','FP','SerialNr_Code_PY','PCS','PAL',6,'Net',42,'Kg','Gross',42,'Kg'
exec #CreateProduct '08048027','Kompakt HR 28/24','ACV','FP','SerialNr_Code_PY','PCS','PAL',6,'Net',42,'Kg','Gross',42,'Kg'
exec #CreateProduct '08048037','Kompakt HR 36/30','ACV','FP','SerialNr_Code_PY','PCS','PAL',6,'Net',44,'Kg','Gross',44,'Kg'
exec #CreateProduct '08048067','Kompakt solo HRE 18','ACV','FP','SerialNr_Code_PY','PCS','PAL',6,'Net',30,'Kg','Gross',30,'Kg'
exec #CreateProduct '08048077','Kompakt solo HRE 24','ACV','FP','SerialNr_Code_PY','PCS','PAL',6,'Net',33,'Kg','Gross',33,'Kg'
exec #CreateProduct '08048087','Kompakt solo HRE 30','ACV','FP','SerialNr_Code_PY','PCS','PAL',6,'Net',36,'Kg','Gross',36,'Kg'
exec #CreateProduct '08048097','Kompakt Solo HRE 35','ACV','FP','SerialNr_Code_PY','PCS','PAL',6,'Net',36,'Kg','Gross',36,'Kg'
exec #CreateProduct '08048117','Kompakt solo HRE 40','ACV','FP','SerialNr_Code_PY','PCS','PAL',6,'Net',36,'Kg','Gross',36,'Kg'
exec #CreateProduct '08048127','Kompakt HRE 24/18','ACV','FP','SerialNr_Code_PY','PCS','PAL',6,'Net',32,'Kg','Gross',32,'Kg'
exec #CreateProduct '08048137','Kompakt HRE 28/24','ACV','FP','SerialNr_Code_PY','PCS','PAL',6,'Net',35,'Kg','Gross',35,'Kg'
exec #CreateProduct '08048147','Kompakt HRE 36/30','ACV','FP','SerialNr_Code_PY','PCS','PAL',6,'Net',38,'Kg','Gross',38,'Kg'
exec #CreateProduct '08048167','Kompakt HRE 36/39','ACV','FP','SerialNr_Code_PY','PCS','PAL',6,'Net',38,'Kg','Gross',38,'Kg'
exec #CreateProduct '10800183','Cascade Extension kit PP Dn 150','ACV','Acc','Code','PCS','PAL',32,'Net',2.8,'Kg','Gross',2.8,'Kg'
exec #CreateProduct '10800186','Cascade Valve dn 100','ACV','Acc','Code','PCS','PAL',64,'Net',0.63,'Kg','Gross',0.63,'Kg'
exec #CreateProduct '10800273','Kit électrique de 9 kW (blindée DN 110)','ACV','Acc','Code','PCS', null, 0,'Net',6.4,'Kg','Gross',6.4,'Kg'
exec #CreateProduct '10800274','Kit électrique de 15kW (blindée DN 110)','ACV','Acc','Code','PCS', null, 0,'Net',6.7,'Kg','Gross',6.7,'Kg'
exec #CreateProduct '10800275','Kit électrique de 30 kW (blindée DN 110)','ACV','Acc','Code','PCS', null, 0,'Net',7.8,'Kg','Gross',7.8,'Kg'
exec #CreateProduct '10800276','Kit électrique de 9kW (blindée DN 400)','ACV','Acc','Code','PCS', null, 0,'Net',37,'Kg','Gross',37,'Kg'
exec #CreateProduct '10800277','Kit électrique de 15kW (blindée DN 400)','ACV','Acc','Code','PCS', null, 0,'Net',36,'Kg','Gross',36,'Kg'
exec #CreateProduct '10800278','Kit électrique de 30kw (blindée DN 400)','ACV','Acc','Code','PCS', null, 0,'Net',37,'Kg','Gross',37,'Kg'
exec #CreateProduct '10800279','Kit électrique 4de 45kW (blindée DN 400)','ACV','Acc','Code','PCS', null, 0,'Net',40,'Kg','Gross',40,'Kg'
exec #CreateProduct '10800280','Kit électrique de 60kW (blindée DN 400)','ACV','Acc','Code','PCS', null, 0,'Net',41,'Kg','Gross',41,'Kg'
exec #CreateProduct '10800281','Kit électrique de 9 kW (stéatite DN400)','ACV','Acc','Code','PCS', null, 0,'Net',50,'Kg','Gross',50,'Kg'
exec #CreateProduct '10800282','Kit électrique de 12kW (stéatite DN400)','ACV','Acc','Code','PCS', null, 0,'Net',53,'Kg','Gross',53,'Kg'
exec #CreateProduct '10800283','Kit électrique de 15kw (stéatite DN400)','ACV','Acc','Code','PCS', null, 0,'Net',58,'Kg','Gross',58,'Kg'
exec #CreateProduct '10800284','Kit électrique de 30kW (stéatite DN400)','ACV','Acc','Code','PCS', null, 0,'Net',70,'Kg','Gross',70,'Kg'
exec #CreateProduct '10800285','Kit coil 1 m2 on 400mm flange - Complete','ACV','Acc','Code','PCS', null, 0,'Net',44,'Kg','Gross',44,'Kg'
exec #CreateProduct '10800286','Kit coil 3 m2 on 400mm flange - Complete','ACV','Acc','Code','PCS', null, 0,'Net',53,'Kg','Gross',53,'Kg'
exec #CreateProduct '10800300','Cascade Extension Kit PP DN 150','ACV','Acc','Code','PCS','PAL',32,'Net',3.55,'Kg','Gross',3.55,'Kg'
exec #CreateProduct '10800301','Wall Terminal Kit PP/GLV 80/125','ACV','Acc','Code','PCS','PAL',64,'Net',3.43,'Kg','Gross',3.43,'Kg'
exec #CreateProduct '10800302','Wall Terminal Kit PP/GLV 100/150','ACV','Acc','Code','PCS','PAL',15,'Net',5.32,'Kg','Gross',5.32,'Kg'
exec #CreateProduct '10800303','Wall Terminal Kit AL/GLV 80/125','ACV','Acc','Code','PCS','PAL',64,'Net',3.8,'Kg','Gross',3.8,'Kg'
exec #CreateProduct '10800304','Kit électrique de 18 kW (stéatite DN400)','ACV','Acc','Code','PCS', null, 0,'Net',65,'Kg','Gross',65,'Kg'
exec #CreateProduct '10800305','Kit électrique de 24 kW (stéatite DN400)','ACV','Acc','Code','PCS', null, 0,'Net',67,'Kg','Gross',67,'Kg'
exec #CreateProduct '10800306','Kit électrique de 3kW (stéatite DN400)','ACV','Acc','Code','PCS', null, 0,'Net',44,'Kg','Gross',44,'Kg'
exec #CreateProduct '10800307','Kit électrique de 6kW (stéatite DN400)','ACV','Acc','Code','PCS', null, 0,'Net',47,'Kg','Gross',47,'Kg'
exec #CreateProduct '10800308','Kit électrique de 3kW (blindée DN 110)','ACV','Acc','Code','PCS', null, 0,'Net',4.57,'Kg','Gross',4.57,'Kg'
exec #CreateProduct '10800327','Profilés (2X) V1 Helio plan-S vertical','ACV','Acc','SerialNr_Code_PY','PCS','PAL',54,'Net',2.91,'Kg','Gross',2.91,'Kg'
exec #CreateProduct '10800328','Profilés (2X) V2 Helio plan-S vertical','ACV','Acc','SerialNr_Code_PY','PCS','PAL',48,'Net',5.84,'Kg','Gross',5.84,'Kg'
exec #CreateProduct '10800329','Junction parts for 2 pairs of profiles','ACV','Acc','SerialNr_Code_PY','PCS', null, 0,'Net',10.22,'Kg','Gross',10.22,'Kg'
exec #CreateProduct '10800330','Kit étrier V1 Hélio plan-S add. Vertical','ACV','Acc','SerialNr_Code_PY','PCS','PAL',50,'Net',1.55,'Kg','Gross',1.55,'Kg'
exec #CreateProduct '10800331','Kit lagbolts for 1 add. vert. collector','ACV','Acc','SerialNr_Code_PY','PCS','PAL',50,'Net',1.32,'Kg','Gross',1.32,'Kg'
exec #CreateProduct '10800332','Kit angled frame for 1 add. vert. coll.','ACV','Acc','SerialNr_Code_PY','PCS','PAL',50,'Net',3.9,'Kg','Gross',3.9,'Kg'
exec #CreateProduct '10800333','Kit étriers V2 Hélio plan-S Vertical','ACV','Acc','SerialNr_Code_PY','PCS','PAL',50,'Net',4.06,'Kg','Gross',4.06,'Kg'
exec #CreateProduct '10800334','Kit tirefonds Helio Plan-S Vertical','ACV','Acc','SerialNr_Code_PY','PCS','PAL',50,'Net',3.26,'Kg','Gross',3.26,'Kg'
exec #CreateProduct '10800335','Kit chassis V2 Helio Plan-S Vertical','ACV','Acc','SerialNr_Code_PY','PCS','PAL',25,'Net',10.27,'Kg','Gross',10.27,'Kg'
exec #CreateProduct '10800336','Profiles for 1 single horiz. collector','ACV','Acc','SerialNr_Code_PY','PCS','PAL',48,'Net',5.25,'Kg','Gross',5.25,'Kg'
exec #CreateProduct '10800337','Kit chassis H1 base HelioPlan-S Horiz.','ACV','Acc','SerialNr_Code_PY','PCS','PAL',50,'Net',4.93,'Kg','Gross',4.93,'Kg'
exec #CreateProduct '10800338','Kit chassis H1 add. HelioPlan-S Horiz.','ACV','Acc','SerialNr_Code_PY','PCS','PAL',50,'Net',5.32,'Kg','Gross',5.32,'Kg'
exec #CreateProduct '10800339','Kit tirefonds base. HelioPlan-S Horiz.','ACV','Acc','SerialNr_Code_PY','PCS','PAL',50,'Net',2.14,'Kg','Gross',2.14,'Kg'
exec #CreateProduct '10800340','Kit tirefonds H1 add. HelioPlan-S Horiz.','ACV','Acc','SerialNr_Code_PY','PCS','PAL',50,'Net',2.31,'Kg','Gross',2.31,'Kg'
exec #CreateProduct '10800341','Kit étrier H1 base Helio Plan-S Horiz.','ACV','Acc','SerialNr_Code_PY','PCS','PAL',50,'Net',2.72,'Kg','Gross',2.72,'Kg'
exec #CreateProduct '10800342','Kit étrier H1 add. Helio Plan-S Horiz.','ACV','Acc','SerialNr_Code_PY','PCS','PAL',50,'Net',2.81,'Kg','Gross',2.81,'Kg'
exec #CreateProduct '10800343','Kit hydr. in/out Plan-S','ACV','Acc','SerialNr_Code_PY','PCS','PAL',40,'Net',1.61,'Kg','Gross',1.61,'Kg'
exec #CreateProduct '10800344','Kit hydr. Base H Helio Plan-S horiz.','ACV','Acc','SerialNr_Code_PY','PCS','PAL',50,'Net',1.3,'Kg','Gross',1.3,'Kg'
exec #CreateProduct '10800345','Kit hydr. Add. H Helio Plan-S Horiz.','ACV','Acc','SerialNr_Code_PY','PCS','PAL',50,'Net',0.8,'Kg','Gross',0.8,'Kg'
exec #CreateProduct '10800346','Kit hydr. Base V Helio Plan-S Vertical','ACV','Acc','SerialNr_Code_PY','PCS','PAL',50,'Net',1.02,'Kg','Gross',1.02,'Kg'
exec #CreateProduct '10800347','Kit hydr. Add. V Helio Plan-S Vertical','ACV','Acc','SerialNr_Code_PY','PCS','PAL',50,'Net',0.5,'Kg','Gross',0.5,'Kg'
exec #CreateProduct '237D0073','Burner BG 2000-S/60 (GN)','ACV','Acc','SerialNr_Code_PY','PCS', null, 0,'Net',14,'Kg','Gross',14,'Kg'
exec #CreateProduct '237D0091','Burner BG 2000 M/71','ACV','Acc','SerialNr_Code_PY','PCS', null, 0,'Net',17,'Kg','Gross',17,'Kg'
exec #CreateProduct '237D0092','Burner BG 2000 M/101','ACV','Acc','SerialNr_Code_PY','PCS', null, 0,'Net',23,'Kg','Gross',23,'Kg'
exec #CreateProduct '237D0118','Burner BG 2000 M/201','ACV','Acc','SerialNr_Code_PY','PCS','PAL',4,'Net',30,'Kg','Gross',30,'Kg'
exec #CreateProduct '237D0119','Burner BG 2000 S/35 HM 30N','ACV','Acc','SerialNr_Code_PY','PCS', null, 0,'Net',14,'Kg','Gross',14,'Kg'
exec #CreateProduct '237D0122','Burner BG 2000 S/60 (GP)','ACV','Acc','SerialNr_Code_PY','PCS', null, 0,'Net',14,'Kg','Gross',14,'Kg'
exec #CreateProduct '237D0126','Burner BG 2000-M/201 Propane / Butane','ACV','Acc','SerialNr_Code_PY','PCS', null, 0,'Net',30,'Kg','Gross',30,'Kg'
exec #CreateProduct '237D0137','Burner BG 2000 S/25 v09','ACV','Acc','SerialNr_Code_PY','PCS', null, 0,'Net',11,'Kg','Gross',11,'Kg'
exec #CreateProduct '237D0138','Burner BG 2000 S/45 v09','ACV','Acc','SerialNr_Code_PY','PCS', null, 0,'Net',11,'Kg','Gross',11,'Kg'
exec #CreateProduct '237D0139','Burner BG 2000 S/55 v09','ACV','Acc','SerialNr_Code_PY','PCS', null, 0,'Net',11,'Kg','Gross',11,'Kg'
exec #CreateProduct '237D0154','Burner BG 2000 S/25','ACV','Acc','SerialNr_Code_PY','PCS','PAL',6,'Net',11,'Kg','Gross',11,'Kg'
exec #CreateProduct '237D0155','Burner BG 2000 S/45','ACV','Acc','SerialNr_Code_PY','PCS','PAL',6,'Net',11,'Kg','Gross',11,'Kg'
exec #CreateProduct '237D0156','Burner BG 2000 S/55','ACV','Acc','SerialNr_Code_PY','PCS','PAL',6,'Net',11,'Kg','Gross',11,'Kg'
exec #CreateProduct '237D0157','Burner BG 2000-S/60 (GN)','ACV','Acc','SerialNr_Code_PY','PCS','PAL',4,'Net',13,'Kg','Gross',13,'Kg'
exec #CreateProduct '237D0158','Burner BG 2000 S/60 (GP)','ACV','Acc','SerialNr_Code_PY','PCS','PAL',4,'Net',13,'Kg','Gross',13,'Kg'
exec #CreateProduct '237D0159','Burner BG 2000-S/70 V13','ACV','Acc','SerialNr_Code_PY','PCS','PAL',4,'Net',18,'Kg','Gross',18,'Kg'
exec #CreateProduct '237D0160','Burner BG 2000-S/70 V13 propane','ACV','Acc','SerialNr_Code_PY','PCS','PAL',4,'Net',18,'Kg','Gross',18,'Kg'
exec #CreateProduct '237D0161','Burner BG 2000-S/100 107kw','ACV','Acc','SerialNr_Code_PY','PCS','PAL',4,'Net',24,'Kg','Gross',24,'Kg'
exec #CreateProduct '237D0162','Burner BG 2000-S/100 107kw propane','ACV','Acc','SerialNr_Code_PY','PCS','PAL',4,'Net',24,'Kg','Gross',24,'Kg'
exec #CreateProduct '237D0169','Burner BG2000-S/100 85kW','ACV','Acc','SerialNr_Code_PY','PCS','PAL',4,'Net',24,'Kg','Gross',24,'Kg'
exec #CreateProduct '237D0172','Burner BG 2000 S-35 V13 propane','ACV','Acc','SerialNr_Code_PY','PCS','PAL',4,'Net',13,'Kg','Gross',13,'Kg'
exec #CreateProduct '237D0174','Burner BG 2000 S/55 Propane','ACV','Acc','SerialNr_Code_PY','PCS','PAL',4,'Net',13,'Kg','Gross',13,'Kg'
exec #CreateProduct '237E0024','Burner BMV1','ACV','Acc','Code','PCS','PAL',24,'Net',13.535,'Kg','Gross',13.535,'Kg'
exec #CreateProduct '237E0025','Burner BMV2 (pack), PVC','ACV','Acc','SerialNr_Code_PY','PCS','PAL',24,'Net',13.62,'Kg','Gross',13.62,'Kg'
exec #CreateProduct '237E0027','Burner BMV1V-FV (pack), valve, PVC','ACV','Acc','SerialNr_Code_PY','PCS','PAL',24,'Net',13.39,'Kg','Gross',13.39,'Kg'
exec #CreateProduct '237E0028','Burner BMV2V-FV (pack), valve, PVC','ACV','Acc','SerialNr_Code_PY','PCS','PAL',24,'Net',13.49,'Kg','Gross',13.49,'Kg'
exec #CreateProduct '507F4262','ACV GLASS Tripod BL&P','ACV','Acc','Code','PCS','PAL',100,'Net',4.2,'Kg','Gross',4.2,'Kg'
exec #CreateProduct '537D6182','Weather Slate Steep PF 80/125 25°-45°','ACV','Acc','Code','PCS','PAL',45,'Net',1.42,'Kg','Gross',1.42,'Kg'
exec #CreateProduct '537D6183','Wall Bracket dn 125','ACV','Acc','Code','PCS','PAL',3200,'Net',0.18,'Kg','Gross',0.18,'Kg'
exec #CreateProduct '537D6184','Roof Terminal PP/GLV 80/125','ACV','Acc','Code','PCS','PAL',20,'Net',4.08,'Kg','Gross',4.08,'Kg'
exec #CreateProduct '537D6185','Wall Terminal PP/GLV 80/125','ACV','Acc','Code','PCS','PAL',64,'Net',2.16,'Kg','Gross',2.16,'Kg'
exec #CreateProduct '537D6186','Extension PP/GLV 80/125 X 250 mm','ACV','Acc','Code','PCS','PAL',192,'Net',0.28,'Kg','Gross',0.28,'Kg'
exec #CreateProduct '537D6187','Extension PP/GLV 80/125 X 500 mm','ACV','Acc','Code','PCS','PAL',224,'Net',0.55,'Kg','Gross',0.55,'Kg'
exec #CreateProduct '537D6188','Extension PP/GLV 80/125 x 1000 mm','ACV','Acc','Code','PCS','PAL',112,'Net',2.23,'Kg','Gross',2.23,'Kg'
exec #CreateProduct '537D6189','Extension Telescopic PP/GLV 80/125','ACV','Acc','Code','PCS','PAL',224,'Net',0.57,'Kg','Gross',0.57,'Kg'
exec #CreateProduct '537D6190','Elbow PP/GLV 80/125 45°','ACV','Acc','Code','PCS','PAL',432,'Net',0.505,'Kg','Gross',0.505,'Kg'
exec #CreateProduct '537D6191','Elbow PP/GLV 80/125 90°','ACV','Acc','Code','PCS','PAL',300,'Net',0.95,'Kg','Gross',0.95,'Kg'
exec #CreateProduct '537D6193','Measurement Extension PP/GLV 80/125','ACV','Acc','Code','PCS','PAL',432,'Net',0.47,'Kg','Gross',0.47,'Kg'
exec #CreateProduct '537D6194','Weather Slate Flat 80/125','ACV','Acc','Code','PCS','PAL',27,'Net',0.33,'Kg','Gross',0.33,'Kg'
exec #CreateProduct '537D6197','Roof Terminal SST/SST 100/150','ACV','Acc','Code','PCS','PAL',11,'Net',8.2,'Kg','Gross',8.2,'Kg'
exec #CreateProduct '537D6198','Wall Terminal SST/SST 100/150','ACV','Acc','Code','PCS','PAL',84,'Net',2.7,'Kg','Gross',2.7,'Kg'
exec #CreateProduct '537D6199','Extension SST/SST 100/150 x 250 mm','ACV','Acc','Code','PCS','PAL',192,'Net',0.92,'Kg','Gross',0.92,'Kg'
exec #CreateProduct '537D6200','ExtensionSST/SST 100/15x 500 mm','ACV','Acc','Code','PCS','PAL',168,'Net',1.62,'Kg','Gross',1.62,'Kg'
exec #CreateProduct '537D6201','Extension SST/SST 100/150 X 1000 mm','ACV','Acc','Code','PCS','PAL',50,'Net',3.54,'Kg','Gross',3.54,'Kg'
exec #CreateProduct '537D6202','Extension Telescopic SST/SST 100/150','ACV','Acc','Code','PCS','PAL',100,'Net',1.895,'Kg','Gross',1.895,'Kg'
exec #CreateProduct '537D6203','Elbow SST/SST 100/150 45°','ACV','Acc','Code','PCS','PAL',120,'Net',1.2,'Kg','Gross',1.2,'Kg'
exec #CreateProduct '537D6204','Elbow SST/SST 100/150 90°','ACV','Acc','Code','PCS','PAL',120,'Net',1.57,'Kg','Gross',1.57,'Kg'
exec #CreateProduct '537D6207','Adapter PP/Alu 100/150 - 100/100','ACV','Acc','Code','PCS','PAL',192,'Net',0.88,'Kg','Gross',0.88,'Kg'
exec #CreateProduct '537D6208','Weather Slate Flat Alu 100/150','ACV','Acc','Code','PCS','PAL',12,'Net',0.33,'Kg','Gross',0.33,'Kg'
exec #CreateProduct '537D6209','Weather Slate Steep PF 100/150 25°-45°','ACV','Acc','Code','PCS','PAL',45,'Net',1.97,'Kg','Gross',1.97,'Kg'
exec #CreateProduct '537D6210','Wall Bracket dn 150','ACV','Acc','Code','PCS','PAL',64,'Net',0.21,'Kg','Gross',0.21,'Kg'
exec #CreateProduct '537D6211','Roof Terminal SST 150 flue','ACV','Acc','Code','PCS','PAL',5,'Net',8.7,'Kg','Gross',8.7,'Kg'
exec #CreateProduct '537D6212','Wall Terminal SST 150 flue','ACV','Acc','Code','PCS','PAL',9,'Net',4.2,'Kg','Gross',4.2,'Kg'
exec #CreateProduct '537D6213','Wall Terminal Alu 100 air','ACV','Acc','Code','PCS','PAL',64,'Net',2.12,'Kg','Gross',2.12,'Kg'
exec #CreateProduct '537D6214','Extension SST 150 x 250 mm flue','ACV','Acc','Code','PCS','PAL',192,'Net',0.578,'Kg','Gross',0.578,'Kg'
exec #CreateProduct '537D6215','Extension SST 150 x 500 mm flue','ACV','Acc','Code','PCS','PAL',100,'Net',1.283,'Kg','Gross',1.283,'Kg'
exec #CreateProduct '537D6216','Extension SST 150 x 1000 mm flue','ACV','Acc','Code','PCS','PAL',50,'Net',2.29,'Kg','Gross',2.29,'Kg'
exec #CreateProduct '537D6217','Extension PP 100 x 500 mm air','ACV','Acc','Code','PCS', null, 0,'Net',0.3,'Kg','Gross',0.3,'Kg'
exec #CreateProduct '537D6218','Extension Telescopic SST 150 flue','ACV','Acc','Code','PCS','PAL',192,'Net',0.51,'Kg','Gross',0.51,'Kg'
exec #CreateProduct '537D6219','Elbow SST 150 45°flue','ACV','Acc','Code','PCS','PAL',192,'Net',0.585,'Kg','Gross',0.585,'Kg'
exec #CreateProduct '537D6220','Elbow SST 150 90°Flue','ACV','Acc','Code','PCS','PAL',120,'Net',0.936,'Kg','Gross',0.936,'Kg'
exec #CreateProduct '537D6221','Elbow PP 100 45°Air','ACV','Acc','Code','PCS','PAL',64,'Net',0.098,'Kg','Gross',0.098,'Kg'
exec #CreateProduct '537D6222','Elbow PP 100 90°Air','ACV','Acc','Code','PCS','PAL',64,'Net',0.14,'Kg','Gross',0.14,'Kg'
exec #CreateProduct '537D6223','Meas. Extension + condens SST 150','ACV','Acc','Code','PCS','PAL',192,'Net',0.79,'Kg','Gross',0.79,'Kg'
exec #CreateProduct '537D6226','Meas.Extension + condens SST/SST 100/150','ACV','Acc','Code','PCS','PAL',300,'Net',0.825,'Kg','Gross',0.825,'Kg'
exec #CreateProduct '537D6229','Meas. Tee w/ Inspect. Pnl PP/GLV 80/125','ACV','Acc','Code','PCS','PAL',128,'Net',1.25,'Kg','Gross',1.25,'Kg'
exec #CreateProduct '537D6231','Adapter SST/Alu 80/125 - 80/80','ACV','Acc','Code','PCS','PAL',192,'Net',2.25,'Kg','Gross',2.25,'Kg'
exec #CreateProduct '537D6239','Roof Terminal Skyline AL/GLV 80/125','ACV','Acc','Code','PCS','PAL',20,'Net',4.75,'Kg','Gross',4.75,'Kg'
exec #CreateProduct '537D6241','Extension AL/GLV 80/125 x 250 mm SIL','ACV','Acc','Code','PCS','PAL',128,'Net',0.75,'Kg','Gross',0.75,'Kg'
exec #CreateProduct '537D6242','Extension AL/GLV 80/125 x 500 mm SIL','ACV','Acc','Code','PCS','PAL',64,'Net',1.5,'Kg','Gross',1.5,'Kg'
exec #CreateProduct '537D6243','Extension AL/GLV 80/125 x 1000 mm SIL','ACV','Acc','Code','PCS','PAL',32,'Net',2.5,'Kg','Gross',2.5,'Kg'
exec #CreateProduct '537D6245','Exten. Telesc. AL/GLV 80/125 x 500 SIL','ACV','Acc','Code','PCS','PAL',64,'Net',1.7,'Kg','Gross',1.7,'Kg'
exec #CreateProduct '537D6247','Elbow AL/AL 80/125 90°SIL','ACV','Acc','Code','PCS','PAL',64,'Net',1,'Kg','Gross',1,'Kg'
exec #CreateProduct '537D6248','Elbow AL/AL 80/125 45°SIL','ACV','Acc','Code','PCS','PAL',64,'Net',0.85,'Kg','Gross',0.85,'Kg'
exec #CreateProduct '537D6257','Meas. Ext. AL/AL80/110 - 80/125 Komp. HR','ACV','Acc','Code','PCS','PAL',432,'Net',0.432,'Kg','Gross',0.432,'Kg'
exec #CreateProduct '537D6260','Wall Terminal SST 150/220','ACV','Acc','Code','PCS','PAL',15,'Net',6.2,'Kg','Gross',6.2,'Kg'
exec #CreateProduct '537D6261','Roof Terminal SST 150/220','ACV','Acc','Code','PCS','PAL',9,'Net',12,'Kg','Gross',12,'Kg'
exec #CreateProduct '537D6266','Connection sheath Alu for 80/125','ACV','Acc','Code','PCS','PAL',128,'Net',1.27,'Kg','Gross',1.27,'Kg'
exec #CreateProduct '537D6267','Connection Sheath Alu for 100/150','ACV','Acc','Code','PCS','PAL',128,'Net',1.03,'Kg','Gross',1.03,'Kg'
exec #CreateProduct '537D6271','Flexible PP 100 - L=25m','ACV','Acc','Code','PCS', null, 0,'Net',19,'Kg','Gross',19,'Kg'
exec #CreateProduct '537D6275','Flexible PP 80 - L=25m','ACV','Acc','Code','PCS', null, 0,'Net',18.5,'Kg','Gross',18.5,'Kg'
exec #CreateProduct '537D6287','Accessories Kit C93 80/125','ACV','Acc','Code','PCS','PAL',40,'Net',3.92,'Kg','Gross',3.92,'Kg'
exec #CreateProduct '537D6288','Weather Slate Flat Alu 150/220','ACV','Acc','Code','PCS','PAL',25,'Net',1.4,'Kg','Gross',1.4,'Kg'
exec #CreateProduct '537D6289','Weather Slate Steep pb/glv 150/220 18-22','ACV','Acc','Code','PCS','PAL',10,'Net',10.07,'Kg','Gross',10.07,'Kg'
exec #CreateProduct '537D6290','Accessories Kit C93 100/150','ACV','Acc','Code','PCS','PAL',40,'Net',4.26,'Kg','Gross',4.26,'Kg'
exec #CreateProduct '537D6293','Expander SST 100-150','ACV','Acc','Code','PCS','PAL',300,'Net',0.37,'Kg','Gross',0.37,'Kg'
exec #CreateProduct '537D6300','Roof terminal PP/GLV 100/150','ACV','Acc','Code','PCS','PAL',16,'Net',5.72,'Kg','Gross',5.72,'Kg'
exec #CreateProduct '537D6301','Wall Terminal PP/GLV 100/150','ACV','Acc','Code','PCS','PAL',84,'Net',2.675,'Kg','Gross',2.675,'Kg'
exec #CreateProduct '537D6302','Extension PP/GLV 100/150 X 250 mm','ACV','Acc','Code','PCS','PAL',192,'Net',0.86,'Kg','Gross',0.86,'Kg'
exec #CreateProduct '537D6303','Extension PP/GLV 100/150 500 mm','ACV','Acc','Code','PCS','PAL',168,'Net',1.54,'Kg','Gross',1.54,'Kg'
exec #CreateProduct '537D6304','Extension PP/GLV 100/15 X 1000 mm','ACV','Acc','Code','PCS','PAL',84,'Net',2.86,'Kg','Gross',2.86,'Kg'
exec #CreateProduct '537D6305','Extension Telescopic PP/GLV 100/150','ACV','Acc','Code','PCS','PAL',168,'Net',0.77,'Kg','Gross',0.77,'Kg'
exec #CreateProduct '537D6306','Elbow PP/GLV 100/150 45°','ACV','Acc','Code','PCS','PAL',192,'Net',0.93,'Kg','Gross',0.93,'Kg'
exec #CreateProduct '537D6307','Elbow PP/GLV 100/150 90°','ACV','Acc','Code','PCS','PAL',192,'Net',1.13,'Kg','Gross',1.13,'Kg'
exec #CreateProduct '537D6308','Measurement Extension PP/GLV 100/150','ACV','Acc','Code','PCS','PAL',300,'Net',0.55,'Kg','Gross',0.55,'Kg'
exec #CreateProduct '537D6310','Meas. Tee w/ Inspect. Pnl PP/GLV 100/150','ACV','Acc','Code','PCS','PAL',120,'Net',1.25,'Kg','Gross',1.25,'Kg'
exec #CreateProduct '537D6353','Roof terminal PP/GLV 60/100','ACV','Acc','Code','PCS','PAL',30,'Net',2.37,'Kg','Gross',2.37,'Kg'
exec #CreateProduct '537D6354','Wall temrinal kit PP/GLV 60/100','ACV','Acc','Code','PCS','PAL',98,'Net',1.97,'Kg','Gross',1.97,'Kg'
exec #CreateProduct '537D6355','Extension pp/glv 60/100 x 250 mm','ACV','Acc','Code','PCS','PAL',192,'Net',0.6,'Kg','Gross',0.6,'Kg'
exec #CreateProduct '537D6356','Extension PP/GLV 60/100 X 500 mm','ACV','Acc','Code','PCS','PAL',256,'Net',0.99,'Kg','Gross',0.99,'Kg'
exec #CreateProduct '537D6357','Extension PP/GLV 60/100 X 1000 mm','ACV','Acc','Code','PCS','PAL',135,'Net',1.84,'Kg','Gross',1.84,'Kg'
exec #CreateProduct '537D6358','Extension Temescopic PP/GLV 60/100','ACV','Acc','Code','PCS','PAL',192,'Net',0.645,'Kg','Gross',0.645,'Kg'
exec #CreateProduct '537D6359','Elbow PP/GLV 45°','ACV','Acc','Code','PCS','PAL',432,'Net',0.45,'Kg','Gross',0.45,'Kg'
exec #CreateProduct '537D6360','Elbow PP/GLV 60/100 90°','ACV','Acc','Code','PCS','PAL',192,'Net',0.67,'Kg','Gross',0.67,'Kg'
exec #CreateProduct '537D6361','Meas.Tee w/ inspect. Pnl PP/GLV 60/100','ACV','Acc','Code','PCS','PAL',192,'Net',0.77,'Kg','Gross',0.77,'Kg'
exec #CreateProduct '537D6362','Weather Slate Flat Alu 60/100','ACV','Acc','Code','PCS','PAL',27,'Net',0.25,'Kg','Gross',0.25,'Kg'
exec #CreateProduct '537D6363','Weather Slate Steep PF 60/100 25°-45°','ACV','Acc','Code','PCS','PAL',45,'Net',1.42,'Kg','Gross',1.42,'Kg'
exec #CreateProduct '537D6364','Wall Bracket Dn 100','ACV','Acc','Code','PCS','PAL',128,'Net',0.088,'Kg','Gross',0.088,'Kg'
exec #CreateProduct '537D6365','Adapter PP/ALU 80/125 - 60/100','ACV','Acc','Code','PCS','PAL',432,'Net',0.31,'Kg','Gross',0.31,'Kg'
exec #CreateProduct '537D6405','Expander PP/Alu 60/100 - 80/125','ACV','Acc','Code','PCS','PAL',432,'Net',0.285,'Kg','Gross',0.285,'Kg'
exec #CreateProduct '537D6406','Flexible PP 60 L.25m','ACV','Acc','Code','PCS', null, 0,'Net',12.5,'Kg','Gross',12.5,'Kg'
exec #CreateProduct '537D6407','Accessories Kit C93 60/100','ACV','Acc','Code','PCS','PAL',40,'Net',3.245,'Kg','Gross',3.245,'Kg'
exec #CreateProduct '537D6408','Connection sheath Alu for 60/100','ACV','Acc','Code','PCS','PAL',128,'Net',0.86,'Kg','Gross',0.86,'Kg'
exec #CreateProduct '537D6414','Wall Term. Kit low prof. PP/GLV 60/100','ACV','Acc','Code','PCS','PAL',98,'Net',1.96,'Kg','Gross',1.96,'Kg'
exec #CreateProduct '537D6415','Adapter SST/Alu 60/100 - 80/80','ACV','Acc','Code','PCS','PAL',120,'Net',1.11,'Kg','Gross',1.11,'Kg'
exec #CreateProduct '537D6444','Expander alu Ø80/100','ACV','Acc','Code','PCS','PAL',1920,'Net',0.22,'Kg','Gross',0.22,'Kg'
exec #CreateProduct '537D6445','Cascade end Condensate Set Dn 150','ACV','Acc','Code','PCS','PAL',192,'Net',0.81,'Kg','Gross',0.81,'Kg'
exec #CreateProduct '537D6446','Cascade end Condensate Set Dn 200','ACV','Acc','Code','PCS','PAL',192,'Net',0.62,'Kg','Gross',0.62,'Kg'
exec #CreateProduct '537D6447','Connector Flex-Flex PP 60','ACV','Acc','Code','PCS','PAL',2400,'Net',0.2,'Kg','Gross',0.2,'Kg'
exec #CreateProduct '537D6448','Connector Flex-Flex PP 80','ACV','Acc','Code','PCS','PAL',390,'Net',0.26,'Kg','Gross',0.26,'Kg'
exec #CreateProduct '537D6449','Adapter PP/Alu 80/110 - 80/125','ACV','Acc','Code','PCS','PAL',192,'Net',0.57,'Kg','Gross',0.57,'Kg'
exec #CreateProduct '537D6451','Connector Flex-Flex PP 100','ACV','Acc','Code','PCS','PAL',390,'Net',0.32,'Kg','Gross',0.32,'Kg'
exec #CreateProduct '537D6460','Meas. Exten. PP/AL 80/110 - 80/125 Komp.','ACV','Acc','Code','PCS','PAL',300,'Net',0.725,'Kg','Gross',0.725,'Kg'
exec #CreateProduct '537D6461','Adptr Alu/alu 80/110 - 60/100 Kompact HR','ACV','Acc','Code','PCS','PAL',300,'Net',0.426,'Kg','Gross',0.426,'Kg'
exec #CreateProduct '537D6462','Extension PP DN 200x1000 mm flue','ACV','Acc','Code','PCS','PAL',32,'Net',3.1,'Kg','Gross',3.1,'Kg'
exec #CreateProduct '537D6463','Elbow PP 200 90° Flue','ACV','Acc','Code','PCS','PAL',51,'Net',1.26,'Kg','Gross',1.26,'Kg'
exec #CreateProduct '537D6464','Wall Plate DN 200','ACV','Acc','Code','PCS','PAL',256,'Net',0.83,'Kg','Gross',0.83,'Kg'
exec #CreateProduct '537D6465','Extension SST 200x500mm Flue','ACV','Acc','Code','PCS','PAL',64,'Net',0.4,'Kg','Gross',0.4,'Kg'
exec #CreateProduct '537D6466','Elbow PP/GLV 60/100 15°','ACV','Acc','Code','PCS','PAL',432,'Net',0.41,'Kg','Gross',0.41,'Kg'
exec #CreateProduct '537D6467','Elbow PP/GLV 60/100 30°','ACV','Acc','Code','PCS','PAL',300,'Net',0.48,'Kg','Gross',0.48,'Kg'
exec #CreateProduct '537D6471','Cascade connection tube 2 boilers DN 100','ACV','Acc','Code','PCS','PAL',192,'Net',0.52,'Kg','Gross',0.52,'Kg'
exec #CreateProduct '537D6472','Cascade connection tube 3 boilers DN 100','ACV','Acc','Code','PCS','PAL',144,'Net',0.73,'Kg','Gross',0.73,'Kg'
exec #CreateProduct '537D6473','Cascade connection tube 4 boilers DN 100','ACV','Acc','Code','PCS','PAL',80,'Net',1.04,'Kg','Gross',1.04,'Kg'
exec #CreateProduct '537D6474','Cascade connection tube 5 boilers DN 100','ACV','Acc','Code','PCS','PAL',64,'Net',1.6,'Kg','Gross',1.6,'Kg'
exec #CreateProduct '537D6475','Cascade connection tube 6 boilers DN 100','ACV','Acc','Code','PCS','PAL',64,'Net',1.8,'Kg','Gross',1.8,'Kg'
exec #CreateProduct '537D6476','Cascade connection tube 7 boilers DN 100','ACV','Acc','Code','PCS','PAL',40,'Net',1.9,'Kg','Gross',1.9,'Kg'
exec #CreateProduct '537D6477','Cascade connection tube 8 boilers DN 100','ACV','Acc','Code','PCS','PAL',40,'Net',2.1,'Kg','Gross',2.1,'Kg'
exec #CreateProduct '537D6478','Expander 60/60-60/100','ACV','Acc','Code','PCS','PAL',192,'Net',0.41,'Kg','Gross',0.41,'Kg'
exec #CreateProduct '537D6479','Extension PP 60x500 EPDM','ACV','Acc','Code','PCS','PAL',1024,'Net',0.2,'Kg','Gross',0.2,'Kg'
exec #CreateProduct '537D6480','Extension PP 60x1000 EPDM','ACV','Acc','Code','PCS','PAL',512,'Net',0.4,'Kg','Gross',0.4,'Kg'
exec #CreateProduct '537D6481','Elbow PP 60 90° EPDM','ACV','Acc','Code','PCS','PAL',2560,'Net',0.07,'Kg','Gross',0.07,'Kg'
exec #CreateProduct '537D6482','Elbow PP 60 45° EPDM','ACV','Acc','Code','PCS','PAL',1600,'Net',0.07,'Kg','Gross',0.07,'Kg'
exec #CreateProduct '537D6483','Wall bracket 60 PP','ACV','Acc','Code','PCS','PAL',3200,'Net',0.075,'Kg','Gross',0.075,'Kg'
exec #CreateProduct '537D6484','Expander 80/80-80/125','ACV','Acc','Code','PCS','PAL',120,'Net',1.3,'Kg','Gross',1.3,'Kg'
exec #CreateProduct '537D6485','Extension PP 80x500 EPDM','ACV','Acc','Code','PCS','PAL',1152,'Net',0.3,'Kg','Gross',0.3,'Kg'
exec #CreateProduct '537D6486','Extension PP 80x1000 EPDM','ACV','Acc','Code','PCS','PAL',288,'Net',0.6,'Kg','Gross',0.6,'Kg'
exec #CreateProduct '537D6487','Elbow PP 80 90° EPDM','ACV','Acc','Code','PCS','PAL',1280,'Net',0.13,'Kg','Gross',0.13,'Kg'
exec #CreateProduct '537D6488','Elbow PP 80 45° EPDM','ACV','Acc','Code','PCS','PAL',1600,'Net',0.11,'Kg','Gross',0.11,'Kg'
exec #CreateProduct '537D6489','Wall bracket 80 PP','ACV','Acc','Code','PCS','PAL',3200,'Net',2.105,'Kg','Gross',2.105,'Kg'
exec #CreateProduct '537D6490','Expander 100/100-100/125','ACV','Acc','Code','PCS','PAL',128,'Net',0.89,'Kg','Gross',0.89,'Kg'
exec #CreateProduct '537D6491','Extension PP 100x500 EPDM','ACV','Acc','Code','PCS','PAL',320,'Net',0.3,'Kg','Gross',0.3,'Kg'
exec #CreateProduct '537D6492','Extension PP 100x1000 EPDM','ACV','Acc','Code','PCS','PAL',160,'Net',0.6,'Kg','Gross',0.6,'Kg'
exec #CreateProduct '537D6493','Elbow PP 100 90° EPDM','ACV','Acc','Code','PCS','PAL',384,'Net',0.13,'Kg','Gross',0.13,'Kg'
exec #CreateProduct '537D6494','Elbow PP 100 45° EPDM','ACV','Acc','Code','PCS','PAL',384,'Net',0.11,'Kg','Gross',0.11,'Kg'
exec #CreateProduct '537D6495','Wall bracket 100 PP','ACV','Acc','Code','PCS','PAL',3200,'Net',1.115,'Kg','Gross',1.115,'Kg'
exec #CreateProduct '537D6497','Roof terminal PP 200 7021','ACV','Acc','Code','PCS','PAL',12,'Net',7.55,'Kg','Gross',7.55,'Kg'
exec #CreateProduct '537D6498','Weather slate Steep lead 200 25°-45°','ACV','Acc','Code','PCS','PAL',30,'Net',4,'Kg','Gross',4,'Kg'
exec #CreateProduct '537D6499','Weather slate Flat lead 200 0°','ACV','Acc','Code','PCS','PAL',120,'Net',0.76,'Kg','Gross',0.76,'Kg'
exec #CreateProduct '537D6500','Extension PP Dn 200 L.1900mm Flue','ACV','Acc','Code','PCS','PAL',20,'Net',6,'Kg','Gross',6,'Kg'
exec #CreateProduct '537D6501','Elbow PP 200 45° EPDM','ACV','Acc','Code','PCS','PAL',128,'Net',1.26,'Kg','Gross',1.26,'Kg'
exec #CreateProduct '537D6502','Support elbow PP 200 90° Viton','ACV','Acc','Code','PCS','PAL',48,'Net',1.26,'Kg','Gross',1.26,'Kg'
exec #CreateProduct '537D6503','Support elbow PP 200 90° EPDM','ACV','Acc','Code','PCS','PAL',27,'Net',1.26,'Kg','Gross',1.26,'Kg'
exec #CreateProduct '537D6504','Chimney cap AL + Air 200','ACV','Acc','Code','PCS','PAL',12,'Net',0.5,'Kg','Gross',0.5,'Kg'
exec #CreateProduct '537D6506','Wall Bracket Dn 200','ACV','Acc','Code','PCS','PAL',3200,'Net',2.105,'Kg','Gross',2.105,'Kg'
exec #CreateProduct '537D6507','Spacer Bracket Dn 200 (2 pcs)','ACV','Acc','Code','PCS','PAL',1600,'Net',0.2,'Kg','Gross',0.2,'Kg'
exec #CreateProduct '537D6509','Expander pp 150-200 EPDM','ACV','Acc','Code','PCS', null, 0,'Net' ------------------------------------------------------------------------
exec #CreateProduct '557A0181','Joint plat Durion 9000 PSGSK12','ACV','Acc','Code','PCS','PAL',300,'Net',0.01,'Kg','Gross',0.01,'Kg'
exec #CreateProduct '5785A002','CAPTEUR HELIOPLAN N','ACV','FP','SerialNr_Code_PY','PCS','PAL',8,'Net',48,'Kg','Gross',48,'Kg'
exec #CreateProduct '5785A004','Capteur HelioPlan S 110100056.1','ACV','FP','SerialNr_Code_PY','PCS','PAL',8,'Net',38,'Kg','Gross',38,'Kg'
exec #CreateProduct '5785C000','GROUPE DE TRANSFERT','ACV','Acc','Code','PCS','PAL',30,'Net',7.96,'Kg','Gross',7.96,'Kg'
exec #CreateProduct '5785C001','FLUIDE CALOPORTEUR 10L','ACV','Acc','Code','PCS','PAL',36,'Net',11.55,'Kg','Gross',11.55,'Kg'
exec #CreateProduct '5785C002','MITIGEUR THERMOSTATIQUE HELIOMIX 3/4''','ACV','Acc','Code','PCS', null, 0,'Net',0.7,'Kg','Gross',0.7,'Kg'
exec #CreateProduct '5785C003','KIT VASE D''EXPANSION 18L','ACV','Acc','Code','PCS','PAL',25,'Net',3.96,'Kg','Gross',3.96,'Kg'
exec #CreateProduct '5785C004','KIT VASE D''EXPANSION 24L','ACV','Acc','Code','PCS','PAL',20,'Net',5.5,'Kg','Gross',5.5,'Kg'
exec #CreateProduct '5785C005','GROUPE DE TRANSFERT 25/80','ACV','Acc','Code','PCS','PAL',30,'Net',9.66,'Kg','Gross',9.66,'Kg'
exec #CreateProduct '5785C012','Kit pré-vase d''expansion 5L','ACV','Acc','Code','PCS', null, 0,'Net',2.02,'Kg','Gross',2.02,'Kg'
exec #CreateProduct '5785C013','Kit de 2 vannes de VIDANGE','ACV','Acc','Code','PCS', null, 0,'Net',0.43,'Kg','Gross',0.43,'Kg'
exec #CreateProduct '5785C014','Vanne isolement pour VASE D''EXPANSION','ACV','Acc','Code','PCS','PAL',1200,'Net',0.34,'Kg','Gross',0.34,'Kg'
exec #CreateProduct '5785C015','FLUIDE CALOPORTEUR HELIOFLUID 5L','ACV','Acc','Code','PCS','PAL',90,'Net',5.53,'Kg','Gross',5.53,'Kg'
exec #CreateProduct '5785C160','FLEXIBLES HELIOLINE DN16 15MM','ACV','Acc','Code','PCS','PAL',12,'Net',10.5,'Kg','Gross',10.5,'Kg'
exec #CreateProduct '5785C162','Kit 2 racc. à visser HELIOLINE DN16','ACV','Acc','Code','PCS','PAL',2000,'Net',0.2,'Kg','Gross',0.2,'Kg'
exec #CreateProduct '5785C163','KIT 2 RACCORDS ALLONGNEMENT DN16','ACV','Acc','Code','PCS','PAL',1600,'Net',0.29,'Kg','Gross',0.29,'Kg'
exec #CreateProduct '5785C164','KIT DE 4 FIXATIONS HELIOLINE DN16','ACV','Acc','Code','PCS','PAL',360,'Net',0.56,'Kg','Gross',0.56,'Kg'
exec #CreateProduct '5785C165','KIT 2 RACCORDS SUR HELIOGROUP DN16','ACV','Acc','Code','PCS','PAL',1600,'Net',0.35,'Kg','Gross',0.35,'Kg'
exec #CreateProduct '5785C166','KIT 2 RACCORDS FEMELLE A VISSER DN16','ACV','Acc','Code','PCS','PAL',2000,'Net',0.22,'Kg','Gross',0.22,'Kg'
exec #CreateProduct '5785C168','KIT HYDR FACE TO FACE','ACV','Acc','Code','PCS', null, 0,'Net',0.51,'Kg','Gross',0.51,'Kg'
exec #CreateProduct '5785C169','FLEXIBLES HELIOLINE DN16 10M','ACV','Acc','Code','PCS','PAL',15,'Net',11,'Kg','Gross',11,'Kg'
exec #CreateProduct '5785C200','FLEXIBLES HELIOLINE DN20 15M','ACV','Acc','Code','PCS','PAL',12,'Net',12.5,'Kg','Gross',12.5,'Kg'
exec #CreateProduct '5785C202','KIT 2 RACCORDS A VISSER DN20','ACV','Acc','Code','PCS','PAL',1350,'Net',0.16,'Kg','Gross',0.16,'Kg'
exec #CreateProduct '5785C203','KIT 2 RACCORDS ALLONGEMENT DN20','ACV','Acc','Code','PCS','PAL',1200,'Net',0.55,'Kg','Gross',0.55,'Kg'
exec #CreateProduct '5785C204','KIT DE 4 FIXATION HELIOLINE DN20','ACV','Acc','Code','PCS','PAL',360,'Net',0.62,'Kg','Gross',0.62,'Kg'
exec #CreateProduct '5785C205','KIT 2 RACCORDS SUR HELIOGROUP DN 20','ACV','Acc','Code','PCS','PAL',1600,'Net',0.48,'Kg','Gross',0.48,'Kg'
exec #CreateProduct '5785C206','KIT 2 RACCORDS FEMELLE A VISSER DN20','ACV','Acc','Code','PCS','PAL',1600,'Net',0.26,'Kg','Gross',0.26,'Kg'
exec #CreateProduct '5785D000','REGULATION SOLAR UNIT 1','ACV','Acc','Code','PCS','PAL',20,'Net',0.5,'Kg','Gross',0.5,'Kg'
exec #CreateProduct '5785D001','BOITIER DE PROTECTION SURTENSION','ACV','Acc','Code','PCS','PAL',800,'Net',0.09,'Kg','Gross',0.09,'Kg'
exec #CreateProduct '5785D005','Sonde PT1000','ACV','Acc','Code','PCS','PAL',4000,'Net',0.07,'Kg','Gross',0.07,'Kg'
exec #CreateProduct '5785D006','REGULATION SOLAR UNIT 2','ACV','Acc','Code','PCS','PAL',20,'Net',0.61,'Kg','Gross',0.61,'Kg'
exec #CreateProduct '5785D007','VANNE 3V 3/4 MOTORISE','ACV','Acc','Code','PCS', null, 0,'Net',1,'Kg','Gross',1,'Kg'
exec #CreateProduct '5785D008','Vanne 3 voies 1" MOTORISE"','ACV','Acc','Code','PCS', null, 0,'Net',0.94,'Kg','Gross',0.94,'Kg'
exec #CreateProduct '5785D011','KIT ECHANGEUR PISCINE 20','ACV','Acc','Code','PCS', null, 0,'Net',7.3,'Kg','Gross',7.3,'Kg'
exec #CreateProduct '5785D012','KIT ECHANGEUR PISCINE 10','ACV','Acc','Code','PCS', null, 0,'Net',6.4,'Kg','Gross',6.4,'Kg'
exec #CreateProduct '5785D013','KIT COMPTEUR CHALEUR 1,5','ACV','Acc','Code','PCS', null, 0,'Net',1.53,'Kg','Gross',1.53,'Kg'
exec #CreateProduct '5785E000','KIT MONTAGE 2 CAPTEURS SUR TOITURE','ACV','Acc','Code','PCS','PAL',48,'Net',6,'Kg','Gross',6,'Kg'
exec #CreateProduct '5785E001','KIT 6 SUPPORTS POUR TUILE MECANIQUE','ACV','Acc','Code','PCS','PAL',56,'Net',6.012,'Kg','Gross',6.012,'Kg'
exec #CreateProduct '5785E002','KIT 6 SUPPORTS POUR ARDOISES','ACV','Acc','Code','PCS','PAL',56,'Net',7.74,'Kg','Gross',7.74,'Kg'
exec #CreateProduct '5785E003','KIT MONTAGE TOIT PLAT 1 CAPTEUR VERTICAL','ACV','Acc','Code','PCS','PAL',48,'Net',12.35,'Kg','Gross',12.35,'Kg'
exec #CreateProduct '5785E004','KIT EXT. TOIT PLAT 1 CAPTEUR VERTICAL','ACV','Acc','Code','PCS','PAL',48,'Net',6.8,'Kg','Gross',6.8,'Kg'
exec #CreateProduct '5785E005','KIT EXTENSION 1 CAPTEUR SUR TOITURE','ACV','Acc','Code','PCS','PAL',48,'Net',3.2,'Kg','Gross',3.2,'Kg'
exec #CreateProduct '5785E006','KIT 2 SUPPORTS POUR TUILE MECANIQUE','ACV','Acc','Code','PCS','PAL',100,'Net',2.56,'Kg','Gross',2.56,'Kg'
exec #CreateProduct '5785E008','KIT MONTAGE 2 CAPTEURS INTEGR. TUILES','ACV','Acc','Code','PCS','PAL',10,'Net',20.7,'Kg','Gross',20.7,'Kg'
exec #CreateProduct '5785E009','KIT EXT. 1 CAPTEUR INTEGR. ARDOISES','ACV','Acc','Code','PCS','PAL',10,'Net',7.8,'Kg','Gross',7.8,'Kg'
exec #CreateProduct '5785E010','KIT MONTAGE 1 CAPTEUR SUR TOITURE','ACV','Acc','Code','PCS','PAL',48,'Net',2.9,'Kg','Gross',2.9,'Kg'
exec #CreateProduct '5785E011','KIT MONTAGE TOIT PLAT 1 CAPTEUR HORIZ.','ACV','Acc','Code','PCS','PAL',48,'Net',7.93,'Kg','Gross',7.93,'Kg'
exec #CreateProduct '5785E012','KIT INTEGR. CAPTEUR UNIQUE HELIOPLAN','ACV','Acc','Code','PCS','PAL',10,'Net',9.7,'Kg','Gross',9.7,'Kg'
exec #CreateProduct '5785E015','KIT 6 PROFILS DE LESTAGE 2 CAPTEURS','ACV','Acc','Code','PCS','PAL',8,'Net',19,'Kg','Gross',19,'Kg'
exec #CreateProduct '5785E016','KIT 6 PROFILS DE LESTAGE 3 CAPTEURS','ACV','Acc','Code','PCS','PAL',6,'Net',27.34,'Kg','Gross',27.34,'Kg'
exec #CreateProduct '5785E017','KIT 6 PROFILS DE LESTAGE 1 CAPTEUR','ACV','Acc','Code','PCS','PAL',8,'Net',26.02,'Kg','Gross',26.02,'Kg'
exec #CreateProduct '5785E018','KIT 8 VIS TIRE-FOND','ACV','Acc','Code','PCS','PAL',112,'Net',1.74,'Kg','Gross',1.74,'Kg'
exec #CreateProduct '5785E019','KIT 4 VIS TIRE-FOND','ACV','Acc','Code','PCS', null, 0,'Net',3.32,'Kg','Gross',3.32,'Kg'
exec #CreateProduct '5785E020','kit STD intégr. ardois HELIOPLAN 2010','ACV','Acc','Code','PCS','PAL',10,'Net',18.32,'Kg','Gross',18.32,'Kg'
exec #CreateProduct '5785E022','KIT INTEGRATION CAPTEUR UNIQUE ARDOISES','ACV','Acc','Code','PCS','PAL',10,'Net',13.8,'Kg','Gross',13.8,'Kg'
exec #CreateProduct '5785G000','POMPE DE REMPLISSAGE','ACV','Acc','Code','PCS','PAL',90,'Net',14.24,'Kg','Gross',14.24,'Kg'
exec #CreateProduct '5785P004','Thermomètre bleu','ACV','Acc','Code','PCS', null, 0,'Net',0.02,'Kg','Gross',0.02,'Kg'
exec #CreateProduct '5785P025','FLEXIBLE DE RACC. CAPTEUR','ACV','Acc','Code','PCS', null, 0,'Net',0.99,'Kg','Gross',0.99,'Kg'
exec #CreateProduct '5786C120','HELIOLINE DB DN10 CU - 15MM','ACV','Acc','Code','PCS','PAL',15,'Net',11.5,'Kg','Gross',11.5,'Kg'
exec #CreateProduct '5786E000','KIT MONTAGE 2 CAPTEURS DB SUR TOITURE','ACV','Acc','Code','PCS','PAL',72,'Net',3.56,'Kg','Gross',3.56,'Kg'
exec #CreateProduct '5786E010','KIT MONTAGE 1 CAPTEUR DB Sur TOITURE','ACV','Acc','Code','PCS','PAL',72,'Net',1.74,'Kg','Gross',1.74,'Kg'
exec #CreateProduct '5786E011','KIT MONTAGE TOIT PLAT 1 CAPT. DB HORIZ.','ACV','Acc','Code','PCS','PAL',80,'Net',5.7,'Kg','Gross',5.7,'Kg'
exec #CreateProduct '91065117','SENSOR BOILER 12KOhm','ACV','Acc','Code','PCS', null, 0,'Net',0.5,'Kg','Gross',0.5,'Kg'
exec #CreateProduct '91090177','ELEMENT MESURE 80/125 HR','ACV','Acc','Code','PCS', null, 0,'Net',0.5,'Kg','Gross',0.5,'Kg'
exec #CreateProduct '91090347','KIT POUR BOILER SOLAIRE REMPLACE I090317','ACV','Acc','Code','PCS', null, 0,'Net',0.27,'Kg','Gross',0.27,'Kg'
exec #CreateProduct '91090357','Kit Solar Kompakt ACV ES','ACV','Acc','Code','PCS', null, 0,'Net',0.1,'Kg','Gross',0.1,'Kg'
exec #CreateProduct '91090547','Adapter with measurement extn HRE 60/100','ACV','Acc','Code','PCS', null, 0,'Net',0.23,'Kg','Gross',0.23,'Kg'
exec #CreateProduct '91090557','ELEMNT MESURE 80/125 HRE','ACV','Acc','Code','PCS', null, 0,'Net',0.25,'Kg','Gross',0.25,'Kg'
exec #CreateProduct '91092507','short frame HR28/24','ACV','Acc','Code','PCS', null, 0,'Net',2.6,'Kg','Gross',2.6,'Kg'
exec #CreateProduct '91092527','PLAQUE DE PROTECTION','ACV','Acc','Code','PCS', null, 0,'Net',2.7,'Kg','Gross',2.7,'Kg'
exec #CreateProduct '91092647','SET VANNE 3 VOIES 230V','ACV','Acc','Code','PCS', null, 0,'Net',1.2,'Kg','Gross',1.2,'Kg'
exec #CreateProduct '91092687','EQUERRE DE FIXATION','ACV','Acc','Code','PCS', null, 0,'Net',1.6,'Kg','Gross',1.6,'Kg'
exec #CreateProduct '91092697','SET DE MONTAGE BAS HR KOMBI','ACV','Acc','Code','PCS', null, 0,'Net',1.5,'Kg','Gross',1.5,'Kg'
exec #CreateProduct '91092757','DOSSERET MODEL LONG','ACV','Acc','Code','PCS', null, 0,'Net',2.8,'Kg','Gross',2.8,'Kg'
exec #CreateProduct '91093217','Cache tuyaux HRE','ACV','Acc','Code','PCS', null, 0,'Net',0.96,'Kg','Gross',0.96,'Kg'
exec #CreateProduct '91093227','Wall mnt frm HRE 14/18 w/ Exp vess sml','ACV','Acc','Code','PCS', null, 0,'Net',8,'Kg','Gross',8,'Kg'
exec #CreateProduct '91093237','Wall mnt frm HRE 28/24 w/ Exp vess med','ACV','Acc','Code','PCS', null, 0,'Net',8.2,'Kg','Gross',8.2,'Kg'
exec #CreateProduct '91093247','Wall mnt frm HRE 36/30 w/ Exp vess med','ACV','Acc','Code','PCS', null, 0,'Net',8.4,'Kg','Gross',8.4,'Kg'
exec #CreateProduct '91093257','EQUERRE DE FIXATION HRE','ACV','Acc','Code','PCS', null, 0,'Net',1.6,'Kg','Gross',1.6,'Kg'
exec #CreateProduct '91093267','SET DE MONTAGE BAS HRE KOMBI','ACV','Acc','Code','PCS', null, 0,'Net',2.6,'Kg','Gross',2.6,'Kg'
exec #CreateProduct '91093397','Kit raccordement HRE avec disconnecteur','ACV','Acc','Code','PCS', null, 0,'Net',3.2,'Kg','Gross',3.2,'Kg'
exec #CreateProduct '91093407','KIT raccordement HR avec disconnecteur','ACV','Acc','Code','PCS', null, 0,'Net',3.2,'Kg','Gross',3.2,'Kg'
exec #CreateProduct '91093417','Kit raccordement HRE standard','ACV','Acc','Code','PCS', null, 0,'Net',3,'Kg','Gross',3,'Kg'
exec #CreateProduct '91093427','Kit raccordement HR standard','ACV','Acc','Code','PCS', null, 0,'Net',3,'Kg','Gross',3,'Kg'
exec #CreateProduct '77777777','Euro Pallet','ACV','PACKAGING MATERIAL','Code','PCS', null, 0
exec #CreateProduct '11111111','Spare Pallets','ACV','Acc','Code','PCS', null, 0,'Net',50,'Kg','Gross',50,'Kg'
go