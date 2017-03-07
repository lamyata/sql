-- join TARIFF_CUSTOMER tc on t.TARIFF_ID = tc.TARIFF_ID and tc.COMPANY_ID = 549 

BEGIN TRY
	BEGIN TRANSACTION
	--Your code starts here

	declare @CutOffDate datetime = '1-FEB-2017';
	declare @updateUser nvarchar(15) = 'an170126'
	declare @tmpTariffId int

	--Change period of the existing one
	update t set
	PERIOD_TO = dateadd(ms, -10, @CutOffDate),
	UPDATE_USER = @updateUser,
	UPDATE_TIMESTAMP=GETDATE()
from TARIFF t
 inner join TARIFF_INFO ti
on t.TARIFF_INFO_ID = ti.TARIFF_INFO_ID
where TARIFF_ID
in
(select TARIFF_ID from TARIFF_CUSTOMER
where COMPANY_ID = (select top 1 COMPANYNR from COMPANY where CODE = 'KOD'))

/*
insert into [dbo].[ADDITIONAL_OPERATION_COMPANY]
	([ADDITIONAL_OPERATION_ID],[COMPANYNR])
select o.OPERATION_ID, c.COMPANYNR 
from OPERATION o, COMPANY c, COMPANY ic where o.CODE='AWHSP' and o.INTERNAL_COMPANY_ID = ic.COMPANYNR and ic.CODE = 'IC_VMHZP' and c.CODE ='KOD'
*/

	--Create new tariffs - one discharging, one loading
	EXEC [dbo].[TariffGeneral_CreateTariff]
		@TariffType =			'D',
		@TariffInfoCode =		'DISCHKOD',
		@TariffInfoDescr =		'DISCHARGING ex-truck/ex-container/ex-wagon',
		@TariffInfoTariff =		2.7,
		@CurrencyCode =			'EUR',
		@UnitCode =				'Gross',
		@MeasurementUnitDescription= 't',
		@TariffFileReference =	'OP_TARIFFS_KOD',
		@IcCompanyCode =		'IC_VMHZP',
		@DateFrom =				@CutOffDate,
		@ServiceAccount =		'701300',
		@CustomerCodes =		'KOD'

	EXEC [dbo].[TariffGeneral_CreateTariff]
		@TariffType =			'L',
		@TariffInfoCode =		'LOADKOD',
		@TariffInfoDescr =		'LOADING into truck/wagon',
		@TariffInfoTariff =		2.7,
		@CurrencyCode =			'EUR',
		@UnitCode =				'Gross',
		@MeasurementUnitDescription= 't',
		@TariffFileReference =	'OP_TARIFFS_KOD',
		@IcCompanyCode =		'IC_VMHZP',
		@DateFrom =				@CutOffDate,
		@ServiceAccount =		'701300',
		@CustomerCodes =		'KOD'

	--Create new tariffs - six additional tariffs
	EXEC [dbo].[TariffGeneral_CreateTariff]
		@TariffType =			'A',
		@TariffInfoCode =		'LBLKOD',
		@TariffInfoDescr =		'Labelling',
		@TariffInfoTariff =		1.1,
		@CurrencyCode =			'EUR',
		@UnitCode =				'LBL',
		@TariffFileReference =	'OP_TARIFFS_KOD',
		@IcCompanyCode =		'IC_VMHZP',
		@DateFrom =				@CutOffDate,
		@ServiceAccount =		'701310',
		@CustomerCodes =		'KOD',
		@OperationCode =		'ALABNG'

	EXEC [dbo].[TariffGeneral_CreateTariff]
		@TariffType =			'A',
		@TariffInfoCode =		'NEUTRKOD',
		@TariffInfoDescr =		'Neutralizing',
		@TariffInfoTariff =		9.1,
		@CurrencyCode =			'EUR',
		@UnitCode =				'COILS',
		@TariffFileReference =	'OP_TARIFFS_KOD',
		@IcCompanyCode =		'IC_VMHZP',
		@DateFrom =				@CutOffDate,
		@ServiceAccount =		'701310',
		@CustomerCodes =		'KOD',
		@OperationCode =		'NEUTRLZ'

	EXEC [dbo].[TariffGeneral_CreateTariff]
		@TariffType =			'A',
		@TariffInfoCode =		'TAOTLNHKOD',
		@TariffInfoDescr =		'Traction LO non-hazardous',
		@TariffInfoTariff =		122,
		@CurrencyCode =			'EUR',
		@UnitCode =				'TRP',
		@TariffFileReference =	'OP_TARIFFS_KOD',
		@IcCompanyCode =		'IC_VMHZP',
		@DateFrom =				@CutOffDate,
		@ServiceAccount =		'701100',
		@CustomerCodes =		'KOD',
		@OperationCode =		'AOTLNH'

	EXEC [dbo].[TariffGeneral_CreateTariff]
		@TariffType =			'A',
		@TariffInfoCode =		'TAOTRONHKOD',
		@TariffInfoDescr =		'Traction RO non-hazardous',
		@TariffInfoTariff =		153,
		@CurrencyCode =			'EUR',
		@UnitCode =				'TRP',
		@TariffFileReference =	'OP_TARIFFS_KOD',
		@IcCompanyCode =		'IC_VMHZP',
		@DateFrom =				@CutOffDate,
		@ServiceAccount =		'701100',
		@CustomerCodes =		'KOD',
		@OperationCode =		'AOTRONH'

	EXEC [dbo].[TariffGeneral_CreateTariff]
		@TariffType =			'A',
		@TariffInfoCode =		'TAOSTSTCTKOD',
		@TariffInfoDescr =		'Loading container (incl. Stuffing)',
		@TariffInfoTariff =		193,
		@CurrencyCode =			'EUR',
		@UnitCode =				'TRP',
--		@MeasurementUnitDescription = 'CTR',
		@TariffFileReference =	'OP_TARIFFS_KOD',
		@IcCompanyCode =		'IC_VMHZP',
		@DateFrom =				@CutOffDate,
		@ServiceAccount =		'701310',
		@CustomerCodes =		'KOD',
		@OperationCode =		'AOSTSTCT'

	EXEC [dbo].[TariffGeneral_CreateTariff]
		@TariffType =			'A',
		@TariffInfoCode =		'AWHSPKOD',
		@TariffInfoDescr =		'Additional work',
		@TariffInfoTariff =		50,
		@CurrencyCode =			'EUR',
		@UnitCode =				'HR',
		@TariffFileReference =	'OP_TARIFFS_KOD',
		@IcCompanyCode =		'IC_VMHZP',
		@DateFrom =				@CutOffDate,
		@ServiceAccount =		'701310',
		@CustomerCodes =		'KOD',
		@OperationCode =		'AWHSP'
		
	--Your code ends here
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION
		SELECT ERROR_NUMBER() as ErrorNumber, ERROR_MESSAGE() as ErrorMessage
END CATCH
GO


