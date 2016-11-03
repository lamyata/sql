/*
exec('
update STOCK_INFO_CONFIG
set _KEY_ = REPLACE(_KEY_, '',"ST":'', '',"LOT":"'' + ISNULL(LOT, '''') + ''","PD":'' + ISNULL(CONVERT(NVARCHAR(8), PRODUCTION_DATE, 112), ''null'') + '',"ED":'' + ISNULL(CONVERT(NVARCHAR(8), EXPIRY_DATE, 112), ''null'') + '',"DI":'' + ISNULL(CONVERT(NVARCHAR(8), DATE_IN, 112), ''null'') + '',"ST":'')
')
*/

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

BEGIN TRY
	BEGIN TRAN

declare @LotSidCode nvarchar(11) = 'LOT';
declare @SGNIcCode  nvarchar(50) = 'IC_SGN';

declare @LotSidId int;
declare @SGNIcId int;

select @SGNIcId = COMPANYNR from COMPANY where CODE = @SGNIcCode;
select @LotSidId = STORAGE_IDENTIFIER_ID from STORAGE_IDENTIFIER where CODE = @LotSidCode;

update sic set LOT = sis.[VALUE], UPDATE_TIMESTAMP = GETDATE(), UPDATE_USER = 'sys160530'
	from STOCK_INFO_CONFIG sic join STOCK_INFO_SID sis on sic.STOCK_INFO_CONFIG_ID = sis.STOCK_INFO_CONFIG_ID
		and sic.INTERNAL_COMPANY_ID != @SGNIcId
		and sis.SID_ID = @LotSidId

print 'Updating LOT of SICs';
update STOCK_INFO_CONFIG
	set _KEY_ = dbo.SetKeyValue (_KEY_, '"LOT":"', '"', LOT),
	UPDATE_TIMESTAMP = GETDATE(), UPDATE_USER = 'sys160530' 
	where INTERNAL_COMPANY_ID != @SGNIcId

print 'Remove sid LOT from SICs';
update STOCK_INFO_CONFIG
	set _KEY_ = dbo.RemoveSidFromKey(_KEY_, @LotSidId),
	UPDATE_TIMESTAMP = GETDATE(),
	UPDATE_USER = 'sys160531'
	FROM STOCK_INFO_CONFIG
	where INTERNAL_COMPANY_ID != @SGNIcId

print 'Deleting psot'
delete psot from [dbo].[PRODUCT_SID_OPERATION_TYPE] psot, PRODUCT_STORAGE_IDENTIFIER psi
	where psot.PRODUCT_SID_ID = psi.PRODUCT_STORAGE_IDENTIFIER_ID and  psi.SID_ID = @LotSidId
	and not exists (select * from PRODUCT_INT_COMPANY where PRODUCT_ID = psi.PRODUCT_ID and INT_COMPANYNR = @SGNIcId)

print 'Deleting psi'
delete psi from
 PRODUCT_STORAGE_IDENTIFIER psi
 where psi.SID_ID = @LotSidId
 and not exists (select * from PRODUCT_INT_COMPANY where PRODUCT_ID = psi.PRODUCT_ID and INT_COMPANYNR = @SGNIcId)

print 'Deleting sis'
delete sis from
STOCK_INFO_SID sis, STOCK_INFO_CONFIG sic
where sis.STOCK_INFO_CONFIG_ID = sic.STOCK_INFO_CONFIG_ID
and sis.SID_ID = @LotSidId
and sic.INTERNAL_COMPANY_ID != @SGNIcId

	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK
		SELECT ERROR_NUMBER() as ErrorNumber, ERROR_MESSAGE() as ErrorMessage
END CATCH

DROP FUNCTION [dbo].[SetKeyValue];
DROP FUNCTION [dbo].[RemoveSidFromKey];

GO
