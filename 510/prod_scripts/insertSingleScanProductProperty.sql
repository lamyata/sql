declare @ProductPropertyId int
INSERT INTO [dbo].[NS_PRODUCT_PROPERTY]
           ([CODE]
           ,[DESCRIPTION]
           ,[TYPE]
           ,[CREATE_USER]
           ,[CREATE_TIMESTAMP]
           ,[UPDATE_USER]
           ,[UPDATE_TIMESTAMP]
           ,[STATUS])
     VALUES
           ('ISS'
           ,'Inbound Single Scan'
           ,2
           ,'system'
           ,getdate()
           ,'system'
           ,getdate()
           ,1)
select @ProductPropertyId = SCOPE_IDENTITY()
INSERT INTO [dbo].[NS_PREDEFINED_PP_VALUE]
           ([PRODUCT_PROPERTY_ID]
           ,[PREDEFINED_VALUE]
           ,[CREATE_USER]
           ,[CREATE_TIMESTAMP]
           ,[UPDATE_USER]
           ,[UPDATE_TIMESTAMAP])
     VALUES
           (@ProductPropertyId
           ,'BaseQuantity'
           ,'system'
           ,getdate()
           ,'system'
           ,getdate())
INSERT INTO [dbo].[NS_PREDEFINED_PP_VALUE]
           ([PRODUCT_PROPERTY_ID]
           ,[PREDEFINED_VALUE]
           ,[CREATE_USER]
           ,[CREATE_TIMESTAMP]
           ,[UPDATE_USER]
           ,[UPDATE_TIMESTAMAP])
     VALUES
           (@ProductPropertyId
           ,'StorageQuantity'
           ,'system'
           ,getdate()
           ,'system'
           ,getdate())
INSERT INTO [dbo].[NS_PREDEFINED_PP_VALUE]
           ([PRODUCT_PROPERTY_ID]
           ,[PREDEFINED_VALUE]
           ,[CREATE_USER]
           ,[CREATE_TIMESTAMP]
           ,[UPDATE_USER]
           ,[UPDATE_TIMESTAMAP])
     VALUES
           (@ProductPropertyId
           ,'TotalQuantityPerTransport'
           ,'system'
           ,getdate()
           ,'system'
           ,getdate())

declare @SerialNrCodePyBarcodeTypeId int
declare @CodeBarcodeTypeId int
select @SerialNrCodePyBarcodeTypeId = BARCODE_TYPE_ID from WMS_BARCODE_TYPE where [DESCRIPTION] = 'SerialNr_Code_PY'
select @CodeBarcodeTypeId = BARCODE_TYPE_ID from WMS_BARCODE_TYPE where [DESCRIPTION] = 'Code'

INSERT INTO [dbo].[NS_PRODUCT_PP]
           ([PRODUCT_ID]
           ,[PRODUCT_PROPERTY_ID]
           ,[PROPERTY_VALUE]
           ,[CREATE_USER]
           ,[CREATE_TIMESTAMP]
           ,[UPDATE_USER]
           ,[UPDATE_TIMESTAMP])
     select
            PRODUCT_ID
           ,@ProductPropertyId
           ,'TotalQuantityPerTransport'
           ,'system'
           ,getdate()
           ,'system'
           ,getdate()
	from WMS_PRODUCT
	where WMS_PRODUCT.BARCODE_TYPE_ID = @SerialNrCodePyBarcodeTypeId
INSERT INTO [dbo].[NS_PRODUCT_PP]
           ([PRODUCT_ID]
           ,[PRODUCT_PROPERTY_ID]
           ,[PROPERTY_VALUE]
           ,[CREATE_USER]
           ,[CREATE_TIMESTAMP]
           ,[UPDATE_USER]
           ,[UPDATE_TIMESTAMP])
     select
            PRODUCT_ID
           ,@ProductPropertyId
           ,'StorageQuantity'
           ,'system'
           ,getdate()
           ,'system'
           ,getdate()
	from WMS_PRODUCT
	where WMS_PRODUCT.BARCODE_TYPE_ID = @CodeBarcodeTypeId

GO