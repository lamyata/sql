--join TARIFF_CUSTOMER tc on t.TARIFF_ID = tc.TARIFF_ID and tc.COMPANY_ID = 516 

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
	join TARIFF_CUSTOMER tc on t.TARIFF_ID = tc.TARIFF_ID join COMPANY c on tc.COMPANY_ID = c.COMPANYNR and c.CODE = 'EXP'

EXEC @tmpTariffId = TariffGeneral_CreateTariff
	@TariffInfoCode = 'DSCHEXP',
	@TariffInfoDescr = 'DISCHARGING into warehouse',
	@TariffInfoTariff = 0,
	@UnitCode = 'PCS',
	@CurrencyCode = 'EUR',
	@OperationCode = NULL,
	@TariffType = 'D',
	@CustomerCodes = 'EXP',
	@ServiceAccount = '701300',
	@TariffFileReference = 'OP_TARIFFS_EXP',
	@IcCompanyCode = 'IC_VMHZP',
	@DateFrom =	@CutOffDate,
	@ProductCode = NULL
exec TariffGeneral_CreateTariffRange  @tmpTariffId, 10.2, null, 3000, 'Gross', 'kg'
exec TariffGeneral_CreateTariffRange  @tmpTariffId, 51, 3000.0001, 8001, 'Gross', 'kg'
exec TariffGeneral_CreateTariffRange  @tmpTariffId, 76.3, 8001.0001, null, 'Gross', 'kg'

exec @tmpTariffId = TariffGeneral_CreateTariff
	@TariffInfoCode = 'LSCHEXP',
	@TariffInfoDescr = 'LOADING ex-warehouse',
	@TariffInfoTariff = 0,
	@UnitCode = 'PCS',
	@CurrencyCode = 'EUR',
	@OperationCode = NULL,
	@TariffType = 'L',
	@CustomerCodes = 'EXP',
	@ServiceAccount = '701300',
	@TariffFileReference = 'OP_TARIFFS_EXP',
	@IcCompanyCode = 'IC_VMHZP',
	@DateFrom =	@CutOffDate,
	@ProductCode = NULL
exec TariffGeneral_CreateTariffRange  @tmpTariffId, 10.2, null, 3000, 'Gross', 'kg'
exec TariffGeneral_CreateTariffRange  @tmpTariffId, 51, 3000.0001, 8001, 'Gross', 'kg'
exec TariffGeneral_CreateTariffRange  @tmpTariffId, 76.3, 8001.0001, null, 'Gross', 'kg'

exec TariffGeneral_CreateTariff
	@TariffInfoCode = 'AOPICEXP',
	@TariffInfoDescr = 'Taking pictures',
	@TariffInfoTariff = 5.05,
	@UnitCode = 'PIC',
	@CurrencyCode = 'EUR',
	@OperationCode = 'PIC',
	@TariffType = 'A',
	@CustomerCodes = 'EXP',
	@ServiceAccount = '701380',
	@TariffFileReference = 'OP_TARIFFS_EXP',
	@IcCompanyCode = 'IC_VMHZP',
	@DateFrom =	@CutOffDate,
	@ProductCode = NULL

exec TariffGeneral_CreateTariff
	@TariffInfoCode = 'AOLBLEXP',
	@TariffInfoDescr = 'Labeling',
	@TariffInfoTariff = 2.7,
	@UnitCode = 'LBL',
	@CurrencyCode = 'EUR',
	@OperationCode = 'LBL',
	@TariffType = 'A',
	@CustomerCodes = 'EXP',
	@ServiceAccount = '701380',
	@TariffFileReference = 'OP_TARIFFS_EXP',
	@IcCompanyCode = 'IC_VMHZP',
	@DateFrom =	@CutOffDate,
	@ProductCode = NULL

