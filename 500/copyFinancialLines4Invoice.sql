declare @user varchar(20) = 'la170707t1610'
declare @FinancialDocumentId int = 2295
declare @NewFinancialLineIds table (FINANCIAL_LINE_ID int, NEW_TARIFF_INFO_ID int);
declare @NewTariffRangeIds table (FINANCIAL_LINE_ID int, NEW_TARIFF_RANGE_ID int);

-- create copies of tariff info
MERGE
INTO    TARIFF_INFO
USING	(
	SELECT ti.*, cfl.FINANCIAL_LINE_ID
FROM TARIFF_INFO ti
	join FINANCIAL_LINE cfl on ti.TARIFF_INFO_ID = cfl.TARIFF_INFO_ID
	join FINANCIAL_LINE_LINE fll on cfl.FINANCIAL_LINE_ID = fll.CHILD_FINANCIAL_LINE_ID
	join FINANCIAL_LINE fl on fll.FINANCIAL_LINE_ID = fl.FINANCIAL_LINE_ID and fl.FINANCIAL_DOCUMENT_ID = @FinancialDocumentId 
) newTi
ON      (1 = 0)
WHEN NOT MATCHED THEN
INSERT  
		([CODE]
        ,[DESCRIPTION]
        ,[TARIFF]
        ,[UNIT_ID]
        ,[MEASUREMENT_UNIT_ID]
        ,[CURRENCY_ID]
        ,[CREATE_USER]
        ,[CREATE_TIMESTAMP]
        ,[UPDATE_USER]
        ,[UPDATE_TIMESTAMP]
        ,[SERVICE_ACCOUNT]
        ,[RANGE_CALCULATION]
        ,[MIN_AMOUNT]
        ,[MAX_AMOUNT]
        ,[ISSUER_ID]
        ,[TARIFF_TARGET])
VALUES  ([CODE]
        ,[DESCRIPTION]
        ,[TARIFF]
        ,[UNIT_ID]
        ,[MEASUREMENT_UNIT_ID]
        ,[CURRENCY_ID]
        ,@user
        ,getdate()
        ,@user
        ,getdate()
        ,[SERVICE_ACCOUNT]
        ,[RANGE_CALCULATION]
        ,[MIN_AMOUNT]
        ,[MAX_AMOUNT]
        ,[ISSUER_ID]
        ,[TARIFF_TARGET])
OUTPUT  newTi.FINANCIAL_LINE_ID, INSERTED.TARIFF_INFO_ID
INTO    @NewFinancialLineIds(FINANCIAL_LINE_ID, NEW_TARIFF_INFO_ID);

--create copies of tariff ranges
MERGE
INTO    TARIFF_RANGE
USING	(
	SELECT tr.*, fl.FINANCIAL_LINE_ID
FROM TARIFF_RANGE tr
	join FINANCIAL_LINE fl on tr.TARIFF_RANGE_ID = fl.TARIFF_RANGE_ID
	join @NewFinancialLineIds nfl on fl.FINANCIAL_LINE_ID = nfl.FINANCIAL_LINE_ID
) newTr
ON      (1 = 0)
WHEN NOT MATCHED THEN
INSERT
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
           ([TARIFF]
           ,[RANGE_FROM]
           ,[RANGE_TO]
           ,[UNIT_ID]
           ,[MEASUREMENT_UNIT_ID]
           ,@user
           ,getdate()
           ,@user
           ,getdate())
OUTPUT  newTr.FINANCIAL_LINE_ID, INSERTED.TARIFF_RANGE_ID
INTO    @NewTariffRangeIds(FINANCIAL_LINE_ID, NEW_TARIFF_RANGE_ID);

-- copy financial lines
INSERT INTO [dbo].[FINANCIAL_LINE]
        ([CREATION_TYPE]
        ,[DIRECTION]
        ,[DESCRIPTION]
        ,[VALUE_DATE]
        ,[QUANTITY]
        ,[UNIT_ID]
        ,[MEASUREMENT_UNIT_ID]
        ,[TARIFF_INFO_ID]
        ,[PARTNER_ID]
        ,[VAT_ID]
        ,[EXEMPT_ID]
        ,[CURRENCY_ID]
        ,[BASE_CURRENCY_ID]
        ,[TOTAL]
        ,[TOTAL_BASE_CURRENCY]
        ,[EXCHANGE_RATE]
        ,[FINANCIAL_DOCUMENT_ID]
        ,[CREATE_USER]
        ,[CREATE_TIMESTAMP]
        ,[UPDATE_USER]
        ,[UPDATE_TIMESTAMP]
        ,[COST_CENTER]
        ,[INTERNAL_COMPANY_ID])
    select
        [CREATION_TYPE]
        ,[DIRECTION]
        ,[DESCRIPTION]
        ,[VALUE_DATE]
        ,[QUANTITY]
        ,[UNIT_ID]
        ,[MEASUREMENT_UNIT_ID]
        ,[NEW_TARIFF_INFO_ID]
        ,[PARTNER_ID]
        ,[VAT_ID]
        ,[EXEMPT_ID]
        ,[CURRENCY_ID]
        ,[BASE_CURRENCY_ID]
        ,[TOTAL]
        ,[TOTAL_BASE_CURRENCY]
        ,[EXCHANGE_RATE]
        ,[FINANCIAL_DOCUMENT_ID]
        ,@user
        ,getdate()
        ,@user
        ,getdate()
        ,[COST_CENTER]
        ,[INTERNAL_COMPANY_ID]
	from FINANCIAL_LINE fl join @NewFinancialLineIds nfl on fl.FINANCIAL_LINE_ID = nfl.FINANCIAL_LINE_ID

update fl set TARIFF_RANGE_ID = tr.NEW_TARIFF_RANGE_ID from FINANCIAL_LINE fl,
	@NewFinancialLineIds nfl, @NewTariffRangeIds tr where nfl.FINANCIAL_LINE_ID = tr.FINANCIAL_LINE_ID and fl.TARIFF_INFO_ID = nfl.NEW_TARIFF_INFO_ID
	
--script has to add lines to entity - OI, Location, OR, Transport - this is not done yet.
