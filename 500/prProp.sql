select p.PRODUCT_ID, p.CODE, p.SHORT_DESC,
	stuff((select ', ' + CODE from PRODUCT_GROUP pg join PRODUCT_GROUP_PRODUCT pgp on pg.PRODUCT_GROUP_ID = pgp.PRODUCT_GROUP_ID and pgp.PRODUCT_ID = ppv.PRODUCT_ID for XML PATH('')), 1, 2, '') as PRD_GROUPs,
	IsNull(stuff((select ', ' + NAME from PRODUCT_COMPANY pc join COMPANY c on pc.COMPANY_ID = c.COMPANY_ID and pc.PRODUCT_ID = ppv.PRODUCT_ID for XML PATH('')), 1, 2, ''),'') as CUSTRs,
	pp.PRODUCT_PROPERTY_ID PP_ID, pp.CODE PP_CODE, pp.NAME PP_NAME, ppv.PROPERTY_VALUE,
	case pp.TYPE when 0 then 'FreeText' when 1 then 'Combo' when 2 then 'Checkbox' when 3 then 'LookUpCustomer' end PP_TYPE,
	IsNull(stuff((select ', ' + PREDEFINED_VALUE from PRODUCT_PROPERTY_PR_VALUE ppv where ppv.PRODUCT_PROPERTY_ID = pp.PRODUCT_PROPERTY_ID for XML PATH('')), 1, 2, ''),'') as PR_VALs
from PRODUCT_PROPERTY_VALUE ppv join PRODUCT p on ppv.PRODUCT_ID = p.PRODUCT_ID
    join PRODUCT_PROPERTY pp on ppv.PRODUCT_PROPERTY_ID = pp.PRODUCT_PROPERTY_ID
    order by 1
	
--
declare @pp table (id int)
insert into @pp select distinct pp.PRODUCT_PROPERTY_ID
from PRODUCT_PROPERTY pp join PRODUCT_PROPERTY_VALUE ppv on pp.PRODUCT_PROPERTY_ID = ppv.PRODUCT_PROPERTY_ID
where pp.TYPE = 0

declare @p table (id int, pp_num int)
insert into @p
select ppv.PRODUCT_ID, count(*)
from PRODUCT_PROPERTY_VALUE ppv join @pp pp on ppv.PRODUCT_PROPERTY_ID = pp.id
group by ppv.PRODUCT_ID

select p.PRODUCT_ID, p.CODE, p.SHORT_DESC,
	stuff((select ', ' + CODE from PRODUCT_GROUP pg join PRODUCT_GROUP_PRODUCT pgp on pg.PRODUCT_GROUP_ID = pgp.PRODUCT_GROUP_ID and pgp.PRODUCT_ID = p.PRODUCT_ID for XML PATH('')), 1, 2, '') as PRD_GROUPs,
	IsNull(stuff((select ', ' + NAME from PRODUCT_COMPANY pc join COMPANY c on pc.COMPANY_ID = c.COMPANY_ID and pc.PRODUCT_ID = p.PRODUCT_ID for XML PATH('')), 1, 2, ''),'') as CUSTRs,
	stuff((select '|' + prpr.NAME + '__' + prpr.CODE + '|' + IsNull(ppv1.PROPERTY_VALUE, '**Not present**') from @pp pp 
		join PRODUCT_PROPERTY prpr on pp.id = prpr.PRODUCT_PROPERTY_ID
		left join PRODUCT_PROPERTY_VALUE ppv1 on pp.id = ppv1.PRODUCT_PROPERTY_ID and ppv1.PRODUCT_ID = p.PRODUCT_ID order by 1 for XML PATH('')), 1, 1, '') as PPs
from PRODUCT p join @p p1 on p.PRODUCT_ID = p1.id
    order by 1