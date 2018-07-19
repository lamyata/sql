select oi.ORDER_ID, oi.SEQUENCE, case when oi.STATUS = 0 then 'Open' when oi.STATUS = 1 then 'Approved' end STATUS, c.NAME, oi.CREATE_TIMESTAMP, oi.UPDATE_TIMESTAMP, t.REFERENCE
from ORDER_ITEM oi join ORDERS o on oi.ORDER_ID = o.ORDER_ID
	join COMPANY c on o.CUSTOMER_ID = c.COMPANY_ID
	left join
(
	select TRANSPORT_ID, LOADING_ORDER_ITEM_ID ORDER_ITEM_ID from LOADING_ORDER_ITEM
	union select TRANSPORT_ID, DISCHARGING_ORDER_ITEM_ID doi from DISCHARGING_ORDER_ITEM
) xoi on oi.ORDER_ITEM_ID = xoi.ORDER_ITEM_ID
	left join TRANSPORT t on xoi.TRANSPORT_ID = t.TRANSPORT_ID
	where oi.STATUS in (0, 1) order by 1
--------------------------------------------------------------------------------------------------------

select ORDER_ID, SEQUENCE, xoi.*, t.REFERENCE from ORDER_ITEM oi join
(select LOADING_ORDER_ITEM_ID as ORDER_ITEM_ID, 'L' as TP, TRANSPORT_ID from LOADING_ORDER_ITEM
union select DISCHARGING_ORDER_ITEM_ID, 'D', TRANSPORT_ID from DISCHARGING_ORDER_ITEM
union select VAS_ORDER_ITEM_ID, 'VAS', null from VAS_ORDER_ITEM
union select STOCK_CHANGE_ORDER_ITEM_ID, 'SC', null from STOCK_CHANGE_ORDER_ITEM) xoi
 on oi.ORDER_ITEM_ID = xoi.ORDER_ITEM_ID
left join TRANSPORT t on xoi.TRANSPORT_ID = t.TRANSPORT_ID
where oi.STATUS in (0, 1)

--------------------------------------------------------------------------------------------------------
select oi.ORDER_ID, oi.SEQUENCE, case when oi.STATUS = 0 then 'Open' when oi.STATUS = 1 then 'Approved' end STATUS, c.NAME,
	year(oi.CREATE_TIMESTAMP) [Crea Year], month(oi.CREATE_TIMESTAMP) [Crea Month],
	oi.CREATE_TIMESTAMP [Creation date], 
	year(oi.UPDATE_TIMESTAMP) [Sav Year], month(oi.UPDATE_TIMESTAMP) [Sav Month], oi.UPDATE_TIMESTAMP [Last saved on], IsNull(t.REFERENCE, '') [Transport reference]
from ORDER_ITEM oi join ORDERS o on oi.ORDER_ID = o.ORDER_ID
	join COMPANY c on o.CUSTOMER_ID = c.COMPANY_ID
	left join
(
	select TRANSPORT_ID, LOADING_ORDER_ITEM_ID ORDER_ITEM_ID from LOADING_ORDER_ITEM
	union select TRANSPORT_ID, DISCHARGING_ORDER_ITEM_ID doi from DISCHARGING_ORDER_ITEM
) xoi on oi.ORDER_ITEM_ID = xoi.ORDER_ITEM_ID
	left join TRANSPORT t on xoi.TRANSPORT_ID = t.TRANSPORT_ID
	where oi.STATUS in (0, 1) order by o.CUSTOMER_ID, o.ORDER_ID
--------
STOCK_ID	STOCK_INFO_ID	OPERATIONAL_DATE	CREATE_USER	CREATE_TIMESTAMP	UPDATE_USER	UPDATE_TIMESTAMP	QUANTITY	ExtraQs	_KEY_
60581	512220	2017-11-29 00:00:00.0000000	Anonymous	2017-11-29 13:42:59.0000000	Anonymous	2017-11-29 13:42:59.7400000	12000.00000000	NULL	{"IC":1,"O":2,"P":162,"L":1,"BU":2,"TN":"BE01-003737-1 / Mv GDYNIA","IN":"BE01-003737-1 / Mv GDYNIA","LOT":"BE01-003737-1 / Mv GDYNIA","PD":null,"ED":null,"DI":20170429,"ST":0,"SU":16,"ITN":"","PU":"","SHU":"","EU":[],"S":[{"3":""},{"5":""},{"6":""},{"7":""},{"8":""},{"10":""},{"12":"BB1200"},{"14":""},{"33":""}]}
60613	512386	2017-11-29 00:00:00.0000000	Anonymous	2017-11-29 13:55:09.0000000	Anonymous	2017-11-29 13:55:09.8400000	201600.00000000	NULL	{"IC":1,"O":2,"P":162,"L":1,"BU":2,"TN":"BE01-003737-1 / Mv GDYNIA","IN":"BE01-003737-1 / Mv GDYNIA","LOT":"BE01-003737-1 / Mv GDYNIA","PD":null,"ED":null,"DI":20170429,"ST":0,"SU":16,"ITN":"","PU":"","SHU":"","EU":[],"S":[{"3":""},{"5":""},{"6":""},{"7":""},{"8":""},{"10":""},{"12":"BB1200"},{"14":""},{"33":""}]}

