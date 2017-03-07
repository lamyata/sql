-- 47585:Fuji - phase 1
-- 1/ Script to delete all stock of Fuji: delete all stock and related entities for owner ID = 515
-- 2/ Delete all products and related entities: delete all products linked to product group with code FUJI,
--      delete SIDs used in the products if not used in other products
--      delete all PP if not used in other products
--      delete product group with code FUJI
--3/ Delete all location below and including location with address '3'. ID = 2143
--      attached file can be used as a reference which locations should be deleted

--select * into bak_LOCATION from LOCATION                                                                           (41261 row(s) affected)
--select * into bak_STOCK from STOCK											(627240 row(s) affected)
--select * into bak_SIEQ from STOCK_INFO_EXTRA_QUANTITY															   (6367785 row(s) affected)
--select * into bak_SI from STOCK_INFO											(3218074 row(s) affected)
--select * into bak_SID from STORAGE_IDENTIFIER 																	    (69 row(s) affected)
--select * into bak_SIPV from STORAGE_IDENTIFIER_PR_VALUE						(3626 row(s) affected)
--select * into bak_PRODUCT from PRODUCT																			   (2956 row(s) affected)
--select * into bak_PRODUCT_PROPERTY from PRODUCT_PROPERTY						(66 row(s) affected)
--select * into bak_PPPV from PRODUCT_PROPERTY_PR_VALUE															  (56 row(s) affected)


declare @fujiCompanyCode nvarchar(20) = 'FUJI'
declare @fujiId int = (select COMPANYNR from COMPANY where CODE = @fujiCompanyCode);

declare @sic table (ID int)
insert into @sic
 select STOCK_INFO_CONFIG_ID
 from STOCK_INFO_CONFIG where OWNER_ID = @fujiId
 
declare @si table (ID int)
insert into @si
 select si.STOCK_INFO_ID
 from STOCK_INFO si
 join @sic sic on si.STOCK_INFO_CONFIG_ID = sic.ID

delete s
 from STOCK s
 join @si si on s.STOCK_INFO_ID = si.ID

declare @sieq table (ID int)
 delete sieq
 output deleted.STOCK_INFO_QUANTITY_ID into @sieq
 from STOCK_INFO_EXTRA_QUANTITY sieq
 join @si si on sieq.STOCK_INFO_ID = si.ID;
 
delete siceu
 from STOCK_INFO_CONFIG_EXTRA_UNIT siceu
 join @sic sic on siceu.STOCK_INFO_CONFIG_ID = sic.ID;
 
delete sis
 from STOCK_INFO_SID sis
 join @sic sic on sis.STOCK_INFO_CONFIG_ID = sic.ID;

delete siri
 from STOCK_INVENTORY_REQUEST_ITEM siri
 join @si si on siri.STOCK_INFO_ID = si.ID

declare @q table (BASE_QUANTITY_ID int, STORAGE_QUANTITY_ID int)
delete si
 output deleted.BASE_QUANTITY_ID, deleted.STORAGE_QUANTITY_ID into @q (BASE_QUANTITY_ID, STORAGE_QUANTITY_ID)
 from STOCK_INFO si
 join @si s on si.STOCK_INFO_ID = s.ID;

delete sic
 from STOCK_INFO_CONFIG sic
 join @sic s on sic.STOCK_INFO_CONFIG_ID = s.ID;
 
delete siq
 from STOCK_INFO_QUANTITY siq
 join @q q on (siq.STOCK_INFO_QUANTITY_ID = q.BASE_QUANTITY_ID or siq.STOCK_INFO_QUANTITY_ID = q.STORAGE_QUANTITY_ID);

delete siq
 from STOCK_INFO_QUANTITY siq
 join @sieq s on siq.STOCK_INFO_QUANTITY_ID = s.ID;

-- delete prods 
declare @fujiProductGroupCode nvarchar(20) = 'FUJI'
declare @fujiProductGroupId int = (select PRODUCT_GROUP_ID from PRODUCT_GROUP where CODE = @fujiProductGroupCode);

DECLARE @IntCompany INT = 299

PRINT('SELECT IDs for all products for selected internal company and product group')
SELECT distinct pic.PRODUCT_ID
INTO #ProductIds
FROM PRODUCT_INT_COMPANY pic JOIN PRODUCT_GROUP_PRODUCT pgp ON pic.PRODUCT_ID = pgp.PRODUCT_ID
	AND pic.INT_COMPANYNR = @IntCompany
	--AND PRODUCT_ID NOT IN (SELECT PRODUCT_ID FROM STOCK_INFO_CONFIG)
	AND pgp.PRODUCT_GROUP_ID = @fujiProductGroupId	

