create proc CreateAdditionalOperation
	@NameDescr nvarchar(250),
	@Code nvarchar(50),
	@IcCmpCode nvarchar(50),
	@Usage int,
	@OpTypes nvarchar(50),
	@CustomerCmpCode nvarchar(50),
	@OpCodes nvarchar(500) = null
as
	declare @Operations table(OPERATION_ID int)
begin
	INSERT INTO [dbo].[OPERATION]([NAME],[DESCRIPTION],[CODE],[INTERNAL_COMPANY_ID],[TYPE_ID],[STATUS],[CREATE_USER],[CREATE_TIMESTAMP],[UPDATE_USER],[UPDATE_TIMESTAMP])
		SELECT @NameDescr, @NameDescr, @Code, c.COMPANYNR, ot.OPERATION_TYPE_ID, 0,'system', getdate(), 'system', getdate()
		FROM COMPANY c, OPERATION_TYPE ot where c.CODE = @IcCmpCode and ot.[DESCRIPTION]='Additional'
	insert into [dbo].[ADDITIONAL_OPERATION] ([ADDITIONAL_OPERATION_ID],[USAGE],[CREATE_USER],[CREATE_TIMESTAMP],[UPDATE_USER],[UPDATE_TIMESTAMP] )
		select o.OPERATION_ID , @Usage,'system', getdate(), 'system', getdate() FROM [OPERATION] o where o.[CODE] = @Code
	if CHARINDEX(N'L', @OpTypes) > 0
		INSERT INTO @Operations	SELECT LOADING_OPERATION_ID FROM LOADING_OPERATION
	if CHARINDEX(N'D', @OpTypes) > 0
		INSERT INTO @Operations	SELECT DISCHARGING_OPERATION_ID FROM DISCHARGING_OPERATION
	if CHARINDEX(N'S', @OpTypes) > 0
		INSERT INTO @Operations	SELECT STOCK_CHANGE_OPERATION_ID FROM STOCK_CHANGE_OPERATION
	if CHARINDEX(N'V', @OpTypes) > 0
		INSERT INTO @Operations	SELECT VAS_OPERATION_ID FROM VAS_OPERATION
	if @OpCodes is not null
		INSERT INTO @Operations SELECT OPERATION_ID FROM [OPERATION] o WHERE CHARINDEX(o.CODE, @OpCodes) > 0
	insert into OPERATION_ADDITIONAL_OPERATION
		select o.OPERATION_ID, ao.OPERATION_ID
		from OPERATION o, OPERATION ao
		where o.INTERNAL_COMPANY_ID = ao.INTERNAL_COMPANY_ID
		and o.OPERATION_ID in (select OPERATION_ID from @Operations)
		and ao.CODE = @Code
	insert into [dbo].[ADDITIONAL_OPERATION_COMPANY]([ADDITIONAL_OPERATION_ID],[COMPANYNR]) select o.OPERATION_ID, c.COMPANYNR from OPERATION o, COMPANY c where o.CODE=@Code and c.CODE =@CustomerCmpCode
end

go

create proc CreateTariffInternal
	@TariffInfoCode nvarchar(250),
	@TariffInfoDescr nvarchar(250),
	@TariffInfoTariff decimal(18,3),
	@UnitCode nvarchar(50),
	@MeasurementUnitDescription  nvarchar(50),
	@CurrencyCode nvarchar(3),
	@OperationCode nvarchar(50),
	@CustomerCode nvarchar(50),
	@ServiceAccount nvarchar(50),
	@TariffFileReference nvarchar(250)
as
	declare @OperationId int
	declare @TariffId int
	declare @MeasurementUnitId int
begin
	set nocount on

	select @OperationId = [OPERATION_ID] from [OPERATION] where [CODE] = @OperationCode;
	if (IsNull(@MeasurementUnitDescription,'')!='')
		select @MeasurementUnitId = [MEASUREMENT_UNIT_ID] from [MEASUREMENT_UNIT] WHERE UPPER([DESCRIPTION]) = @MeasurementUnitDescription;

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
			,'sys'
			,getdate()
			,'sys'
			,getdate()
	FROM
		UNIT u, CURRENCY c
		WHERE u.CODE = @UnitCode AND c.CODE = @CurrencyCode;

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
			   ,TARIFF_INFO_ID
			   ,0
			   ,'1-JAN-2016' -- PERIOD_FROM
			   ,'1-JAN-2050' -- PERIOD_TO
			   ,'sys'
			   ,getdate()
			   ,'sys'
			   ,getdate()
	FROM TARIFF_INFO ti, TARIFF_FILE tf
	WHERE ti.CODE = @TariffInfoCode AND tf.REFERENCE = @TariffFileReference;

	select @TariffId = SCOPE_IDENTITY();

	if @CustomerCode is not null
		INSERT INTO [dbo].[TARIFF_CUSTOMER]
			([TARIFF_ID]
			,[COMPANY_ID])
		SELECT
			@TariffId,
			COMPANYNR
		FROM COMPANY WHERE CODE = @CustomerCode;
	
	set nocount off;
	
	return @TariffId;
	
