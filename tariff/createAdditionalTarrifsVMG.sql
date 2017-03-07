BEGIN TRY
	BEGIN TRAN	
	
insert into [dbo].[UNIT]([DESCRIPTION],[STATUS],[FORMULA],[CODE],[CREATE_USER],[CREATE_TIMESTAMP],[UPDATE_USER],[UPDATE_TIMESTAMP])
	values ('Appearance',1,'','APRNCE','system', getdate(), 'system', getdate())	

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
	'Additional tariffs - ACV'
	,'ADD_TARIFFS_ACV'
	,0
	,COMPANYNR
	,NULL
	,'sys'
	,getdate()
	,'sys'
	,getdate()
FROM COMPANY c
WHERE c.CODE = 'IC_ACV'

exec CreateTariff
	@TariffInfoCode = 'AATRACV',
	@TariffInfoDescr = 'Administratie Truck Russia',
	@TariffInfoTariff = 25,
	@UnitCode = 'APRNCE',
	@MeasurementUnitDescription  = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'ATR',
	@OperationType = 'A',
	@CustomerCode = '491000',
	@ServiceAccount = '700310 ',
	@TariffFileReference = 'ADD_TARIFFS_ACV',
	@ProductCode = null,
	@TransportTypeCode = null,
	@Period = null, -- Mandatory if create WarehouseRentTariff
	@PeriodType = null, -- Mandatory if create WarehouseRentTariff; 0=Day, 1=Week, 2=Month 
	@FreePeriod = null, 
	@FreePeriodType = null -- 0=Day, 1=Week, 2=Month 	
	
exec CreateTariff
	@TariffInfoCode = 'ACFACV',
	@TariffInfoDescr = 'Custom Formalities',
	@TariffInfoTariff = 5,
	@UnitCode = 'APRNCE',
	@MeasurementUnitDescription  = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'CF',
	@OperationType = 'A',
	@CustomerCode = '491000',
	@ServiceAccount = '700310 ',
	@TariffFileReference = 'ADD_TARIFFS_ACV',
	@ProductCode = null,
	@TransportTypeCode = null,
	@Period = null, -- Mandatory if create WarehouseRentTariff
	@PeriodType = null, -- Mandatory if create WarehouseRentTariff; 0=Day, 1=Week, 2=Month 
	@FreePeriod = null, 
	@FreePeriodType = null -- 0=Day, 1=Week, 2=Month 	

exec CreateTariff
	@TariffInfoCode = 'ADOUACV',
	@TariffInfoDescr = 'Douane Opmaak Transit',
	@TariffInfoTariff = 50,
	@UnitCode = 'APRNCE',
	@MeasurementUnitDescription  = null,
	@CurrencyCode = 'EUR',
	@OperationCode = 'DOU',
	@OperationType = 'A',
	@CustomerCode = '491000',
	@ServiceAccount = '700310 ',
	@TariffFileReference = 'ADD_TARIFFS_ACV',
	@ProductCode = null,
	@TransportTypeCode = null,
	@Period = null, -- Mandatory if create WarehouseRentTariff
	@PeriodType = null, -- Mandatory if create WarehouseRentTariff; 0=Day, 1=Week, 2=Month 
	@FreePeriod = null, 
	@FreePeriodType = null -- 0=Day, 1=Week, 2=Month 

	--ROLLBACK
	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK
		SELECT ERROR_NUMBER() as ErrorNumber, ERROR_MESSAGE() as ErrorMessage
END CATCH