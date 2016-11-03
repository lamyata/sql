select p.PRODUCT_ID, p.CODE, p.SHORT_DESC, p.BASE_UNIT_ID, 
	bu.UNIT_ID as 'BASE.UNIT.ID', u.CODE as 'BASE.UNIT.CODE', 
	psu.STORAGE_UNIT_ID, su.UNIT_ID as 'STORAGE.UNIT.ID', u0.CODE as 'STORAGE.UNIT.CODE', su.COEF as 'STORAGE_UNIT.COEFF',
	peu1.EXTRA_UNIT_ID, pu1.UNIT_ID, u1.CODE, pu1.COEF, pu1.DEFAULT_MEASUREMENT_UNIT_ID, mu1.[DESCRIPTION],
	peu2.EXTRA_UNIT_ID, pu2.UNIT_ID, u2.CODE, pu2.COEF, pu2.DEFAULT_MEASUREMENT_UNIT_ID, mu2.[DESCRIPTION]
from PRODUCT p join PRODUCT_INT_COMPANY pic on p.PRODUCT_ID = pic.PRODUCT_ID join COMPANY c on pic.INT_COMPANYNR = c.COMPANYNR
	join PRODUCT_UNIT bu on p.BASE_UNIT_ID = bu.PRODUCT_UNIT_ID
	join UNIT u on bu.UNIT_ID = u.UNIT_ID
	join PRODUCT_STORAGE_UNIT psu on p.PRODUCT_ID = psu.PRODUCT_ID join PRODUCT_UNIT su on psu.STORAGE_UNIT_ID = su.PRODUCT_UNIT_ID
	join UNIT u0 on su.UNIT_ID = u0.UNIT_ID
	join PRODUCT_EXTRA_UNIT peu1 on p.PRODUCT_ID = peu1.PRODUCT_ID join PRODUCT_UNIT pu1 on peu1.EXTRA_UNIT_ID = pu1.PRODUCT_UNIT_ID
	join UNIT u1 on pu1.UNIT_ID = u1.UNIT_ID join MEASUREMENT_UNIT mu1 on pu1.DEFAULT_MEASUREMENT_UNIT_ID = mu1.MEASUREMENT_UNIT_ID
	join PRODUCT_EXTRA_UNIT peu2 on p.PRODUCT_ID = peu2.PRODUCT_ID join PRODUCT_UNIT pu2 on peu2.EXTRA_UNIT_ID = pu2.PRODUCT_UNIT_ID
	join UNIT u2 on pu2.UNIT_ID = u2.UNIT_ID join MEASUREMENT_UNIT mu2 on pu2.DEFAULT_MEASUREMENT_UNIT_ID = mu2.MEASUREMENT_UNIT_ID
where c.CODE = 'IC_ACV' and u1.CODE = 'Gross' and u2.CODE = 'Net'
----above query is wrong, correct one follows
create table #Prods (PRODUCT_ID int, CODE nvarchar(50), SHORT_DESC nvarchar(50), BASEUNIT_ID int, BASE_UNITID int, BASE_UNITCODE nvarchar(50),
	STORAGEUNIT_ID int, STORAGE_UNITID int, STORAGE_UNITCODE nvarchar(50), STORAGEUNIT_COEFF decimal(16,8),
	EXTRA1_ID int, EXTRA1_UNITID int, EXTRA1_UNITCODE nvarchar(50), EXTRA1_COEFF decimal(16,8), EXTRA1_MU_ID int, EXTRA1_MUDESCR nvarchar(50),
	EXTRA2_ID int, EXTRA2_UNITID int, EXTRA2_UNITCODE nvarchar(50), EXTRA2_COEFF decimal(16,8), EXTRA2_MU_ID int, EXTRA2_MUDESCR nvarchar(50))

insert into #Prods(PRODUCT_ID, CODE, SHORT_DESC, BASEUNIT_ID, BASE_UNITID, BASE_UNITCODE, STORAGEUNIT_ID, STORAGE_UNITID, STORAGE_UNITCODE, STORAGEUNIT_COEFF)
select p.PRODUCT_ID, p.CODE, p.SHORT_DESC, p.BASE_UNIT_ID, 
	bu.UNIT_ID, u.CODE, psu.STORAGE_UNIT_ID, pu.UNIT_ID , u2.CODE , pu.COEF --,
from PRODUCT p join PRODUCT_INT_COMPANY pic on p.PRODUCT_ID = pic.PRODUCT_ID join COMPANY c on pic.INT_COMPANYNR = c.COMPANYNR
	join PRODUCT_UNIT bu on p.BASE_UNIT_ID = bu.PRODUCT_UNIT_ID
	join UNIT u on bu.UNIT_ID = u.UNIT_ID
	left join PRODUCT_STORAGE_UNIT psu on p.PRODUCT_ID = psu.PRODUCT_ID left join PRODUCT_UNIT pu on psu.STORAGE_UNIT_ID = pu.PRODUCT_UNIT_ID
	left join UNIT u2 on pu.UNIT_ID = u2.UNIT_ID
where c.CODE = 'IC_ACV' and p.STATUS = 1 

update p set EXTRA1_ID = peu.EXTRA_UNIT_ID, EXTRA1_UNITID = u.UNIT_ID, EXTRA1_UNITCODE = u.CODE, EXTRA1_COEFF = pu.COEF, EXTRA1_MU_ID = mu.MEASUREMENT_UNIT_ID, EXTRA1_MUDESCR = mu.[DESCRIPTION]
from #Prods p join PRODUCT_EXTRA_UNIT peu on p.PRODUCT_ID = peu.PRODUCT_ID join PRODUCT_UNIT pu on peu.EXTRA_UNIT_ID = pu.PRODUCT_UNIT_ID
	join UNIT u on pu.UNIT_ID = u.UNIT_ID left join MEASUREMENT_UNIT mu on pu.DEFAULT_MEASUREMENT_UNIT_ID = mu.MEASUREMENT_UNIT_ID
	where u.CODE = 'Gross'

update p set EXTRA2_ID = peu.EXTRA_UNIT_ID, EXTRA2_UNITID = u.UNIT_ID, EXTRA2_UNITCODE = u.CODE, EXTRA2_COEFF = pu.COEF, EXTRA2_MU_ID = mu.MEASUREMENT_UNIT_ID, EXTRA2_MUDESCR = mu.[DESCRIPTION]
from #Prods p join PRODUCT_EXTRA_UNIT peu on p.PRODUCT_ID = peu.PRODUCT_ID join PRODUCT_UNIT pu on peu.EXTRA_UNIT_ID = pu.PRODUCT_UNIT_ID
	join UNIT u on pu.UNIT_ID = u.UNIT_ID left join MEASUREMENT_UNIT mu on pu.DEFAULT_MEASUREMENT_UNIT_ID = mu.MEASUREMENT_UNIT_ID
	where u.CODE = 'Net'
	
select * from #Prods