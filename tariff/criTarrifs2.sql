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
begin
	set nocount on

	select @OperationId = [OPERATION_ID] from [OPERATION] where [CODE] = @OperationCode;

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

	if not exists (select * from TARIFF_INFO ti, TARIFF_FILE tf	WHERE ti.CODE = @TariffInfoCode AND tf.REFERENCE = @TariffFileReference)
		BEGIN
		;declare @errMsg nvarchar(100)
		;select @errMsg = 'Tariff file with ref ' + @TariffFileReference +' does not exist or tariff info was not inserted.'
		;THROW 51000, @errMsg, 1;
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
	
declare @createUser nvarchar(15) = 'la161108'

exec KreaAdditTar
	@TariffInfoCode = 'TREPADANG',
	@TariffInfoDescr = 'Repalletize Dangerous Goods',
	@TariffInfoTariff = 8.1,
	@UnitCode = 'PAL',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'REPADANG',
	@CustomerCode = 'CRI',
	@ServiceAccount = '701380',
	@TariffFileReference = 'CRI_TARIFF',
	@createUser = @createUser

exec KreaAdditTar
	@TariffInfoCode = 'TREPANDAN',
	@TariffInfoDescr = 'Repalletize Non-Dangerous Goods',
	@TariffInfoTariff = 8.1,
	@UnitCode = 'PAL',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'REPANDAN',
	@CustomerCode = 'CRI',
	@ServiceAccount = '701380',
	@TariffFileReference = 'CRI_TARIFF',
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
