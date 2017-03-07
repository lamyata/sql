create PROC KreaTarInt
	@TariffInfoCode nvarchar(250),
	@TariffInfoDescr nvarchar(250),
	@TariffInfoTariff decimal(18,3),
	@UnitCode nvarchar(50),
	@MeasurementUnitDescription nvarchar(50),
	@CurrencyCode nvarchar(3),
	@OperationCode nvarchar(50),
	@ServiceAccount nvarchar(50),
	@TariffFileReference nvarchar(250),
	@DateFrom date,
	@DateTo date,
	@createUser nvarchar(15)
as
	declare @OperationId int
	declare @TariffId int
	declare @MeasurementUnitId int
	declare @TariffInfoId int
	declare @InternalCompanyId int
	declare @errMsg nvarchar(100)
	
begin
	set nocount on

	select @InternalCompanyId = INTERNAL_COMPANY_ID from TARIFF_FILE tf WHERE tf.REFERENCE = @TariffFileReference;
	select @OperationId = [OPERATION_ID] from [OPERATION] where [CODE] = @OperationCode and INTERNAL_COMPANY_ID = @InternalCompanyId;

	--select @TariffId = TARIFF_ID from TARIFF t join TARIFF_INFO ti on t.TARIFF_INFO_ID = ti.TARIFF_INFO_ID
	--	and ti.CODE = @TariffInfoCode
	--	and not (@DateFrom < t.PERIOD_FROM and @DateTo < t.PERIOD_FROM)
	--	and not (@DateFrom > t.PERIOD_TO and @DateTo > t.PERIOD_TO)

	--if @TariffId is not null return @TariffId

	if (IsNull(@MeasurementUnitDescription,'')!='')
		select @MeasurementUnitId = [MEASUREMENT_UNIT_ID] from [MEASUREMENT_UNIT] where [DESCRIPTION] = @MeasurementUnitDescription;

	INSERT INTO [dbo].[TARIFF_INFO]
			([CODE]
			,[DESCRIPTION]
			,[TARIFF]
			,[UNIT_ID]
			,[MEASUREMENT_UNIT_ID]
			,[CURRENCY_ID]
			,[SERVICE_ACCOUNT]
			,[CREATE_USER]
			,[CREATE_TIMESTAMP]
			,[UPDATE_USER]
			,[UPDATE_TIMESTAMP])
		SELECT
			@TariffInfoCode
			,@TariffInfoDescr
			,@TariffInfoTariff
			,UNIT_ID
			,@MeasurementUnitId
			,CURRENCY_ID
			,@ServiceAccount
			,@createUser
			,getdate()
			,@createUser
			,getdate()
	FROM
		UNIT u, CURRENCY c
		WHERE u.CODE = @UnitCode AND c.CODE = @CurrencyCode;

	select @TariffInfoId = SCOPE_IDENTITY();
	
	if @TariffInfoId is null
	BEGIN
		;select @errMsg = 'Tariff info cannot be created. Make sure that unit code ' + @UnitCode +' and currency code ' + @CurrencyCode + ' are correct.'
		;THROW 51000, @errMsg, 1;
	END;			

	if not exists (select * from TARIFF_INFO ti, TARIFF_FILE tf	WHERE ti.CODE = @TariffInfoCode AND tf.REFERENCE = @TariffFileReference)
	BEGIN
		;select @errMsg = 'Tariff file with ref ' + @TariffFileReference +' does not exist or tariff info was not inserted.'
		;THROW 51000, @errMsg, 2;
	END;			
		
	INSERT INTO [dbo].[TARIFF]
				([TARIFF_FILE_ID]
				,[OPERATION_ID]
				,[TARIFF_INFO_ID]
				,[STATUS]
				,[PERIOD_FROM]
				,[PERIOD_TO]
				,[CREATE_USER]
				,[CREATE_TIMESTAMP]
				,[UPDATE_USER]
				,[UPDATE_TIMESTAMP])
			SELECT
				TARIFF_FILE_ID
				,@OperationId
				,@TariffInfoId
				,0
				,@DateFrom 
				,@DateTo
				,@createUser
				,getdate()
				,@createUser
				,getdate()
	FROM TARIFF_FILE tf
	WHERE tf.REFERENCE = @TariffFileReference;

	select @TariffId = SCOPE_IDENTITY();

	set nocount off;
	
	return @TariffId;
	
end

go

