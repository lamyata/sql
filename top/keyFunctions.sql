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

		return STUFF(@key, @valueStart, @valueEnd-@valueStart-len(@endTag), @newValue);

    END

GO

CREATE FUNCTION [dbo].[SetSidKeyValue] (
	@key nvarchar(max),
	@sidId int,
	@newValue nvarchar(250)
)
RETURNS nvarchar(max)
AS
    BEGIN
		declare @sidStart int;
		declare @sidEnd int;
		declare @sidStartTag varchar(20);
		declare @sidEndTag varchar(10);

		set @sidStartTag = '{"' + CAST(@sidId as VARCHAR) + '":"';

		set @sidStart = CHARINDEX(@sidStartTag, @key);
		if @sidStart = 0 return @key;

		set @sidEndTag = '"},';
		set @sidEnd = CHARINDEX(@sidEndTag, @key, @sidStart);

		if @sidEnd = 0 -- sid is last in the _KEY_
		begin
			set @sidStartTag = ',{"' + CAST(@sidId as VARCHAR) + '":"';
			set @sidStart = CHARINDEX(@sidStartTag, @key);
			if @sidStart = 0 -- sid is also first in the _KEY_
			begin
				set @sidStartTag = '{"' + CAST(@sidId as VARCHAR) + '":"';
				set @sidStart = CHARINDEX(@sidStartTag, @key);
			end
			set @sidEndTag = '"}';
			set @sidEnd = CHARINDEX(@sidEndTag, @key, @sidStart);
		end

		return STUFF(@key, @sidStart, @sidEnd - @sidStart + LEN(@sidEndTag), @sidStartTag + @newValue + @sidEndTag);

    END

GO

BEGIN TRY
	BEGIN TRAN

declare @InboundSidCode nvarchar(11) = 'INBND';
declare @InboundSidId int;
select @InboundSidId = STORAGE_IDENTIFIER_ID from STORAGE_IDENTIFIER where CODE = @InboundSidCode;
declare @NewExternalId nvarchar(250) = '4500139184';
declare @OrderItemId int = 28950;

update sic set
	_KEY_ = dbo.[SetSidKeyValue](_KEY_, @InboundSidId, @NewExternalId),
	HASH_KEY = CAST(hashbytes('SHA1', dbo.[SetSidKeyValue](_KEY_, @InboundSidId, @NewExternalId)) AS BINARY(20)),
	UPDATE_TIMESTAMP = GETDATE(),
	UPDATE_USER = 'la161027'
	FROM STOCK_INFO_CONFIG sic WHERE ...
update STOCK_INFO_SID set
	[VALUE] = @NewExternalId,
	UPDATE_TIMESTAMP = GETDATE(),
	UPDATE_USER = 'la161027'
	WHERE ...

print 'Updating LOT of SICs';
update STOCK_INFO_CONFIG set
	_KEY_ = dbo.SetKeyValue (_KEY_, '"LOT":"', '"', LOT),
	HASH_KEY = CAST(hashbytes('SHA1', dbo.SetKeyValue (_KEY_, '"LOT":"', '"', LOT)) AS BINARY(20)),	
	UPDATE_TIMESTAMP = GETDATE(), UPDATE_USER = 'sys160530' 
	where INTERNAL_COMPANY_ID = @SGNIcId
	
		
	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK
		SELECT ERROR_NUMBER() as ErrorNumber, ERROR_MESSAGE() as ErrorMessage
END CATCH

DROP FUNCTION [dbo].[SetKeyValue]
DROP FUNCTION [dbo].[SetSidKeyValue]

GO
