declare @StorageIdentifierId int
select @StorageIdentifierId = STORAGE_IDENTIFIER_ID from STORAGE_IDENTIFIER where CODE = 'CUST'
update STORAGE_IDENTIFIER set SHORT_DESC = 'Customs Status' where STORAGE_IDENTIFIER_ID=@StorageIdentifierId

declare @ProductGroupId int
select @ProductGroupId = PRODUCT_GROUP_ID from PRODUCT_GROUP where CODE = 'CRI'

INSERT INTO STORAGE_IDENTIFIER_PR_VALUE ([SID_ID], [PREDEFINED_VALUE], [STATUS], [CREATE_USER],[CREATE_TIMESTAMP],[UPDATE_USER],[UPDATE_TIMESTAMP])
	SELECT si.STORAGE_IDENTIFIER_ID, 'Bonded', 1, 'sys', GETDATE(), 'sys', GETDATE() FROM STORAGE_IDENTIFIER si WHERE si.CODE = 'CUST'
INSERT INTO STORAGE_IDENTIFIER_PR_VALUE ([SID_ID], [PREDEFINED_VALUE], [STATUS], [CREATE_USER],[CREATE_TIMESTAMP],[UPDATE_USER],[UPDATE_TIMESTAMP])
	SELECT si.STORAGE_IDENTIFIER_ID, 'Transit', 1, 'sys', GETDATE(), 'sys', GETDATE() FROM STORAGE_IDENTIFIER si WHERE si.CODE = 'CUST'

INSERT INTO [dbo].[PRODUCT_STORAGE_IDENTIFIER]
		([PRODUCT_ID]
		,[SID_ID]
		,[SID_DEFAULT]
		,[SID_SEQUENCE]
		,[IS_MANDATORY]
		,[CREATE_USER]
		,[CREATE_TIMESTAMP]
		,[UPDATE_USER]
		,[UPDATE_TIMESTAMP])
	SELECT
		 PRODUCT_ID
		,@StorageIdentifierId
		,'Free'
		,50
		,0
		,'sys'
		,getdate()
		,'sys'
		,getdate()
FROM PRODUCT p
WHERE p.PRODUCT_GROUP_ID = @ProductGroupId
	
INSERT INTO [dbo].[PRODUCT_SID_SID_VALUE]
		 ([PRODUCT_SID_ID]
		 ,[PREDEFINED_SID_VALUE_ID])
 select
		 PRODUCT_STORAGE_IDENTIFIER_ID
		 ,STORAGE_IDENTIFIER_PR_VALUE_ID
 from PRODUCT_STORAGE_IDENTIFIER psi, PRODUCT p, STORAGE_IDENTIFIER_PR_VALUE sipv
 where psi.PRODUCT_ID = p.PRODUCT_ID and p.PRODUCT_GROUP_ID = @ProductGroupId and psi.SID_ID = @StorageIdentifierId	
	and sipv.SID_ID = @StorageIdentifierId and sipv.PREDEFINED_VALUE in ('Free', 'Bonded', 'Transit')

INSERT INTO [dbo].[PRODUCT_SID_OPERATION_TYPE]
		([PRODUCT_SID_ID]
		,[OPERATION_TYPE_ID])
	SELECT
		PRODUCT_STORAGE_IDENTIFIER_ID
		,OPERATION_TYPE_ID
	FROM PRODUCT_STORAGE_IDENTIFIER psi, PRODUCT p, OPERATION_TYPE ot
	WHERE psi.PRODUCT_ID = p.PRODUCT_ID and p.PRODUCT_GROUP_ID = @ProductGroupId and psi.SID_ID = @StorageIdentifierId
		and ot.[DESCRIPTION] != 'Additional'

INSERT INTO [dbo].[STOCK_INFO_SID]
		([SID_ID]
		,[STOCK_INFO_CONFIG_ID]
		,[VALUE]
		,[CREATE_USER]
		,[CREATE_TIMESTAMP]
		,[UPDATE_USER]
		,[UPDATE_TIMESTAMP])
 SELECT
		@StorageIdentifierId
		,sic.STOCK_INFO_CONFIG_ID
		,'Free'
		,'sys'
		,getdate()
		,'sys'
		,getdate()
FROM STOCK_INFO_CONFIG sic, PRODUCT p
WHERE sic.PRODUCT_ID = p.PRODUCT_ID and p.PRODUCT_GROUP_ID = @ProductGroupId