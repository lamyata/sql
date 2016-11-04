		DECLARE @currentId INT
		DECLARE tableIdsCursor CURSOR FOR
		SELECT COMPANY_ID FROM @CustomerIDs
		OPEN tableIdsCursor;
		FETCH NEXT FROM tableIdsCursor
		INTO @currentId

		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO [dbo].[TARIFF_CUSTOMER]
				([TARIFF_ID]
				,[COMPANY_ID])
			SELECT
				@TariffId,
				COMPANYNR
			FROM COMPANY WHERE CODE = @CustomerCode;
		
		
			UPDATE @AllCodes SET CODE = @newCode WHERE COMPANY_ID = @currentId
			UPDATE COMPANY SET CODE = @newCode WHERE COMPANY_ID = @currentId
			--GENERATE UNIQUE NEW CODE
			SET @newCode = (SELECT ABS(CONVERT(int, HASHBYTES(''SHA2_256'', CONVERT(NVARCHAR(MAX), NEWID())))))
			SET @count = (SELECT COUNT(*) FROM @AllCodes WHERE CODE = @newCode)

			WHILE(@count > 1)
			BEGIN
				SET @newCode = (SELECT ABS(CONVERT(int, HASHBYTES(''SHA2_256'', CONVERT(NVARCHAR(MAX), NEWID())))))
				SET @count = (SELECT COUNT(*) FROM @AllCodes WHERE CODE = @newCode)
			END

			FETCH NEXT FROM tableIdsCursor
			INTO @currentId
		END		