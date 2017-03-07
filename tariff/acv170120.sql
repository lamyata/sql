-- run createProc.sql
-- where tf.INTERNAL_COMPANY_ID = 1

BEGIN TRY
	BEGIN TRANSACTION	
	--Your code starts here

declare @CutOffDate datetime = '1-FEB-2017';
declare @updateUser nvarchar(15) = 'sys170123'
declare @tmpTariffId int

update t set
	PERIOD_TO = dateadd(ms, -10, @CutOffDate),
	UPDATE_USER = @updateUser,
	UPDATE_TIMESTAMP=GETDATE()
from TARIFF t join TARIFF_FILE tf on t.TARIFF_FILE_ID = tf.TARIFF_FILE_ID and t.PERIOD_FROM < getdate() and t.PERIOD_TO > getdate() 
	join TARIFF_INFO ti on t.TARIFF_INFO_ID = ti.TARIFF_INFO_ID and ti.CODE != 'LOS04_1' -- LOS04_1 won't be modified
	join COMPANY c on tf.INTERNAL_COMPANY_ID = c.COMPANYNR and c.CODE = 'IC_ACV'

update tf set
	REFERENCE = tf.DESCRIPTION + 'ACV',
	UPDATE_USER = @updateUser,
	UPDATE_TIMESTAMP = getdate()
from TARIFF_FILE tf, TARIFF t, TARIFF_INFO ti
where tf.TARIFF_FILE_ID = t.TARIFF_FILE_ID and t.TARIFF_INFO_ID = ti.TARIFF_INFO_ID and ti.CODE in ('LOS01', 'LAD01')

	EXEC [dbo].[TariffGeneral_CreateTariff]
		@TariffType =			'D',
		@TariffInfoCode =		'LOS01',
		@TariffInfoDescr =		'Unloading pallets ex-truck / ACV INT',
		@TariffInfoTariff =		3.71,
		@UnitCode =				'PAL',
		@CurrencyCode =			'EUR',
		@TariffFileReference =	'DischargingACV',
		@IcCompanyCode =		'IC_ACV',
		@DateFrom =				@CutOffDate,
		@ServiceAccount =		'701300',
		@TransportTypeCodes =	'SLSRV,TR',
		@CustomerCodes =		'491000'

	EXEC [dbo].[TariffGeneral_CreateTariff]
		@TariffType =			'D',
		@TariffInfoCode =		'EXH03',
		@TariffInfoDescr =		'Unloading ex-container and palletizing in the warehouse / ACV INT',
		@TariffInfoTariff =		432,
		@UnitCode =				'TRP',
		@CurrencyCode =			'EUR',
		@TariffFileReference =	'DischargingACV',
		@IcCompanyCode =		'IC_ACV',
		@DateFrom =				@CutOffDate,
		@ServiceAccount =		'701300',
		@TransportTypeCodes =	'CNT',
		@CustomerCodes =		'491000'

	EXEC [dbo].[TariffGeneral_CreateTariff]
		@TariffType =			'D',
		@TariffInfoCode =		'LOS02',
		@TariffInfoDescr =		'Minimum charge per unloading order / ACV INT',
		@TariffInfoTariff =		25.5,
		@UnitCode =				'FIXED',
		@CurrencyCode =			'EUR',
		@TariffFileReference =	'DischargingMINFIXEDTARIFF',
		@IcCompanyCode =		'IC_ACV',
		@DateFrom =				@CutOffDate,
		@ServiceAccount =		'701300',
		@CustomerCodes =		'491000'

	EXEC [dbo].[TariffGeneral_CreateTariff]
		@TariffType =			'D',
		@TariffInfoCode =		'LOS04',
		@TariffInfoDescr =		'Fixed charge per unloading order / ACV BE',
		@TariffInfoTariff =		11.2,
		@UnitCode =				'ORDER',
		@CurrencyCode =			'EUR',
		@TariffFileReference =	'DischargingACV',
		@IcCompanyCode =		'IC_ACV',
		@DateFrom =				@CutOffDate,
		@ServiceAccount =		'701300',
		@CustomerCodes =		'493200'

	EXEC [dbo].[TariffGeneral_CreateTariff]
		@TariffType =			'L',
		@TariffInfoCode =		'LAD01',
		@TariffInfoDescr =		'Orderpicking and loading pallets on truck / ACV INT',
		@TariffInfoTariff =		3.71,
		@UnitCode =				'PAL',
		@CurrencyCode =			'EUR',
		@TariffFileReference =	'LoadingACV',
		@IcCompanyCode =		'IC_ACV',
		@DateFrom =				@CutOffDate,
		@ServiceAccount =		'701300',
		@TransportTypeCodes =	'SLSRV,TR,CNT',
		@CustomerCodes =		'491000'
		
