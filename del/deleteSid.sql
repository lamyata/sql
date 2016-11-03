create procedure UpdateCustomsStockKey
as
begin
update cs
set cs._KEY_ = ('{"DC":' + ISNULL(CONVERT(NVARCHAR(10), cs.DOCUMENT_CODE_ID), 'null') + 
',"DN":"' + ISNULL(cs.DOCUMENT_NUMBER, '') + 
'","DD":"' + ISNULL(CONVERT(NVARCHAR(8), cs.DOCUMENT_DATE, 112), 'null') + 
'","CS":' + CONVERT(NVARCHAR(10), cs.CUSTOMS_STATUS) + 
',"SKEY":' + sic._KEY_ + '}')
from CUSTOMS_STOCK cs
inner join STOCK_INFO si on cs.STOCK_INFO_ID = si.STOCK_INFO_ID
inner join STOCK_INFO_CONFIG sic on si.STOCK_INFO_CONFIG_ID = sic.STOCK_INFO_CONFIG_ID
inner join STOCK_INFO_SID sis on sis.STOCK_INFO_CONFIG_ID = sic.STOCK_INFO_CONFIG_ID
end
go

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

declare @CustomsStatusSidCode nvarchar(11) = 'CUST';
declare @CustomsStatusSidId int;
select @CustomsStatusSidId = STORAGE_IDENTIFIER_ID from STORAGE_IDENTIFIER where CODE = @CustomsStatusSidCode;

delete psot from [dbo].[PRODUCT_SID_OPERATION_TYPE] psot, PRODUCT_STORAGE_IDENTIFIER psi
	where psot.PRODUCT_SID_ID = psi.PRODUCT_STORAGE_IDENTIFIER_ID and  psi.SID_ID = @CustomsStatusSidId;

delete pssv from PRODUCT_SID_SID_VALUE pssv join PRODUCT_STORAGE_IDENTIFIER ps
	on pssv.PRODUCT_SID_ID = ps.PRODUCT_STORAGE_IDENTIFIER_ID and ps.SID_ID = @CustomsStatusSidId;
	
delete from PRODUCT_STORAGE_IDENTIFIER where SID_ID = @CustomsStatusSidId;

update STOCK_INFO_CONFIG
	set _KEY_ = dbo.RemoveSidFromKey(_KEY_, @CustomsStatusSidId),
	UPDATE_TIMESTAMP = GETDATE(),
	UPDATE_USER = 'sys-rmsid-cstatus'
	WHERE STOCK_INFO_CONFIG_ID in (select STOCK_INFO_CONFIG_ID from STOCK_INFO_SID where SID_ID = @CustomsStatusSidId);

delete from STOCK_INFO_SID where SID_ID = @CustomsStatusSidId;

delete from	STORAGE_IDENTIFIER_PR_VALUE where SID_ID = @CustomsStatusSidId;

delete from STORAGE_IDENTIFIER where STORAGE_IDENTIFIER_ID = @CustomsStatusSidId;

exec UpdateCustomsStockKey;

	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK
		SELECT ERROR_NUMBER() as ErrorNumber, ERROR_MESSAGE() as ErrorMessage
END CATCH

DROP FUNCTION [dbo].[RemoveSidFromKey];

GO
