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

update sic
	set _KEY_ = dbo.[SetSidKeyValue](_KEY_, @InboundSidId, @NewExternalId),
	UPDATE_TIMESTAMP = GETDATE(),
	UPDATE_USER = 'sys-u-inboundorder'
	FROM DISCHARGING_OPERATION_REPORT dor
		join OPERATION_REPORT r on r.OPERATION_REPORT_ID = dor.DISCHARGING_OPERATION_REPORT_ID and r.ORDER_ITEM_ID = @OrderItemId
		join STOCK_INFO si on si.STOCK_INFO_ID = dor.REPORTED_ID
		join STOCK_INFO_CONFIG sic on sic.STOCK_INFO_CONFIG_ID = si.STOCK_INFO_CONFIG_ID
		join STOCK_INFO_SID sis on sis.STOCK_INFO_CONFIG_ID = si.STOCK_INFO_CONFIG_ID and sis.SID_ID = 23 and sis.VALUE in ('8062450', '8062450-cancelled')

update sis
	set [VALUE] = @NewExternalId,
	UPDATE_TIMESTAMP = GETDATE(),
	UPDATE_USER = 'sys-u-inboundorder'
	from DISCHARGING_OPERATION_REPORT dor
		join OPERATION_REPORT r on r.OPERATION_REPORT_ID = dor.DISCHARGING_OPERATION_REPORT_ID and r.ORDER_ITEM_ID = 28950
		join STOCK_INFO si on si.STOCK_INFO_ID = dor.REPORTED_ID
		join STOCK_INFO_CONFIG sic on sic.STOCK_INFO_CONFIG_ID = si.STOCK_INFO_CONFIG_ID
		join STOCK_INFO_SID sis on sis.STOCK_INFO_CONFIG_ID = si.STOCK_INFO_CONFIG_ID and sis.SID_ID = 23 and sis.VALUE in ('8062450', '8062450-cancelled')

update sic
	set _KEY_ = dbo.[SetSidKeyValue](_KEY_, @InboundSidId, @NewExternalId),
	UPDATE_TIMESTAMP = GETDATE(),
	UPDATE_USER = 'sys-u-inboundorder'
	from STOCK s join STOCK_INFO si on s.STOCK_INFO_ID = si.STOCK_INFO_ID
		join STOCK_INFO_CONFIG sic on si.STOCK_INFO_CONFIG_ID = sic.STOCK_INFO_CONFIG_ID
		join STOCK_INFO_SID sis on sic.STOCK_INFO_CONFIG_ID = sis.STOCK_INFO_CONFIG_ID and sis.SID_ID = 23 and sis.VALUE in ('8062450', '8062450-cancelled')
		where sic.INTERNAL_COMPANY_ID = 299
		and sic.OWNER_ID = 513
		and sic.PRODUCT_ID = 2476
		and sic.TRACKING_NUMBER = '20160706'

update sis
	set [VALUE] = @NewExternalId,
	UPDATE_TIMESTAMP = GETDATE(),
	UPDATE_USER = 'sys-u-inboundorder'
	from STOCK s join STOCK_INFO si on s.STOCK_INFO_ID = si.STOCK_INFO_ID
		join STOCK_INFO_CONFIG sic on si.STOCK_INFO_CONFIG_ID = sic.STOCK_INFO_CONFIG_ID
		join STOCK_INFO_SID sis on sic.STOCK_INFO_CONFIG_ID = sis.STOCK_INFO_CONFIG_ID and sis.SID_ID = 23 and sis.VALUE in ('8062450', '8062450-cancelled')
		where sic.INTERNAL_COMPANY_ID = 299
		and sic.OWNER_ID = 513
		and sic.PRODUCT_ID = 2476
		and sic.TRACKING_NUMBER = '20160706'

update ORDER_ITEM set EXTERNAL_ID = @NewExternalId
	where ORDER_ITEM_ID = @OrderItemId

	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK
		SELECT ERROR_NUMBER() as ErrorNumber, ERROR_MESSAGE() as ErrorMessage
END CATCH

DROP FUNCTION [dbo].[SetSidKeyValue]

GO
	