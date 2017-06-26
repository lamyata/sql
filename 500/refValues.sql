-- list of problem references of type 'Text'
select * from ORDER_REFERENCE_VALUE orv join REFERENCE r on orv.REFERENCE_ID = r.REFERENCE_ID and orv.VALUE is not null and orv.VALUE != ''
		and lower(orv.VALUE) not in ('true', 'false')
	join REFERENCE_TYPE rt on r.REFERENCE_TYPE_ID = rt.REFERENCE_TYPE_ID and rt.VALUE_TYPE = 'System.Boolean, mscorlib'
select * from ORDER_ITEM_REFERENCE_VALUE orv join REFERENCE r on orv.REFERENCE_ID = r.REFERENCE_ID and orv.VALUE is not null and orv.VALUE != ''
		and lower(orv.VALUE) not in ('true', 'false')
	join REFERENCE_TYPE rt on r.REFERENCE_TYPE_ID = rt.REFERENCE_TYPE_ID and rt.VALUE_TYPE = 'System.Boolean, mscorlib'

-- list of problem reference of type 'Combo'
--select * from ORDER_ITEM_REFERENCE_VALUE orv join REFERENCE r on orv.REFERENCE_ID = r.REFERENCE_ID and orv.VALUE is not null and orv.VALUE != ''
--	join REFERENCE_TYPE rt on r.REFERENCE_TYPE_ID = rt.REFERENCE_TYPE_ID and rt.VALUE_TYPE = 'System.String[], mscorlib'
--	and orv.VALUE not in (select PREDEFINED_VALUE from REFERENCE_TYPE_PR_VALUE where REFERENCE_TYPE_ID = rt.REFERENCE_TYPE_ID)
--	join ORDER_ITEM oi on oi.ORDER_ITEM_ID = orv.ORDER_ITEM_ID
select distinct r.REFERENCE_TYPE_ID, substring(orv.[VALUE], 1, 50)
from ORDER_REFERENCE_VALUE orv join REFERENCE r on orv.REFERENCE_ID = r.REFERENCE_ID
	join REFERENCE_TYPE rt on r.REFERENCE_TYPE_ID = rt.REFERENCE_TYPE_ID and rt.VALUE_TYPE = 'System.String[], mscorlib'
where 
	orv.[VALUE] is not null and orv.[VALUE] != ''	and len(orv.[VALUE]) < 50 and
	not exists (select * from REFERENCE_TYPE_PR_VALUE where REFERENCE_TYPE_ID = r.REFERENCE_TYPE_ID and lower(PREDEFINED_VALUE) = lower(orv.[VALUE]))

select distinct r.REFERENCE_TYPE_ID, substring(oirv.[VALUE], 1, 50)
from ORDER_ITEM_REFERENCE_VALUE oirv join REFERENCE r on oirv.REFERENCE_ID = r.REFERENCE_ID
	join REFERENCE_TYPE rt on r.REFERENCE_TYPE_ID = rt.REFERENCE_TYPE_ID and rt.VALUE_TYPE = 'System.String[], mscorlib'
where 
	oirv.[VALUE] is not null and oirv.[VALUE] != ''	and len(oirv.[VALUE]) < 50 and
	not exists (select * from REFERENCE_TYPE_PR_VALUE where REFERENCE_TYPE_ID = r.REFERENCE_TYPE_ID and lower(PREDEFINED_VALUE) = lower(oirv.[VALUE]))
	
--------------------------------------------------------------------------------------------------------
-- list of problem references of type 'Text'
select * from ORDER_REFERENCE_VALUE orv join REFERENCE r on orv.REFERENCE_ID = r.REFERENCE_ID and orv.VALUE is not null and orv.VALUE != ''
		and lower(orv.VALUE) not in ('true', 'false')
	join REFERENCE_TYPE rt on r.REFERENCE_TYPE_ID = rt.REFERENCE_TYPE_ID and rt.TYPE = 3

select * from ORDER_ITEM_REFERENCE_VALUE oirv join REFERENCE r on oirv.REFERENCE_ID = r.REFERENCE_ID and oirv.VALUE is not null and oirv.VALUE != ''
		and lower(oirv.VALUE) not in ('true', 'false')
	join REFERENCE_TYPE rt on r.REFERENCE_TYPE_ID = rt.REFERENCE_TYPE_ID and rt.TYPE = 3

