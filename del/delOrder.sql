--select count(*) from DISCHARGING_OPERATION_PLAN dop join DISCHARGING_ORDER_ITEM_GOODS doig on dop.ORDERED_ID = doig.STOCK_INFO_ID
--	join ORDER_ITEM oi on doig.DISCHARGING_ORDER_ITEM_ID = oi.ORDER_ITEM_ID and oi.ORDER_ID = @OrderId order by 1
declare @OrderId int = 28655;
--select * from ORDERS where ORDER_ID = @OrderId
--select * from ORDER_ITEM where ORDER_ID = @OrderId
--select * from DISCHARGING_ORDER_ITEM doi join ORDER_ITEM oi on doi.DISCHARGING_ORDER_ITEM_ID = oi.ORDER_ITEM_ID and oi.ORDER_ID = @OrderId
--select * from ORDER_TRANSPORT where ORDER_ID = @OrderId
--select * from DISCHARGING_ORDER_ITEM_GOODS doig join ORDER_ITEM oi on doig.DISCHARGING_ORDER_ITEM_ID = oi.ORDER_ITEM_ID and oi.ORDER_ID = @OrderId
--select top 33 * from OPERATION_PLAN op join ORDER_ITEM oi on op.ORDER_ITEM_ID = oi.ORDER_ITEM_ID and oi.ORDER_ID = @OrderId
--select top 33 * from DISCHARGING_OPERATION_PLAN dop join OPERATION_PLAN op on dop.DISCHARGING_OPERATION_PLAN_ID = op.OPERATION_PLAN_ID
--	join ORDER_ITEM oi on op.ORDER_ITEM_ID = oi.ORDER_ITEM_ID and oi.ORDER_ID = @OrderId
--select top 33 * from OPERATION_CONTEXT c join OPERATION_PLAN p on c.OPERATION_CONTEXT_ID = p.CONTEXT_ID
--	join ORDER_ITEM oi on p.ORDER_ITEM_ID = oi.ORDER_ITEM_ID and oi.ORDER_ID = @OrderId
--select top 33 * from STOCK_INFO si join DISCHARGING_OPERATION_PLAN dop on si.STOCK_INFO_ID in (dop.PLANNED_ID, dop.REMAINING_ID, ORDERED_ID, PENDING_ID)
--	join OPERATION_PLAN op on dop.DISCHARGING_OPERATION_PLAN_ID = op.OPERATION_PLAN_ID
--	join ORDER_ITEM oi on op.ORDER_ITEM_ID = oi.ORDER_ITEM_ID and oi.ORDER_ID = @OrderId
select * from OPERATION_REPORT r join ORDER_ITEM oi on r.ORDER_ITEM_ID = oi.ORDER_ITEM_ID and oi.ORDER_ID = @OrderId


--select * from ORDER_ITEM oi join
--(select LOADING_ORDER_ITEM_ID as ORDER_ITEM_ID, 'L' as 'TYPE' from LOADING_ORDER_ITEM
--union
--select DISCHARGING_ORDER_ITEM_ID, 'D' from DISCHARGING_ORDER_ITEM
--union
--select STOCK_CHANGE_ORDER_ITEM_ID, 'S' from STOCK_CHANGE_ORDER_ITEM
--union
--select VAS_ORDER_ITEM_ID, 'V' from VAS_ORDER_ITEM) as xoi on oi.ORDER_ITEM_ID = xoi.ORDER_ITEM_ID and oi.ORDER_ID = 28655

------------------------------------------------------------
-------------------------------------------------------------------
--------------------------------------------------------------------------------
ice fts


select * from ORDER_ITEM where ORDER_ID = 28655
SELECT @@TRANCOUNT
select * from OPERATION_PLAN op join ORDER_ITEM oi on op.ORDER_ITEM_ID = oi.ORDER_ITEM_ID and oi.ORDER_ID = 28655
create table DelCtxIds (CONTEXT_ID int, unique clustered (CONTEXT_ID))
CREATE TABLE DelEQIds (ID int, unique clustered (ID))
create table DelOIIds (ID int, unique clustered (ID))

insert into DelCtxIds (CONTEXT_ID) select c.OPERATION_CONTEXT_ID from OPERATION_CONTEXT c join OPERATION_PLAN p on c.OPERATION_CONTEXT_ID = p.CONTEXT_ID
	join ORDER_ITEM oi on p.ORDER_ITEM_ID = oi.ORDER_ITEM_ID and oi.ORDER_ID = 28655

insert into DelSIQIds (ID) select STORAGE_QUANTITY_ID from STOCK_INFO si join DelIds d on si.STOCK_INFO_ID = d.STOCK_INFO_ID where STORAGE_QUANTITY_ID is not null

select top 33 sieq.STOCK_INFO_QUANTITY_ID from STOCK_INFO_EXTRA_QUANTITY sieq join DelIds d on sieq.STOCK_INFO_ID = d.STOCK_INFO_ID
insert into DelEQIds select sieq.STOCK_INFO_QUANTITY_ID from STOCK_INFO_EXTRA_QUANTITY1 sieq join DelIds d on sieq.STOCK_INFO_ID = d.STOCK_INFO_ID

