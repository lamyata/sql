declare @updateUser varchar(15) = 'la180330';
declare @NipponProductGroupId int = (select PRODUCT_GROUP_ID from PRODUCT_GROUP where CODE = 'NIP');
declare @CheckStatusSidCode varchar(11) = 'PRDCHECK';
declare @CheckStatusPredefinedValues table (VAL varchar(1));
insert into @CheckStatusPredefinedValues values ('Y'), ('N');
declare @SidDefaultValue varchar(1) = 'N';
declare @StockSidDefaultValue varchar(1) = 'N';
declare @new_key nvarchar(MAX) = '';
declare @emptyString nvarchar = '';
declare @nullString nvarchar(4) = 'null';

IF EXISTS ( SELECT * FROM STORAGE_IDENTIFIER WHERE CODE = @CheckStatusSidCode )
	BEGIN
		IF EXISTS ( SELECT * FROM PRODUCT_STORAGE_IDENTIFIER psi JOIN STORAGE_IDENTIFIER si ON psi.SID_ID = si.STORAGE_IDENTIFIER_ID
			AND si.CODE = @CheckStatusSidCode)
		BEGIN
			PRINT 'PRDCHECK SID IS CONFIGURED WRONGLY, AND IS USED IN SOME PRODUCTS'
			RETURN
		END
		UPDATE STORAGE_IDENTIFIER SET
			PREDEFINED = 1,
			SHORT_DESC = 'Check Status',
			VALUE_TYPE = 'System.String[], mscorlib',
			UPDATE_TIMESTAMP = GETDATE(),
			UPDATE_USER = @updateUser
		WHERE CODE = @CheckStatusSidCode
	END
ELSE
	BEGIN
		print 'INSERT INTO [dbo].[STORAGE_IDENTIFIER] ...'
		INSERT INTO [dbo].[STORAGE_IDENTIFIER]
			   ([CODE],[SHORT_DESC],[PREDEFINED],[CREATE_USER],[CREATE_TIMESTAMP],[UPDATE_USER],[UPDATE_TIMESTAMP],[STATUS],[VALUE_TYPE])
		VALUES
			   (@CheckStatusSidCode ,'Check Status' ,1 ,@updateUser ,getdate() ,@updateUser ,getdate() ,1 ,'System.String[], mscorlib')
	END

declare @CheckStatusSidId int = ( select STORAGE_IDENTIFIER_ID from STORAGE_IDENTIFIER where CODE = @CheckStatusSidCode );

-- Insert predefined values
print 'INSERT INTO [dbo].[STORAGE_IDENTIFIER_PR_VALUE] ...'
INSERT INTO [dbo].[STORAGE_IDENTIFIER_PR_VALUE]
        ([SID_ID] ,[PREDEFINED_VALUE] ,[CREATE_USER] ,[CREATE_TIMESTAMP] ,[UPDATE_USER] ,[UPDATE_TIMESTAMP])
SELECT
        @CheckStatusSidId, VAL, @updateUser, getdate(), @updateUser, getdate()
FROM @CheckStatusPredefinedValues

declare @maxSequences table (ProdId int, Seq int)
insert into @maxSequences
	select psi.PRODUCT_ID, max(psi.SID_SEQUENCE)
	from PRODUCT_STORAGE_IDENTIFIER psi join PRODUCT_GROUP_PRODUCT pgp on psi.PRODUCT_ID = pgp.PRODUCT_ID and pgp.PRODUCT_GROUP_ID = @NipponProductGroupId
	group by psi.PRODUCT_ID 

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
           ,@CheckStatusSidId
		   ,@SidDefaultValue
           ,ms.Seq + 10
           ,0 -- IS_MANDATORY
           ,@updateUser
		   ,GETDATE()
		   ,@updateUser
		   ,GETDATE()
	FROM PRODUCT_GROUP_PRODUCT pgp, @maxSequences ms
	WHERE pgp.PRODUCT_GROUP_ID = @NipponProductGroupId
	AND ms.ProdId = pgp.PRODUCT_ID

INSERT INTO [dbo].[PRODUCT_SID_OPERATION_TYPE]
        ([PRODUCT_SID_ID]
        ,[OPERATION_TYPE_ID])
    SELECT
		psi.PRODUCT_STORAGE_IDENTIFIER_ID,
		ot.OPERATION_TYPE_ID
	FROM PRODUCT_STORAGE_IDENTIFIER psi, PRODUCT_GROUP_PRODUCT pgp, OPERATION_TYPE ot
	WHERE psi.PRODUCT_ID = pgp.PRODUCT_ID and pgp.PRODUCT_GROUP_ID = @NipponProductGroupId and psi.SID_ID = @CheckStatusSidId
		and ot.[DESCRIPTION] != 'Additional'		
		
