CREATE PROCEDURE [dbo].[TariffGeneral_CreateTariffFileForGrouping]
	@Description nvarchar(250),					--required
	@TariffFileReference nvarchar(250),			--required
	@IC_code nvarchar(50)						--required		This internal company will be taken into account when creating the tariffs
AS
DECLARE @createUser nvarchar(15) = 'system'
DECLARE @errMsg nvarchar(500)
BEGIN

IF @Description IS NULL OR @TariffFileReference IS NULL OR @IC_code IS NULL
BEGIN
	;SELECT @errMsg = 'All parameters are required for creating a tariff file for grouping.'
	;THROW 51000, @errMsg, 1;
END

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
       @Description
       ,@TariffFileReference
       ,0--Active
       ,COMPANYNR
       ,NULL -- OPERATION_TYPE_ID
       ,@createUser
       ,getdate()
       ,@createUser
       ,getdate()
FROM COMPANY c
WHERE c.CODE = @IC_code

END
GO

--You shoud not use this proc directly
CREATE PROCEDURE [dbo].[TariffGeneral_CreateTariffInternal]
	@TariffInfoCode nvarchar(250),						--required
	@TariffInfoDescr nvarchar(250),						--required
	@TariffInfoTariff decimal(18,3),					--required
	@UnitCode nvarchar(50),								--required
	@CurrencyCode nvarchar(3),							--required
	@TariffFileReference nvarchar(250),					--required

	@OperationCode nvarchar(50) = null,					--optional
	@MeasurementUnitDescription nvarchar(50) = null,	--optional
	@CustomerCodes nvarchar(500) = null,				--optional
	@ServiceAccount nvarchar(50) = null					--optional
AS
	DECLARE @OperationId int
	DECLARE @TariffId int
	DECLARE @MeasurementUnitId int
	DECLARE @createUser nvarchar(15) = 'system'
	DECLARE @DateFrom nvarchar(15) = '1-JAN-2016'
	DECLARE @DateTo nvarchar(15) = '1-JAN-2050'
	DECLARE @errMsg nvarchar(500)