CUSTOMS_STOCK_ID	DATE	DOCUMENT_NUMBER	DOCUMENT_DATE	CUSTOMS_STATUS	DOCUMENT_CODE_ID	STOCK_INFO_ID	_KEY_	CREATE_USER	CREATE_TIMESTAMP	UPDATE_USER	UPDATE_TIMESTAMP	QUANTITY	_KEY_
38044	2017-11-29 00:00:00.0000000	17NLJ1XAV2A2BGWD51	2017-04-25 13:57:47.0000000	3	1	512216	{"DC":1,"DN":"17NLJ1XAV2A2BGWD51","DD":"20170425","CS":3,"SKEY":{"IC":1,"O":2,"P":162,"L":1,"BU":2,"TN":"BE01-003737-1 / Mv GDYNIA","IN":"BE01-003737-1 / Mv GDYNIA","LOT":"BE01-003737-1 / Mv GDYNIA","PD":null,"ED":null,"DI":20170429,"ST":0,"SU":16,"ITN":"","PU":"","SHU":"","EU":[],"S":[{"3":""},{"5":""},{"6":""},{"7":""},{"8":""},{"10":""},{"12":"BB1200"},{"14":""},{"33":""}]}}	Anonymous	2017-11-29 13:42:58.0000000	Anonymous	2017-11-29 13:42:58.9000000	3897600.00000000	{"IC":1,"O":2,"P":162,"L":1,"BU":2,"TN":"BE01-003737-1 / Mv GDYNIA","IN":"BE01-003737-1 / Mv GDYNIA","LOT":"BE01-003737-1 / Mv GDYNIA","PD":null,"ED":null,"DI":20170429,"ST":0,"SU":16,"ITN":"","PU":"","SHU":"","EU":[],"S":[{"3":""},{"5":""},{"6":""},{"7":""},{"8":""},{"10":""},{"12":"BB1200"},{"14":""},{"33":""}]}
38070	2017-11-29 00:00:00.0000000	17NLJ1XAV2A2BGWD51	2017-04-25 13:57:47.0000000	3	1	512381	{"DC":1,"DN":"17NLJ1XAV2A2BGWD51","DD":"20170425","CS":3,"SKEY":{"IC":1,"O":2,"P":162,"L":1,"BU":2,"TN":"BE01-003737-1 / Mv GDYNIA","IN":"BE01-003737-1 / Mv GDYNIA","LOT":"BE01-003737-1 / Mv GDYNIA","PD":null,"ED":null,"DI":20170429,"ST":0,"SU":16,"ITN":"","PU":"","SHU":"","EU":[],"S":[{"3":""},{"5":""},{"6":""},{"7":""},{"8":""},{"10":""},{"12":"BB1200"},{"14":""},{"33":""}]}}	Anonymous	2017-11-29 13:55:08.0000000	Anonymous	2017-11-29 13:55:08.9700000	4087200.00000000	{"IC":1,"O":2,"P":162,"L":1,"BU":2,"TN":"BE01-003737-1 / Mv GDYNIA","IN":"BE01-003737-1 / Mv GDYNIA","LOT":"BE01-003737-1 / Mv GDYNIA","PD":null,"ED":null,"DI":20170429,"ST":0,"SU":16,"ITN":"","PU":"","SHU":"","EU":[],"S":[{"3":""},{"5":""},{"6":""},{"7":""},{"8":""},{"10":""},{"12":"BB1200"},{"14":""},{"33":""}]}

delete from STOCK where STOCK_ID in (60581, 60613)
delete from CUSTOMS_STOCK where CUSTOMS_STOCK_ID in (38044, 38070)

select * from STOCK where STOCK_ID in (60581, 60613)
select * from CUSTOMS_STOCK where CUSTOMS_STOCK_ID in (38044, 38070)
select top 44 * from CUSTOMS_INVENTORY_REQUEST_ITEM where CUSTOMS_STOCK_ID in (38044, 38070)
update CUSTOMS_INVENTORY_REQUEST_ITEM set CUSTOMS_STOCK_ID = null where CUSTOMS_INVENTORY_REQUEST_ITEM_ID in (47293, 47319)