insert into DelOIIds select ORDER_ITEM_ID from  ORDER_ITEM where ORDER_ID = 28655
select * from DelOIIds

--select * from ORDERS where ORDER_ID = 28655
--select * from ORDER_ITEM where ORDER_ID = 28655
--select * from DISCHARGING_ORDER_ITEM doi join ORDER_ITEM oi on doi.DISCHARGING_ORDER_ITEM_ID = oi.ORDER_ITEM_ID and oi.ORDER_ID = 28655
--select * from ORDER_TRANSPORT where ORDER_ID = 28655
--select * from DISCHARGING_ORDER_ITEM_GOODS doig join ORDER_ITEM oi on doig.DISCHARGING_ORDER_ITEM_ID = oi.ORDER_ITEM_ID and oi.ORDER_ID = 28655
--select * from OPERATION_PLAN op join ORDER_ITEM oi on op.ORDER_ITEM_ID = oi.ORDER_ITEM_ID and oi.ORDER_ID = 28655
--select top 33 * from DISCHARGING_OPERATION_PLAN dop join OPERATION_PLAN op on dop.DISCHARGING_OPERATION_PLAN_ID = op.OPERATION_PLAN_ID join ORDER_ITEM oi on op.ORDER_ITEM_ID = oi.ORDER_ITEM_ID and oi.ORDER_ID =28655
--select top 33 * from OPERATION_CONTEXT c join OPERATION_PLAN p on c.OPERATION_CONTEXT_ID = p.CONTEXT_ID join ORDER_ITEM oi on p.ORDER_ITEM_ID = oi.ORDER_ITEM_ID and oi.ORDER_ID = 28655

--select top 33 * from STOCK_INFO si join DISCHARGING_OPERATION_PLAN dop on si.STOCK_INFO_ID in (dop.PLANNED_ID, dop.REMAINING_ID, ORDERED_ID, PENDING_ID)
--	join OPERATION_PLAN op on dop.DISCHARGING_OPERATION_PLAN_ID = op.OPERATION_PLAN_ID
--	join ORDER_ITEM oi on op.ORDER_ITEM_ID = oi.ORDER_ITEM_ID and oi.ORDER_ID = @OrderId

delete op from OPERATION_PLAN op join DelPlanIds d on op.OPERATION_PLAN_ID = d.PLAN_ID
delete from OPERATION_PLAN where OPERATION_PLAN_ID = 314664

select * from DelCtxIds
delete c from OPERATION_CONTEXT c join DelCtxIds d on c.OPERATION_CONTEXT_ID = d.CONTEXT_ID
delete from OPERATION_CONTEXT where OPERATION_CONTEXT_ID = 1204595

delete doig from DISCHARGING_ORDER_ITEM_GOODS doig join ORDER_ITEM oi on doig.DISCHARGING_ORDER_ITEM_ID = oi.ORDER_ITEM_ID and oi.ORDER_ID = 28655
delete doi from DISCHARGING_ORDER_ITEM doi join DelOIIds on doi.DISCHARGING_ORDER_ITEM_ID = DelOIIds.ID
delete i from OPERATION_INSTRUCTION i join DelOIIds on i.ORDER_ITEM_ID = DelOIIds.ID
delete oi from ORDER_ITEM oi join DelOIIds on oi.ORDER_ITEM_ID = DelOIIds.ID

update DelIds set STOCK_INFO_QUANTITY_ID = BASE_QUANTITY_ID from STOCK_INFO si join DelIds on si.STOCK_INFO_ID = DelIds.STOCK_INFO_ID
 select * from DelIds
 select * from DelEQIds

delete siceu
 from STOCK_INFO_CONFIG_EXTRA_UNIT siceu
 join DelIds d on siceu.STOCK_INFO_CONFIG_ID = d.STOCK_INFO_CONFIG_ID;

delete sis
 from STOCK_INFO_SID sis
 join DelIds d on sis.STOCK_INFO_CONFIG_ID = d.STOCK_INFO_CONFIG_ID;

delete sieq
	from STOCK_INFO_EXTRA_QUANTITY sieq
	join DelIds on sieq.STOCK_INFO_ID = DelIds.STOCK_INFO_ID

delete si
	from STOCK_INFO si
	join DelIds on si.STOCK_INFO_ID = DelIds.STOCK_INFO_ID

delete sic
 from STOCK_INFO_CONFIG sic
 join DelIds d on sic.STOCK_INFO_CONFIG_ID = d.STOCK_INFO_CONFIG_ID;

delete siq
 from STOCK_INFO_QUANTITY siq
 join DelIds d on siq.STOCK_INFO_QUANTITY_ID = d.STOCK_INFO_QUANTITY_ID;

delete siq
 from STOCK_INFO_QUANTITY siq
 join DelEQIds d on siq.STOCK_INFO_QUANTITY_ID = d.ID;

select * from DelEQIds