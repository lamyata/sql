select * from ORDER_ITEM oi join ORDERS o on oi.ORDER_ID = o.ORDER_ID
	where oi.STATUS<4 and oi.ORDER_ITEM_ID not in (select ORDER_ITEM_ID from OPERATION_REPORT where STATUS<3)
		and oi.ORDER_ID not in (2598, 2672, 2673)
		and o.DATE<'2016-DEC-31'

select * from ORDERS where STATUS<2 and DATE<'2016-DEC-31' 
and ORDER_ID not in (2598, 2672, 2673)
and ORDER_ID in (
	select ORDER_ID from ORDER_ITEM where STATUS<4 and ORDER_ITEM_ID not in (select ORDER_ITEM_ID from OPERATION_REPORT where STATUS<3)
		and ORDER_ID not in (2598, 2672, 2673)
)

update ORDERS set
	STATUS=2,
	UPDATE_USER = 'sys170207',
	UPDATE_TIMESTAMP = getdate()
where STATUS<2
	and DATE<'2016-DEC-31' 
	and ORDER_ID not in (2598, 2672, 2673)
	and ORDER_ID in (
		select ORDER_ID from ORDER_ITEM where STATUS<4
		and ORDER_ITEM_ID not in (select ORDER_ITEM_ID from OPERATION_REPORT where STATUS<3)
		and ORDER_ID not in (2598, 2672, 2673)
	)
	
update oi set
	STATUS = 4,
	UPDATE_USER = 'sys170207',
	UPDATE_TIMESTAMP = getdate()
from ORDER_ITEM oi join ORDERS o on oi.ORDER_ID = o.ORDER_ID
	where oi.STATUS<4 and oi.ORDER_ITEM_ID not in (select ORDER_ITEM_ID from OPERATION_REPORT where STATUS<3)
		and oi.ORDER_ID not in (2598, 2672, 2673)
		and o.DATE<'2016-DEC-31'
		and o.STATUS = 2