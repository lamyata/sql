declare @updatedIds table (
 STOCK_INFO_CONFIG_ID int
);
declare @nullString nvarchar(4) = 'null';
declare @emptyString nvarchar = '';
DECLARE @new_key nvarchar(MAX) = '';

update sic
set sic.DATE_IN = CAST(sic.TRACKING_NUMBER as datetime2), 
        sic.TRACKING_NUMBER = NULL
output inserted.STOCK_INFO_CONFIG_ID into @updatedIds 
from OPERATION_REPORT o
    join LOADING_OPERATION_REPORT lor on o.OPERATION_REPORT_ID = lor.LOADING_OPERATION_REPORT_ID and o.ORDER_ITEM_ID = 52962
    join STOCK_INFO si on lor.REPORTED_ID = si.STOCK_INFO_ID
    join STOCK_INFO_CONFIG sic on si.STOCK_INFO_CONFIG_ID = sic.STOCK_INFO_CONFIG_ID
where sic.DATE_IN IS NULL 
            AND TRY_CONVERT(datetime2, sic.TRACKING_NUMBER) IS NOT NULL
            AND (o.STATUS < 2 OR (o.STATUS=2 and lor.INVENTORY_STATUS=1))

-- Update SIC key + Hash
update sic
set @new_key = (
		'{"IC":' + ISNULL(CAST(sic.INTERNAL_COMPANY_ID as nvarchar), @nullString) + 
		',"O":'  + ISNULL(CAST(sic.OWNER_ID as nvarchar), @nullString) + 
		',"P":'  + ISNULL(CAST(sic.PRODUCT_ID as nvarchar), @nullString) +
		',"L":'  + ISNULL(CAST(sic.LOCATION_ID as nvarchar), @nullString) + 
		',"BU":'  + ISNULL(CAST(sic.BASE_UNIT_ID as nvarchar), @nullString) + 
		',"TN":"'  + ISNULL(sic.TRACKING_NUMBER, @emptyString)  + '"' +
		',"IN":"'  + ISNULL(sic.INVENTORY_NUMBER, @emptyString)  + '"' +
		',"LOT":"'  + ISNULL(sic.LOT, @emptyString)  + '"' +
		',"PD":'  + ISNULL(CONVERT(nvarchar, sic.PRODUCTION_DATE, 112), @nullString) + 
		',"ED":'  + ISNULL(CONVERT(nvarchar, sic.EXPIRY_DATE, 112), @nullString) + 
		',"DI":'  + ISNULL(CONVERT(nvarchar, sic.DATE_IN, 112), @nullString) + 
		',"ST":'  + CAST(sic.STATUS as nvarchar) +
		',"SU":'  + ISNULL(CAST(sic.STORAGE_UNIT_ID as nvarchar), @nullString) + 
		',"ITN":"'  + ISNULL(sic.ITEM_NUMBER, @emptyString)  + '"' +
		',"PU":"'  + ISNULL(sic.PACKAGING_UNIT, @emptyString)  + '"' +
		',"SHU":"'  + ISNULL(sic.PICKING_LIST, @emptyString)  + '"' +
		',"EU":['  + ISNULL([dbo].[JOIN_SIC_EXTRA_UNITS](sic.STOCK_INFO_CONFIG_ID), @emptyString) + ']' +  
		',"S":['  + ISNULL([dbo].[JOIN_SIC_SIDS](sic.STOCK_INFO_CONFIG_ID), @emptyString) + ']}'),
	sic._KEY_ = @new_key,
	sic.HASH_KEY = CAST(hashbytes('SHA1', @new_key) AS BINARY(20)),
	sic.UPDATE_TIMESTAMP = getdate(),
	sic.UPDATE_USER = 'la170714a'
from STOCK_INFO_CONFIG sic
join @updatedIds upd on sic.STOCK_INFO_CONFIG_ID = upd.STOCK_INFO_CONFIG_ID


----------------------------------------
declare @orderItemId int = 52962
declare @user varchar (10) = 'la170714aa';
declare @sicIds table (
 STOCK_INFO_CONFIG_ID int
);

insert into @sicIds
select si.STOCK_INFO_CONFIG_ID
from OPERATION_REPORT o
    join LOADING_OPERATION_REPORT lor on o.OPERATION_REPORT_ID = lor.LOADING_OPERATION_REPORT_ID and o.ORDER_ITEM_ID = @orderItemId and lor.INVENTORY_STATUS = 1
    join STOCK_INFO si on lor.REPORTED_ID = si.STOCK_INFO_ID

INSERT INTO [dbo].[STOCK_INFO_SID]
           ([SID_ID]
           ,[STOCK_INFO_CONFIG_ID]
           ,[VALUE]
           ,[CREATE_USER]
           ,[CREATE_TIMESTAMP]
           ,[UPDATE_USER]
           ,[UPDATE_TIMESTAMP])
select 55,
	STOCK_INFO_CONFIG_ID,
	'',
	@user,
	getdate(),
	@user,
	getdate()
from @sicIds

--select *
--from STOCK_INFO_SID sis join @sicIds sic on sis.SID_ID = 23 and sis.STOCK_INFO_CONFIG_ID = sic.STOCK_INFO_CONFIG_ID

