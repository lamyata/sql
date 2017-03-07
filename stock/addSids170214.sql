-- add sids
declare @user nvarchar(15) = 'sys170215';
declare @icCmpCode varchar(10) = 'IC_SGN';

insert into PRODUCT_STORAGE_IDENTIFIER (PRODUCT_ID, SID_ID, SID_SEQUENCE, IS_MANDATORY, CREATE_USER, CREATE_TIMESTAMP, UPDATE_USER, UPDATE_TIMESTAMP)
	select pic.PRODUCT_ID, si.STORAGE_IDENTIFIER_ID, 100, 0, @user, GETDATE(), @user, GETDATE() 
	from PRODUCT_INT_COMPANY pic, COMPANY c, STORAGE_IDENTIFIER si
	where pic.INTERNAL_COMPANY_ID = c.COMPANY_ID and c.CODE = @icCmpCode and si.CODE in ('CTRNO', 'DNR')

insert into PRODUCT_STORAGE_IDENTIFIER (PRODUCT_ID, SID_ID, SID_SEQUENCE, IS_MANDATORY, CREATE_USER, CREATE_TIMESTAMP, UPDATE_USER, UPDATE_TIMESTAMP)
	select pic.PRODUCT_ID, si.STORAGE_IDENTIFIER_ID, 110, 0, @user, GETDATE(), @user, GETDATE() 
	from PRODUCT_INT_COMPANY pic, COMPANY c, STORAGE_IDENTIFIER si
	where pic.INTERNAL_COMPANY_ID = c.COMPANY_ID and c.CODE = @icCmpCode and si.CODE in ('CTRNO', 'DNR')	
	
INSERT INTO [dbo].[PRODUCT_SID_OPERATION_TYPE]
		([PRODUCT_SID_ID]
		,[OPERATION_TYPE_ID])
	SELECT
		psi.PRODUCT_STORAGE_IDENTIFIER_ID,
		ot.OPERATION_TYPE_ID
	FROM PRODUCT_STORAGE_IDENTIFIER psi, PRODUCT_INT_COMPANY pic, COMPANY c, STORAGE_IDENTIFIER si, OPERATION_TYPE ot
	WHERE psi.PRODUCT_ID = pic.PRODUCT_ID and pic.INTERNAL_COMPANY_ID = c.COMPANY_ID and c.CODE = @icCmpCode
		and psi.SID_ID=si.STORAGE_IDENTIFIER_ID and si.CODE in ('CTRNO', 'DNR')
		and ot.[DESCRIPTION] != 'Additional'

insert into STOCK_INFO_SID (SID_ID, STOCK_INFO_CONFIG_ID, VALUE, CREATE_USER, CREATE_TIMESTAMP, UPDATE_USER, UPDATE_TIMESTAMP)
	select psi.SID_ID, sic.STOCK_INFO_CONFIG_ID, null, @user, GETDATE(), @user, GETDATE()
	from STORAGE_IDENTIFIER si, PRODUCT_STORAGE_IDENTIFIER psi, STOCK_INFO_CONFIG sic, PRODUCT_INT_COMPANY pic, COMPANY c
	where pic.PRODUCT_ID = psi.PRODUCT_ID and psi.SID_ID = si.STORAGE_IDENTIFIER_ID and si.CODE in ('CTRNO', 'DNR')
		and pic.PRODUCT_ID = sic.PRODUCT_ID and pic.INTERNAL_COMPANY_ID = c.COMPANY_ID and c.CODE = @icCmpCode