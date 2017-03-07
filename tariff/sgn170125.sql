-- run createProc.sql
-- where tf.INTERNAL_COMPANY_ID = 220

BEGIN TRY
	BEGIN TRANSACTION	
	--Your code starts here

declare @CutOffDate datetime = '1-FEB-2017';
declare @updateUser nvarchar(15) = 'sys170123'
declare @tmpTariffId int

EXEC [dbo].[TariffGeneral_CreateTariff]
	@TariffType = 'A',
	@TariffInfoCode = 'TAOCTRHT',
	@TariffInfoDescr = 'Traction Container Rotterdam Home terminal',
	@TariffInfoTariff = 295,
	@UnitCode = 'CONTAINER',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AOCTRHT',
	@ServiceAccount = '701100',
	@TariffFileReference = 'ADD_TARIFFS_SGN',
	@IcCompanyCode =	'IC_SGN',
	@createUser = @updateUser

EXEC [dbo].[TariffGeneral_CreateTariff]
	@TariffType = 'A',
	@TariffInfoCode = 'TAOTRE',
	@TariffInfoDescr = 'Transport Euskirchen',
	@TariffInfoTariff = 485,
	@UnitCode = 'TRP',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AOTRE',
	@ServiceAccount = '701100',
	@TariffFileReference = 'ADD_TARIFFS_SGN',
	@IcCompanyCode =	'IC_SGN',
	@createUser = @updateUser	

update t set
	PERIOD_TO = dateadd(ms, -10, @CutOffDate),
	UPDATE_USER = @updateUser,
	UPDATE_TIMESTAMP=GETDATE()
from TARIFF t join TARIFF_FILE tf on t.TARIFF_FILE_ID = tf.TARIFF_FILE_ID and t.PERIOD_FROM < getdate() and t.PERIOD_TO > getdate() 
	join COMPANY c on tf.INTERNAL_COMPANY_ID = c.COMPANYNR and c.CODE = 'IC_SGN'

EXEC [dbo].[TariffGeneral_CreateTariffFileForGrouping]
	@Description =			'Discharging minimum',
	@TariffFileReference =	'DischargingMINFIXEDTARIFF',
	@IC_code =				'IC_SGN'
EXEC [dbo].[TariffGeneral_CreateTariffFileForGrouping]
	@Description =			'Loading minimum',
	@TariffFileReference =	'LoadingMINFIXEDTARIFF',
	@IC_code =				'IC_SGN'
	
EXEC [dbo].[TariffGeneral_CreateTariff]
	@TariffType =			'D',
	@TariffInfoCode =		'LOS06S',
	@TariffInfoDescr =		'LOS06S',
	@TariffInfoTariff =		3.81,
	@UnitCode =				'BUNDLE',
	@CurrencyCode =			'EUR',
	@TariffFileReference =	'DischargingSGN',
	@IcCompanyCode =		'IC_SGN',
	@DateFrom =				@CutOffDate,
	@ServiceAccount =		'701300'
	
EXEC [dbo].[TariffGeneral_CreateTariff]
	@TariffType =			'L',
	@TariffInfoCode =		'LAD06S',
	@TariffInfoDescr =		'LAD06S',
	@TariffInfoTariff =		3.81,
	@UnitCode =				'BUNDLE',
	@CurrencyCode =			'EUR',
	@TariffFileReference =	'LoadingSGN',
	@IcCompanyCode =		'IC_SGN',
	@DateFrom =				@CutOffDate,
	@ServiceAccount =		'701300'
		
EXEC [dbo].[TariffGeneral_CreateTariff]
	@TariffType =			'D',
	@TariffInfoCode =		'LOS06S_MIN',
	@TariffInfoDescr =		'Minimum charge per unloading order / SGN',
	@TariffInfoTariff =		84,
	@UnitCode =				'FIXED',
	@CurrencyCode =			'EUR',
	@TariffFileReference =	'DischargingMINFIXEDTARIFF',
	@IcCompanyCode =		'IC_SGN',
	@DateFrom =				@CutOffDate,
	@ServiceAccount =		'701300'
	