declare @exh01TariffId int;
exec @exh01TariffId = [dbo].[TariffGeneral_CreateTariff]
		@TariffType =			'L',
		@TariffInfoCode =		'EXH01',
		@TariffInfoDescr =		'Preparation of spare pallets in the warehouse / ACV INT',
		@TariffInfoTariff =		25.5,
		@UnitCode =				'PAL',
		@CurrencyCode =			'EUR',
		@TariffFileReference =	'LoadingACV',
		@IcCompanyCode =		'IC_ACV',
		@DateFrom =				@CutOffDate,
		@ServiceAccount =		'701300',
		@CustomerCodes =		'491000'
		
declare @exh01StockInfoId int;
exec @exh01StockInfoId = CreateStockInfoWithSid @sidCode = 'PCS', @sidValue = 'FIRST'; -- sid 'Packaging Sequence'
update LOADING_TARIFF set STOCK_INFO_ID = @exh01StockInfoId where LOADING_TARIFF_ID = @exh01TariffId;

declare @exh02TariffId int;
exec @exh02TariffId = [dbo].[TariffGeneral_CreateTariff]
		@TariffType =			'L',
		@TariffInfoCode =		'EXH02',
		@TariffInfoDescr =		'Per extra pallet / ACV INT',
		@TariffInfoTariff =		10.17,
		@UnitCode =				'PAL',
		@CurrencyCode =			'EUR',
		@TariffFileReference =	'LoadingACV',
		@IcCompanyCode =		'IC_ACV',
		@DateFrom =				@CutOffDate,
		@ServiceAccount =		'701300',
		@CustomerCodes =		'491000'		