PRINT('delete relations to internal companies')
DELETE FROM PRODUCT_INT_COMPANY
WHERE PRODUCT_ID IN 
	(SELECT PRODUCT_ID FROM #ProductIds)

PRINT('delete relations to customers')
DELETE FROM PRODUCT_COMPANY
WHERE PRODUCT_ID IN 
	(SELECT PRODUCT_ID FROM #ProductIds)

PRINT('delete relations to product groups')
DELETE FROM PRODUCT_GROUP_PRODUCT
WHERE PRODUCT_ID IN 
	(SELECT PRODUCT_ID FROM #ProductIds)

PRINT ('delete relations to product locations')
DELETE FROM PRODUCT_LOCATION
WHERE PRODUCT_ID IN 
	(SELECT PRODUCT_ID FROM #ProductIds)

PRINT ('delete relations to SID operation types')
DELETE FROM PRODUCT_SID_OPERATION_TYPE
WHERE PRODUCT_SID_ID IN (
	SELECT PRODUCT_STORAGE_IDENTIFIER_ID
	FROM PRODUCT_STORAGE_IDENTIFIER
	WHERE PRODUCT_ID IN 
		(SELECT PRODUCT_ID FROM #ProductIds))

PRINT('Select Sid Ids')
SELECT PRODUCT_STORAGE_IDENTIFIER_ID
INTO #Sids
FROM PRODUCT_STORAGE_IDENTIFIER
WHERE PRODUCT_ID IN 
	(SELECT PRODUCT_ID FROM #ProductIds)

PRINT('Delete Product Sids predefined values')
DELETE FROM PRODUCT_SID_SID_VALUE
WHERE PRODUCT_SID_ID IN (SELECT PRODUCT_STORAGE_IDENTIFIER_ID FROM #Sids)

PRINT ('delete Product SID values')
DELETE FROM PRODUCT_STORAGE_IDENTIFIER
WHERE PRODUCT_ID IN 
	(SELECT PRODUCT_ID FROM #ProductIds)

DELETE sipv
FROM STORAGE_IDENTIFIER_PR_VALUE sipv
	join PRODUCT_STORAGE_IDENTIFIER psi on sipv.SID_ID = psi.SID_ID
	and PRODUCT_ID in (select PRODUCT_ID from #ProductIds)
	and PRODUCT_ID not in (select PRODUCT_ID from PRODUCT where PRODUCT_ID not in (select PRODUCT_ID from #ProductIds))
	
delete si
	from STORAGE_IDENTIFIER si join PRODUCT_STORAGE_IDENTIFIER psi on si.STORAGE_IDENTIFIER_ID = psi.SID_ID
	and psi.PRODUCT_ID in (select PRODUCT_ID from #ProductIds)
	and psi.PRODUCT_ID not in (select PRODUCT_ID from PRODUCT where PRODUCT_ID not in (select PRODUCT_ID from #ProductIds))
	
PRINT ('delete Product properties')
DELETE FROM PRODUCT_PROPERTY_VALUE
WHERE PRODUCT_ID IN 
	(SELECT PRODUCT_ID FROM #ProductIds)

DELETE pppv
	from PRODUCT_PROPERTY_PR_VALUE pppv join PRODUCT_PROPERTY_VALUE ppv on pppv.PRODUCT_PROPERTY_ID = ppv.PRODUCT_PROPERTY_ID
	and ppv.PRODUCT_ID in (select PRODUCT_ID from #ProductIds)
	and ppv.PRODUCT_ID not in (select PRODUCT_ID from PRODUCT where PRODUCT_ID not in (select PRODUCT_ID from #ProductIds))
	
DELETE pp
	from PRODUCT_PROPERTY pp join PRODUCT_PROPERTY_VALUE ppv on pp.PRODUCT_PROPERTY_ID = ppv.PRODUCT_PROPERTY_ID
	and ppv.PRODUCT_ID in (select PRODUCT_ID from #ProductIds)
	and ppv.PRODUCT_ID not in (select PRODUCT_ID from PRODUCT where PRODUCT_ID not in (select PRODUCT_ID from #ProductIds))

PRINT ('Select IDs of Product Base Units')
SELECT BASE_UNIT_ID 
INTO #BaseUnits
FROM PRODUCT
WHERE PRODUCT_ID IN (SELECT PRODUCT_ID FROM #ProductIds)

PRINT('Select IDs of Product Extra Units')
SELECT EXTRA_UNIT_ID
INTO #ExtraUnits
FROM PRODUCT_EXTRA_UNIT
WHERE PRODUCT_ID IN (SELECT PRODUCT_ID FROM #ProductIds)

PRINT('Delete references to Extra Units')
DELETE FROM PRODUCT_EXTRA_UNIT
WHERE PRODUCT_ID IN (SELECT PRODUCT_ID FROM #ProductIds)

PRINT('Select IDs of Product Storage Units')
SELECT STORAGE_UNIT_ID
INTO #StorageUnits
FROM PRODUCT_STORAGE_UNIT
WHERE PRODUCT_ID IN (SELECT PRODUCT_ID FROM #ProductIds)

PRINT('Delete references to Storage Units')
DELETE FROM PRODUCT_STORAGE_UNIT
WHERE PRODUCT_ID IN (SELECT PRODUCT_ID FROM #ProductIds)

PRINT('Delete Product Extra units')
DELETE FROM PRODUCT_UNIT
WHERE PRODUCT_UNIT_ID IN (SELECT EXTRA_UNIT_ID FROM #ExtraUnits)

PRINT('Delete Product Storage units')
DELETE FROM PRODUCT_UNIT
WHERE PRODUCT_UNIT_ID IN (SELECT STORAGE_UNIT_ID FROM #StorageUnits)

PRINT('Delete Products')
DELETE FROM PRODUCT
WHERE PRODUCT_ID IN (SELECT PRODUCT_ID FROM #ProductIds)

PRINT('Delete Product Base units')
DELETE FROM PRODUCT_UNIT
WHERE PRODUCT_UNIT_ID IN (SELECT BASE_UNIT_ID FROM #BaseUnits)

delete from PRODUCT_GROUP where PRODUCT_GROUP_ID = @fujiProductGroupId

DROP TABLE #ProductIds
DROP TABLE #BaseUnits
DROP TABLE #ExtraUnits
DROP TABLE #StorageUnits
DROP TABLE #Sids

-- delete fuji locations
declare @ParentLocationId int = 2143
declare @LocationIds table (ID int, PARENT_ID int)
;with cte as
(
select *
 from [LOCATION]
 where LOCATION_ID=@ParentLocationId
 union all
 select [LOCATION].*
 from [LOCATION]
 join cte on [LOCATION].PARENT_ID=cte.LOCATION_ID
)
insert into @LocationIds select LOCATION_ID, PARENT_ID from cte;

declare @NonFujiStockLocationIds table (ID int)
;with cte as
(
select l.* from @LocationIds l join STOCK_INFO_CONFIG sic on l.ID = sic.LOCATION_ID and sic.OWNER_ID != 515
union all
select l1.* from @LocationIds l1 join cte on l1.ID = cte.PARENT_ID
)
insert into @NonFujiStockLocationIds select distinct ID from cte;
--exclude locations used for stock of other owners
delete l from @LocationIds l join @NonFujiStockLocationIds n on l.ID = n.ID;
delete lic from LOCATION_INTERNAL_COMPANY lic join @LocationIds locs on lic.LOCATION_ID = locs.ID
delete l from [LOCATION] l join @LocationIds locs on l.LOCATION_ID = locs.ID; 


/*
-- locations used in stock for owner other than 'Fuji'
declare @ParentLocationId int = 2143
declare @LocationIds table (ID int, PARENT_ID int)
;with cte as
(
select *
 from [LOCATION]
 where LOCATION_ID=@ParentLocationId
 union all
 select [LOCATION].*
 from [LOCATION]
 join cte on [LOCATION].PARENT_ID=cte.LOCATION_ID
)
insert into @LocationIds select LOCATION_ID, PARENT_ID from cte;

--select * from @LocationIds l join STOCK_INFO_CONFIG sic on l.ID = sic.LOCATION_ID and sic.OWNER_ID != 515
declare @NonFujiStockLocationIds table (ID int)
;with cte as
(
select l.* from @LocationIds l join STOCK_INFO_CONFIG sic on l.ID = sic.LOCATION_ID and sic.OWNER_ID != 515
union all
select l1.* from @LocationIds l1 join cte on l1.ID = cte.PARENT_ID
)
insert into @NonFujiStockLocationIds select distinct ID from cte;
--locations used for stock of other owners
select * from @NonFujiStockLocationIds;

2143
2160
19854
19855
66599
93245
*/