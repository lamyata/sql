SET NOCOUNT ON
-- 0. Creating variables and functions
PRINT '0. Creating variables and functions'

--Check if function exists
IF EXISTS (SELECT * FROM sys.objects 
			WHERE object_id = OBJECT_ID(N'[dbo].[FN_DETERMINE_BAG_UNIT]') 
			AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	BEGIN
		PRINT 'Dropping function [dbo].[FN_DETERMINE_BAG_UNIT]'
		DROP FUNCTION [dbo].[FN_DETERMINE_BAG_UNIT]
	END
GO

IF EXISTS (SELECT * FROM sys.objects 
			WHERE object_id = OBJECT_ID(N'[dbo].[FN_UPDATE_STOCK_KEY_WITH_BAG_UNIT]') 
			AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	BEGIN
		PRINT 'Dropping function [dbo].[FN_UPDATE_STOCK_KEY_WITH_BAG_UNIT]'
		DROP FUNCTION [dbo].[FN_UPDATE_STOCK_KEY_WITH_BAG_UNIT]
	END
GO

--Create function - Determine the appropriate value for the "Bag Unit" sid based on the other two sids
PRINT 'Creating function [dbo].[FN_DETERMINE_BAG_UNIT]'
GO
CREATE FUNCTION [dbo].[FN_DETERMINE_BAG_UNIT]
(
	@BagType nvarchar(4000),
	@BagTissue nvarchar(4000)
)
RETURNS NVARCHAR(4000)
AS
BEGIN
DECLARE @BagUnit NVARCHAR(4000)

SET @BagUnit = 
CASE 
	WHEN @BagType = N'B013 - KRISTA K PLUS' AND @BagTissue = N'PE' THEN N'B25'
	WHEN @BagType = N'B015 - SQM ULTRA SOP' AND @BagTissue = N'PP' THEN N'B25'
	WHEN @BagType = N'B020 - CAMPBELLS' AND @BagTissue = N'PP' THEN N'B25'
	WHEN @BagType = N'B026 - YARA KRISTA K' AND @BagTissue = N'PP' THEN N'B25'
	WHEN @BagType = N'B027 - SQM HORTICULT' AND @BagTissue = N'PP' THEN N'B25'
	WHEN @BagType = N'B029 - KRISTA K PLUS' AND @BagTissue = N'PP' THEN N'B25'
	WHEN @BagType = N'B034 - BRINKMAN' AND @BagTissue = N'PE' THEN N'B25'
	WHEN @BagType = N'B038 - YARA KRISTA SOP' AND @BagTissue = N'PE' THEN N'B25'
	WHEN @BagType = N'B044 - SANGRAL NPC' AND @BagTissue = N'PP/PE' THEN N'B25'
	WHEN @BagType = N'B045 - KRISTA K ARABIC' AND @BagTissue = N'PP' THEN N'B25'
	WHEN @BagType = N'B053 - SANGRAL USOP52' AND @BagTissue = N'PP' THEN N'B25'
	WHEN @BagType = N'B058 - SQM HYDROPONICA' AND @BagTissue = N'PE' THEN N'B25'
	WHEN @BagType = N'B085 - YARA KRISTA K' AND @BagTissue = N'PE' THEN N'B25'
	WHEN @BagType = N'B1013 - SQM NK 13-0-45' AND @BagTissue = N'PP' THEN N'B25'
	WHEN @BagType = N'B1017 - MULTI SOP GG' AND @BagTissue = N'PE' THEN N'B25'
	WHEN @BagType = N'B1024 - BIOLCHIM NPC' AND @BagTissue = N'PE' THEN N'B25'
	WHEN @BagType = N'B1072 - VAN IPEREN NPC' AND @BagTissue = N'PP' THEN N'B25'
	WHEN @BagType = N'B1073 - VAN IPEREN SOP' AND @BagTissue = N'PP' THEN N'B25'
	WHEN @BagType = N'B1094 - ULTRASOL MOP' AND @BagTissue = N'PE' THEN N'B25'
	WHEN @BagType = N'B1103 - YARA KRISTA SOP' AND @BagTissue = N'PE' THEN N'B25'
	WHEN @BagType = N'B1114 - EUROSOLIDS VII' AND @BagTissue = N'PP' THEN N'B25'
	WHEN @BagType = N'B1146 - EUROSOLIDS' AND @BagTissue = N'PP' THEN N'B25'
	WHEN @BagType = N'B1191 - FENASA (NEW)' AND @BagTissue = N'PP' THEN N'B25'
	WHEN @BagType = N'B1234 - ULTRASOL K PLUS' AND @BagTissue = N'PP' THEN N'B25'
	WHEN @BagType = N'B1271 - KRISTA K PLUS' AND @BagTissue = N'PE' THEN N'B25'
	WHEN @BagType = N'B1298 - BLUE OCEAN' AND @BagTissue = N'PP' THEN N'B25'
	WHEN @BagType = N'B1312 - KISTA K (ALG)' AND @BagTissue = N'PP' THEN N'B25'
	WHEN @BagType = N'B1342 - COMPO HYD. K-MAX' AND @BagTissue = N'PE' THEN N'B25'
	WHEN @BagType = N'B459 - ULTRASOL 0-0-50' AND @BagTissue = N'PP' THEN N'B25'
	WHEN @BagType = N'B479 - GROGREEN' AND @BagTissue = N'PP' THEN N'B25'
	WHEN @BagType = N'B494 - NEUTRAL' AND @BagTissue = N'PP/PE' THEN N'B25'
	WHEN @BagType = N'B539 - GROGREEN - SOP' AND @BagTissue = N'PP' THEN N'B25'
	WHEN @BagType = N'B579 - LIQUIFERT' AND @BagTissue = N'PE' THEN N'B25'
	WHEN @BagType = N'B611 - K ADFERT NPC' AND @BagTissue = N'PP/PE' THEN N'B25'
	WHEN @BagType = N'B707 - K SAN.NPC GEN.' AND @BagTissue = N'PP/PE' THEN N'B25'
	WHEN @BagType = N'B708 - SAN USOP52 GENER' AND @BagTissue = N'PP' THEN N'B25'
	WHEN @BagType = N'B773 - ASTRA' AND @BagTissue = N'PP' THEN N'B25'
	WHEN @BagType = N'B807 - AGROWMORE SOP' AND @BagTissue = N'PP' THEN N'B25'
	WHEN @BagType = N'B817 - YARA KRISTA SOP' AND @BagTissue = N'PP' THEN N'B25'
	WHEN @BagType = N'B820 - SQM ULTRASOL SOP' AND @BagTissue = N'PP' THEN N'B25'
	WHEN @BagType = N'B960 - MULTI SOP HC' AND @BagTissue = N'PE' THEN N'B25'
	WHEN @BagType = N'B961 - YARA KRISTA K EE' AND @BagTissue = N'PE' THEN N'B25'
	WHEN @BagType = N'B962 - KRISTA K PLUS EE' AND @BagTissue = N'PE' THEN N'B25'
	WHEN @BagType = N'B982 - SOLUFERTIL' AND @BagTissue = N'PP' THEN N'B25'
	WHEN @BagType = N'B988 - SOLUPLANT' AND @BagTissue = N'PP' THEN N'B25'
	WHEN @BagType = N'B992 - ADFERT FORT-SOP' AND @BagTissue = N'PP' THEN N'B25'
	WHEN @BagType = N'B996 - TIMAC AGRO' AND @BagTissue = N'PP' THEN N'B25'
	WHEN @BagType = N'B997 - SULFOPOTASH ASTRA' AND @BagTissue = N'PP' THEN N'B25'
	WHEN @BagType = N'B2013 - MOP' AND @BagTissue = N'' THEN N'B25'
	WHEN @BagType = N'B1207 - MOP-S DRILLING GR' AND @BagTissue = N'' THEN N'B25'
	WHEN @BagType = N'B538 - YARA KRISTA SOP' AND @BagTissue = N'PE' THEN N'B25'
	WHEN @BagType = N'B561 - SOP 0-0-51' AND @BagTissue = N'PE' THEN N'B25'
	WHEN @BagType = N'B562 - BLANK' AND @BagTissue = N'PE' THEN N'B25'
	WHEN @BagType = N'B980 - USOP ALMERISUR' AND @BagTissue = N'PE' THEN N'B25'
	WHEN @BagType = N'B983 - MOP SQM IBE' AND @BagTissue = N'PE' THEN N'B25'
	WHEN @BagType = N'B733 - NPC-I SQM' AND @BagTissue = N'PE' THEN N'B25'
	WHEN @BagType = N'B738 - KRISTA SOP' AND @BagTissue = N'PE' THEN N'B25'
	WHEN @BagType = N'B739 - KRISTA K' AND @BagTissue = N'PE' THEN N'B25'
	WHEN @BagType = N'B975 - NPC-TA BIOLCHIM' AND @BagTissue = N'PE' THEN N'B25'
	WHEN @BagType = N'B1335 - QROP COMPLEX' AND @BagTissue = N'PP' THEN N'B25'
	WHEN @BagType = N'B1358 PE 25 K Campbells' AND @BagTissue = N'PE' THEN N'B25'
	WHEN @BagType = N'B032 - PP 25 K YARA UNIKA KALI ' AND @BagTissue = N'PP' THEN N'B25'
	WHEN @BagType = N'B1363 PP 25K AMC' AND @BagTissue = N'PP' THEN N'B25'
	WHEN @BagType = N'B008 - 25kg PE NPCTA 50 B' AND @BagTissue = N'PE' THEN N'B25'
	WHEN @BagType = N'B1357 - PE 25K Campbells' AND @BagTissue = N'PE' THEN N'B25'
	WHEN @BagType = N'POLYAMIX GREY' AND @BagTissue = N'PE' THEN N'B25'
	WHEN @BagType = N'B1268 - SANGRAL GENERIC PP25K' AND @BagTissue = N'PP' THEN N'B25'
	WHEN @BagType = N'ZAKKENCENTRALE WPP/PE' AND @BagTissue = N'PP/PE' THEN N'B25'
	WHEN @BagType = N'ANOREL - Bladjes' AND @BagTissue = N'PE' THEN N'B25'
	WHEN @BagType = N'B075 - SQM HYDROPONICA' AND @BagTissue = N'PE' THEN N'B50'
	WHEN @BagType = N'B078 - SQM HORTICULTUR' AND @BagTissue = N'PP' THEN N'B50'
	WHEN @BagType = N'B486 - NEUTRAL' AND @BagTissue = N'PP/PE' THEN N'B50'
	WHEN @BagType = N'B703 - MIX AGROWMORE' AND @BagTissue = N'PP' THEN N'B50'
	WHEN @BagType = N'B734 - KRISTA K' AND @BagTissue = N'PE' THEN N'B50'
	WHEN @BagType = N'B1393 - YARA KRISTA K 1200KG' AND @BagTissue = N'PP' THEN N'BB'
	WHEN @BagType = N'B347 - NITRAM 600KG' AND @BagTissue = N'PP' THEN N'BB'
	WHEN @BagType = N'B036 - 4-LOOPS SQM' AND @BagTissue = N'PP' THEN N'BB'
	WHEN @BagType = N'B057 - 1-LOOP IMCO' AND @BagTissue = N'PP' THEN N'BB'
	WHEN @BagType = N'B1049 - 4-L BLANCO' AND @BagTissue = N'PP' THEN N'BB'
	WHEN @BagType = N'B1093 - 4-LOOPS BLANCO' AND @BagTissue = N'PP' THEN N'BB'
	WHEN @BagType = N'B1244 - 4-LOOPS SQM' AND @BagTissue = N'PP' THEN N'BB'
	WHEN @BagType = N'B1274 - 4-LOOPS BLANCO' AND @BagTissue = N'PP' THEN N'BB'
	WHEN @BagType = N'B1304 - 4-LOOPS SQM' AND @BagTissue = N'PP' THEN N'BB'
	WHEN @BagType = N'B573 - 4-LOOPS SQM' AND @BagTissue = N'PP' THEN N'BB'
	WHEN @BagType = N'B790 - 4-LOOPS BLANCO' AND @BagTissue = N'PP' THEN N'BB'
	WHEN @BagType = N'B849 - 4-LOOPS BLANCO' AND @BagTissue = N'PP' THEN N'BB'
	WHEN @BagType = N'B2000 - BB BLANK S' AND @BagTissue = N'PP' THEN N'BB'
	WHEN @BagType = N'B2001 - BB' AND @BagTissue = N'PP' THEN N'BB'
	WHEN @BagType = N'B3000 - UNDEFINED ' AND @BagTissue = N'PP' THEN N'BB'
	ELSE N'BB'
END

RETURN @BagUnit
END	
GO

--Create function - If sid is missing - add it, keeping the sorting by SID_ID asc. Else update its value if needed
PRINT 'Creating function [dbo].[FN_UPDATE_STOCK_KEY_WITH_BAG_UNIT]'
GO
CREATE FUNCTION [dbo].[FN_UPDATE_STOCK_KEY_WITH_BAG_UNIT]
(
	@oldKey nvarchar(MAX),
	@bagUnitSidId INT,
	@bagUnitValue NVARCHAR(500) -- new sid value
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
DECLARE @newKey NVARCHAR(MAX)

DECLARE @startTag nvarchar(50) = '"' + CONVERT(NVARCHAR(50), @bagUnitSidId) + '":"'
DECLARE @endTag nvarchar(50) = '"'
DECLARE @start INT = CHARINDEX(@startTag, @oldKey)

IF @start = 0
BEGIN
	--sid does not exist in the key. Add it and keep the sorting by sid id
	DECLARE @counterId INT = @bagUnitSidId - 1
	DECLARE @posToAdd INT = 0
	WHILE @counterId > 0
	BEGIN
		DECLARE @maina NVARCHAR(50) = '"' + CONVERT(NVARCHAR(50), @counterId) + '":"'
		 SET @posToAdd = CHARINDEX(@maina, @oldKey)
		 IF @posToAdd > 0
		 BEGIN
			SET @posToAdd = CHARINDEX(@endTag, @oldKey, @posToAdd + LEN(@maina) + 1) + 2
			BREAK
		 END
		 SET @counterId = @counterId - 1
	END
	
	--add the sid to the found position
	DECLARE @whatToAdd NVARCHAR(MAX) = '{"' + CONVERT(NVARCHAR(50), @bagUnitSidId) +'":"' + @bagUnitValue +'"}'
	IF @posToAdd = 0
	BEGIN
		SET @posToAdd = CHARINDEX('"S":[', @oldKey) + 5
		IF SUBSTRING (@oldKey, @posToAdd , 1) != ']'
		SET @whatToAdd = @whatToAdd + ','
	END
	ELSE
		SET @whatToAdd = ',' + @whatToAdd

	SET @newKey = STUFF(@oldKey, @posToAdd, 0 , @whatToAdd)
END
ELSE
BEGIN
	--sid exists in the key
	DECLARE @valueStart INT = @start + LEN(@startTag);
	DECLARE @valueEnd INT = CHARINDEX(@endTag, @oldKey, @valueStart);
	SET @newKey = STUFF(@oldKey, @valueStart, @valueEnd-@valueStart, @bagUnitValue);
END

RETURN @newKey
END
GO

-- Variables declaration
DECLARE @bagUnitSidId INT
DECLARE @bagTypeSidId INT
DECLARE @bagTissueSidId INT
DECLARE @bagUnitSidPRValueId INT
DECLARE @bagProductId INT
SET @bagUnitSidId = (SELECT [STORAGE_IDENTIFIER_ID] FROM [STORAGE_IDENTIFIER] WHERE [CODE] = 'BGU')
SET @bagTypeSidId = (SELECT [STORAGE_IDENTIFIER_ID] FROM [STORAGE_IDENTIFIER] WHERE [CODE] = 'BGTP')
SET @bagTissueSidId = (SELECT [STORAGE_IDENTIFIER_ID] FROM [STORAGE_IDENTIFIER] WHERE [CODE] = 'BGTS')
SET @bagProductId = (SELECT [PRODUCT_ID] from [PRODUCT] WHERE [CODE] = 'Bag')

DECLARE @p_sids_table TABLE
(
	[ROW_NUMBER] INT,
	[PRODUCT_STORAGE_IDENTIFIER_ID] INT,
	[PRODUCT_ID] INT
)
INSERT INTO @p_sids_table
SELECT ROW_NUMBER() OVER (ORDER BY [PRODUCT_STORAGE_IDENTIFIER_ID]), *
FROM
(SELECT [PRODUCT_STORAGE_IDENTIFIER_ID], [PRODUCT_ID] FROM [PRODUCT_STORAGE_IDENTIFIER] PSI
WHERE PSI.[SID_ID] = @bagUnitSidId) AS Ids
DECLARE @p_sid_id INT
DECLARE @totalrows INT = (SELECT COUNT(*) FROM @p_sids_table)
DECLARE @currentrow INT
DECLARE @stockChangeOperationId INT = (SELECT [OPERATION_TYPE_ID] FROM [OPERATION_TYPE] WHERE [DESCRIPTION] in ('StockChange'))

-- I. Insert new predefined value for SID "Bag Unit" 'BB'

PRINT 'I. Insert new predefined value for SID "Bag Unit" ''BB'''

IF NOT EXISTS(SELECT * FROM [STORAGE_IDENTIFIER_PR_VALUE] WHERE [PREDEFINED_VALUE] = 'BB' AND [SID_ID] = @bagUnitSidId)
BEGIN 
	PRINT 'Inserting ''BB'' predefined value for sid ''Bag Unit'''
    
	INSERT INTO [dbo].[STORAGE_IDENTIFIER_PR_VALUE]([SID_ID], [PREDEFINED_VALUE], [CREATE_USER], [CREATE_TIMESTAMP], [UPDATE_USER], [UPDATE_TIMESTAMP], [STATUS])
	VALUES(@bagUnitSidId, 'BB', 'script', GETDATE(), 'script', GETDATE(), 1)
	SET @bagUnitSidPRValueId = IDENT_CURRENT('[STORAGE_IDENTIFIER_PR_VALUE]')
END 
ELSE
BEGIN
	PRINT '''BB'' predefined value already exists for sid ''Bag Unit'''

	SET @bagUnitSidPRValueId = (SELECT [STORAGE_IDENTIFIER_PR_VALUE_ID] FROM [STORAGE_IDENTIFIER_PR_VALUE] WHERE [PREDEFINED_VALUE] = 'BB' AND [SID_ID] = 12)
END


-- II. Add 'BB' to product configuration of all product having SID "Bag Unit" into product config

PRINT 'II. Add ''BB'' to product configuration of all product having SID "Bag Unit" into product config'

SET @currentrow = 1

WHILE @currentrow <=  @totalrows
BEGIN 
		SET @p_sid_id = (SELECT [PRODUCT_STORAGE_IDENTIFIER_ID] FROM @p_sids_table WHERE [ROW_NUMBER] = @currentrow)

		IF NOT EXISTS (SELECT * FROM [PRODUCT_SID_SID_VALUE]
						WHERE [PRODUCT_SID_SID_VALUE].[PRODUCT_SID_ID] = @p_sid_id AND
						 [PRODUCT_SID_SID_VALUE].[PREDEFINED_SID_VALUE_ID] = @bagUnitSidPRValueId)
		BEGIN
			PRINT 'Adding ''BB'' predefined value to P_SID_ID ' + CONVERT(varchar(50), @p_sid_id)

			INSERT INTO [dbo].[PRODUCT_SID_SID_VALUE]([PREDEFINED_SID_VALUE_ID], [PRODUCT_SID_ID])
			SELECT @bagUnitSidPRValueId, @p_sid_id
		END

	SET @currentrow = @currentrow + 1
END

-- III. Update existing stocks_info_configs only for Product "Bag" with the new sid and update their keys

PRINT 'III. Update existing stocks_info_configs only for Product "Bag" with the new sid and update their keys'

DECLARE @sid_values_for_product_bag TABLE
(
	[STOCK_INFO_SID_ID] INT,
	[SID_ID] INT,
	[VALUE] NVARCHAR(500)
)
DECLARE @bagUnitValue NVARCHAR(500)
DECLARE @currenctStockInfoConfigId INT
DECLARE @currenctStockInfoConfigKey NVARCHAR(MAX)
DECLARE MyCursor CURSOR FOR  
SELECT [STOCK_INFO_CONFIG_ID], [_KEY_] FROM [STOCK_INFO_CONFIG]
WHERE [PRODUCT_ID] = @bagProductId

OPEN MyCursor
FETCH NEXT FROM MyCursor INTO @currenctStockInfoConfigId, @currenctStockInfoConfigKey
		
WHILE @@FETCH_STATUS = 0  
	BEGIN
		INSERT INTO @sid_values_for_product_bag
		SELECT [STOCK_INFO_SID_ID], [SID_ID], [VALUE] FROM [STOCK_INFO_SID]
		WHERE [STOCK_INFO_CONFIG_ID] = @currenctStockInfoConfigId

		--Determine the sid "Bag Unit" value and set it
		SET @bagUnitValue = [dbo].[FN_DETERMINE_BAG_UNIT]
		(
			(SELECT ISNULL([VALUE], '') FROM @sid_values_for_product_bag
			WHERE [SID_ID] = @bagTypeSidId),
			(SELECT ISNULL([VALUE], '') FROM @sid_values_for_product_bag
			WHERE [SID_ID] = @bagTissueSidId)
		)

		IF EXISTS (SELECT * FROM @sid_values_for_product_bag
		WHERE [SID_ID] = @bagUnitSidId)
		BEGIN
			-- Sid already exists. Update its value if it is empty.
			IF (SELECT [VALUE] FROM @sid_values_for_product_bag WHERE [SID_ID] = @bagUnitSidId) IS NULL
			BEGIN
				UPDATE [STOCK_INFO_SID]
				SET [VALUE] = @bagUnitValue
				WHERE [STOCK_INFO_SID_ID] = (SELECT [STOCK_INFO_SID_ID] FROM @sid_values_for_product_bag WHERE [SID_ID] = @bagUnitSidId)

				--Update the key only if needed
				UPDATE [STOCK_INFO_CONFIG]
				SET [_KEY_] = [dbo].[FN_UPDATE_STOCK_KEY_WITH_BAG_UNIT](@currenctStockInfoConfigKey, @bagUnitSidId, @bagUnitValue)
				WHERE [STOCK_INFO_CONFIG_ID] = @currenctStockInfoConfigId
			END
		END
		ELSE
		BEGIN
			-- Sid does not exist. Add it and set its value
			INSERT INTO [STOCK_INFO_SID]([SID_ID], [STOCK_INFO_CONFIG_ID], [VALUE], [CREATE_USER], [CREATE_TIMESTAMP], [UPDATE_USER], [UPDATE_TIMESTAMP])
			VALUES(@bagUnitSidId, @currenctStockInfoConfigId, @bagUnitValue, 'script', GETDATE(), 'script', GETDATE())

			--Update the key only if needed
			UPDATE [STOCK_INFO_CONFIG]
			SET [_KEY_] = [dbo].[FN_UPDATE_STOCK_KEY_WITH_BAG_UNIT](@currenctStockInfoConfigKey, @bagUnitSidId, @bagUnitValue)
			WHERE [STOCK_INFO_CONFIG_ID] = @currenctStockInfoConfigId
		END

		DELETE FROM @sid_values_for_product_bag --It serves as a context!!!
		FETCH NEXT FROM MyCursor INTO @currenctStockInfoConfigId, @currenctStockInfoConfigKey
	END
CLOSE MyCursor
DEALLOCATE MyCursor

-- IV. Update custom stock keys by copying the STOCK_INFO_CONFIG key into SKEY. Credits to BBORISOV

PRINT 'IV. Update custom stock keys'

UPDATE cs
SET cs.[_KEY_] = ('{"DC":' + ISNULL(CONVERT(NVARCHAR(10), cs.[DOCUMENT_CODE_ID]), 'null') + 
',"DN":"' + ISNULL(cs.[DOCUMENT_NUMBER], '') + 
'","DD":"' + ISNULL(CONVERT(NVARCHAR(8), cs.[DOCUMENT_DATE], 112), 'null') + 
'","CS":' + CONVERT(NVARCHAR(10), cs.[CUSTOMS_STATUS]) + 
',"SKEY":' + sic.[_KEY_] + '}')
FROM [CUSTOMS_STOCK] cs
INNER JOIN [STOCK_INFO] si on cs.[STOCK_INFO_ID] = si.[STOCK_INFO_ID]
INNER JOIN [STOCK_INFO_CONFIG] sic on si.[STOCK_INFO_CONFIG_ID] = sic.[STOCK_INFO_CONFIG_ID]
INNER JOIN [STOCK_INFO_SID] sis on sis.[STOCK_INFO_CONFIG_ID] = sic.[STOCK_INFO_CONFIG_ID]

-- V. Add the stock change operation to the SID if not added (because we manually removed it)

PRINT 'V. Add the stock change operation to the SID if not added'

SET @currentrow = 1
WHILE @currentrow <=  @totalrows
BEGIN 
		SET @p_sid_id = (SELECT [PRODUCT_STORAGE_IDENTIFIER_ID] FROM @p_sids_table WHERE [ROW_NUMBER] = @currentrow)

		IF (SELECT COUNT(*) FROM [PRODUCT_SID_OPERATION_TYPE]
		WHERE [PRODUCT_SID_ID] = @p_sid_id AND [OPERATION_TYPE_ID] = @stockChangeOperationId) = 0
		BEGIN
			PRINT 'Adding SCH operation to P_SID_ID ' + CONVERT(varchar(50), @p_sid_id) + ' (this should be the bag)'

			INSERT INTO [PRODUCT_SID_OPERATION_TYPE]([PRODUCT_SID_ID], [OPERATION_TYPE_ID])
			VALUES(@p_sid_id, @stockChangeOperationId)
		END

	SET @currentrow = @currentrow + 1
END

-- VI. Drop used resources

PRINT 'VI. Drop used resources'

IF EXISTS (SELECT * FROM sys.objects 
			WHERE object_id = OBJECT_ID(N'[dbo].[FN_DETERMINE_BAG_UNIT]') 
			AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	BEGIN
		PRINT 'Dropping function [dbo].[FN_DETERMINE_BAG_UNIT]'
		DROP FUNCTION [dbo].[FN_DETERMINE_BAG_UNIT] 
	END
GO

IF EXISTS (SELECT * FROM sys.objects 
			WHERE object_id = OBJECT_ID(N'[dbo].[FN_UPDATE_STOCK_KEY_WITH_BAG_UNIT]') 
			AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	BEGIN
		PRINT 'Dropping function [dbo].[FN_UPDATE_STOCK_KEY_WITH_BAG_UNIT]'
		DROP FUNCTION [dbo].[FN_UPDATE_STOCK_KEY_WITH_BAG_UNIT]
	END
GO

PRINT 'All done' 

PRINT '----------------------------'
PRINT '|     Rebuild indexes!     |'
PRINT '----------------------------'