IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'CreateCRIWarehouseRentTariff')
	DROP PROCEDURE CreateCRIWarehouseRentTariff
go

create proc CreateCRIWarehouseRentTariff
       @tariffFileReference nvarchar(250),
	   @icCompanyCode nvarchar(50),
       @tariffInfoCode nvarchar(250),
       @tariffInfoDesc nvarchar(250),
       @tariffInfoTariff decimal(18,3),
	   @tariffInfoUnitCode nvarchar(250),
	   @tariffInfoMeasurementUnitDesc nvarchar(250),
	   @tariffCustomerCode nvarchar(250),
       @siStorageUnitCode nvarchar(250),
	   @ownerCode nvarchar(250),
       @currencyCode nvarchar(250),
       @tariffPeriodType int, -- 0 day, 1 week, 2 month
       @locationAddress nvarchar(250),
	   @serviceAccount nvarchar(250)
as
begin

set nocount on

DECLARE @tariffFileId int
DECLARE @tariffInfoId int
DECLARE @tariffId int
DECLARE @stockInfoConfigId int
DECLARE @stockInfoId int

SELECT @tariffFileId = TARIFF_FILE_ID 
	FROM TARIFF_FILE tf, COMPANY c
	WHERE tf.REFERENCE = @tariffFileReference
		AND tf.INTERNAL_COMPANY_ID = c.COMPANYNR
		AND c.CODE = @icCompanyCode

-- Insert new TariffInfo
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
	@tariffInfoCode
	,@tariffInfoDesc
	,@tariffInfoTariff
	,u.UNIT_ID
	,mu.MEASUREMENT_UNIT_ID
	,c.CURRENCY_ID
	,@serviceAccount
	,'sys'
	,getdate()
	,'sys'
	,getdate()
FROM
	UNIT u, CURRENCY c, MEASUREMENT_UNIT mu
WHERE
	u.CODE = @tariffInfoUnitCode AND c.CODE = @currencyCode AND mu.[DESCRIPTION] = @tariffInfoMeasurementUnitDesc

set @tariffInfoId = SCOPE_IDENTITY()

-- Insert TARIFF
INSERT INTO [dbo].[TARIFF]
	([TARIFF_FILE_ID]
	,[TARIFF_INFO_ID]
	,[STATUS]
	,[PERIOD_FROM]
	,[PERIOD_TO]
	,[CREATE_USER]
	,[CREATE_TIMESTAMP]
	,[UPDATE_USER]
	,[UPDATE_TIMESTAMP])
SELECT
	@tariffFileId
	,@tariffInfoId
	,0
	,'1-JAN-2016' -- PERIOD_FROM
	,'1-JAN-2022' -- PERIOD_TO
	,'sys'
	,getdate()
	,'sys'
	,getdate()

set @tariffId = SCOPE_IDENTITY()

IF @tariffCustomerCode IS NOT NULL
BEGIN
	INSERT INTO TARIFF_CUSTOMER
				(TARIFF_ID
				,COMPANY_ID)
	SELECT
				@tariffId
				,c.COMPANYNR
	FROM COMPANY c
	WHERE c.CODE = @tariffCustomerCode
					
END

-- Insert STOCK_INFO_CONFIG
INSERT INTO [dbo].[STOCK_INFO_CONFIG]
                    ([LOCATION_ID]
					,[OWNER_ID]
					,[STORAGE_UNIT_ID]
                    ,[STATUS]
                    ,[CREATE_USER]
                    ,[CREATE_TIMESTAMP]
                    ,[UPDATE_USER]
                    ,[UPDATE_TIMESTAMP])
        SELECT
                    (select l.LOCATION_ID from LOCATION l where l.ADDRESS = @locationAddress)
					,(select c.COMPANYNR from COMPANY c where c.CODE = @ownerCode)
					,(select u.UNIT_ID from UNIT u where u.CODE = @siStorageUnitCode)
                    ,0
                    ,'sys'
                ,getdate()
                ,'sys'
                ,getdate()
       
set @stockInfoConfigId = SCOPE_IDENTITY()

    PRINT N'StockInfoConfigId: ' + CAST(@stockInfoConfigId as varchar(50))

-- Insert STOCK_INFO
INSERT INTO [dbo].[STOCK_INFO]
                ([STOCK_INFO_CONFIG_ID]
                ,[CREATE_USER]
                ,[CREATE_TIMESTAMP]
                ,[UPDATE_USER]
                ,[UPDATE_TIMESTAMP])
        SELECT
                @stockInfoConfigId
                ,'sys'
                ,getdate()
                ,'sys'
                ,getdate()

set @stockInfoId = SCOPE_IDENTITY()

    PRINT N'StockInfoId: ' + CAST(@stockInfoId as varchar(50))

-- Insert WAREHOUSE_RENT_TARIFF
INSERT INTO [dbo].[WAREHOUSE_RENT_TARIFF]
                    ([WAREHOUSE_RENT_TARIFF_ID]
                    ,[STOCK_INFO_ID]
                    ,[PERIOD_TYPE]
                    ,[CREATE_USER]
                    ,[CREATE_TIMESTAMP]
                    ,[UPDATE_USER]
                    ,[UPDATE_TIMESTAMP]
                    ,[FREE_PERIOD_TYPE])
        SELECT
                    @tariffId
                    ,@stockInfoId
                    ,@tariffPeriodType
                    ,'sys'
                    ,getdate()
                    ,'sys'
                    ,getdate()
                    ,0

set nocount off

end
go

exec CreateCRIWarehouseRentTariff
       @tariffFileReference = 'Default_BulkWarehouseRent',
	   @icCompanyCode = 'IC_AXL',
       @tariffInfoCode = 'MAG55',
       @tariffInfoDesc = 'Weekly Warehouse rent',
       @tariffInfoTariff = .5,
	   @tariffInfoUnitCode = 'Net',
	   @tariffInfoMeasurementUnitDesc = 't',
	   @tariffCustomerCode = 'Rosier SA',
       @siStorageUnitCode = null,
	   @ownerCode = 'Rosier SA',
       @currencyCode = 'EUR',
       @tariffPeriodType = 1,
       @locationAddress = null,
	   @serviceAccount = '700050'
	   
exec CreateCRIWarehouseRentTariff
       @tariffFileReference = 'Default_BulkWarehouseRent',
	   @icCompanyCode = 'IC_AXL',
       @tariffInfoCode = 'MAG56',
       @tariffInfoDesc = 'Weekly Warehouse rent',
       @tariffInfoTariff = .5,
	   @tariffInfoUnitCode = 'Net',
	   @tariffInfoMeasurementUnitDesc = 't',
	   @tariffCustomerCode = 'Rosier NL',
       @siStorageUnitCode = null,
	   @ownerCode = 'Rosier NL',
       @currencyCode = 'EUR',
       @tariffPeriodType = 1,
       @locationAddress = null,
	   @serviceAccount = '700050'	   


DROP PROCEDURE CreateCRIWarehouseRentTariff
