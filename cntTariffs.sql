create PROC crTrfInt
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

	--select top 1 @TariffId = TARIFF_ID from TARIFF t join TARIFF_INFO ti on t.TARIFF_INFO_ID = ti.TARIFF_INFO_ID
	--	and ti.CODE = @TariffInfoCode
	--	and (@DateFrom > t.PERIOD_FROM or @DateTo > t.PERIOD_FROM)
	--	and (@DateFrom < t.PERIOD_TO or @DateTo < t.PERIOD_TO)

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

CREATE proc crDischTrf
	@TariffInfoCode nvarchar(250),
	@TariffInfoDescr nvarchar(250),
	@TariffInfoTariff decimal(18,3),
	@UnitCode nvarchar(50),
	@MeasurementUnitDescription  nvarchar(50),
	@CurrencyCode nvarchar(3),
	@OperationCode nvarchar(50),
	@CustomerCodes nvarchar(500), -- comma delimited, no apostrophies
	@ServiceAccount nvarchar(50),
	@TariffFileReference nvarchar(250),
	@ProductCode nvarchar(50),
	@StorageUnitCode nvarchar(50)
	@TransportTypeCode nvarchar(10),
	@createUser nvarchar(15)
as
	declare @TariffId int
	declare @StockInfoConfigId int
	declare @StockInfoId int
	declare @InternalCompanyId int
	declare @TransportTypeId int
begin
	exec @TariffId = 
		CrTrfInt
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
			
	if @ProductCode is not null OR @StorageUnitCode is not null
	begin
		select @InternalCompanyId = INTERNAL_COMPANY_ID from TARIFF_FILE where REFERENCE = @TariffFileReference

		select @StorageUnitId = UNIT_ID from UNIT where CODE = @StorageUnitCode
		select @ProductId = PRODUCT_ID from PRODUCT where CODE = @ProductCode

		INSERT INTO [dbo].[STOCK_INFO_CONFIG]
				   ([INTERNAL_COMPANY_ID]
				   ,[PRODUCT_ID]
				   ,[STATUS]
				   ,[STORAGE_UNIT_ID]
				   ,[CREATE_USER]
				   ,[CREATE_TIMESTAMP]
				   ,[UPDATE_USER]
				   ,[UPDATE_TIMESTAMP])
			 VALUES(
				   @InternalCompanyId 
				   ,@ProductId
				   ,0 -- STATUS (0 available, 1 blocked)
				   ,@StorageUnitId
				   ,@createUser
				   ,GETDATE()
				   ,@createUser
				   ,GETDATE())

		select @StockInfoConfigId = SCOPE_IDENTITY();

		INSERT INTO [dbo].[STOCK_INFO]
			   ([STOCK_INFO_CONFIG_ID]
			   ,[CREATE_USER]
			   ,[CREATE_TIMESTAMP]
			   ,[UPDATE_USER]
			   ,[UPDATE_TIMESTAMP])
		 VALUES
			   (@StockInfoConfigId
			   ,@createUser
			   ,GETDATE()
			   ,@createUser
			   ,GETDATE())

		select @StockInfoId = SCOPE_IDENTITY();
	end			

	INSERT INTO [dbo].[DISCHARGING_TARIFF]
		 ([DISCHARGING_TARIFF_ID]
		 ,[STOCK_INFO_ID]
		 ,[CREATE_USER]
		 ,[CREATE_TIMESTAMP]
		 ,[UPDATE_USER]
		 ,[UPDATE_TIMESTAMP])
	 VALUES
		 (@TariffId
		 ,@StockInfoId
		 ,@createUser
		 ,getdate()
		 ,@createUser
		 ,getdate())

	if (@TransportTypeCode is not null)
	begin
		select @TransportTypeId = TRANSPORT_TYPE_ID from TRANSPORT_TYPE
			where CODE = @TransportTypeCode and INTERNAL_COMPANY_NR = @InternalCompanyId
		if (@TransportTypeId is null)
			select @TransportTypeId = TRANSPORT_TYPE_ID from TRANSPORT_TYPE
			where CODE = @TransportTypeCode and INTERNAL_COMPANY_NR is null
		if (@TransportTypeId is not null)
			INSERT INTO [dbo].[DISCHARGING_TARIFF_TRANSPORT_TYPE]
				   ([DISCHARGING_TARIFF_ID]
				   ,[TRANSPORT_TYPE_ID])
			VALUES (@TariffId
				   ,@TransportTypeId)
	end
		 
	if @CustomerCodes is not null
	BEGIN
				 
		DECLARE @pos INT
		DECLARE @len INT
		DECLARE @value nvarchar(50)
		
		set @pos = 0
		set @len = 0
		set @CustomerCodes = @CustomerCodes + ','
		
		WHILE CHARINDEX(',', @CustomerCodes, @pos+1)>0
		BEGIN
			set @len = CHARINDEX(',', @valueList, @pos+1) - @pos
			set @value = SUBSTRING(@valueList, @pos, @len)
			--SELECT @pos, @len, @value /*this is here for debugging*/
				
			--Here is you value
			--PRINT @value
			
			INSERT INTO [dbo].[TARIFF_CUSTOMER]
				([TARIFF_ID]
				,[COMPANY_ID])
			SELECT
				@TariffId,
				COMPANYNR
			FROM COMPANY WHERE CODE = @CustomerCode;

			set @pos = CHARINDEX(',', @valueList, @pos+@len) +1
		END		
		
	END
		
end

GO

BEGIN TRY
	BEGIN TRAN	
	
declare @createUser nvarchar(15) = 'la161024';

