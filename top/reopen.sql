-- reopen all order 
declare @OrderId int = 2743
-- order items
update oi set STATUS = 2 from ORDER_ITEM oi where ORDER_ID in (@OrderId)
-- customs status
update LOADING_ORDER_ITEM set CUSTOMS_STATUS = 0 from LOADING_ORDER_ITEM loi join ORDER_ITEM oi
	on loi.LOADING_ORDER_ITEM_ID = oi.ORDER_ITEM_ID and oi.ORDER_ID in (@OrderId)
update DISCHARGING_ORDER_ITEM set CUSTOMS_STATUS = 0 from DISCHARGING_ORDER_ITEM doi join ORDER_ITEM oi
	on doi.DISCHARGING_ORDER_ITEM_ID = oi.ORDER_ITEM_ID and oi.ORDER_ID in (@OrderId)
-- operation reports
update r set STATUS = 2 from OPERATION_REPORT r join ORDER_ITEM oi
	on r.ORDER_ITEM_ID = oi.ORDER_ITEM_ID and oi.ORDER_ID in (@OrderId)
-- transports
select t.* from TRANSPORT t join (
	select TRANSPORT_ID, LOADING_ORDER_ITEM_ID as ORDER_ITEM_ID from LOADING_ORDER_ITEM union
	select TRANSPORT_ID, DISCHARGING_ORDER_ITEM_ID from DISCHARGING_ORDER_ITEM) as eoi on t.TRANSPORT_ID = eoi.TRANSPORT_ID
	join ORDER_ITEM oi on eoi.ORDER_ITEM_ID = oi.ORDER_ITEM_ID and oi.ORDER_ID in (@OrderId)
update t set STATUS = 2, END_TIME = null from TRANSPORT t join LOADING_ORDER_ITEM loi on t.TRANSPORT_ID = loi.TRANSPORT_ID
	join ORDER_ITEM oi on loi.LOADING_ORDER_ITEM_ID = oi.ORDER_ITEM_ID and oi.ORDER_ID in (@OrderId)
update t set STATUS = 2, END_TIME = null from TRANSPORT t join DISCHARGING_ORDER_ITEM doi on t.TRANSPORT_ID = doi.TRANSPORT_ID
	join ORDER_ITEM oi on doi.DISCHARGING_ORDER_ITEM_ID = oi.ORDER_ITEM_ID and oi.ORDER_ID in (@OrderId)
-- check for FLs
select * from ORDER_ITEM_FINANCIAL_LINE oifl join ORDER_ITEM oi on oifl.ORDER_ITEM_ID = oi.ORDER_ITEM_ID and oi.ORDER_ID = @OrderId
select * from OPERATION_REPORT_FINANCIAL_LINE orfl join OPERATION_REPORT rpt on orfl.OPERATION_REPORT_ID = rpt.OPERATION_REPORT_ID
	join ORDER_ITEM oi on rpt.ORDER_ITEM_ID = oi.ORDER_ITEM_ID and oi.ORDER_ID = @OrderId
-- order
update ORDERS set STATUS = 1 where ORDER_ID = @OrderId

-----------------------
-- reopen order item --
declare @OrderItemId int = 43852
update OPERATION_REPORT set STATUS = 2 where ORDER_ITEM_ID in (@OrderItemId)
update ORDER_ITEM set STATUS = 2 where ORDER_ITEM_ID in (@OrderItemId)
update t set STATUS = 2, END_TIME = null from TRANSPORT t join LOADING_ORDER_ITEM loi on t.TRANSPORT_ID = loi.TRANSPORT_ID where loi.LOADING_ORDER_ITEM_ID in (@OrderItemId)
update t set STATUS = 2, END_TIME = null from TRANSPORT t join DISCHARGING_ORDER_ITEM doi on t.TRANSPORT_ID = doi.TRANSPORT_ID where doi.DISCHARGING_ORDER_ITEM_ID in (@OrderItemId)
update LOADING_ORDER_ITEM set CUSTOMS_STATUS = 0 where LOADING_ORDER_ITEM_ID in (@OrderItemId)
update DISCHARGING_ORDER_ITEM set CUSTOMS_STATUS = 0 where DISCHARGING_ORDER_ITEM_ID in (@OrderItemId)
update o set STATUS = 1 from ORDERS o join ORDER_ITEM oi on o.ORDER_ID = oi.ORDER_ID and oi.ORDER_ITEM_ID = @OrderItemId

-- reopen invoice --
declare @FinancialDocumentId int = 1735
select * from FINANCIAL_DOCUMENT where FINANCIAL_DOCUMENT_ID = @FinancialDocumentId
Update FINANCIAL_DOCUMENT
set JOURNAL_ID = NULL,
	SEQUENCE = NULL,
	STATUS = 0,
	BOOKING_DATE = NULL,
	IS_PRINTED = 0,
	SEQUENCE_WITH_MOD = NULL
where FINANCIAL_DOCUMENT_ID = @FinancialDocumentId
--update FINANCIAL_DOCUMENT set SEQUENCE = 160291, SEQUENCE_WITH_MOD =160291 where FINANCIAL_DOCUMENT_ID = 234

C:\Program Files\Microsoft SQL Server\MSSQL11.UAT\MSSQL\DATA\\iTos.VMG.mdf
C:\Program Files\Microsoft SQL Server\MSSQL11.UAT\MSSQL\DATA\\iTos.VMG.ldf
