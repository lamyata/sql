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

CREATE FUNCTION [dbo].[SetKeySidValue] (
	@key nvarchar(max),
	@sidId int,
	@newValue nvarchar(250)	
)
RETURNS nvarchar(max)
AS
    BEGIN
		declare @sidStart int;
		declare @sidStartTag varchar(20);
		declare @sidEndTag varchar(10);
		
		declare @valueStart int;
		declare @valueEnd int;

		set @sidStartTag = '{"' + CAST(@sidId as VARCHAR) + '":"';

		set @sidStart = CHARINDEX(@sidStartTag, @key);
		if @sidStart = 0 return @key;

		set @valueStart = @sidStart + LEN(@sidStartTag);
		
		set @sidEndTag = '"}';
		set @valueEnd = CHARINDEX(@sidEndTag, @key, @sidStart);
		
		return STUFF(@key, @valueStart, @valueEnd - @valueStart, @newValue);

    END

GO

update
	sic
set
	_KEY_ = dbo.SetKeySidValue (_KEY_, sis.SID_ID, LTRIM(RTRIM(sis.[VALUE]))),
	HASH_KEY = CAST(hashbytes('SHA1',dbo.SetKeySidValue (_KEY_, sis.SID_ID, LTRIM(RTRIM(sis.[VALUE])))) AS BINARY(20))
from
	STOCK_INFO_CONFIG sic, STOCK_INFO_SID sis
where
	sic.STOCK_INFO_CONFIG_ID = sis.STOCK_INFO_CONFIG_ID and LTRIM(RTRIM(sis.[VALUE])) != [VALUE]
	
update STOCK_INFO_SID set [VALUE] = LTRIM(RTRIM([VALUE])) where LTRIM(RTRIM([VALUE])) != [VALUE]

update
	STOCK_INFO_CONFIG
set
	TRACKING_NUMBER = LTRIM(RTRIM(TRACKING_NUMBER)),
	_KEY_ = dbo.SetKeyValue (_KEY_, '"TN":"', '"', LTRIM(RTRIM(TRACKING_NUMBER))),
	HASH_KEY = CAST(hashbytes('SHA1', dbo.SetKeyValue (_KEY_, '"TN":"', '"', LTRIM(RTRIM(TRACKING_NUMBER)))) AS BINARY(20))
where
	LTRIM(RTRIM(TRACKING_NUMBER)) != TRACKING_NUMBER
	
update
	STOCK_INFO_CONFIG
set
	INVENTORY_NUMBER = LTRIM(RTRIM(INVENTORY_NUMBER)),
	_KEY_ = dbo.SetKeyValue (_KEY_, '"IN":"', '"', LTRIM(RTRIM(INVENTORY_NUMBER))),
	HASH_KEY = CAST(hashbytes('SHA1', dbo.SetKeyValue (_KEY_, '"IN":"', '"', LTRIM(RTRIM(INVENTORY_NUMBER)))) AS BINARY(20))
where
	LTRIM(RTRIM(INVENTORY_NUMBER)) != INVENTORY_NUMBER

update
	STOCK_INFO_CONFIG
set
	LOT = LTRIM(RTRIM(LOT)),
	_KEY_ = dbo.SetKeyValue (_KEY_, '"LOT":"', '"', LTRIM(RTRIM(LOT))),
	HASH_KEY = CAST(hashbytes('SHA1', dbo.SetKeyValue (_KEY_, '"LOT":"', '"', LTRIM(RTRIM(LOT)))) AS BINARY(20))
where
	LTRIM(RTRIM(LOT)) != LOT

exec [UpdateCustomsStockKey];

drop function [dbo].[SetKeyValue];
drop function [dbo].[SetKeySidValue];

-----------------
select *, REPLACE(VALUE, ' ', '~') as SID_VALUE from STOCK_INFO_SID sis where LTRIM(RTRIM(sis.[VALUE])) != [VALUE]
select *, REPLACE(TRACKING_NUMBER, ' ', '~') as TR_N,
	REPLACE(INVENTORY_NUMBER, ' ', '~') as INV_N,
	REPLACE(LOT, ' ', '~') as LOT_
from STOCK_INFO_CONFIG where LTRIM(RTRIM(TRACKING_NUMBER)) != TRACKING_NUMBER
	or LTRIM(RTRIM(INVENTORY_NUMBER)) != INVENTORY_NUMBER
	or LTRIM(RTRIM(LOT)) != LOT