BEGIN
	SET NOCOUNT ON

	-- Check if provided code for the tariff is unique
	IF EXISTS (SELECT * FROM [dbo].[TARIFF_INFO] WHERE [CODE] = @TariffInfoCode)
	BEGIN
		;SELECT @errMsg = 'Tariff info with code ' + @TariffInfoCode +' already exists. Could not insert tariff.'
		;THROW 51000, @errMsg, 1;
	END

	--Check if unit exists
	IF NOT EXISTS (SELECT * FROM [dbo].[UNIT] WHERE [CODE] = @UnitCode)
	BEGIN
		;SELECT @errMsg = 'Unit with code ' + @UnitCode +' does not exist. Could not insert tariff.'
		;THROW 51000, @errMsg, 1;
	END

	--Check if currency exists
	IF NOT EXISTS (SELECT * FROM [dbo].[CURRENCY] WHERE [CODE] = @CurrencyCode)
	BEGIN
		;SELECT @errMsg = 'Currency with code ' + @CurrencyCode +' does not exist. Could not insert tariff.'
		;THROW 51000, @errMsg, 1;
	END

	-- Check if tariff file with the provided reference for grouping exists
	IF NOT EXISTS (SELECT * FROM [dbo].[TARIFF_FILE] WHERE [REFERENCE] = @TariffFileReference)
	BEGIN
		;SELECT @errMsg = 'Tariff file with reference ' + @TariffFileReference +' does not exist. Could not insert tariff.'
		;THROW 51000, @errMsg, 1;
	END;			

	--Check if measurement unit exists, if specified only
	IF @MeasurementUnitDescription IS NOT NULL
	BEGIN
		IF NOT EXISTS (SELECT [MEASUREMENT_UNIT_ID] from [MEASUREMENT_UNIT] where [DESCRIPTION] = @MeasurementUnitDescription)
		BEGIN
			;SELECT @errMsg = 'Measurement unit with description ' + @MeasurementUnitDescription +' does not exist. Could not insert tariff.'
			;THROW 51000, @errMsg, 1;
		END

		SELECT @MeasurementUnitId = [MEASUREMENT_UNIT_ID] from [MEASUREMENT_UNIT] where [DESCRIPTION] = @MeasurementUnitDescription;
	END

	--Check if operation exists, if specified only
	IF @OperationCode IS NOT NULL
	BEGIN
		IF NOT EXISTS (SELECT * FROM [dbo].[OPERATION] WHERE [CODE] = @OperationCode AND [INTERNAL_COMPANY_ID] = (SELECT TOP 1 [INTERNAL_COMPANY_ID] FROM [dbo].[TARIFF_FILE] WHERE [REFERENCE] = @TariffFileReference))
		BEGIN
			;SELECT @errMsg = 'Operation with code ' + @OperationCode +' does not exist or is not linked to the required internal company from the tariff file. Could not insert tariff.'
			;THROW 51000, @errMsg, 1;
		END

		SELECT @OperationId = [OPERATION_ID] FROM [dbo].[OPERATION] WHERE [CODE] = @OperationCode AND [INTERNAL_COMPANY_ID] = (SELECT TOP 1 [INTERNAL_COMPANY_ID] FROM [dbo].[TARIFF_FILE] WHERE [REFERENCE] = @TariffFileReference);
	END

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
			,[UNIT_ID]
			,@MeasurementUnitId
			,[CURRENCY_ID]
			,@ServiceAccount
			,@createUser
			,getdate()
			,@createUser
			,getdate()
	FROM
		[dbo].[UNIT] u, [dbo].[CURRENCY] c
		WHERE u.CODE = @UnitCode AND c.CODE = @CurrencyCode;

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
			   [TARIFF_FILE_ID]
			   ,@OperationId
			   ,[TARIFF_INFO_ID]
			   ,0
			   ,@DateFrom 
			   ,@DateTo
			   ,@createUser
			   ,getdate()
			   ,@createUser
			   ,getdate()
	FROM [dbo].[TARIFF_INFO] ti, [TARIFF_FILE] tf
	WHERE ti.[CODE] = @TariffInfoCode AND tf.REFERENCE = @TariffFileReference;

	SELECT @TariffId = SCOPE_IDENTITY();

	--Insert tariff for different customers if provided
	IF @CustomerCodes IS NOT NULL
	BEGIN
				 
		DECLARE @pos INT
		DECLARE @len INT
		DECLARE @value NVARCHAR(50)
		
		SET @pos = 0
		SET @len = 0
		SET @CustomerCodes = @CustomerCodes + ','
		
		WHILE CHARINDEX(',', @CustomerCodes, @pos+1)>0
		BEGIN
			SET @len = CHARINDEX(',', @CustomerCodes, @pos+1) - @pos
			SET @value = SUBSTRING(@CustomerCodes, @pos, @len)

			--Check if the customer exists
			IF NOT EXISTS (SELECT * FROM [dbo].[COMPANY] WHERE [CODE] = @value)
			BEGIN
				;select @errMsg = 'Customer with code ' + @value +' does not exist. Could not insert tariff.'
				;THROW 51000, @errMsg, 1;
			END

			INSERT INTO [dbo].[TARIFF_CUSTOMER]
				([TARIFF_ID]
				,[COMPANY_ID])
			SELECT
				@TariffId,
				[COMPANYNR]
			FROM [dbo].[COMPANY] WHERE [CODE] = @value;

			SET @pos = CHARINDEX(',', @CustomerCodes, @pos+@len) + 1

		END		
		
	END

	SET NOCOUNT OFF;
	
	RETURN @TariffId;
END
GO

--You shoud not use this proc directly
CREATE PROCEDURE [dbo].[TariffGeneral_ValidateAdditionalTariff]
	@OperationCode nvarchar(50),				--required
	@InternalCompanyId int,						--required  
	@CustomerCodes nvarchar(500)=null			--optional
AS
	DECLARE @errMsg nvarchar(500)
