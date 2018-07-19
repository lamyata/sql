--select r.[OPERATION_REPORT_ID],
--		r.[REPORT_STATUS],
--		r.[OPERATION_ID],
--		r.[OPERATION_NAME],
--		r.[INTERNAL_COMPANY_ID],
--		r.[OPERATION_TYPE_ID],
--		r.[REPORT_DATE],
--		r.[INVENTORY_STATUS],

--		--r.[SHIFT_ID],
--		--r.[SHIFT_CODE],
--		--r.[START_TIME],
--		--r.[END_TIME],
--		--r.[REPORT_USER],
		
--		-- Order
--		r.[ORDER_ID],
--		r.[ORDER_NUMBER],
--		r.[ORDER_DATE],
--		r.[CUSTOMER],
--		r.[CUSTOMER_ID],
--		r.[ORDER_EXTERNAL_ID],
--		--r.[ORDER_FILE_MANAGER],
--		--r.[ORDER_DESCRIPTION],
--		r.[ORDER_STATUS],

--		-- Order Item
--		r.[ORDER_ITEM_ID],
--		r.[ORDER_ITEM_SEQUENCE],
--		r.[ORDER_ITEM_EXTERNAL_ID],
--		--r.[ORDER_ITEM_DESCRIPTION],
--		--r.[ORDER_ITEM_PLANNED_DATE],
--		--r.[ORDER_ITEM_CLOSING_DATE],
--		--r.[COST_CENTRE_ID],
--		--r.[COST_CENTRE],
--		--r.[ORDER_ITEM_PRIORITY],
--		r.[ORDER_ITEM_STATUS],

--		sic.[PRODUCT_ID],
--		si.[STOCK_INFO_ID],

--		--Location
--		--l.[LOCATION_ID] as LOCATION_ID,
--		--l.[ADDRESS] as LOCATION_ADDRESS,
--		--l.[CODE] as LOCATION_CODE,
--		--pl.[ADDRESS] as LOCATION_PARENT_ADDRESS,
--		--l.[PATH] + '|' + replace(str(l.[LOCATION_ID]), ' ', '')  + '|' as LOCATION_PATH,
--		--l.[PLAIN_PATH] as LOCATION_PLAIN_PATH,
--		--l.[HIERARCHY_LEVEL] as LOCATION_HIERARCHY_LEVEL,

--		sic.[STOCK_INFO_CONFIG_ID],
--		onr.[COMPANY_ID] as OWNER_ID,
--		onr.[NAME] as OWNER_NAME,
--		sic.[STATUS] as STOCK_STATUS,
--		sic.[TRACKING_NUMBER],
--		sic.[INVENTORY_NUMBER],
--		sic.[LOT],
--		sic.[ITEM_NUMBER],
--		sic.[DATE_IN],
--		sic.[EXPIRY_DATE],
--		sic.[PRODUCTION_DATE],
--		sic.[PACKAGING_UNIT],
--		sic.[PICKING_LIST],

--		-- Quantity
--		bsiq.[QUANTITY] as BASE_QUANTITY,
--		bsiq.[UNIT_ID] as BASE_UNIT_ID,
--		u.[DESCRIPTION] as	BASE_UNIT_DESCRIPTION,
--		bsiq.[MEASUREMENT_UNIT_ID] as MEASUREMENT_UNIT_ID,
--		mu.[DESCRIPTION] as	MEASUREMENT_UNIT_DESCRIPTION,
--		ssiq.[QUANTITY] as STORAGE_QUANTITY,
--		usq.[DESCRIPTION] as STORAGE_UNIT_DESCRIPTION
		
--		-- Transport
--		--t.[TRANSPORT_ID],
--		--tt.[DESCRIPTION] as TRANSPORT_TYPE,
--		--t.[REFERENCE] as TRANSPORT_REFERENCE,
--		--t.[DIRECTION] as TRANSPORT_DIRECTION,
--		--pt.[REFERENCE] as TRANSPORT_PARENT,
--		--t.[PUBLIC_ID] as TRANSPORT_PUBLIC_ID,
--		--t.[SYSTEM_ID] as TRANSPORT_SYSTEM_ID,
--		--t.[REMARK] as TRANSPORT_REMARK,
--		--t.[STATUS] as TRANSPORT_STATUS,
--		--t.[ESTIMATED_ARRIVAL] as TRANSPORT_ETA,
--		--t.[ESTIMATED_DEPARTURE] as TRANSPORT_ETD,
--		--t.[ARRIVAL] as TRANSPORT_ARRIVAL,
--		--t.[DEPARTURE] as TRANSPORT_DEPARTURE,
--		--t.[START_TIME] as TRANSPORT_START_TIME,
--		--t.[END_TIME] as TRANSPORT_END_TIME,
--		--t.[CARRIER] as TRANSPORT_CARRIER,
--		--t.[NET] as TRANSPORT_NET,
--		--t.[GROSS] as TRANSPORT_GROSS,
--		--t.[TARE] as TRANSPORT_TARE,
--		--t.[VGM] as TRANSPORT_VGM,
--		--t.[MAX_PAYLOAD] as TRANSPORT_MAX_PAYLOAD