end
go

create proc CreateTariff
	@TariffInfoCode nvarchar(250),
	@TariffInfoDescr nvarchar(250),
	@TariffInfoTariff decimal(18,3),
	@UnitCode nvarchar(50),
	@MeasurementUnitDescription nvarchar(50),
	@CurrencyCode nvarchar(3),
	@OperationCode nvarchar(50),
	@OperationType nvarchar(10),
	@CustomerCode nvarchar(50),
	@ServiceAccount nvarchar(50),
	@TariffFileReference nvarchar(250),
	@ProductCode nvarchar(50),
	@TransportTypeCode nvarchar(10)
as
	declare @TariffId int
	declare @StockInfoConfigId int
	declare @StockInfoId int
	declare @InternalCompanyId int
	declare @TransportTypeId int
begin
	exec @TariffId = CreateTariffInternal @TariffInfoCode, @TariffInfoDescr, @TariffInfoTariff, @UnitCode, @MeasurementUnitDescription, @CurrencyCode,
		@OperationCode, @CustomerCode, @ServiceAccount, @TariffFileReference

	if @ProductCode is not null
	begin
		select @InternalCompanyId = INTERNAL_COMPANY_ID from TARIFF_FILE where REFERENCE = @TariffFileReference

		INSERT INTO [dbo].[STOCK_INFO_CONFIG]
				   ([INTERNAL_COMPANY_ID]
				   ,[PRODUCT_ID]
				   ,[STATUS]
				   ,[CREATE_USER]
				   ,[CREATE_TIMESTAMP]
				   ,[UPDATE_USER]
				   ,[UPDATE_TIMESTAMP])
			 SELECT
				   @InternalCompanyId 
				   ,PRODUCT_ID
				   ,0 -- STATUS (0 available, 1 blocked)
				   ,'sys'
				   ,GETDATE()
				   ,'sys'
				   ,GETDATE()
			FROM PRODUCT
			WHERE CODE = @ProductCode

		select @StockInfoConfigId = SCOPE_IDENTITY();

		INSERT INTO [dbo].[STOCK_INFO]
			   ([STOCK_INFO_CONFIG_ID]
			   ,[CREATE_USER]
			   ,[CREATE_TIMESTAMP]
			   ,[UPDATE_USER]
			   ,[UPDATE_TIMESTAMP])
		 VALUES
			   (@StockInfoConfigId
			   ,'sys'
			   ,GETDATE()
			   ,'sys'
			   ,GETDATE())

		select @StockInfoId = SCOPE_IDENTITY();
	end

	if CHARINDEX(N'D', @OperationType) > 0
	begin
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
			 ,'sys'
			 ,getdate()
			 ,'sys'
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
	end
		 
	if CHARINDEX(N'L', @OperationType) > 0
	begin
		INSERT INTO [dbo].[LOADING_TARIFF]
			 ([LOADING_TARIFF_ID]
			 ,[STOCK_INFO_ID]
			 ,[CREATE_USER]
			 ,[CREATE_TIMESTAMP]
			 ,[UPDATE_USER]
			 ,[UPDATE_TIMESTAMP])
		 VALUES
			 (@TariffId
			 ,@StockInfoId
			 ,'sys'
			 ,getdate()
			 ,'sys'
			 ,getdate())

	    if (@TransportTypeCode is not null)
		begin
			select @TransportTypeId = TRANSPORT_TYPE_ID from TRANSPORT_TYPE
				where CODE = @TransportTypeCode and INTERNAL_COMPANY_NR = @InternalCompanyId
			if (@TransportTypeId is null)
				select @TransportTypeId = TRANSPORT_TYPE_ID from TRANSPORT_TYPE
				where CODE = @TransportTypeCode and INTERNAL_COMPANY_NR is null
			if (@TransportTypeId is not null)
				INSERT INTO [dbo].[LOADING_TARIFF_TRANSPORT_TYPE]
					   ([LOADING_TARIFF_ID]
					   ,[TRANSPORT_TYPE_ID])
				VALUES (@TariffId
					   ,@TransportTypeId)
		end
	end

	if CHARINDEX(N'V', @OperationType) > 0
		INSERT INTO [dbo].[VAS_TARIFF]
					 ([VAS_TARIFF_ID]
					 ,[CREATE_USER]
					 ,[CREATE_TIMESTAMP]
					 ,[UPDATE_USER]
					 ,[UPDATE_TIMESTAMP])
			 VALUES
					 (@TariffId
					 ,'sys'
					 ,getdate()
					 ,'sys'
					 ,getdate())
					 
	if CHARINDEX(N'S', @OperationType) > 0
		INSERT INTO [dbo].[STOCK_CHANGE_TARIFF]
					 ([STOCK_CHANGE_TARIFF_ID]
					 ,[CREATE_USER]
					 ,[CREATE_TIMESTAMP]
					 ,[UPDATE_USER]
					 ,[UPDATE_TIMESTAMP])
			 VALUES
					 (@TariffId
					 ,'sys'
					 ,getdate()
					 ,'sys'
					 ,getdate())

	if CHARINDEX(N'A', @OperationType) > 0
		INSERT INTO [dbo].[ADDITIONAL_TARIFF]
					 ([ADDITIONAL_TARIFF_ID]
					 ,[CREATE_USER]
					 ,[CREATE_TIMESTAMP]
					 ,[UPDATE_USER]
					 ,[UPDATE_TIMESTAMP])
			 VALUES
					 (@TariffId
					 ,'sys'
					 ,getdate()
					 ,'sys'
					 ,getdate())		 