BEGIN
	-- Additinal tariff validation: it must have OperationCode .i.e. linked to additional operation and any customer specified must be linked to this additional operation
	
	IF @OperationCode IS NULL
	BEGIN
		;SELECT @errMsg = 'Operation code is required when creating additional tariff.'
		;THROW 51000, @errMsg, 1;
	END

	IF NOT EXISTS (SELECT * FROM [dbo].[OPERATION] WHERE [CODE] = @OperationCode AND [INTERNAL_COMPANY_ID] = @InternalCompanyId)
	BEGIN
		;SELECT @errMsg = 'Operation is required when creating additional tariff. Operation with code ' + @OperationCode +' does not exist or is not linked to the required internal company from the tariff file. Could not insert tariff.'
		;THROW 51000, @errMsg, 1;
	END

	IF @CustomerCodes IS NOT NULL
	BEGIN
		DECLARE @addOpId INT = (SELECT TOP 1 [OPERATION_ID] FROM [dbo].[OPERATION] WHERE [CODE] = @OperationCode AND [INTERNAL_COMPANY_ID] = @InternalCompanyId)

		DECLARE @pos INT
		DECLARE @len INT
		DECLARE @value NVARCHAR(50)
		
		SET @pos = 0
		SET @len = 0
		SET @CustomerCodes = @CustomerCodes + ','
		
		WHILE CHARINDEX(',', @CustomerCodes, @pos+1)>0
		BEGIN
			SET @len = CHARINDEX(',', @CustomerCodes, @pos+1) - @pos
			SET @value = SUBSTRING(@CustomerCodes, @pos, @len)

			DECLARE @companyId INT = (SELECT TOP 1 [COMPANYNR] FROM [dbo].[COMPANY] WHERE [CODE] = @value)
			
			IF NOT EXISTS (SELECT * FROM [dbo].[ADDITIONAL_OPERATION_COMPANY] WHERE [ADDITIONAL_OPERATION_ID] = @addOpId AND [COMPANYNR] = @companyId)
			BEGIN
				;SELECT @errMsg = 'You want to create additional tariff for a customer with code ' + @value + ' but this it is not linked to the additional operation with code ' + @OperationCode + ' for the tariff. Could not insert tariff.' 
				;THROW 51000, @errMsg, 1;
				--You want to create additional tariff for a given customer but this customer is not linked to the additional operation for the tariff
			END

			SET @pos = CHARINDEX(',', @CustomerCodes, @pos+@len) + 1

		END		
		
	END


END
GO

CREATE PROCEDURE [dbo].[TariffGeneral_CreateTariff]
	--Master parameter. Type of the tariff being created
	@TariffType nvarchar(10),						--required		Values: D - discharging, L - loading, V - vas, S - stock change, A - additional, ADM - administrative, W - warehouse rent

	-- Basic parameters. Goes in the internal tariff procedure
	@TariffInfoCode nvarchar(250),					--required
	@TariffInfoDescr nvarchar(250),					--required
	@TariffInfoTariff decimal(18,3)=0,				--required		if not range tariff
	@UnitCode nvarchar(50)=null,					--required
	@CurrencyCode nvarchar(3),						--required
	@TariffFileReference nvarchar(250),				--required

	@OperationCode nvarchar(50)=null,				--optional		required if creating Additional tariff
	@MeasurementUnitDescription nvarchar(50)=null,	--optional
	@CustomerCodes nvarchar(500)=null,				--optional		comma delimited; no apostrophies; can be used with a single code
	@ServiceAccount nvarchar(50)=null,				--optional		GLA

	--Tarif configuration that goes in the stock info config if you need it
	@ProductCode nvarchar(50)=null,					--optional
	@StorageUnitCode nvarchar(50)=null,				--optional		only single code

	-- Loading and discharging tariff specific options
	@TransportTypeCodes nvarchar(500)=null,			--optional;		comma delimited; no apostrophies; can be used with a single code

	--Warehouse rent tariff specific options
	@Period int = null,								--optional
	@PeriodType int = null,							--optional		required only if WHR		Values: 0 = Day, 1 = Week, 2 = Month
	@FreePeriod int = null,							--optional
	@FreePeriodType int = null						--optional		required only if WHR		Values: 0 = Day, 1 = Week, 2 = Month
AS
	DECLARE @TariffId int
	DECLARE @StockInfoConfigId int
	DECLARE @StockInfoId int
	DECLARE @InternalCompanyId int

	DECLARE @TransportTypeId int
	DECLARE @pos INT
	DECLARE @len INT
	DECLARE @value NVARCHAR(50)
		
	DECLARE @createUser nvarchar(15) = 'system'
	DECLARE @StorageUnitId int = null
	DECLARE @ProductId int = null
	DECLARE @errMsg nvarchar(500)