--		from 
--	V_SMV_OPERATION_REPORT r 
--	inner join 
--		(select dor.DISCHARGING_OPERATION_REPORT_ID as OPERATION_REPORT_ID, si.STOCK_INFO_ID, t.TRANSPORT_ID
--			from DISCHARGING_OPERATION_REPORT dor 
--				inner join STOCK_INFO si on dor.REPORTED_ID = si.STOCK_INFO_ID
--				left outer join TRANSPORT t on dor.TRANSPORT_ID = t.TRANSPORT_ID
--		union 
--		select lor.LOADING_OPERATION_REPORT_ID as OPERATION_REPORT_ID, si.STOCK_INFO_ID, t.TRANSPORT_ID
--			from LOADING_OPERATION_REPORT lor
--				inner join STOCK_INFO si on lor.REPORTED_ID = si.STOCK_INFO_ID
--				left outer join TRANSPORT t on lor.TRANSPORT_ID = t.TRANSPORT_ID) sor
--		on sor.OPERATION_REPORT_ID = r.OPERATION_REPORT_ID

--		inner join STOCK_INFO si on sor.STOCK_INFO_ID = si.STOCK_INFO_ID
--		inner join STOCK_INFO_CONFIG sic on si.STOCK_INFO_CONFIG_ID = sic.STOCK_INFO_CONFIG_ID
--		inner join STOCK_INFO_QUANTITY bsiq on si.BASE_QUANTITY_ID = bsiq.STOCK_INFO_QUANTITY_ID
--		left outer join STOCK_INFO_QUANTITY ssiq on si.STORAGE_QUANTITY_ID = ssiq.STOCK_INFO_QUANTITY_ID
--		left outer join COMPANY onr on sic.OWNER_ID = onr.COMPANY_ID
--		left outer join [LOCATION] l on sic.LOCATION_ID = l.LOCATION_ID
--		left outer join [LOCATION] pl on l.PARENT_ID = pl.LOCATION_ID
--		left outer join TRANSPORT t on sor.TRANSPORT_ID = t.TRANSPORT_ID
--		left outer join TRANSPORT pt on t.PARENT_ID = pt.TRANSPORT_ID
--		left outer join TRANSPORT_TYPE tt on t.TRANSPORT_TYPE_ID = tt.TRANSPORT_TYPE_ID

--		left outer join UNIT u on u.UNIT_ID = bsiq.UNIT_ID
--		left outer join MEASUREMENT_UNIT mu on mu.MEASUREMENT_UNIT_ID = bsiq.MEASUREMENT_UNIT_ID
--		left outer join UNIT usq on usq.UNIT_ID = ssiq.UNIT_ID




