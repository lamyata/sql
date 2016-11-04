-- reopen all order 
declare @OrderId int = 177
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
update t set STATUS = 3, END_TIME = null from TRANSPORT t join LOADING_ORDER_ITEM loi on t.TRANSPORT_ID = loi.TRANSPORT_ID
	join ORDER_ITEM oi on loi.LOADING_ORDER_ITEM_ID = oi.ORDER_ITEM_ID and oi.ORDER_ID in (@OrderId)
update t set STATUS = 3, END_TIME = null from TRANSPORT t join DISCHARGING_ORDER_ITEM doi on t.TRANSPORT_ID = doi.TRANSPORT_ID
	join ORDER_ITEM oi on doi.DISCHARGING_ORDER_ITEM_ID = oi.ORDER_ITEM_ID and oi.ORDER_ID in (@OrderId)
-- order
update ORDERS set STATUS = 1 where ORDER_ID = @OrderId

-------------------------
-- reopen order item
declare @OrderItemId int = 7302
update OPERATION_REPORT set STATUS = 2 where ORDER_ITEM_ID in (@OrderItemId)
update ORDER_ITEM set STATUS = 2 where ORDER_ITEM_ID in (@OrderItemId)
update t set STATUS = 3, END_TIME = null from TRANSPORT t join LOADING_ORDER_ITEM loi on t.TRANSPORT_ID = loi.TRANSPORT_ID where loi.LOADING_ORDER_ITEM_ID in (@OrderItemId)
update t set STATUS = 3, END_TIME = null from TRANSPORT t join DISCHARGING_ORDER_ITEM doi on t.TRANSPORT_ID = doi.TRANSPORT_ID where doi.DISCHARGING_ORDER_ITEM_ID in (@OrderItemId)
update LOADING_ORDER_ITEM set CUSTOMS_STATUS = 0 where LOADING_ORDER_ITEM_ID in (@OrderItemId)
update DISCHARGING_ORDER_ITEM set CUSTOMS_STATUS = 0 where DISCHARGING_ORDER_ITEM_ID in (@OrderItemId)
