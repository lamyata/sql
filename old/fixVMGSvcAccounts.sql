update ti set SERVICE_ACCOUNT = '701380'
	from ADDITIONAL_TARIFF at join TARIFF t on at.ADDITIONAL_TARIFF_ID = t.TARIFF_ID
	join TARIFF_INFO ti on t.TARIFF_INFO_ID = ti.TARIFF_INFO_ID
	join ADDITIONAL_OPERATION ao on t.OPERATION_ID = ao.ADDITIONAL_OPERATION_ID
	where ao.[USAGE] = 1

update ti set SERVICE_ACCOUNT = '701380'
	from VAS_TARIFF vt join TARIFF t on vt.VAS_TARIFF_ID = t.TARIFF_ID
	join TARIFF_INFO ti on t.TARIFF_INFO_ID = ti.TARIFF_INFO_ID
	
update ti set SERVICE_ACCOUNT = '701380' from TARIFF_INFO ti join FINANCIAL_LINE fl on ti.TARIFF_INFO_ID = fl.TARIFF_INFO_ID
	where fl.FINANCIAL_LINE_ID not in (select CHILD_FINANCIAL_LINE_ID from FINANCIAL_LINE_LINE)
	and (
		ti.CODE in (select CODE from TARIFF_INFO ti join TARIFF t on ti.TARIFF_INFO_ID = t.TARIFF_INFO_ID join VAS_TARIFF vt on t.TARIFF_ID = vt.VAS_TARIFF_ID) or
		ti.CODE in (select CODE from TARIFF_INFO ti join TARIFF t on ti.TARIFF_INFO_ID = t.TARIFF_INFO_ID join ADDITIONAL_TARIFF at on t.TARIFF_ID = at.ADDITIONAL_TARIFF_ID join 
			ADDITIONAL_OPERATION ao on t.OPERATION_ID = ao.ADDITIONAL_OPERATION_ID where ao.USAGE = 1)
	)
	
--- to see all tariffs by type
select * from (
select ADDITIONAL_TARIFF_ID as 'TARIFF_ID', 'A' as 'DESC' from ADDITIONAL_TARIFF
union
select LOADING_TARIFF_ID, 'L' from LOADING_TARIFF
union
select DISCHARGING_TARIFF_ID, 'D' from DISCHARGING_TARIFF
union
select STOCK_CHANGE_TARIFF_ID, 'SC' from STOCK_CHANGE_TARIFF
union
select VAS_TARIFF_ID, 'VAS' from VAS_TARIFF
union
select WAREHOUSE_RENT_TARIFF_ID, 'WHR' from WAREHOUSE_RENT_TARIFF
) as TARIFFS

-- to see problem TARIFF_INFOs
select count(TARIFF_ID), TARIFF_INFO_ID from TARIFF group by TARIFF_INFO_ID having count(TARIFF_ID) > 1
select * from TARIFF t join TARIFF_INFO ti on t.TARIFF_INFO_ID = ti.TARIFF_INFO_ID where t.TARIFF_INFO_ID in (select TARIFF_INFO_ID from TARIFF group by TARIFF_INFO_ID having count(*) > 1)

-- problem tariff infos by CODE
select count(t.TARIFF_ID), ti.CODE from TARIFF t join TARIFF_INFO ti on t.TARIFF_INFO_ID = ti.TARIFF_INFO_ID group by (ti.CODE)
select t.TARIFF_ID, ti.* from TARIFF t join TARIFF_INFO ti on t.TARIFF_INFO_ID = ti.TARIFF_INFO_ID where ti.CODE in (select ti.CODE from TARIFF t join TARIFF_INFO ti on t.TARIFF_INFO_ID = ti.TARIFF_INFO_ID group by (ti.CODE) having count(*) > 1)

-- 422170, 422072