exec TariffGeneral_CreateTariff
	@TariffInfoCode = 'AOFWHEXP',
	@TariffInfoDescr = 'Forklift work hours', 
	@TariffInfoTariff = 76.2,
	@UnitCode = 'HR',
	@CurrencyCode = 'EUR',
	@OperationCode = 'AFRKLFTWRK', -- Forklift work hours
	@TariffType = 'A',
	@CustomerCodes = 'EXP',
	@ServiceAccount = '701310',
	@TariffFileReference = 'OP_TARIFFS_EXP',
	@IcCompanyCode = 'IC_VMHZP',
	@DateFrom =	@CutOffDate,
	@ProductCode = NULL
	
exec TariffGeneral_CreateTariff
	@TariffType = 'A',
	@TariffInfoCode = 'TAOTLNHEXP',
	@TariffInfoDescr = 'Traction LO non-hazardous',
	@TariffInfoTariff = 254,
	@UnitCode = 'TRP',
	@CurrencyCode = 'EUR',
	@OperationCode = 'AOTLNH',
	@CustomerCodes = 'EXP',
	@ServiceAccount = '701100',
	@TariffFileReference = 'OP_TARIFFS_EXP',
	@IcCompanyCode = 'IC_VMHZP',
	@DateFrom =	@CutOffDate

exec TariffGeneral_CreateTariff
	@TariffType = 'A',
	@TariffInfoCode = 'TAOTRONHEXP',
	@TariffInfoDescr = 'Traction RO non-hazardous',
	@TariffInfoTariff = 280,
	@UnitCode = 'TRP',
	@CurrencyCode = 'EUR',
	@OperationCode = 'AOTRONH',
	@CustomerCodes = 'EXP',
	@ServiceAccount = '701100',
	@TariffFileReference = 'OP_TARIFFS_EXP',
	@IcCompanyCode = 'IC_VMHZP',
	@DateFrom =	@CutOffDate
	
exec TariffGeneral_CreateTariff
	@TariffType = 'A',
	@TariffInfoCode = 'TAOSTSTCTEXP',
	@TariffInfoDescr = 'Stuffing/stripping Container',
	@TariffInfoTariff = 280,
	@UnitCode = 'TRP',
	@CurrencyCode = 'EUR',
	@OperationCode = 'AOSTSTCT',
	@CustomerCodes = 'EXP',
	@ServiceAccount = '701310',
	@TariffFileReference = 'OP_TARIFFS_EXP',
	@IcCompanyCode = 'IC_VMHZP',
	@DateFrom =	@CutOffDate
	
exec TariffGeneral_CreateTariff
	@TariffType = 'A',
	@TariffInfoCode = 'TAOCTTREXP',
	@TariffInfoDescr = 'Container Traction General',
	@TariffInfoTariff = 168,
	@UnitCode = 'TRP',
	@CurrencyCode = 'EUR',
	@OperationCode = 'AOCTTR',
	@CustomerCodes = 'EXP',
	@ServiceAccount = '701100',
	@TariffFileReference = 'OP_TARIFFS_EXP',
	@IcCompanyCode = 'IC_VMHZP',
	@DateFrom =	@CutOffDate
	
exec TariffGeneral_CreateTariff
	@TariffType = 'A',
	@TariffInfoCode = 'TAWHSPEXP',
	@TariffInfoDescr = 'Additional work hours / special project',
	@TariffInfoTariff = 50.85,
	@UnitCode = 'HR',
	@CurrencyCode = 'EUR',
	@OperationCode = 'AWHSP',
	@CustomerCodes = 'EXP',
	@ServiceAccount = '700000',
	@TariffFileReference = 'OP_TARIFFS_EXP',
	@IcCompanyCode = 'IC_VMHZP',
	@DateFrom =	@CutOffDate	
	
