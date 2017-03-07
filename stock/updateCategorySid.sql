
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

declare @data table (sic int, r int, rType nvarchar(5), cnt int)
insert into @data (sic, r)
select 
	sic.STOCK_INFO_CONFIG_ID, sir.OPERATION_REPORT_ID
from STOCK s join STOCK_INFO si on s.STOCK_INFO_ID = si.STOCK_INFO_ID
	join STOCK_INFO_CONFIG sic on si.STOCK_INFO_CONFIG_ID = sic.STOCK_INFO_CONFIG_ID and sic.PRODUCT_ID = 3932 and sic.OWNER_ID = 559
	join STOCK_INFO_SID sis on si.STOCK_INFO_CONFIG_ID = sis.STOCK_INFO_CONFIG_ID and sis.SID_ID = 56 and sis.VALUE = 'SCA'
	join STOCK_INVENTORY_REQUEST_ITEM siri on siri.STOCK_ID = s.STOCK_ID
	join STOCK_INVENTORY_REQUEST sir on siri.REQUEST_ID = sir.STOCK_INVENTORY_REQUEST_ID

--update @data set cnt = (select count(*) from STOCK s join STOCK_INFO si on s.STOCK_INFO_ID = si.STOCK_INFO_ID and si.STOCK_INFO_CONFIG_ID = sic)

insert into @data(sic, rType) select STOCK_INFO_CONFIG_ID, 'sc' from STOCK_INFO si join STOCK_CHANGE_ITEM sci on si.STOCK_INFO_ID = sci.TO_ID join STOCK_CHANGE_OPERATION_REPORT scor on sci.STOCK_CHANGE_ITEM_ID = scor.REPORTED_ID
	join @data d on scor.STOCK_CHANGE_OPERATION_REPORT_ID = d.r

insert into @data(sic, rType) select STOCK_INFO_CONFIG_ID, 'load' from STOCK_INFO si join LOADING_OPERATION_REPORT lor on lor.REPORTED_ID = si.STOCK_INFO_ID
	join @data d on lor.LOADING_OPERATION_REPORT_ID = d.r

--select * from @data

update sic set
	_KEY_ = dbo.[SetSidKeyValue](_KEY_, 56, 'LAAKIRCHEN'),
	HASH_KEY = CAST(hashbytes('SHA1', dbo.[SetSidKeyValue](_KEY_, 56, 'LAAKIRCHEN')) AS BINARY(20)),
	UPDATE_TIMESTAMP = GETDATE(),
	UPDATE_USER = 'sys161216'
	FROM STOCK_INFO_CONFIG sic, @data d
	WHERE sic.STOCK_INFO_CONFIG_ID = d.sic 

update sis set
	VALUE = 'LAAKIRCHEN',
	UPDATE_TIMESTAMP = GETDATE(),
	UPDATE_USER = 'sys161216'
from STOCK_INFO_SID sis join @data d on sis.STOCK_INFO_CONFIG_ID = d.sic

	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK
		SELECT ERROR_NUMBER() as ErrorNumber, ERROR_MESSAGE() as ErrorMessage
END CATCH

drop function [dbo].[SetSidKeyValue] 