CREATE proc KreaAdditTar
	@TariffInfoCode nvarchar(250),
	@TariffInfoDescr nvarchar(250),
	@TariffInfoTariff decimal(18,3),
	@UnitCode nvarchar(50),
	@MeasurementUnitDescription  nvarchar(50),
	@CurrencyCode nvarchar(3),
	@OperationCode nvarchar(50),
	@CustomerCode nvarchar(50),
	@ServiceAccount nvarchar(50),
	@TariffFileReference nvarchar(250),
	@createUser nvarchar(15)
as
	declare @TariffId int
	declare @StockInfoConfigId int
	declare @StockInfoId int
	declare @InternalCompanyId int
	declare @TransportTypeId int
begin
	exec @TariffId = 
		KreaTarInt
			@TariffInfoCode = @TariffInfoCode,
			@TariffInfoDescr = @TariffInfoDescr,
			@TariffInfoTariff = @TariffInfoTariff,
			@UnitCode = @UnitCode,
			@MeasurementUnitDescription = @MeasurementUnitDescription,
			@CurrencyCode = @CurrencyCode,
			@OperationCode = @OperationCode,
			@ServiceAccount = @ServiceAccount,
			@TariffFileReference = @TariffFileReference,
			@DateFrom = '1-OCT-2016',
			@DateTo = '1-JAN-2050',
			@createUser = @createUser
		
	if @CustomerCode is not null
		INSERT INTO [dbo].[TARIFF_CUSTOMER]
			([TARIFF_ID]
			,[COMPANY_ID])
		SELECT
			@TariffId,
			COMPANYNR
		FROM COMPANY WHERE CODE = @CustomerCode;

	INSERT INTO [dbo].[ADDITIONAL_TARIFF]
					([ADDITIONAL_TARIFF_ID]
					,[CREATE_USER]
					,[CREATE_TIMESTAMP]
					,[UPDATE_USER]
					,[UPDATE_TIMESTAMP])
			VALUES
					(@TariffId
					,@createUser
					,getdate()
					,@createUser
					,getdate())	

end

GO

BEGIN TRY
	BEGIN TRAN	
	
declare @createUser nvarchar(15) = 'la161024';

update ti set TARIFF =  8.95, SERVICE_ACCOUNT = '701310', UPDATE_TIMESTAMP = GETDATE(), UPDATE_USER = @createUser
 from TARIFF t join TARIFF_INFO ti on t.TARIFF_INFO_ID = ti.TARIFF_INFO_ID
	join OPERATION o on t.OPERATION_ID = o.OPERATION_ID and o.CODE  = 'ALABNG'
	join TARIFF_CUSTOMER tc on t.TARIFF_ID = tc.TARIFF_ID
	join COMPANY c on tc.COMPANY_ID = c.COMPANYNR and c.CODE = 'KOD'

update ti set TARIFF =  20, SERVICE_ACCOUNT = '701310', UPDATE_TIMESTAMP = GETDATE(), UPDATE_USER = @createUser
 from TARIFF t join TARIFF_INFO ti on t.TARIFF_INFO_ID = ti.TARIFF_INFO_ID
	join OPERATION o on t.OPERATION_ID = o.OPERATION_ID and o.CODE  = 'NEUTRLZ'
	join TARIFF_CUSTOMER tc on t.TARIFF_ID = tc.TARIFF_ID
	join COMPANY c on tc.COMPANY_ID = c.COMPANYNR and c.CODE = 'KOD'
	
update TARIFF_INFO set UNIT_ID = 39 where UNIT_ID = 35
update UNIT set CODE = 'PIC_NA', STATUS=2 where UNIT_ID = 35

exec KreaAdditTar
	@TariffInfoCode = 'TAOTLNHKOD',
	@TariffInfoDescr = 'Traction LO non-hazardous',
	@TariffInfoTariff = 150,
	@UnitCode = 'TRP',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AOTLNH',
	@CustomerCode = 'KOD',
	@ServiceAccount = '701100',
	@TariffFileReference = 'OP_TARIFFS_KOD',
	@createUser = @createUser
	
exec KreaAdditTar
	@TariffInfoCode = 'TAOTRONHKOD',
	@TariffInfoDescr = 'Traction RO non-hazardous',
	@TariffInfoTariff = 120,
	@UnitCode = 'TRP',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AOTRONH',
	@CustomerCode = 'KOD',
	@ServiceAccount = '701100',
	@TariffFileReference = 'OP_TARIFFS_KOD',
	@createUser = @createUser