declare @exh02StockInfoId int;
exec @exh02StockInfoId = CreateStockInfoWithSid @sidCode = 'PCS', @sidValue = 'NEXT';
update LOADING_TARIFF set STOCK_INFO_ID = @exh02StockInfoId where LOADING_TARIFF_ID = @exh02TariffId;
		
	EXEC [dbo].[TariffGeneral_CreateTariff]
		@TariffType =			'L',
		@TariffInfoCode =		'LAD03',
		@TariffInfoDescr =		'Minimum charge per loading order / ACV INT',
		@TariffInfoTariff =		25.5,
		@UnitCode =				'FIXED',
		@CurrencyCode =			'EUR',
		@DateFrom =				@CutOffDate,
		@TariffFileReference =	'LoadingMINFIXEDTARIFF',
		@IcCompanyCode =		'IC_ACV',
		@ServiceAccount =		'701300',
		@CustomerCodes =		'491000'

	EXEC [dbo].[TariffGeneral_CreateTariff]
		@TariffType =			'L',
		@TariffInfoCode =		'LAD04',
		@TariffInfoDescr =		'Fixed charge per loading order / ACV BE',
		@TariffInfoTariff =		11.2,
		@UnitCode =				'ORDER',
		@CurrencyCode =			'EUR',
		@TariffFileReference =	'LoadingACV',
		@IcCompanyCode =		'IC_ACV',
		@DateFrom =				@CutOffDate,
		@ServiceAccount =		'701300',
		@CustomerCodes =		'493200'

	exec [TariffGeneral_CreateTariff]
		@TariffType =	'A',
		@TariffInfoCode = 'AATRACV',
		@TariffInfoDescr = 'Administratie Truck Russia',
		@TariffInfoTariff = 25.5,
		@UnitCode = 'APRNCE',
		@MeasurementUnitDescription  = null,
		@CurrencyCode = 'EUR',
		@TariffFileReference = 'ADD_TARIFFS_ACV',
		@IcCompanyCode =		'IC_ACV',
		@DateFrom =	@CutOffDate,
		@OperationCode = 'ATR',
		@CustomerCodes = '491000',
		@ServiceAccount = '700310'
	
	exec [TariffGeneral_CreateTariff]
		@TariffType =	'A',
		@TariffInfoCode = 'ACFACV',
		@TariffInfoDescr = 'Custom Formalities',
		@TariffInfoTariff = 5.1,
		@UnitCode = 'APRNCE',
		@MeasurementUnitDescription  = null,
		@CurrencyCode = 'EUR',
		@TariffFileReference = 'ADD_TARIFFS_ACV',
		@IcCompanyCode =		'IC_ACV',
		@DateFrom =	@CutOffDate,
		@OperationCode = 'CF',
		@CustomerCodes = '491000',
		@ServiceAccount = '700310'

	exec [TariffGeneral_CreateTariff]
		@TariffType =	'A',
		@TariffInfoCode = 'ADOUACV',
		@TariffInfoDescr = 'Douane Opmaak Transit',
		@TariffInfoTariff = 50.1,
		@UnitCode = 'APRNCE',
		@MeasurementUnitDescription  = null,
		@CurrencyCode = 'EUR',
		@TariffFileReference = 'ADD_TARIFFS_ACV',
		@IcCompanyCode =		'IC_ACV',
		@DateFrom =	@CutOffDate,
		@OperationCode = 'DOU',
		@CustomerCodes = '491000',
		@ServiceAccount = '700310'

	exec [TariffGeneral_CreateTariff]
		@TariffType =	'W',
		@TariffInfoCode = 'MAG01',
		@TariffInfoDescr = 'Warehouse rent / ACV INT',
		@TariffInfoTariff = 1.02,
		@UnitCode = 'FIXED',
		@MeasurementUnitDescription  = null,
		@CurrencyCode = 'EUR',
		@ServiceAccount = '700514',
		@TariffFileReference = 'WarehouseRentBasicTariff',
		@IcCompanyCode =		'IC_ACV',
		@DateFrom =	@CutOffDate,
		@Period = null, -- Mandatory if create WarehouseRentTariff
		@PeriodType = 1, -- Mandatory if create WarehouseRentTariff; 0=Day, 1=Week, 2=Month 
		@FreePeriod = null, 
		@FreePeriodType = 0 -- 0=Day, 1=Week, 2=Month 

	exec [TariffGeneral_CreateTariff]
		@TariffType =	'W',
		@TariffInfoCode = 'MAG10',
		@TariffInfoDescr = 'MAG10',
		@TariffInfoTariff = 2.14,
		@UnitCode = 'PAL',
		@MeasurementUnitDescription  = null,
		@CurrencyCode = 'EUR',
		@ServiceAccount = '700514',
		@TariffFileReference = 'WarehouseRentKits',
		@IcCompanyCode =		'IC_ACV',
		@DateFrom =	@CutOffDate,
		@Period = null, -- Mandatory if create WarehouseRentTariff
		@PeriodType = 1, -- Mandatory if create WarehouseRentTariff; 0=Day, 1=Week, 2=Month 
		@FreePeriod = null, 
		@FreePeriodType = 0 -- 0=Day, 1=Week, 2=Month 

	exec [TariffGeneral_CreateTariff]
		@TariffType =	'W',
		@TariffInfoCode = 'MAG11',
		@TariffInfoDescr = 'MAG11',
		@TariffInfoTariff = 1.07,
		@UnitCode = 'PAL',
		@MeasurementUnitDescription  = null,
		@CurrencyCode = 'EUR',
		@ServiceAccount = '700514',
		@TariffFileReference = 'WarehouseRentNonKits',
		@IcCompanyCode =		'IC_ACV',
		@DateFrom =	@CutOffDate,
		@Period = null, -- Mandatory if create WarehouseRentTariff
		@PeriodType = 1, -- Mandatory if create WarehouseRentTariff; 0=Day, 1=Week, 2=Month 
		@FreePeriod = null, 
		@FreePeriodType = 0 -- 0=Day, 1=Week, 2=Month 

	--Your code ends here
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION
		SELECT ERROR_NUMBER() as ErrorNumber, ERROR_MESSAGE() as ErrorMessage
END CATCH
GO


