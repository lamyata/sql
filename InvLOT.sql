CREATE FUNCTION [dbo].[SetKeyValue] (
	@key nvarchar(max),
	@startTag nvarchar(50),
	@endTag nvarchar(50),
	@newValue nvarchar(250)
)
RETURNS nvarchar(max)
AS
    BEGIN
		declare @start int;
		declare @valueStart int;
		declare @valueEnd int;

		set @start = CHARINDEX(@startTag, @key);
		if @start = 0 return @key;

		set @valueStart = @start + LEN(@startTag);
		set @valueEnd = CHARINDEX(@endTag, @key, @valueStart);

		return STUFF(@key, @valueStart, @valueEnd-@valueStart, @newValue);

    END

GO

BEGIN TRY
	BEGIN TRAN

declare @SGNIcCode  nvarchar(50) = 'IC_SGN';
declare @SGNIcId int;
select @SGNIcId = COMPANYNR from COMPANY where CODE = @SGNIcCode;

update sic set
	LOT = sic2.INVENTORY_NUMBER,
	INVENTORY_NUMBER = null,
	_KEY_ = dbo.SetKeyValue ( dbo.SetKeyValue (sic2._KEY_, '"LOT":"', '"', sic2.INVENTORY_NUMBER), '"IN":"', '"', ''),
	UPDATE_TIMESTAMP = GETDATE(),
	UPDATE_USER = 'sys160622'
from STOCK_INFO_CONFIG sic join STOCK_INFO_CONFIG sic2 on sic.STOCK_INFO_CONFIG_ID = sic2.STOCK_INFO_CONFIG_ID
	and sic.INTERNAL_COMPANY_ID = @SGNIcId
	
	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK
		SELECT ERROR_NUMBER() as ErrorNumber, ERROR_MESSAGE() as ErrorMessage
END CATCH

DROP FUNCTION [dbo].[SetKeyValue];

GO