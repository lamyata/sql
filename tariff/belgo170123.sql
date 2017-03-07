-- you may have to run createProc script
-- join TARIFF_CUSTOMER tc on t.TARIFF_ID = tc.TARIFF_ID and tc.COMPANY_ID = 585 

BEGIN TRY
	BEGIN TRANSACTION	
	--Your code starts here

declare @CutOffDate datetime = '1-FEB-2017';
declare @updateUser nvarchar(15) = 'sys170123'

update t set
	PERIOD_TO = dateadd(ms, -10, @CutOffDate),
	UPDATE_USER = @updateUser,
	UPDATE_TIMESTAMP=GETDATE()
from TARIFF t join TARIFF_FILE tf on t.TARIFF_FILE_ID = tf.TARIFF_FILE_ID and t.PERIOD_FROM < getdate() and t.PERIOD_TO > getdate() 
	join TARIFF_INFO ti on t.TARIFF_INFO_ID = ti.TARIFF_INFO_ID and ti.CODE != 'BELGOMILKADD3' -- BELGOMILKADD3 won't be modified
	join TARIFF_CUSTOMER tc on t.TARIFF_ID = tc.TARIFF_ID join COMPANY c on tc.COMPANY_ID = c.COMPANYNR and c.CODE = 'BELGOMILK'

	--Create one discharging tariff
	EXEC [dbo].[TariffGeneral_CreateTariff]
		@TariffType =			'D',
		@TariffInfoCode =		'BELGOMILKDC1',
		@TariffInfoDescr =		'Belgomilk - DISCHARGING into warehouse (per Transport)',
		@TariffInfoTariff =		66.1,
		@UnitCode =				'TRP',
		@CurrencyCode =			'EUR',
		@TariffFileReference =	'Belgomilk_CoreOperationTariffs',
		@IcCompanyCode =		'IC_VMHZP',
		@DateFrom =				@CutOffDate,
		@ServiceAccount =		'701300',
		@CustomerCodes =		'BELGOMILK'

	--Create two loading tariffs
	EXEC [dbo].[TariffGeneral_CreateTariff]
		@TariffType =			'L',
		@TariffInfoCode =		'BELGOMILKLC1',
		@TariffInfoDescr =		'Belgomilk - LOADING ex-warehouse into truck (per Transport)',
		@TariffInfoTariff =		66.1,
		@UnitCode =				'TRP',
		@CurrencyCode =			'EUR',
		@TariffFileReference =	'Belgomilk_CoreOperationTariffs',
		@IcCompanyCode =		'IC_VMHZP',
		@DateFrom =				@CutOffDate,
		@ServiceAccount =		'701300',
		@CustomerCodes =		'BELGOMILK',
		@TransportTypeCodes=	'TR'
	
	EXEC [dbo].[TariffGeneral_CreateTariff]
		@TariffType =			'L',
		@TariffInfoCode =		'BELGOMILKLC2',
		@TariffInfoDescr =		'Belgomilk - LOADING ex-warehouse into container (per Transport)',
		@TariffInfoTariff =		76.27,
		@UnitCode =				'TRP',
		@CurrencyCode =			'EUR',
		@TariffFileReference =	'Belgomilk_CoreOperationTariffs',
		@IcCompanyCode =		'IC_VMHZP',
		@DateFrom =				@CutOffDate,
		@ServiceAccount =		'701300',
		@CustomerCodes =		'BELGOMILK',
		@TransportTypeCodes=	'CTR'

	--Create one vas tariff
	EXEC [dbo].[TariffGeneral_CreateTariff]
		@TariffType =			'V',
		@TariffInfoCode =		'BELGOMILKVAS1',
		@TariffInfoDescr =		'Belgomilk - Repalletizing (per Gross)',
		@TariffInfoTariff =		13.22,
		@UnitCode =				'Gross',
		@CurrencyCode =			'EUR',
		@MeasurementUnitDescription = 't',
		@TariffFileReference =	'Belgomilk_CoreOperationTariffs',
		@IcCompanyCode =		'IC_VMHZP',
		@DateFrom =				@CutOffDate,
		@ServiceAccount =		'701380',
		@CustomerCodes =		'BELGOMILK'

	--Create additional tariffs
	EXEC [dbo].[TariffGeneral_CreateTariff]
		@TariffType =			'A',
		@TariffInfoCode =		'BELGOMILKADD1',
		@TariffInfoDescr =		'Belgomilk - Labeling – Print own label + Attach (per Label)',
		@TariffInfoTariff =		0.92,
		@UnitCode =				'LBL',
		@CurrencyCode =			'EUR',
		@TariffFileReference =	'Belgomilk_AdditionalOperationTariffs',
		@IcCompanyCode =		'IC_VMHZP',
		@DateFrom =				@CutOffDate,
		@ServiceAccount =		'701310',
		@CustomerCodes =		'BELGOMILK',
		@OperationCode =		'OWNLBL'
		
	EXEC [dbo].[TariffGeneral_CreateTariff]
		@TariffType =			'A',
		@TariffInfoCode =		'BELGOMILKADD2',
		@TariffInfoDescr =		'Belgomilk - Labeling – Attach Customer Label (per Label)',
		@TariffInfoTariff =		0.51,
		@UnitCode =				'LBL',
		@CurrencyCode =			'EUR',
		@TariffFileReference =	'Belgomilk_AdditionalOperationTariffs',
		@IcCompanyCode =		'IC_VMHZP',
		@DateFrom =				@CutOffDate,
		@ServiceAccount =		'701310',
		@CustomerCodes =		'BELGOMILK',
		@OperationCode =		'CUSLBL'

	EXEC [dbo].[TariffGeneral_CreateTariff]
		@TariffType =			'A',
		@TariffInfoCode =		'BELGOMILKADD4',
		@TariffInfoDescr =		'Belgomilk - Purchase Pallets (per Pallet)',
		@TariffInfoTariff =		6.61,
		@UnitCode =				'PAL',
		@CurrencyCode =			'EUR',
		@TariffFileReference =	'Belgomilk_AdditionalOperationTariffs',
		@IcCompanyCode =		'IC_VMHZP',
		@DateFrom =				@CutOffDate,
		@ServiceAccount =		'701340',
		@CustomerCodes =		'BELGOMILK',
		@OperationCode =		'PURPLT'

	EXEC [dbo].[TariffGeneral_CreateTariff]
		@TariffType =			'A',
		@TariffInfoCode =		'BELGOMILKADD5',
		@TariffInfoDescr =		'Belgomilk - Weging (per Piece)',
		@TariffInfoTariff =		25.42,
		@UnitCode =				'PCS',
		@CurrencyCode =			'EUR',
		@TariffFileReference =	'Belgomilk_AdditionalOperationTariffs',
		@IcCompanyCode =		'IC_VMHZP',
		@DateFrom =				@CutOffDate,
		@ServiceAccount =		'701230',
		@CustomerCodes =		'BELGOMILK',
		@OperationCode =		'WGT'

	EXEC [dbo].[TariffGeneral_CreateTariff]
		@TariffType =			'A',
		@TariffInfoCode =		'BELGOMILKADD6',
		@TariffInfoDescr =		'Belgomilk - Extra hours - warehouse (per Hour)',
		@TariffInfoTariff =		50.85,
		@UnitCode =				'HR',
		@CurrencyCode =			'EUR',
		@TariffFileReference =	'Belgomilk_AdditionalOperationTariffs',
		@IcCompanyCode =		'IC_VMHZP',
		@DateFrom =				@CutOffDate,
		@ServiceAccount =		'700000',
		@CustomerCodes =		'BELGOMILK',
		@OperationCode =		'AWHO'

	EXEC [dbo].[TariffGeneral_CreateTariff]
		@TariffType =			'A',
		@TariffInfoCode =		'BELGOMILKADD7',
		@TariffInfoDescr =		'Belgomilk - Carton border (per Piece)',
		@TariffInfoTariff =		1.22,
		@UnitCode =				'PCS',
		@CurrencyCode =			'EUR',
		@TariffFileReference =	'Belgomilk_AdditionalOperationTariffs',
		@IcCompanyCode =		'IC_VMHZP',
		@DateFrom =				@CutOffDate,
		@ServiceAccount =		'701340',
		@CustomerCodes =		'BELGOMILK',
		@OperationCode =		'CRTNBRDR'

	EXEC [dbo].[TariffGeneral_CreateTariff]
		@TariffType =			'A',
		@TariffInfoCode =		'BELGOMILKADD8',
		@TariffInfoDescr =		'Belgomilk - Container Traction (per Transport)',
		@TariffInfoTariff =		177.96,
		@UnitCode =				'TRP',
		@CurrencyCode =			'EUR',
		@TariffFileReference =	'Belgomilk_AdditionalOperationTariffs',
		@IcCompanyCode =		'IC_VMHZP',
		@DateFrom =				@CutOffDate,
		@ServiceAccount =		'701100',
		@CustomerCodes =		'BELGOMILK',
		@OperationCode =		'CONTRA'
		
	EXEC [dbo].[TariffGeneral_CreateTariff]
		@TariffType =			'A',
		@TariffInfoCode =		'BELGOMILKADD9',
		@TariffInfoDescr =		'Belgomilk - Additional work hours with forklift',
		@TariffInfoTariff =		76.27,
		@UnitCode =				'HR',
		@CurrencyCode =			'EUR',
		@TariffFileReference =	'Belgomilk_AdditionalOperationTariffs',
		@IcCompanyCode =		'IC_VMHZP',
		@DateFrom =				@CutOffDate,
		@ServiceAccount =		'701310',
		@CustomerCodes =		'BELGOMILK',
		@OperationCode =		'AWHWIFL'

	--Create three warehouserent tariffs
	EXEC [dbo].[TariffGeneral_CreateTariff]
		@TariffType =			'W',
		@TariffInfoCode =		'BELGOMILKWHR_NONSTAC',
		@TariffInfoDescr =		'Belgomilk - Warehouse rent – non stackable (per Pallet)',
		
		@TariffInfoTariff =		7.63,
		@UnitCode =				'PAL',
		@CurrencyCode =			'EUR',
		
		@TariffFileReference =	'Belgomilk_WarehouserentTariffs',
		@IcCompanyCode =		'IC_VMHZP',
		@DateFrom =				@CutOffDate,
		@ServiceAccount =		'700514',
		@CustomerCodes =		'BELGOMILK',
		@Period =				30,			
		@PeriodType =			0,		
		@FreePeriod =			null,		
		@FreePeriodType =		0

	EXEC [dbo].[TariffGeneral_CreateTariff]
		@TariffType =			'W',
		@TariffInfoCode =		'BELGOMILKWHR_STAC_2HIGH',
		@TariffInfoDescr =		'Warehouse rent – stackable 2 high (per Pallet)',
		
		@TariffInfoTariff =		5.08,
		@UnitCode =				'PAL',
		@CurrencyCode =			'EUR',
		
		@TariffFileReference =	'Belgomilk_WarehouserentTariffs',
		@IcCompanyCode =		'IC_VMHZP',
		@DateFrom =				@CutOffDate,
		@ServiceAccount =		'700514',
		@CustomerCodes =		'BELGOMILK',
		@Period =				30,			
		@PeriodType =			0,		
		@FreePeriod =			null,		
		@FreePeriodType =		0

	EXEC [dbo].[TariffGeneral_CreateTariff]
		@TariffType =			'W',
		@TariffInfoCode =		'BELGOMILKWHR_STAC_3HIGH',
		@TariffInfoDescr =		'Warehouse rent – stackable 3 high (per Pallet)',
		
		@TariffInfoTariff =		3.56,
		@UnitCode =				'PAL',
		@CurrencyCode =			'EUR',
		
		@TariffFileReference =	'Belgomilk_WarehouserentTariffs',
		@IcCompanyCode =		'IC_VMHZP',
		@DateFrom =				@CutOffDate,
		@ServiceAccount =		'700514',
		@CustomerCodes =		'BELGOMILK',
		@Period =				30,			
		@PeriodType =			0,		
		@FreePeriod =			null,		
		@FreePeriodType =		0		
		
	--Your code ends here
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION
		SELECT ERROR_NUMBER() as ErrorNumber, ERROR_MESSAGE() as ErrorMessage
END CATCH
GO