-- list of problem refs of type 'Combo'
--select * from ORDER_ITEM_REFERENCE_VALUE orv join REFERENCE r on orv.REFERENCE_ID = r.REFERENCE_ID and orv.VALUE is not null and orv.VALUE != ''
--	join REFERENCE_TYPE rt on r.REFERENCE_TYPE_ID = rt.REFERENCE_TYPE_ID and rt.TYPE = 2
--	and orv.VALUE not in (select PREDEFINED_VALUE from REFERENCE_TYPE_PR_VALUE where REFERENCE_TYPE_ID = rt.REFERENCE_TYPE_ID)
--	join ORDER_ITEM oi on oi.ORDER_ITEM_ID = orv.ORDER_ITEM_ID
-- insert into REFERENCE_TYPE_PR_VALUE
select distinct r.REFERENCE_TYPE_ID, substring(orv.[VALUE], 1, 50), 'la170411', getdate(), 'la170411', getdate()
from ORDER_REFERENCE_VALUE orv join REFERENCE r on orv.REFERENCE_ID = r.REFERENCE_ID
	join REFERENCE_TYPE rt on r.REFERENCE_TYPE_ID = rt.REFERENCE_TYPE_ID and rt.TYPE = 2
where 
	orv.[VALUE] is not null and orv.[VALUE] != '' and len(orv.[VALUE]) < 50 and
	not exists (select * from REFERENCE_TYPE_PR_VALUE where REFERENCE_TYPE_ID = r.REFERENCE_TYPE_ID and lower(PREDEFINED_VALUE) = lower(orv.[VALUE]))

select distinct r.REFERENCE_TYPE_ID, substring(oirv.[VALUE], 1, 50), 'la170411', getdate(), 'la170411', getdate()
from ORDER_ITEM_REFERENCE_VALUE oirv join REFERENCE r on oirv.REFERENCE_ID = r.REFERENCE_ID
	join REFERENCE_TYPE rt on r.REFERENCE_TYPE_ID = rt.REFERENCE_TYPE_ID and rt.TYPE = 2
where 
	oirv.[VALUE] is not null and oirv.[VALUE] != ''	and len(oirv.[VALUE]) < 50 and
	not exists (select * from REFERENCE_TYPE_PR_VALUE where REFERENCE_TYPE_ID = r.REFERENCE_TYPE_ID and lower(PREDEFINED_VALUE) = lower(oirv.[VALUE]))

--select * from REFERENCE_TYPE_PR_VALUE order by 1 desc
--delete from REFERENCE_TYPE_PR_VALUE where CREATE_USER = 'la170411'
--select * from ORDER_REFERENCE_VALUE orv join REFERENCE r on orv.REFERENCE_ID = r.REFERENCE_ID and r.REFERENCE_TYPE_ID = 27 and orv.VALUE is not null

---
-- to run on UAT
declare @usr varchar(8) = 'la170418';
update REFERENCE_TYPE set UPDATE_USER = @usr, UPDATE_TIMESTAMP = getdate(), VALUE_TYPE = 'System.String, mscorlib' where REFERENCE_TYPE_ID in (5, 6, 7, 8, 13, 14) and VALUE_TYPE = 'System.Boolean, mscorlib'
update REFERENCE_TYPE set UPDATE_USER = @usr, UPDATE_TIMESTAMP = getdate(), VALUE_TYPE = 'System.String, mscorlib' where REFERENCE_TYPE_ID in (9, 10, 11, 12, 25, 28) and VALUE_TYPE = 'System.String[], mscorlib'
insert into REFERENCE_TYPE_PR_VALUE values (27, 'Export', @usr, getdate(), @usr, getdate()), (27, 'Import', @usr, getdate(), @usr, getdate())

---
-- to run on PRD
declare @usr varchar(8) = 'la170419';
update REFERENCE_TYPE set UPDATE_USER = @usr, UPDATE_TIMESTAMP = getdate(), TYPE = 1 where REFERENCE_TYPE_ID in (5, 6, 7, 8, 13, 14) and TYPE = 3
update REFERENCE_TYPE set UPDATE_USER = @usr, UPDATE_TIMESTAMP = getdate(), TYPE = 1 where REFERENCE_TYPE_ID in (9, 10, 11, 12, 25) and TYPE = 2
insert into REFERENCE_TYPE_PR_VALUE values (27, 'Export', @usr, getdate(), @usr, getdate()), (27, 'Import', @usr, getdate(), @usr, getdate())