exec TariffGeneral_CreateTariff
	@TariffType = 'A',
	@TariffInfoCode = 'TAOTPTNATEXP',
	@TariffInfoDescr = 'Transport National',
	@TariffInfoTariff = 155,
	@UnitCode = 'TRP',
	@CurrencyCode = 'EUR',
	@OperationCode = 'AOTPTNAT',
	@CustomerCodes = 'EXP',
	@ServiceAccount = '701100',
	@TariffFileReference = 'OP_TARIFFS_EXP',
	@IcCompanyCode = 'IC_VMHZP',
	@DateFrom =	@CutOffDate	

exec TariffGeneral_CreateTariff
	@TariffType = 'A',
	@TariffInfoCode = 'TAOTPAALBMEXP',
	@TariffInfoDescr = 'Taking pictures and archiving',
	@TariffInfoTariff = 5.05,
	@UnitCode = 'PIC',
	@CurrencyCode = 'EUR',
	@OperationCode = 'AOTPAALBM',
	@CustomerCodes = 'EXP',
	@ServiceAccount = '701310',
	@TariffFileReference = 'OP_TARIFFS_EXP',
	@IcCompanyCode = 'IC_VMHZP',
	@DateFrom =	@CutOffDate	
	
exec CreateEXPWarehouseRentTariff
	@tariffInfoCode  =  'MAG31',                                                               
	@tariffInfoDesc  =  'Warehouse rent – piece (per square meter/undivided month – 30days)',  
	@tariffInfoTariff =   3.66,                                                                
	@tariffInfoUnitCode = 'FIXED',                                                             
	@tariffCustomerCode  =   'EXP',                                                            
	@TariffFileReference = 'ExpeditorsWarehouseRent',                         
	@IcCompanyCode = 'IC_VMHZP',                                                               
	@currencyCode  =   'EUR',                                                                  
	@tariffPeriod  =  30,                                                                      
	@tariffPeriodType   =   0,                                                                 
	@siStorageUnitCode  =   NULL,                                                              
	@ownerCode  =   'EXP',                                                                     
	@locationAddress  =   NULL,                                                                
	@serviceAccount  = '700514',                                                               
	@DateFrom =	@CutOffDate                                                             
	                                                                                               
EXEC [dbo].[TariffGeneral_CreateTariff]
	@TariffType =			'ADM',
	@TariffInfoCode =		'VMICNT',
	@TariffInfoDescr =		'VMI container',
	@TariffInfoTariff =		432,
	@UnitCode =				'CONTAINER',
	@CurrencyCode =			'EUR',
	@TariffFileReference =	'OP_TARIFFS_EXP',
	@IcCompanyCode =		'IC_VMHZP',
	@DateFrom =				@CutOffDate,
	@ServiceAccount =		'701300',
	@CustomerCodes =		'EXP'	
	
EXEC [dbo].[TariffGeneral_CreateTariff]
	@TariffType =			'ADM',
	@TariffInfoCode =		'LSHSECCNT',
	@TariffInfoDescr =		'Lashing and securing container',
	@TariffInfoTariff =		101.7,
	@UnitCode =				'CONTAINER',
	@CurrencyCode =			'EUR',
	@TariffFileReference =	'OP_TARIFFS_EXP',
	@IcCompanyCode =		'IC_VMHZP',
	@DateFrom =				@CutOffDate,
	@ServiceAccount =		'701380',
	@CustomerCodes =		'EXP'	

EXEC [dbo].[TariffGeneral_CreateTariff]
	@TariffType =			'ADM',
	@TariffInfoCode =		'SOLASWGHNADM',
	@TariffInfoDescr =		'Solas weighing and admin',
	@TariffInfoTariff =		70,
	@UnitCode =				'CONTAINER',
	@CurrencyCode =			'EUR',
	@TariffFileReference =	'OP_TARIFFS_EXP',
	@IcCompanyCode =		'IC_VMHZP',
	@DateFrom =				@CutOffDate,
	@ServiceAccount =		'701380',
	@CustomerCodes =		'EXP'	
	
	--Your code ends here
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION
		SELECT ERROR_NUMBER() as ErrorNumber, ERROR_MESSAGE() as ErrorMessage
END CATCH
GO


