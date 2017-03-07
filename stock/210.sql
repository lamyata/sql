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

CREATE FUNCTION [dbo].[RemoveSidFromKey] (
	@key nvarchar(max),
	@sidId int
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

		return STUFF(@key, @sidStart, @sidEnd - @sidStart + LEN(@sidEndTag), '');

    END

GO

CREATE PROC UpdateSid
	@SidId int
AS
BEGIN

	print 'Fixing _KEY_ for sid id ' + CAST(@SidId as varchar(20))
	
	set nocount on
	
	update STOCK_INFO_CONFIG
		set _KEY_ = dbo.RemoveSidFromKey(_KEY_, @SidId),
		UPDATE_TIMESTAMP = GETDATE(),
		UPDATE_USER = 'sys-updsid'
		FROM STOCK_INFO_CONFIG
		
	delete psot from [dbo].[PRODUCT_SID_OPERATION_TYPE] psot, PRODUCT_STORAGE_IDENTIFIER psi
		where psot.PRODUCT_SID_ID = psi.PRODUCT_STORAGE_IDENTIFIER_ID and  psi.SID_ID = @SidId

	delete from PRODUCT_STORAGE_IDENTIFIER where SID_ID = @SidId

	delete from STOCK_INFO_SID where SID_ID = @SidId
	
	set nocount off

END

go

BEGIN TRY
	BEGIN TRAN

declare @LotSidCode nvarchar(11) = 'LONBR';
declare @ProductionDateSidCode nvarchar(11) = 'PRDDT';
declare @ExpiryDateSidCode nvarchar(11) = 'EXPDT';

declare @LotSidId int;
declare @PdSidId int;
declare @EdSidId int;

select @LotSidId = STORAGE_IDENTIFIER_ID from STORAGE_IDENTIFIER where CODE = @LotSidCode;
select @PdSidId = STORAGE_IDENTIFIER_ID from STORAGE_IDENTIFIER where CODE = @ProductionDateSidCode;
select @EdSidId = STORAGE_IDENTIFIER_ID from STORAGE_IDENTIFIER where CODE = @ExpiryDateSidCode;

update sic set
	LOT = sis.[VALUE],
	UPDATE_TIMESTAMP = GETDATE(),
	UPDATE_USER = 'sys160602a'
from STOCK_INFO_CONFIG sic
	join STOCK_INFO_SID sis on sic.STOCK_INFO_CONFIG_ID = sis.STOCK_INFO_CONFIG_ID
		and sis.SID_ID = @LotSidId	
		
update sic set
	PRODUCTION_DATE = CAST([VALUE] as datetime),
	UPDATE_TIMESTAMP = GETDATE(),
	UPDATE_USER = 'sys160602b'
from STOCK_INFO_CONFIG sic 
	join STOCK_INFO_SID sis on sic.STOCK_INFO_CONFIG_ID = sis.STOCK_INFO_CONFIG_ID
		and sis.SID_ID = @PdSidId and TRY_PARSE([VALUE] as datetime) is not null
		
update sic set
	[EXPIRY_DATE] = EOMONTH (PARSE (REPLACE([VALUE], '2016', '') AS DATETIME)),
	UPDATE_TIMESTAMP = GETDATE(),
	UPDATE_USER = 'sys160602c'
from STOCK_INFO_CONFIG sic 
	join STOCK_INFO_SID sis on sic.STOCK_INFO_CONFIG_ID = sis.STOCK_INFO_CONFIG_ID
		and sis.SID_ID = @EdSidId and TRY_PARSE(REPLACE([VALUE], '2016', '') AS DATETIME) is not null	
		
-- update SIC keys
print 'Updating LOT of SICs';
update STOCK_INFO_CONFIG
	set _KEY_ = dbo.SetKeyValue (_KEY_, '"LOT":"', '"', LOT),
	UPDATE_TIMESTAMP = GETDATE(), UPDATE_USER = 'sys160602d' 
	where LOT is not null
	
print 'Updating PD of SICs';
update STOCK_INFO_CONFIG set
	_KEY_ = dbo.SetKeyValue (_KEY_, '"PD":', ',"ED":', CONVERT(NVARCHAR(8), PRODUCTION_DATE, 112)),
	UPDATE_TIMESTAMP = GETDATE(),
	UPDATE_USER = 'sys160602e'
where PRODUCTION_DATE is not null
	
print 'Updating ED of SICs';
update STOCK_INFO_CONFIG
	set _KEY_ = dbo.SetKeyValue (_KEY_, '"ED":', ',"DI":', CONVERT(NVARCHAR(8), [EXPIRY_DATE], 112)),
	UPDATE_TIMESTAMP = GETDATE(),
	UPDATE_USER = 'sys160602f' 
where EXPIRY_DATE is not null

exec UpdateSid @LotSidId;
exec UpdateSid @PdSidId;
exec UpdateSid @EdSidId;

delete from STORAGE_IDENTIFIER where STORAGE_IDENTIFIER_ID in (@LotSidId, @PdSidId, @EdSidId);

	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK
		SELECT ERROR_NUMBER() as ErrorNumber, ERROR_MESSAGE() as ErrorMessage
END CATCH

DROP PROC UpdateSid
DROP FUNCTION [dbo].[SetKeyValue];
DROP FUNCTION [dbo].[RemoveSidFromKey];

GO