end
go

BEGIN TRY
	BEGIN TRAN
	
INSERT INTO [dbo].[UNIT]
				 ([DESCRIPTION]
				 ,[CREATE_USER]
				 ,[CREATE_TIMESTAMP]
				 ,[UPDATE_USER]
				 ,[UPDATE_TIMESTAMP]
				 ,[STATUS]
				 ,[CODE])
	 VALUES
				 ('Label' -- DESCRIPTION
				 ,'sys'
				 ,getdate()
				 ,'sys'
				 ,getdate()
				 ,1 -- STATUS
				 ,'LBL')
			
INSERT INTO [dbo].[UNIT]
				 ([DESCRIPTION]
				 ,[CREATE_USER]
				 ,[CREATE_TIMESTAMP]
				 ,[UPDATE_USER]
				 ,[UPDATE_TIMESTAMP]
				 ,[STATUS]
				 ,[CODE])
	 VALUES
				 ('Order Item' -- DESCRIPTION
				 ,'sys'
				 ,getdate()
				 ,'sys'
				 ,getdate()
				 ,1 -- STATUS
				 ,'ORDERITEM')						

exec CreateAdditionalOperation
	@NameDescr = 'Administrative fee order',
	@Code = 'AADMFEEORDER',
	@IcCmpCode = 'IC_VMHZP',
	@Usage = 0, -- 0 administrative, 1 operational
	@OpTypes = 'LD',
	@CustomerCmpCode = 'RPC'
	
exec CreateAdditionalOperation
	@NameDescr = 'Labelling',
	@Code = 'ALABNG',
	@IcCmpCode = 'IC_VMHZP',
	@Usage = 1, -- 0 administrative, 1 operational
	@OpTypes = 'LD',
	@CustomerCmpCode = 'RPC'

exec CreateTariff
	@TariffInfoCode = 'AADMFEEORDER',
	@TariffInfoDescr = 'Administrative fee order',
	@TariffInfoTariff = 8.4,
	@UnitCode = 'ORDERITEM',
	@MeasurementUnitDescription  = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'AADMFEEORDER',
	@OperationType = 'A',
	@CustomerCode = 'RPC',
	@ServiceAccount = '701310',
	@TariffFileReference = 'RPC_TARIFFS',
	@ProductCode = null,
	@TransportTypeCode = null

exec CreateTariff
	@TariffInfoCode = 'ALABNG',
	@TariffInfoDescr = 'Labelling',
	@TariffInfoTariff = .6,
	@UnitCode = 'LBL',
	@MeasurementUnitDescription  = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'ALABNG',
	@OperationType = 'A',
	@CustomerCode = 'RPC',
	@ServiceAccount = '701310',
	@TariffFileReference = 'RPC_TARIFFS',
	@ProductCode = null,
	@TransportTypeCode = null

	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK
		SELECT ERROR_NUMBER() as ErrorNumber, ERROR_MESSAGE() as ErrorMessage
END CATCH
	
drop proc CreateTariff
drop proc CreateTariffInternal
drop proc CreateAdditionalOperation