EXEC [dbo].[TariffGeneral_CreateTariff]
	@TariffType =			'L',
	@TariffInfoCode =		'LAD06S_MIN',
	@TariffInfoDescr =		'Minimum charge per loading order / SGN',
	@TariffInfoTariff =		84,
	@UnitCode =				'FIXED',
	@CurrencyCode =			'EUR',
	@TariffFileReference =	'LoadingMINFIXEDTARIFF',
	@IcCompanyCode =		'IC_SGN',
	@DateFrom =				@CutOffDate,
	@ServiceAccount =		'701300'
		
EXEC [dbo].[TariffGeneral_CreateTariff]
	@TariffType = 'A',
	@TariffInfoCode = 'TAOCTTR',
	@TariffInfoDescr = 'Traction Container Antwerp',
	@TariffInfoTariff = 163,
	@UnitCode = 'TRP',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AOCTTR',
	@ServiceAccount = '701100',
	@TariffFileReference = 'ADD_TARIFFS_SGN',
	@IcCompanyCode =		'IC_SGN',
	@DateFrom =				@CutOffDate,
	@createUser = @updateUser
	
EXEC [dbo].[TariffGeneral_CreateTariff]
	@TariffType = 'A',
	@TariffInfoCode = 'TAWHSP',
	@TariffInfoDescr = 'Extra works hours: wh operator',
	@TariffInfoTariff = 56,
	@UnitCode = 'HR',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AWHSP',
	@ServiceAccount = '700000',
	@TariffFileReference = 'ADD_TARIFFS_SGN',
	@IcCompanyCode =		'IC_SGN',
	@DateFrom =				@CutOffDate,
	@createUser = @updateUser

EXEC [dbo].[TariffGeneral_CreateTariff]
	@TariffType = 'A',
	@TariffInfoCode = 'TAOCTRT',
	@TariffInfoDescr = 'Traction Container Rotterdam',
	@TariffInfoTariff = 350,
	@UnitCode = 'TRP',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AOCTRT',
	@ServiceAccount = '701100',
	@TariffFileReference = 'ADD_TARIFFS_SGN',
	@IcCompanyCode =		'IC_SGN',
	@DateFrom =				@CutOffDate,
	@createUser = @updateUser

EXEC [dbo].[TariffGeneral_CreateTariff]
	@TariffType = 'A',
	@TariffInfoCode = 'TAADMFEEORDER',
	@TariffInfoDescr = 'Admin Fee',
	@TariffInfoTariff = 5.1,
	@UnitCode = 'ORDER',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AADMFEEORDER',
	@ServiceAccount = '701310',
	@TariffFileReference = 'ADD_TARIFFS_SGN',
	@IcCompanyCode =		'IC_SGN',
	@DateFrom =				@CutOffDate,
	@createUser = @updateUser
	
EXEC [dbo].[TariffGeneral_CreateTariff]
	@TariffType = 'A',
	@TariffInfoCode = 'TAOCA',
	@TariffInfoDescr = 'Cargo Agency',
	@TariffInfoTariff = .36,
	@UnitCode = 'TON',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AOCA',
	@ServiceAccount = '701310',
	@TariffFileReference = 'ADD_TARIFFS_SGN',
	@IcCompanyCode =		'IC_SGN',
	@DateFrom =				@CutOffDate,
	@createUser = @updateUser
	
EXEC [dbo].[TariffGeneral_CreateTariff]
	@TariffType = 'A',
	@TariffInfoCode = 'TPCSTD',
	@TariffInfoDescr = 'Customs Clearance',
	@TariffInfoTariff = 50.85,
	@UnitCode = 'APRNCE',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'PCSTD',
	@ServiceAccount = '701310',
	@TariffFileReference = 'ADD_TARIFFS_SGN',
	@IcCompanyCode =		'IC_SGN',
	@DateFrom =				@CutOffDate,
	@createUser = @updateUser

EXEC [dbo].[TariffGeneral_CreateTariff]
	@TariffType = 'A',
	@TariffInfoCode = 'TAOBISLIST',
	@TariffInfoDescr = 'AOBISLIST',
	@TariffInfoTariff = 6.1,
	@UnitCode = 'APRNCE',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AOBISLIST',
	@ServiceAccount = '701310',
	@TariffFileReference = 'ADD_TARIFFS_SGN',
	@IcCompanyCode =		'IC_SGN',
	@DateFrom =				@CutOffDate,
	@createUser = @updateUser
	
