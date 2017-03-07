declare @CompanyPropertyId int
INSERT INTO [dbo].[COMPANY_PROPERTY]
		([CODE]
		,[DESCRIPTION]
		,[STATUS]
		,[CREATE_USER]
		,[CREATE_TIMESTAMP]
		,[UPDATE_USER]
		,[UPDATE_TIMESTAMP]
		,[VALUE_TYPE]
		,[GLOBAL])
	VALUES
		('BANKS' --CODE
		,'Banks' --DESCRIPTION
		,1 --STATUS
		,'system'
		,getdate()
		,'system'
		,getdate()
		,'System.String, mscorlib' --VALUE_TYPE
		,0 --GLOBAL;
select @CompanyPropertyId = SCOPE_IDENTITY();
INSERT INTO [dbo].[COMPANY_PROPERTY_DF]
		([COMPANY_TYPE_ID]
		,[COMPANY_PROPERTY_ID]
		,[DEFAULT_VALUE]
		,[REQUIRED]
		,[SEQUENCE]
		,[CREATE_USER]
		,[CREATE_TIMESTAMP]
		,[UPDATE_USER]
		,[UPDATE_TIMESTAMP])
	VALUES
		('General' --COMPANY_TYPE_ID
		,@CompanyPropertyId --COMPANY_PROPERTY_ID
		,null --DEFAULT_VALUE
		,0 --REQUIRED
		,10 --SEQUENCE
		,'system'
		,getdate()
		,'system'
		,getdate())				 
INSERT INTO [dbo].[COMPANY_PROPERTY_VALUE]
		([VALUE]
		,[COMPANYNR]
		,[COMPANY_PROPERTY_ID]
		,[CREATE_USER]
		,[CREATE_TIMESTAMP]
		,[UPDATE_USER]
		,[UPDATE_TIMESTAMP]
		,[STATUS])
	SELECT
		'KBC,BE72 7330 4263 9816,KREDBEBB;ING,BE34 3100 0847 8290, BBRUBEBB'
		,<COMPANYNR, int,>
		,@CompanyPropertyId
		,'system'
		,getdate()
		,'system'
		,getdate()
		,1 --STATUS
	FROM
		COMPANY C
	WHERE
		C.CODE like '491000'
INSERT INTO [dbo].[COMPANY_PROPERTY_VALUE]
		([VALUE]
		,[COMPANYNR]
		,[COMPANY_PROPERTY_ID]
		,[CREATE_USER]
		,[CREATE_TIMESTAMP]
		,[UPDATE_USER]
		,[UPDATE_TIMESTAMP]
		,[STATUS])
	SELECT
		'KBC,BE72 7330 4263 9816,KREDBEBB;ING,BE34 3100 0847 8290, BBRUBEBB'
		,<COMPANYNR, int,>
		,@CompanyPropertyId
		,'system'
		,getdate()
		,'system'
		,getdate()
		,1 --STATUS
	FROM
		COMPANY C
	WHERE
		C.CODE like '493200'			
GO;