exec KreaAdditTar
	@TariffInfoCode = 'TAOSTSTCTKOD',
	@TariffInfoDescr = 'Stuffing/stripping Container',
	@TariffInfoTariff = 190,
	@UnitCode = 'TRP',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AOSTSTCT',
	@CustomerCode = 'KOD',
	@ServiceAccount = '701310',
	@TariffFileReference = 'OP_TARIFFS_KOD',
	@createUser = @createUser
	
exec KreaAdditTar
	@TariffInfoCode = 'TAOTLNHEXP',
	@TariffInfoDescr = 'Traction LO non-hazardous',
	@TariffInfoTariff = 275,
	@UnitCode = 'TRP',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AOTLNH',
	@CustomerCode = 'EXP',
	@ServiceAccount = '701100',
	@TariffFileReference = 'OP_TARIFFS_EXP',
	@createUser = @createUser

exec KreaAdditTar
	@TariffInfoCode = 'TAOTRONHEXP',
	@TariffInfoDescr = 'Traction RO non-hazardous',
	@TariffInfoTariff = 250,
	@UnitCode = 'TRP',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AOTRONH',
	@CustomerCode = 'EXP',
	@ServiceAccount = '701100',
	@TariffFileReference = 'OP_TARIFFS_EXP',
	@createUser = @createUser
	
exec KreaAdditTar
	@TariffInfoCode = 'TAOSTSTCTEXP',
	@TariffInfoDescr = 'Stuffing/stripping Container',
	@TariffInfoTariff = 275,
	@UnitCode = 'TRP',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AOSTSTCT',
	@CustomerCode = 'EXP',
	@ServiceAccount = '701310',
	@TariffFileReference = 'OP_TARIFFS_EXP',
	@createUser = @createUser
	
exec KreaAdditTar
	@TariffInfoCode = 'TAOCTTREXP',
	@TariffInfoDescr = 'Container Traction General',
	@TariffInfoTariff = 165,
	@UnitCode = 'TRP',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AOCTTR',
	@CustomerCode = 'EXP',
	@ServiceAccount = '701100',
	@TariffFileReference = 'OP_TARIFFS_EXP',
	@createUser = @createUser
	
exec KreaAdditTar
	@TariffInfoCode = 'TAWHSPEXP',
	@TariffInfoDescr = 'Additional work hours / special project',
	@TariffInfoTariff = 50,
	@UnitCode = 'HR',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AWHSP',
	@CustomerCode = 'EXP',
	@ServiceAccount = '700000',
	@TariffFileReference = 'OP_TARIFFS_EXP',
	@createUser = @createUser	
	
update ti set SERVICE_ACCOUNT = '700000', UPDATE_TIMESTAMP = GETDATE(), UPDATE_USER = @createUser
from TARIFF t join TARIFF_INFO ti on t.TARIFF_INFO_ID = ti.TARIFF_INFO_ID
	join OPERATION o on t.OPERATION_ID = o.OPERATION_ID and o.CODE  = 'AFRKLFTWRK'
	join TARIFF_CUSTOMER tc on t.TARIFF_ID = tc.TARIFF_ID
	join COMPANY c on tc.COMPANY_ID = c.COMPANYNR and c.CODE = 'EXP'	
	
exec KreaAdditTar
	@TariffInfoCode = 'TAOTPTNATEXP',
	@TariffInfoDescr = 'Transport National',
	@TariffInfoTariff = 150,
	@UnitCode = 'TRP',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AOTPTNAT',
	@CustomerCode = 'EXP',
	@ServiceAccount = '701100',
	@TariffFileReference = 'OP_TARIFFS_EXP',
	@createUser = @createUser	

exec KreaAdditTar
	@TariffInfoCode = 'TAOTPAALBMEXP',
	@TariffInfoDescr = 'Taking pictures and archiving',
	@TariffInfoTariff = 5,
	@UnitCode = 'PIC',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AOTPAALBM',
	@CustomerCode = 'EXP',
	@ServiceAccount = '701310',
	@TariffFileReference = 'OP_TARIFFS_EXP',
	@createUser = @createUser
	
INSERT INTO [dbo].[TARIFF_FILE]
	([DESCRIPTION]
	,[REFERENCE]
	,[STATUS]
	,[INTERNAL_COMPANY_ID]
	,[OPERATION_TYPE_ID]
	,[CREATE_USER]
	,[CREATE_TIMESTAMP]
	,[UPDATE_USER]
	,[UPDATE_TIMESTAMP])
SELECT TOP 1
	'Additional tariffs - SGN'
	,'ADD_TARIFFS_SGN'
	,0
	,COMPANYNR
	,NULL
	,'sys'
	,getdate()
	,'sys'
	,getdate()