insert into PRODUCT_SID_SID_VALUE (PRODUCT_SID_ID, PREDEFINED_SID_VALUE_ID)
	select psi.PRODUCT_STORAGE_IDENTIFIER_ID, sipv.STORAGE_IDENTIFIER_PR_VALUE_ID
	from PRODUCT_STORAGE_IDENTIFIER psi, STORAGE_IDENTIFIER_PR_VALUE sipv,
		PRODUCT_GROUP_PRODUCT pgp
	where psi.PRODUCT_ID = pgp.PRODUCT_ID
		and pgp.PRODUCT_GROUP_ID = @NipponProductGroupId
		and psi.SID_ID = @CheckStatusSidId
		and sipv.SID_ID = psi.SID_ID

INSERT INTO [dbo].[STOCK_INFO_SID]
        ([SID_ID]
        ,[STOCK_INFO_CONFIG_ID]
		,[VALUE]
        ,[CREATE_USER]
        ,[CREATE_TIMESTAMP]
        ,[UPDATE_USER]
        ,[UPDATE_TIMESTAMP])
     SELECT
		@CheckStatusSidId
		,sic.STOCK_INFO_CONFIG_ID
		,@StockSidDefaultValue
		,@updateUser
		,GETDATE()
		,@updateUser
		,GETDATE()
	FROM PRODUCT_STORAGE_IDENTIFIER psi, PRODUCT_GROUP_PRODUCT pgp, STOCK_INFO_CONFIG sic
	WHERE psi.PRODUCT_ID = pgp.PRODUCT_ID and pgp.PRODUCT_GROUP_ID = @NipponProductGroupId and psi.SID_ID = @CheckStatusSidId
		and psi.PRODUCT_ID = sic.PRODUCT_ID
		
exec [dbo].[TOGGLE_NONCLUSTERED_INDEXES_FOR_TABLE] 'STOCK_INFO_CONFIG', 0

-- Update SIC key + Hash
update sic
set @new_key = (
		'{"IC":' + ISNULL(CAST(sic.INTERNAL_COMPANY_ID as nvarchar), @nullString) + 
		',"O":'  + ISNULL(CAST(sic.OWNER_ID as nvarchar), @nullString) + 
		',"P":'  + ISNULL(CAST(sic.PRODUCT_ID as nvarchar), @nullString) +
		',"L":'  + ISNULL(CAST(sic.LOCATION_ID as nvarchar), @nullString) + 
		',"BU":'  + ISNULL(CAST(sic.BASE_UNIT_ID as nvarchar), @nullString) + 
		',"TN":"'  + ISNULL(sic.TRACKING_NUMBER, @emptyString)  + '"' +
		',"IN":"'  + ISNULL(sic.INVENTORY_NUMBER, @emptyString)  + '"' +
		',"LOT":"'  + ISNULL(sic.LOT, @emptyString)  + '"' +
		',"PD":'  + ISNULL(CONVERT(nvarchar, sic.PRODUCTION_DATE, 112), @nullString) + 
		',"ED":'  + ISNULL(CONVERT(nvarchar, sic.EXPIRY_DATE, 112), @nullString) + 
		',"DI":'  + ISNULL(CONVERT(nvarchar, sic.DATE_IN, 112), @nullString) + 
		',"ST":'  + CAST(sic.STATUS as nvarchar) +
		',"SU":'  + ISNULL(CAST(sic.STORAGE_UNIT_ID as nvarchar), @nullString) + 
		',"ITN":"'  + ISNULL(sic.ITEM_NUMBER, @emptyString)  + '"' +
		',"PU":"'  + ISNULL(sic.PACKAGING_UNIT, @emptyString)  + '"' +
		',"SHU":"'  + ISNULL(sic.PICKING_LIST, @emptyString)  + '"' +
		',"EU":['  + ISNULL([dbo].[JOIN_SIC_EXTRA_UNITS](sic.STOCK_INFO_CONFIG_ID), @emptyString) + ']' +  
		',"S":['  + ISNULL([dbo].[JOIN_SIC_SIDS](sic.STOCK_INFO_CONFIG_ID), @emptyString) + ']}'),
	sic._KEY_ = @new_key,
	sic.HASH_KEY = CAST(hashbytes('SHA1', @new_key) AS BINARY(20))
FROM STOCK_INFO_CONFIG sic, PRODUCT_GROUP_PRODUCT pgp
WHERE sic.PRODUCT_ID = pgp.PRODUCT_ID and pgp.PRODUCT_GROUP_ID = @NipponProductGroupId

exec [dbo].[TOGGLE_NONCLUSTERED_INDEXES_FOR_TABLE] 'STOCK_INFO_CONFIG', 1
-- after that rebuild stock and reservations indexes