exec crDischTrf
	@TariffInfoCode = 'TAOCTTR',
	@TariffInfoDescr = 'Traction Container Antwerp',
	@TariffInfoTariff = 160,
	@UnitCode = 'TRP',
	@MeasurementUnitDescription = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AOCTTR',
	@CustomerCodes = null,
	@ServiceAccount = '701100',
	@TariffFileReference = 'Discharging',
	@createUser = @createUser
	
exec crDischTrf @TariffInfoTariff=5.05,@UnitCode='Net',@MeasurementUnitDescription='t',@CustomerCodes='PLANTACOTE NV',@StorageUnitCode='P900',
	@TariffInfoCode = 'TDISCNT',
	@TariffInfoDescr = 'Discharging Goods from Container',
	@CurrencyCode = 'EUR',
	@TransportTypeCode = 'CNT',
	@ServiceAccount = '700007',
	@TariffFileReference = 'Discharging',
	@createUser = @createUser

exec crDischTrf @TariffInfoTariff=5.05,@UnitCode='Net',@MeasurementUnitDescription='t',@CustomerCodes='PLANTACOTE NV',@StorageUnitCode='P1000',
exec crDischTrf @TariffInfoTariff=5.05,@UnitCode='Net',@MeasurementUnitDescription='t',@CustomerCodes='PLANTACOTE NV',@StorageUnitCode='P1050',
exec crDischTrf @TariffInfoTariff=5.05,@UnitCode='Net',@MeasurementUnitDescription='t',@CustomerCodes='PLANTACOTE NV',@StorageUnitCode='P1100',
exec crDischTrf @TariffInfoTariff=5.05,@UnitCode='Net',@MeasurementUnitDescription='t',@CustomerCodes='PLANTACOTE NV',@StorageUnitCode='P1200',
exec crDischTrf @TariffInfoTariff=5.05,@UnitCode='Net',@MeasurementUnitDescription='t',@CustomerCodes='PLANTACOTE NV',@StorageUnitCode='P1250',
exec crDischTrf @TariffInfoTariff=5.05,@UnitCode='Net',@MeasurementUnitDescription='t',@CustomerCodes='PLANTACOTE NV',@StorageUnitCode='P1400',
exec crDischTrf @TariffInfoTariff=5.05,@UnitCode='Net',@MeasurementUnitDescription='t',@CustomerCodes='PLANTACOTE NV',@StorageUnitCode='P1500',
exec crDischTrf @TariffInfoTariff=5.05,@UnitCode='Net',@MeasurementUnitDescription='t',@CustomerCodes='PLANTACOTE NV',@StorageUnitCode='P1750',
exec crDischTrf @TariffInfoTariff=5.05,@UnitCode='Net',@MeasurementUnitDescription='t',@CustomerCodes='PLANTACOTE NV',@StorageUnitCode='P2000',
exec crDischTrf @TariffInfoTariff=5.05,@UnitCode='Net',@MeasurementUnitDescription='t',@CustomerCodes='PLANTACOTE NV',@StorageUnitCode='P2400',
exec crDischTrf @TariffInfoTariff=5.05,@UnitCode='Net',@MeasurementUnitDescription='t',@CustomerCodes='PLANTACOTE NV',@StorageUnitCode='P1350',
exec crDischTrf @TariffInfoTariff=6.35,@UnitCode='Net',@MeasurementUnitDescription='t',@CustomerCodes='PLANTACOTE NV,Anorel',@StorageUnitCode='BB1000',
exec crDischTrf @TariffInfoTariff=6.35,@UnitCode='Net',@MeasurementUnitDescription='t',@CustomerCodes='PLANTACOTE NV,Anorel',@StorageUnitCode='BB1200',
exec crDischTrf @TariffInfoTariff=6.35,@UnitCode='Net',@MeasurementUnitDescription='t',@CustomerCodes='PLANTACOTE NV,Anorel',@StorageUnitCode='BB1250',
exec crDischTrf @TariffInfoTariff=6.35,@UnitCode='Net',@MeasurementUnitDescription='t',@CustomerCodes='PLANTACOTE NV,Anorel',@StorageUnitCode='BB500',
exec crDischTrf @TariffInfoTariff=6.35,@UnitCode='Net',@MeasurementUnitDescription='t',@CustomerCodes='PLANTACOTE NV,Anorel',@StorageUnitCode='BB600',
exec crDischTrf @TariffInfoTariff=6.35,@UnitCode='Net',@MeasurementUnitDescription='t',@CustomerCodes='PLANTACOTE NV,Anorel',@StorageUnitCode='BB650',
exec crDischTrf @TariffInfoTariff=6.35,@UnitCode='Net',@MeasurementUnitDescription='t',@CustomerCodes='PLANTACOTE NV,Anorel',@StorageUnitCode='BB700',
exec crDischTrf @TariffInfoTariff=6.35,@UnitCode='Net',@MeasurementUnitDescription='t',@CustomerCodes='PLANTACOTE NV,Anorel',@StorageUnitCode='BB1050',
exec crDischTrf @TariffInfoTariff=6.35,@UnitCode='Net',@MeasurementUnitDescription='t',@CustomerCodes='PLANTACOTE NV,Anorel',@StorageUnitCode='BB1300',
exec crDischTrf @TariffInfoTariff=2.6,@UnitCode='Net',@MeasurementUnitDescription='t',@CustomerCodes='PLANTACOTE NV'
exec crDischTrf @TariffInfoTariff=6.45,@UnitCode='Net',@MeasurementUnitDescription='t',@CustomerCodes='BOREALIS L.A.T GMBH',@StorageUnitCode='BB1000',

	
	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK
		SELECT ERROR_NUMBER() as ErrorNumber, ERROR_MESSAGE() as ErrorMessage
END CATCH	

drop proc KreaAdditTar
drop proc KreaTarInt