FROM COMPANY c
WHERE c.CODE = 'IC_SGN'

exec KreaAdditTar
	@TariffInfoCode = 'TAOCTTR',
	@TariffInfoDescr = 'Traction Container Antwerp',
	@TariffInfoTariff = 160,
	@UnitCode = 'TRP',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AOCTTR',
	@CustomerCode = null,
	@ServiceAccount = '701100',
	@TariffFileReference = 'ADD_TARIFFS_SGN',
	@createUser = @createUser
	
exec KreaAdditTar
	@TariffInfoCode = 'TAWHSP',
	@TariffInfoDescr = 'Extra works hours: wh operator',
	@TariffInfoTariff = 55,
	@UnitCode = 'HR',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AWHSP',
	@CustomerCode = null,
	@ServiceAccount = '700000',
	@TariffFileReference = 'ADD_TARIFFS_SGN',
	@createUser = @createUser

exec KreaAdditTar
	@TariffInfoCode = 'TAOCTRT',
	@TariffInfoDescr = 'Traction Container Rotterdam',
	@TariffInfoTariff = 345,
	@UnitCode = 'TRP',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AOCTRT',
	@CustomerCode = null,
	@ServiceAccount = '701100',
	@TariffFileReference = 'ADD_TARIFFS_SGN',
	@createUser = @createUser

exec KreaAdditTar
	@TariffInfoCode = 'TAADMFEEORDER',
	@TariffInfoDescr = 'Admin Fee',
	@TariffInfoTariff = 12.5,
	@UnitCode = 'ORDER',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AADMFEEORDER',
	@CustomerCode = null,
	@ServiceAccount = '701310',
	@TariffFileReference = 'ADD_TARIFFS_SGN',
	@createUser = @createUser
	
exec KreaAdditTar
	@TariffInfoCode = 'TAOCA',
	@TariffInfoDescr = 'Cargo Agency',
	@TariffInfoTariff = .35,
	@UnitCode = 'TON',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AOCA',
	@CustomerCode = null,
	@ServiceAccount = '701310',
	@TariffFileReference = 'ADD_TARIFFS_SGN',
	@createUser = @createUser
	
exec KreaAdditTar
	@TariffInfoCode = 'TPCSTD',
	@TariffInfoDescr = 'Customs Clearance',
	@TariffInfoTariff = 50,
	@UnitCode = 'APRNCE',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'PCSTD',
	@CustomerCode = null,
	@ServiceAccount = '701310',
	@TariffFileReference = 'ADD_TARIFFS_SGN',
	@createUser = @createUser

exec KreaAdditTar
	@TariffInfoCode = 'TAOBISLIST',
	@TariffInfoDescr = 'AOBISLIST',
	@TariffInfoTariff = 6,
	@UnitCode = 'APRNCE',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AOBISLIST',
	@CustomerCode = null,
	@ServiceAccount = '701310',
	@TariffFileReference = 'ADD_TARIFFS_SGN',
	@createUser = @createUser
	
exec KreaAdditTar
	@TariffInfoCode = 'TAOISDALBM',
	@TariffInfoDescr = 'Customs Document IMA',
	@TariffInfoTariff = 30,
	@UnitCode = 'APRNCE',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AOISDALBM',
	@CustomerCode = null,
	@ServiceAccount = '701310',
	@TariffFileReference = 'ADD_TARIFFS_SGN',
	@createUser = @createUser

exec KreaAdditTar
	@TariffInfoCode = 'TAOEDALBM',
	@TariffInfoDescr = 'Export Document',
	@TariffInfoTariff = 30,
	@UnitCode = 'APRNCE',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AOEDALBM',
	@CustomerCode = null,
	@ServiceAccount = '701310',
	@TariffFileReference = 'ADD_TARIFFS_SGN',
	@createUser = @createUser
	
exec KreaAdditTar
	@TariffInfoCode = 'TAOREWRAP',
	@TariffInfoDescr = 'Re-Wrapping Reels',
	@TariffInfoTariff = 10,
	@UnitCode = 'PCS',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AOREWRAP',
	@CustomerCode = null,
	@ServiceAccount = '701310',
	@TariffFileReference = 'ADD_TARIFFS_SGN',
	@createUser = @createUser
	
	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK
		SELECT ERROR_NUMBER() as ErrorNumber, ERROR_MESSAGE() as ErrorMessage
END CATCH	

drop proc KreaAdditTar
drop proc KreaTarInt
