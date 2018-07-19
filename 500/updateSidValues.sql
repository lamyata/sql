declare @sidIds table (id int)
insert into @sidIds select STORAGE_IDENTIFIER_ID from STORAGE_IDENTIFIER where CODE in ('NRSH', 'DIA', 'DIAC', 'WID', 'LEN', 'HGHT', 'GRM')

--select * from @sidIds

select * from STOCK_INFO_SID where VALUE like '%.00'

select * from STOCK_INFO_SID 
	where SID_ID in (select id from @sidIds)
	and VALUE like '%.00'

begin tran

update STOCK_INFO_SID set
	VALUE = SUBSTRING(VALUE, 1, LEN(VALUE)-3),
	UPDATE_TIMESTAMP = GETDATE(),
	UPDATE_USER = 'la180214'
	where SID_ID in (select id from @sidIds)
	and VALUE like '%.00'

select * from STOCK_INFO_SID where UPDATE_USER = 'la180214'

rollback

---------------------------------------------------------------------------------------
	declare @nullString nvarchar(4) = 'null';
	declare @emptyString nvarchar = '';
	DECLARE @new_key nvarchar(MAX) = '';

	exec [dbo].[TOGGLE_NONCLUSTERED_INDEXES_FOR_TABLE] 'STOCK_INFO_CONFIG', 0

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
		sic.HASH_KEY = CAST(hashbytes('SHA1', @new_key) AS BINARY(20))
	from STOCK_INFO_CONFIG sic, STOCK_INFO_SID sis
	where sic.STOCK_INFO_CONFIG_ID = sis.STOCK_INFO_CONFIG_ID
		and sis.UPDATE_USER = 'la180214'    

	exec [dbo].[TOGGLE_NONCLUSTERED_INDEXES_FOR_TABLE] 'STOCK_INFO_CONFIG', 1