EXEC [dbo].[TariffGeneral_CreateTariff]
	@TariffType = 'A',
	@TariffInfoCode = 'TAOISDALBM',
	@TariffInfoDescr = 'Customs Document IMA-7',
	@TariffInfoTariff = 50.85,
	@UnitCode = 'APRNCE',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AOISDALBM',
	@ServiceAccount = '701310',
	@TariffFileReference = 'ADD_TARIFFS_SGN',
	@IcCompanyCode =		'IC_SGN',
	@DateFrom =				@CutOffDate,
	@createUser = @updateUser

EXEC [dbo].[TariffGeneral_CreateTariff]
	@TariffType = 'A',
	@TariffInfoCode = 'TAOEDALBM',
	@TariffInfoDescr = 'Customs Document T1',
	@TariffInfoTariff = 30.5,
	@UnitCode = 'APRNCE',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AOEDALBM',
	@ServiceAccount = '701310',
	@TariffFileReference = 'ADD_TARIFFS_SGN',
	@IcCompanyCode =		'IC_SGN',
	@DateFrom =				@CutOffDate,
	@createUser = @updateUser
	
EXEC [dbo].[TariffGeneral_CreateTariff]
	@TariffType = 'A',
	@TariffInfoCode = 'TAOREWRAP',
	@TariffInfoDescr = 'Re-Wrapping Reels',
	@TariffInfoTariff = 10.2,
	@UnitCode = 'PCS',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AOREWRAP',
	@ServiceAccount = '701310',
	@TariffFileReference = 'ADD_TARIFFS_SGN',
	@IcCompanyCode =		'IC_SGN',
	@DateFrom =				@CutOffDate,
	@createUser = @updateUser
	
EXEC [dbo].[TariffGeneral_CreateTariff]
	@TariffType = 'W',
	@TariffInfoCode = 'MAG12',
	@TariffInfoDescr = 'MAG12',
	@TariffInfoTariff = 3.92,
	@UnitCode = 'Net',
	@MeasurementUnitDescription = 't',
	@CurrencyCode = 'EUR',
	@ServiceAccount = '700514',
	@TariffFileReference = 'WarehouseRentSgn',
	@IcCompanyCode =		'IC_SGN',
	@Period = null,	
	@PeriodType = 2,	-- 0 = Day, 1 = Week, 2 = Month
	@FreePeriod = 0,	
	@FreePeriodType = 0, -- 0 = Day, 1 = Week, 2 = Month
	@DateFrom =				@CutOffDate,
	@createUser = @updateUser	
	
EXEC [dbo].[TariffGeneral_CreateTariff]
	@TariffType = 'A',
	@TariffInfoCode = 'TAORBS',
	@TariffInfoDescr = 'Right bank surcharge',
	@TariffInfoTariff = 45,
	@UnitCode = 'CONTAINER',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AORBS',
	@ServiceAccount = '701100',
	@TariffFileReference = 'ADD_TARIFFS_SGN',
	@IcCompanyCode = 'IC_SGN',
	@createUser = @updateUser

EXEC [dbo].[TariffGeneral_CreateTariff]
	@TariffType = 'A',
	@TariffInfoCode = 'TAOCTRHT',
	@TariffInfoDescr = 'Traction Container Rotterdam Home terminal',
	@TariffInfoTariff = 300,
	@UnitCode = 'CONTAINER',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AOCTRHT',
	@ServiceAccount = '701100',
	@TariffFileReference = 'ADD_TARIFFS_SGN',
	@IcCompanyCode = 'IC_SGN',
	@DateFrom =	@CutOffDate,
	@createUser = @updateUser

EXEC [dbo].[TariffGeneral_CreateTariff]
	@TariffType = 'A',
	@TariffInfoCode = 'TAOTRE',
	@TariffInfoDescr = 'Transport Euskirchen',
	@TariffInfoTariff = 493,
	@UnitCode = 'TRP',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AOTRE',
	@ServiceAccount = '701100',
	@TariffFileReference = 'ADD_TARIFFS_SGN',
	@IcCompanyCode =	'IC_SGN',
	@DateFrom =	 @CutOffDate,
	@createUser = @updateUser	

	--Your code ends here
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION
		SELECT ERROR_NUMBER() as ErrorNumber, ERROR_MESSAGE() as ErrorMessage
END CATCH
GO