SELECT	
		r.[OPERATION_REPORT_ID],
		oc.[DATE] as REPORT_DATE,
		ist.Direction,
		p.SHORT_DESC,
		p.CODE,
		case r.[STATUS] when 0 then 'Open' when 1 then 'Processing' when 2 then 'Completed' when 3 then 'Closed' end as 'REPORT_STATUS',
		--r.[STATUS] as REPORT_STATUS,
		--ist.INVENTORY_STATUS,
		
		--oc.[SHIFT_ID],
		--oc.[START_TIME],
		--oc.[END_TIME],		
		--r.CREATE_USER as REPORT_USER,	

		--Order
		--ord.ORDER_ID,
		ord.[NUMBER] AS ORDER_NUMBER,
		--ord.[DATE] as ORDER_DATE,
		--c.[NAME] as CUSTOMER,
		--c.[COMPANY_ID] AS CUSTOMER_ID,
		--ord.[EXTERNAL_ID] as ORDER_EXTERNAL_ID,
		--ord.[DESCRIPTION] as ORDER_DESCRIPTION,
		--ord.[STATUS] as ORDER_STATUS,

		--Order Item
		--oi.[ORDER_ITEM_ID],
		oi.[SEQUENCE] as ORDER_ITEM_SEQUENCE,
		oi.[EXTERNAL_ID] as ORDER_ITEM_EXTERNAL_ID,
		--oi.[DESCRIPTION] as ORDER_ITEM_DESCRIPTION,
		--oi.[PLANNED_DATE] as ORDER_ITEM_PLANNED_DATE,
		--oi.[CLOSING_DATE] as ORDER_ITEM_CLOSING_DATE,
		--oi.[COST_CENTRE_ID],
		--oi.[PRIORITY] as ORDER_ITEM_PRIORITY,
		--oi.[STATUS] as ORDER_ITEM_STATUS
		--sic.PRODUCT_ID,
		sic.LOT,
		sic.DATE_IN
		,bsiq.QUANTITY B_QTY
		,bu.DESCRIPTION B_UNIT
		,sq.QUANTITY S_QTY
		,su.DESCRIPTION S_UNIT
		,net.QUANTITY as NET_QTY
		,sqmtr.QUANTITY as SQMTR_QTY

		FROM OPERATION_REPORT r 
			--inner join OPERATION o on r.OPERATION_ID = o.OPERATION_ID 
			inner join OPERATION_CONTEXT oc on r.CONTEXT_ID = oc.OPERATION_CONTEXT_ID 
			--left outer join INTERNAL_COMPANY ic on o.INTERNAL_COMPANY_ID = ic.[COMPANY_ID] 
			--left outer join OPERATION_TYPE ot on o.[TYPE_ID] = ot.OPERATION_TYPE_ID 
			 join ORDER_ITEM oi on r.ORDER_ITEM_ID = oi.ORDER_ITEM_ID 
			 join ORDERS ord on oi.ORDER_ID = ord.ORDER_ID 
			--left outer join COMPANY c on ord.CUSTOMER_ID = c.COMPANY_ID	
			join (
				SELECT DISCHARGING_OPERATION_REPORT_ID AS OPERATION_REPORT_ID, 'IN' as Direction, INVENTORY_STATUS, si.STOCK_INFO_ID
					FROM DISCHARGING_OPERATION_REPORT dor join STOCK_INFO si on dor.REPORTED_ID = si.STOCK_INFO_ID
				UNION ALL SELECT LOADING_OPERATION_REPORT_ID AS OPERATION_REPORT_ID, 'OUT', INVENTORY_STATUS , si.STOCK_INFO_ID
					FROM LOADING_OPERATION_REPORT AS lor join STOCK_INFO si on lor.REPORTED_ID = si.STOCK_INFO_ID
				--UNION ALL SELECT STOCK_CHANGE_OPERATION_REPORT_ID AS OPERATION_REPORT_ID, 'Stock Change', INVENTORY_STATUS 
				--	FROM STOCK_CHANGE_OPERATION_REPORT AS scor
		 	--	UNION ALL SELECT VAS_OPERATION_REPORT_ID AS OPERATION_REPORT_ID, 'VAS', INVENTORY_STATUS 
				--	FROM VAS_OPERATION_REPORT
			) AS ist ON r.OPERATION_REPORT_ID = ist.OPERATION_REPORT_ID
			 join STOCK_INFO si on ist.STOCK_INFO_ID = si.STOCK_INFO_ID
			 join STOCK_INFO_CONFIG sic on si.STOCK_INFO_CONFIG_ID = sic.STOCK_INFO_CONFIG_ID
			 join STOCK_INFO_QUANTITY bsiq on si.BASE_QUANTITY_ID = bsiq.STOCK_INFO_QUANTITY_ID
			 join UNIT bu on bsiq.UNIT_ID = bu.UNIT_ID
			 join PRODUCT p on sic.PRODUCT_ID = p.PRODUCT_ID
			left join STOCK_INFO_QUANTITY sq on si.STORAGE_QUANTITY_ID = sq.STOCK_INFO_QUANTITY_ID
			left join UNIT su on sq.UNIT_ID = su.UNIT_ID
			left join (select QUANTITY,STOCK_INFO_ID from STOCK_INFO_QUANTITY siqN join STOCK_INFO_EXTRA_QUANTITY sieqN on siqN.STOCK_INFO_QUANTITY_ID=sieqN.STOCK_INFO_QUANTITY_ID and siqN.UNIT_ID=5) net on net.STOCK_INFO_ID = si.STOCK_INFO_ID
			left join (select QUANTITY,STOCK_INFO_ID from STOCK_INFO_QUANTITY siqS join STOCK_INFO_EXTRA_QUANTITY sieqS on siqS.STOCK_INFO_QUANTITY_ID=sieqS.STOCK_INFO_QUANTITY_ID and siqS.UNIT_ID=11) sqmtr on sqmtr.STOCK_INFO_ID = si.STOCK_INFO_ID

where ord.INTERNAL_COMPANY_ID = 220 and oc.DATE between '1-JAN-2018' and '31-MAR-2018'

