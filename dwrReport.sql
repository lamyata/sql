-- add context if it does not exist
exec ('
if not exists (select * from DW_REPORT_CONTEXT where CONTEXT = ''OrderConfirmation'')
	insert into DW_REPORT_CONTEXT (REPORT_CONTEXT_ID, CONTEXT)
		select max(REPORT_CONTEXT_ID) + 1, ''OrderConfirmation''
		from DW_REPORT_CONTEXT
')

EXEC('
	EXECUTE [dbo].[REGISTER_REPORT] ''Confirmation'', ''ACV Confirmation'', ''Confirmation.cs'', ''OrderConfirmation''
	UPDATE DW_REPORT SET ORIGINAL_FILE = 2 WHERE REPORT_KEY = ''Confirmation'' -- excel
')