BEGIN
	-- Dummy proof check for required parameters
	IF @TariffType IS NULL OR @TariffInfoCode IS NULL OR @TariffInfoDescr IS NULL OR @TariffInfoTariff IS NULL
	OR @UnitCode IS NULL OR @CurrencyCode IS NULL OR @TariffFileReference IS NULL
	BEGIN
		;SELECT @errMsg = 'Some required parameters are missing'
		;THROW 51000, @errMsg, 1;
	END
	IF @TariffType != N'D' AND @TariffType != N'L' AND @TariffType != N'V' AND @TariffType != N'S' AND 
	@TariffType != N'A' AND @TariffType != N'ADM' AND @TariffType != N'W'
	BEGIN
		;SELECT @errMsg = 'Unknown tariff type ' + @TariffType
		;THROW 51000, @errMsg, 1;
	END

	SET @InternalCompanyId = (SELECT TOP 1 INTERNAL_COMPANY_ID FROM [dbo].[TARIFF_FILE] WHERE [REFERENCE] = @TariffFileReference)

	EXEC @TariffId = [dbo].[TariffGeneral_CreateTariffInternal]
	@TariffInfoCode, 
	@TariffInfoDescr, 
	@TariffInfoTariff, 
	@UnitCode, 
	@CurrencyCode,
	@TariffFileReference,

	@OperationCode,
	@MeasurementUnitDescription, 
	@CustomerCodes,
	@ServiceAccount 

	--Create StockInfo and StockInfoConfig if neccessary
	IF @ProductCode IS NOT NULL OR @StorageUnitCode IS NOT NULL
	BEGIN

		SELECT @ProductId = 
		(SELECT TOP 1 p.[PRODUCT_ID] FROM [dbo].[PRODUCT] p
		LEFT JOIN [dbo].[PRODUCT_INT_COMPANY] pic
		ON p.[PRODUCT_ID] = pic.[PRODUCT_ID]
		WHERE pic.INT_COMPANYNR = @InternalCompanyId AND p.[CODE] = @ProductCode)

		SELECT @StorageUnitId = [UNIT_ID] from [dbo].[UNIT] where [CODE] = @StorageUnitCode

		--Check that whichever is specified exists
		IF (@ProductId IS NULL AND @ProductCode IS NOT NULL)
		BEGIN
			;SELECT @errMsg = 'Product with code ' + @ProductCode +' does not exist or is not linked to the required internal company from the tariff file. Could not insert tariff.'
			;THROW 51000, @errMsg, 1;
		END
		IF (@StorageUnitId IS NULL AND @StorageUnitCode IS NOT NULL)
		BEGIN
			;SELECT @errMsg = 'Unit with code ' + @StorageUnitCode +' does not exist. Could not insert tariff.'
			;THROW 51000, @errMsg, 1;
		END

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

		SELECT @StockInfoConfigId = SCOPE_IDENTITY();

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

		SELECT @StockInfoId = SCOPE_IDENTITY();
	END

	--Insert the specific tariff in the 1:1 table
	IF @TariffType = N'D'
	BEGIN
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
		
		--Insert for given transport types if needed
		IF @TransportTypeCodes IS NOT NULL
		BEGIN
			SET @pos = 0
			SET @len = 0
			SET @TransportTypeCodes = @TransportTypeCodes + ','
		
			WHILE CHARINDEX(',', @TransportTypeCodes, @pos+1)>0
			BEGIN
				SET @len = CHARINDEX(',', @TransportTypeCodes, @pos+1) - @pos
				SET @value = SUBSTRING(@TransportTypeCodes, @pos, @len)

				--Check if the transport type exists

				SELECT @TransportTypeId = [TRANSPORT_TYPE_ID] FROM [dbo].[TRANSPORT_TYPE]
				WHERE [CODE] = @value and [INTERNAL_COMPANY_NR] = @InternalCompanyId

				IF (@TransportTypeId is null)
					SELECT @TransportTypeId = [TRANSPORT_TYPE_ID] FROM [dbo].[TRANSPORT_TYPE]
					WHERE [CODE] = @value and [INTERNAL_COMPANY_NR] is null
				IF (@TransportTypeId is null)
				BEGIN
					;SELECT @errMsg = 'Transport type with code ' + @value +' does not exist or is not linked to the required internal company from the tariff file. Could not insert tariff.'
					;THROW 51000, @errMsg, 1;
				END

				INSERT INTO [dbo].[DISCHARGING_TARIFF_TRANSPORT_TYPE]
						([DISCHARGING_TARIFF_ID]
						,[TRANSPORT_TYPE_ID])
				VALUES (@TariffId
						,@TransportTypeId)

				SET @pos = CHARINDEX(',', @TransportTypeCodes, @pos+@len) + 1

			END		
		END

	END
		 
	IF @TariffType = N'L'
	BEGIN
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
			 ,@createUser
			 ,getdate()
			 ,@createUser
			 ,getdate())

		--Insert for given transport types if needed
		IF @TransportTypeCodes IS NOT NULL
		BEGIN
			SET @pos = 0
			SET @len = 0
			SET @TransportTypeCodes = @TransportTypeCodes + ','
		
			WHILE CHARINDEX(',', @TransportTypeCodes, @pos+1)>0
			BEGIN
				SET @len = CHARINDEX(',', @TransportTypeCodes, @pos+1) - @pos
				SET @value = SUBSTRING(@TransportTypeCodes, @pos, @len)

				--Check if the transport type exists

				SELECT @TransportTypeId = [TRANSPORT_TYPE_ID] FROM [dbo].[TRANSPORT_TYPE]
				WHERE [CODE] = @value and [INTERNAL_COMPANY_NR] = @InternalCompanyId

				IF (@TransportTypeId is null)
					SELECT @TransportTypeId = [TRANSPORT_TYPE_ID] FROM [dbo].[TRANSPORT_TYPE]
					WHERE [CODE] = @value and [INTERNAL_COMPANY_NR] is null
				IF (@TransportTypeId is null)
				BEGIN
					;SELECT @errMsg = 'Transport type with code ' + @value +' does not exist or is not linked to the required internal company from the tariff file. Could not insert tariff.'
					;THROW 51000, @errMsg, 1;
				END

				INSERT INTO [dbo].[LOADING_TARIFF_TRANSPORT_TYPE]
						([LOADING_TARIFF_ID]
						,[TRANSPORT_TYPE_ID])
				VALUES (@TariffId
						,@TransportTypeId)

				SET @pos = CHARINDEX(',', @TransportTypeCodes, @pos+@len) + 1

			END		
		END
	END

	IF @TariffType = N'V'
	BEGIN
		INSERT INTO [dbo].[VAS_TARIFF]
					 ([VAS_TARIFF_ID]
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
	END
				 
	IF @TariffType = N'S'
	BEGIN
		INSERT INTO [dbo].[STOCK_CHANGE_TARIFF]
					 ([STOCK_CHANGE_TARIFF_ID]
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
	END

	IF @TariffType = N'A'
	BEGIN
		--Validate additional tariff only
		EXEC [dbo].[TariffGeneral_ValidateAdditionalTariff]
			@OperationCode,
			@InternalCompanyId,
			@CustomerCodes

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
	END

	IF @TariffType = N'ADM'
	BEGIN
		INSERT INTO [dbo].[ADMINISTRATIVE_TARIFF]
					 ([ADMINISTRATIVE_TARIFF_ID]
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
	END
					 
	IF @TariffType = N'W'
	BEGIN
		IF @PeriodType IS NULL OR @FreePeriodType IS NULL
		BEGIN
			;SELECT @errMsg = 'Some required parameters are missing for inserting WHR tariff'
			;THROW 51000, @errMsg, 1;
		END

		INSERT INTO [dbo].[WAREHOUSE_RENT_TARIFF]
					 ([WAREHOUSE_RENT_TARIFF_ID]
					 ,[STOCK_INFO_ID]
					 ,[PERIOD]
					 ,[PERIOD_TYPE]
					 ,[FREE_PERIOD]
					 ,[FREE_PERIOD_TYPE]
					 ,[CREATE_USER]
					 ,[CREATE_TIMESTAMP]
					 ,[UPDATE_USER]
					 ,[UPDATE_TIMESTAMP])
			 VALUES
					 (@TariffId
					 ,@StockInfoId
					 ,@Period
					 ,@PeriodType
					 ,@FreePeriod
					 ,@FreePeriodType
					 ,@createUser
					 ,getdate()
					 ,@createUser
					 ,getdate())	
	END

	PRINT CONCAT('Tariff inserted successfully. TariffId ', @TariffId)
END
GO

CREATE PROCEDURE [dbo].[TariffGeneral_CreateTariffRange]
    @TariffInfoCode nvarchar(250),				-- required
    @Tariff decimal (18,3),						-- required
    @RangeFrom decimal (38,8),					-- required
    @RangeTo decimal (38,8),					-- required
    @UnitCode nvarchar(50),						-- required
    @MeasurementUnitDescription nvarchar(50),	-- required
	@RangeCalculation int = 2					-- optional (defaults to: 2 - Independent)
AS
    DECLARE @UnitId int
    DECLARE @MeasurementUnitId int
    DECLARE @TariffRangeId int
	DECLARE	@TariffInfoId int
	DECLARE @errMsg nvarchar(500)
BEGIN
    SELECT @UnitId = UNIT_ID FROM UNIT WHERE CODE = @UnitCode
    SELECT @MeasurementUnitId = MEASUREMENT_UNIT_ID FROM MEASUREMENT_UNIT WHERE [DESCRIPTION] = @MeasurementUnitDescription
	SELECT @TariffInfoId = ti.TARIFF_INFO_ID FROM TARIFF t INNER JOIN TARIFF_INFO ti ON t.TARIFF_INFO_ID = ti.TARIFF_INFO_ID WHERE ti.CODE = @TariffInfoCode

	IF (@UnitId IS NULL)
	BEGIN
		;SELECT @errMsg = 'Unit with code ' + @UnitCode +' does not exist. Could not insert tariff range.'
		;THROW 51000, @errMsg, 1;
	END

	IF (@TariffInfoId IS NULL)
	BEGIN
		;SELECT @errMsg = 'Tariff Info with code ' + @TariffInfoCode +' does not exist. Could not insert tariff range.'
		;THROW 51000, @errMsg, 1;
	END

	IF (@RangeCalculation IS NULL)
	BEGIN
		;SELECT @errMsg = 'Range calculation cannot be NULL. Could not insert tariff range.'
		;THROW 51000, @errMsg, 1;
	END

                
	INSERT INTO [dbo].[TARIFF_RANGE]
                    ([TARIFF]
                    ,[RANGE_FROM]
                    ,[RANGE_TO]
                    ,[UNIT_ID]
                    ,[MEASUREMENT_UNIT_ID]
                    ,[CREATE_USER]
                    ,[CREATE_TIMESTAMP]
                    ,[UPDATE_USER]
                    ,[UPDATE_TIMESTAMP])
    VALUES
                    (@Tariff
                    ,@RangeFrom
                    ,@RangeTo
                    ,@UnitId
                    ,@MeasurementUnitId
                    ,'system'
                    ,getdate()
                    ,'system'
                    ,getdate())                         
                                
    SELECT @TariffRangeId = SCOPE_IDENTITY()
                                                                                
    INSERT INTO [dbo].[TARIFF_INFO_RANGE] ([TARIFF_INFO_ID],[TARIFF_RANGE_ID])
    VALUES (@TariffInfoId,@TariffRangeId)       
								
	UPDATE TARIFF_INFO SET RANGE_CALCULATION = @RangeCalculation WHERE TARIFF_INFO_ID = @TariffInfoId
END
GO

BEGIN TRY
	BEGIN TRANSACTION	
	--Your code starts here

	--Create additional tariff
	EXEC [dbo].[TariffGeneral_CreateTariff]
		@TariffType =			'A',
		@TariffInfoCode =		'BELGOMILKADD9',
		@TariffInfoDescr =		'Belgomilk - Additional work hours with forklift',
		@TariffInfoTariff =		75,
		@UnitCode =				'HR',
		@CurrencyCode =			'EUR',
		@TariffFileReference =	'Belgomilk_AdditionalOperationTariffs',
		@ServiceAccount =		'701310',
		@CustomerCodes =		'BELGOMILK',
		@OperationCode =		'AWHWIFL'

	--Your code ends here
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION
		SELECT ERROR_NUMBER() as ErrorNumber, ERROR_MESSAGE() as ErrorMessage
END CATCH
GO

DROP PROCEDURE [dbo].[TariffGeneral_CreateTariff]
DROP PROCEDURE [dbo].[TariffGeneral_CreateTariffRange]
DROP PROCEDURE [dbo].[TariffGeneral_ValidateAdditionalTariff]
DROP PROCEDURE [dbo].[TariffGeneral_CreateTariffInternal]
DROP PROCEDURE [dbo].[TariffGeneral_CreateTariffFileForGrouping]
