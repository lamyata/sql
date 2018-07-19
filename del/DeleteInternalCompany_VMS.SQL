CREATE TYPE Ids AS TABLE(ID int)
GO

-- The procedure does not delete FINANCIAL_LINE data
CREATE PROC DeleteTransports(@transportIds Ids READONLY)
AS
DECLARE @attachmentIds table
(
	ATTACHMENT_ID int
)
DECLARE @httpLogItemIds table
(
	HTTP_LOG_ITEM_ID int
)
BEGIN
	PRINT 'Delete TRANSPORT_PROPERTY_VALUE'
	delete from TRANSPORT_PROPERTY_VALUE
	where TRANSPORT_ID in(select ID from @transportIds)

	PRINT 'Delete TRANSPORT_ATTACHMENT'
	delete from TRANSPORT_ATTACHMENT
	output deleted.ATTACHMENT_ID into @attachmentIds(ATTACHMENT_ID)
	where TRANSPORT_ID in(select ID from @transportIds)

	delete a from ATTACHMENT a join @attachmentIds ai on a.ATTACHMENT_ID = ai.ATTACHMENT_ID

	PRINT 'Delete TRANSPORT_HTTP_LOG_ITEM'
	delete from TRANSPORT_HTTP_LOG_ITEM
	output deleted.HTTP_LOG_ITEM_ID into @httpLogItemIds(HTTP_LOG_ITEM_ID)
	where TRANSPORT_ID in(select ID from @transportIds)

	delete hli from HTTP_LOG_ITEM hli join @httpLogItemIds li on hli.HTTP_LOG_ITEM_ID = li.HTTP_LOG_ITEM_ID

	PRINT 'Delete LASHING_MATERIAL_QUANTITY'
	delete from LASHING_MATERIAL_QUANTITY where TRANSPORT_ID in(select ID from @transportIds)

	delete from TRANSPORT where TRANSPORT_ID in(select ID from @transportIds)
END
GO

-- The procedure does not delete FINANCIAL_LINE data
CREATE PROC DeleteOrderItemCollections(@OrderItemIds Ids READONLY)
AS
BEGIN
PRINT 'Delete ORDER_ITEM_REFERENCE_VALUE'
delete from ORDER_ITEM_REFERENCE_VALUE where ORDER_ITEM_ID in(select ID from @OrderItemIds)

PRINT 'Delete PARTNER_ADDRESS'
declare @partnerAddresses table(PARTNER_ADDRESS_ID int)
delete from ORDER_ITEM_PARTNER_ADDRESS
output deleted.PARTNER_ADDRESS_ID into @partnerAddresses(PARTNER_ADDRESS_ID)
where ORDER_ITEM_ID in(select ID from @OrderItemIds)

declare @addresses table(ADDRESS_ID int)
delete pa 
output deleted.ADDRESS_ID into @addresses(ADDRESS_ID)
from PARTNER_ADDRESS pa join @partnerAddresses a on pa.PARTNER_ADDRESS_ID = a.PARTNER_ADDRESS_ID

PRINT 'Delete ADDRESS'
declare @communications table(COMMUNICATION_ID int)
delete ac 
output deleted.COMMUNICATION_ID into @communications(COMMUNICATION_ID)
from ADDRESS_COMMUNICATION ac join @addresses a on ac.ADDRESS_ID = a.ADDRESS_ID

delete from COMMUNICATION where COMMUNICATION_ID in(select COMMUNICATION_ID from @communications)
delete from dbo.ADDRESS where ADDRESS_ID in(select ADDRESS_ID from @addresses)

PRINT 'Delete OPERATION_INSTRUCTION'
delete from OPERATION_INSTRUCTION where ORDER_ITEM_ID in(select ID from @OrderItemIds)

PRINT 'Delete ATTACHMENTS'
declare @attachments table(ATTACHMENT_ID int)
delete from ORDER_ITEM_ATTACHMENT
output deleted.ATTACHMENT_ID into @attachments(ATTACHMENT_ID)
where ORDER_ITEM_ID in(select ID from @OrderItemIds)

delete a from ATTACHMENT a join @attachments at on a.ATTACHMENT_ID = at.ATTACHMENT_ID

PRINT 'Delete HTTP_LOG_ITEM'
declare @logItems table(HTTP_LOG_ITEM_ID int)
delete from ORDER_ITEM_HTTP_LOG_ITEM
output deleted.HTTP_LOG_ITEM_ID into @logItems(HTTP_LOG_ITEM_ID)
where ORDER_ITEM_ID in(select ID from @OrderItemIds)

delete hli from HTTP_LOG_ITEM hli join @logItems li on hli.HTTP_LOG_ITEM_ID = li.HTTP_LOG_ITEM_ID 

PRINT 'Delete OBSTRUCTIONS'
declare @obstructions table(OBSTRUCTION_OCCURENCE_ID int)
delete from ORDER_ITEM_OBSTRUCTION
output deleted.OBSTRUCTION_OCCURENCE_ID into @obstructions(OBSTRUCTION_OCCURENCE_ID)
where ORDER_ITEM_ID in(select ID from @OrderItemIds)

delete oo from OBSTRUCTION_OCCURENCE oo join @obstructions o on oo.OBSTRUCTION_OCCURENCE_ID =  o.OBSTRUCTION_OCCURENCE_ID
END
GO

CREATE PROC DeleteOrderCollections(@orderIds Ids READONLY)
AS
BEGIN
	PRINT 'Delete ORDER_TRANSPORT'
	delete from ORDER_TRANSPORT where ORDER_ID in(select ID from @orderIds)

	PRINT 'Delete ORDER_REFERENCE_VALUE'
	delete from ORDER_REFERENCE_VALUE where ORDER_ID in(select ID from @orderIds)

	PRINT 'Delete ORDER_OBSTRUCTION'
	declare @obstructions table(OBSTRUCTION_OCCURENCE_ID int)
	delete from ORDER_OBSTRUCTION
	output deleted.OBSTRUCTION_OCCURENCE_ID into @obstructions(OBSTRUCTION_OCCURENCE_ID)
	where ORDER_ID in(select ID from @orderIds)

	delete oo from OBSTRUCTION_OCCURENCE oo join @obstructions o on oo.OBSTRUCTION_OCCURENCE_ID =  o.OBSTRUCTION_OCCURENCE_ID

	PRINT 'Delete OPERATION_ORDER_INSTRUCTION'
	delete from OPERATION_ORDER_INSTRUCTION where ORDER_ID in(select ID from @orderIds)

	PRINT 'Delete ORDER_ATTACHMENT'
	declare @attachments table(ATTACHMENT_ID int)
	delete from ORDER_ATTACHMENT
	output deleted.ATTACHMENT_ID into @attachments(ATTACHMENT_ID)
	where ORDER_ID in(select ID from @orderIds)

	delete a from ATTACHMENT a join @attachments at on a.ATTACHMENT_ID = at.ATTACHMENT_ID

	PRINT 'Delete PARTNER_ADDRESS'
	declare @partnerAddresses table(PARTNER_ADDRESS_ID int)
	delete from ORDER_PARTNER_ADDRESS
	output deleted.PARTNER_ADDRESS_ID into @partnerAddresses(PARTNER_ADDRESS_ID)
	where ORDER_ID in(select ID from @orderIds)

	declare @addresses table(ADDRESS_ID int)
	delete pa 
	output deleted.ADDRESS_ID into @addresses(ADDRESS_ID)
	from PARTNER_ADDRESS pa join @partnerAddresses a on pa.PARTNER_ADDRESS_ID = a.PARTNER_ADDRESS_ID

	PRINT 'Delete ADDRESS'
	declare @communications table(COMMUNICATION_ID int)
	delete ac 
	output deleted.COMMUNICATION_ID into @communications(COMMUNICATION_ID)
	from ADDRESS_COMMUNICATION ac join @addresses a on ac.ADDRESS_ID = a.ADDRESS_ID

	delete from COMMUNICATION where COMMUNICATION_ID in(select COMMUNICATION_ID from @communications)
	delete from dbo.ADDRESS where ADDRESS_ID in(select ADDRESS_ID from @addresses)
END
GO

-- The procedure does not delete FINANCIAL_LINE data, VAS, TARIFF related data and CUSTOMS related data
CREATE PROC DeleteOperationalData(@companyCode nvarchar(50))
AS
BEGIN

declare @companyId int = (select COMPANY_ID from COMPANY where LOWER(CODE) = LOWER(@companyCode))
if @companyId is null
BEGIN
	print 'COMPANY with CODE: ' + @companyCode + ' not found'
		;THROW 51000, 'Invalid Company Code', 1;
END

declare @dischargingOIs table
(
	ORDER_ITEM_ID INT
)
declare @loadingOIs table
(
	ORDER_ITEM_ID INT
)
declare @stockChangeOIs table
(
	ORDER_ITEM_ID INT
)

print 'Collect all OI ids'
insert into @dischargingOIs
select oi.ORDER_ITEM_ID from ORDER_ITEM oi join DISCHARGING_ORDER_ITEM doi on oi.ORDER_ITEM_ID = doi.DISCHARGING_ORDER_ITEM_ID join ORDERS o on oi.ORDER_ID = o.ORDER_ID
where o.INTERNAL_COMPANY_ID = @companyId

insert into @loadingOIs
select oi.ORDER_ITEM_ID from ORDER_ITEM oi join LOADING_ORDER_ITEM loi on oi.ORDER_ITEM_ID = loi.LOADING_ORDER_ITEM_ID join ORDERS o on oi.ORDER_ID = o.ORDER_ID
where o.INTERNAL_COMPANY_ID = @companyId

insert into @stockChangeOIs
select oi.ORDER_ITEM_ID from ORDER_ITEM oi join STOCK_CHANGE_ORDER_ITEM scoi on oi.ORDER_ITEM_ID = scoi.STOCK_CHANGE_ORDER_ITEM_ID join ORDERS o on oi.ORDER_ID = o.ORDER_ID
where o.INTERNAL_COMPANY_ID = @companyId

BEGIN TRY
	BEGIN TRANSACTION
--------------------- DISCHARGING_ORDER_ITEM -------------------------------------
declare @contextIdsD table (
	OPERATION_CONTEXT_ID int
)

print 'Deliting DISCHARGING OPERATION REPORTS'
-- DISCHARGING O REPORT
delete dor from DISCHARGING_OPERATION_REPORT dor
	join OPERATION_REPORT r on dor.DISCHARGING_OPERATION_REPORT_ID = r.OPERATION_REPORT_ID
	where r.ORDER_ITEM_ID IN(select ORDER_ITEM_ID from @dischargingOIs)

delete from OPERATION_REPORT
output deleted.CONTEXT_ID into @contextIdsD(OPERATION_CONTEXT_ID)
where ORDER_ITEM_ID IN(select ORDER_ITEM_ID from @dischargingOIs)

print 'Deliting DISCHARGING OPERATION PLANS'
-- DISCHARGING O PLAN
delete dop from DISCHARGING_OPERATION_PLAN dop
	join OPERATION_PLAN op on dop.DISCHARGING_OPERATION_PLAN_ID = op.OPERATION_PLAN_ID
	where op.ORDER_ITEM_ID IN(select ORDER_ITEM_ID from @dischargingOIs)

delete from OPERATION_PLAN
output deleted.CONTEXT_ID into @contextIdsD(OPERATION_CONTEXT_ID)
where ORDER_ITEM_ID IN(select ORDER_ITEM_ID from @dischargingOIs)

print 'Deliting DISCHARGING OPERATION CONTEXTS'
-- OPERATION CONTEXT
delete from OPERATION_CONTEXT where OPERATION_CONTEXT_ID IN(select OPERATION_CONTEXT_ID from @contextIdsD)

print 'Deliting DISCHARGING ORDER ITEM collections'
-- ORDER_ITEM collections
declare @dischargingOrderItemIds Ids
insert into @dischargingOrderItemIds (ID)
select ORDER_ITEM_ID from @dischargingOIs
EXEC DeleteOrderItemCollections @dischargingOrderItemIds

print 'Deliting DISCHARGING ORDER ITEM Goods link'
delete from DISCHARGING_ORDER_ITEM_GOODS where DISCHARGING_ORDER_ITEM_ID IN(select ORDER_ITEM_ID from @dischargingOIs)

print 'Deliting DISCHARGING ORDER ITEMS'
-- DISCHARGING_ORDER_ITEM
delete from DISCHARGING_ORDER_ITEM where DISCHARGING_ORDER_ITEM_ID IN(select ORDER_ITEM_ID from @dischargingOIs)
delete from ORDER_ITEM where ORDER_ITEM_ID IN(select ORDER_ITEM_ID from @dischargingOIs)
----------------------------------------------------------------------------------

--------------------- LOADING_ORDER_ITEM -----------------------------------------
declare @contextIdsL table (
	OPERATION_CONTEXT_ID int
);

print 'Deliting LOADING OPERATION REPORTS'
-- LOADING O REPORT
delete lor from LOADING_OPERATION_REPORT lor
	join OPERATION_REPORT r on lor.LOADING_OPERATION_REPORT_ID = r.OPERATION_REPORT_ID
	where r.ORDER_ITEM_ID IN(select ORDER_ITEM_ID from @loadingOIs)

delete from OPERATION_REPORT
output deleted.CONTEXT_ID into @contextIdsL(OPERATION_CONTEXT_ID)
where ORDER_ITEM_ID IN(select ORDER_ITEM_ID from @loadingOIs)

print 'Deliting LOADING OI PICKING LISTS'
-- OI PICKING_LIST
declare @pickingIds table(PICKING_LIST_ID int)
delete oipl 
output deleted.PICKING_LIST_ID into @pickingIds(PICKING_LIST_ID)
from ORDER_ITEM_PICKING_LIST oipl join ORDER_ITEM oi on oi.ORDER_ITEM_ID = oipl.ORDER_ITEM_ID 
where oipl.ORDER_ITEM_ID IN(select ORDER_ITEM_ID from @loadingOIs)

declare @preparedIds table(PREPARED_GOOD_ID int)
insert into @preparedIds
select plpg.PREPARED_GOOD_ID from PICKING_LIST_PREPARED_GOOD plpg join @pickingIds p on plpg.PICKING_LIST_ID = p.PICKING_LIST_ID

delete plpg from PICKING_LIST_PREPARED_GOOD plpg join @pickingIds p on plpg.PICKING_LIST_ID = p.PICKING_LIST_ID

delete pg from PREPARED_GOOD pg join @preparedIds p on pg.PREPARED_GOOD_ID = p.PREPARED_GOOD_ID

delete plop from PICKING_LIST_OPERATION_PLAN plop join @pickingIds p on plop.PICKING_LIST_ID = p.PICKING_LIST_ID

delete from PICKING_LIST where PICKING_LIST_ID IN(select PICKING_LIST_ID from @pickingIds)

print 'Deliting LOADING OPERATION PLANS'
-- LOADING O PLAN
delete lop from LOADING_OPERATION_PLAN lop
	join OPERATION_PLAN op on lop.LOADING_OPERATION_PLAN_ID = op.OPERATION_PLAN_ID
	where op.ORDER_ITEM_ID IN(select ORDER_ITEM_ID from @loadingOIs)

delete from OPERATION_PLAN
output deleted.CONTEXT_ID into @contextIdsL(OPERATION_CONTEXT_ID)
where ORDER_ITEM_ID IN(select ORDER_ITEM_ID from @loadingOIs)

print 'Deliting LOADING OPERATION CONTEXTS'
delete oc from OPERATION_CONTEXT oc join @contextIdsL c on oc.OPERATION_CONTEXT_ID = c.OPERATION_CONTEXT_ID

print 'Deliting LOADING ORDER ITEM collections'
	-- ORDER_ITEM collections
declare @loadingOrderItemIds Ids
insert into @loadingOrderItemIds (ID)
select ORDER_ITEM_ID from @loadingOIs
EXEC DeleteOrderItemCollections @loadingOrderItemIds

print 'Deliting LOADING ORDER ITEM Goods link'
delete from LOADING_ORDER_ITEM_GOOD where LOADING_ORDER_ITEM_ID IN(select ORDER_ITEM_ID from @loadingOIs)

print 'Deliting LOADING ORDER ITEMS'
	-- LOADING_ORDER_ITEM
delete from LOADING_ORDER_ITEM where LOADING_ORDER_ITEM_ID IN(select ORDER_ITEM_ID from @loadingOIs)
delete from ORDER_ITEM where ORDER_ITEM_ID IN(select ORDER_ITEM_ID from @loadingOIs)    
-------------------------------------------------------------------------------------

----------------------------- DELETE STOCK CHANGE------------------------------------
declare @contextIdsSC table (
	OPERATION_CONTEXT_ID int
);

declare @stockChangeItemIds table(
	STOCK_CHANGE_ITEM_ID int,
	ORDERED_ID int,
	PENDING_ID int,
	PLANNED_ID int,
	PREPARED_ID int,
	REMAINING_ID int,
	STOCK_CHANGE_OPERATION_REPORT_ID int
)

print 'Deliting STOCK CHANGE OPERATION REPORTS'
	 -- STOCK CHANGE O REPORT
delete scor 
	output deleted.REPORTED_ID, deleted.STOCK_CHANGE_OPERATION_REPORT_ID into @stockChangeItemIds(STOCK_CHANGE_ITEM_ID, STOCK_CHANGE_OPERATION_REPORT_ID) 
	from STOCK_CHANGE_OPERATION_REPORT scor
	join OPERATION_REPORT r on scor.STOCK_CHANGE_OPERATION_REPORT_ID = r.OPERATION_REPORT_ID
	where r.ORDER_ITEM_ID IN(select ORDER_ITEM_ID from @stockChangeOIs)

	-- HANDHELD SHIFTING O REPORTS
delete scor
	output deleted.REPORTED_ID, deleted.STOCK_CHANGE_OPERATION_REPORT_ID into @stockChangeItemIds(STOCK_CHANGE_ITEM_ID, STOCK_CHANGE_OPERATION_REPORT_ID)
	from STOCK_CHANGE_OPERATION_REPORT scor
	join STOCK_CHANGE_ITEM sci on scor.REPORTED_ID = sci.STOCK_CHANGE_ITEM_ID
	join STOCK_INFO si on si.STOCK_INFO_ID = sci.TO_ID
	join STOCK_INFO_CONFIG sic on sic.STOCK_INFO_CONFIG_ID = si.STOCK_INFO_CONFIG_ID
	join OPERATION_REPORT r on scor.STOCK_CHANGE_OPERATION_REPORT_ID = r.OPERATION_REPORT_ID
	where (r.ORDER_ITEM_ID is null) and (sic.INTERNAL_COMPANY_ID = @companyId)

delete from OPERATION_REPORT 
output deleted.CONTEXT_ID into @contextIdsSC(OPERATION_CONTEXT_ID)
where OPERATION_REPORT_ID IN(select STOCK_CHANGE_OPERATION_REPORT_ID from @stockChangeItemIds)

print 'Deliting STOCK CHANGE OPERATION PLANS'
	 -- STOCK CHANGE O PLAN
delete scop 
	output deleted.ORDERED_ID, deleted.REMAINING_ID, deleted.PLANNED_ID, deleted.PENDING_ID, deleted.PREPARED_ID into @stockChangeItemIds(ORDERED_ID, REMAINING_ID, PLANNED_ID, PENDING_ID, PREPARED_ID)
	from STOCK_CHANGE_OPERATION_PLAN scop
	join OPERATION_PLAN op on scop.STOCK_CHANGE_OPERATION_PLAN_ID = op.OPERATION_PLAN_ID
	where op.ORDER_ITEM_ID IN(select ORDER_ITEM_ID from @stockChangeOIs) 

delete from OPERATION_PLAN 
output deleted.CONTEXT_ID into @contextIdsSC(OPERATION_CONTEXT_ID)
where ORDER_ITEM_ID IN(select ORDER_ITEM_ID from @stockChangeOIs) 

print 'Deliting STOCK CHANGE OPERATION CONTEXTS'
delete oc from OPERATION_CONTEXT oc join @contextIdsSC c on oc.OPERATION_CONTEXT_ID = c.OPERATION_CONTEXT_ID

print 'Deliting STOCK CHANGE ORDER ITEM collections'
	-- ORDER_ITEM collections
declare @stockChangeOrderItemIds Ids
insert into @stockChangeOrderItemIds (ID)
select ORDER_ITEM_ID from @stockChangeOIs
EXEC DeleteOrderItemCollections @stockChangeOrderItemIds

print 'Deliting STOCK CHANGE ORDER ITEM Goods link'
	-- OI GOODS
delete from STOCK_CHANGE_ORDER_ITEM_GOOD 
output deleted.STOCK_CHANGE_ITEM_ID into @stockChangeItemIds(STOCK_CHANGE_ITEM_ID)
where STOCK_CHANGE_ORDER_ITEM_ID IN(select ORDER_ITEM_ID from @stockChangeOIs) 

print 'Deliting STOCK CHANGE ORDER ITEMS'
	-- STOCK CHANGE OI
delete from STOCK_CHANGE_ORDER_ITEM where STOCK_CHANGE_ORDER_ITEM_ID IN(select ORDER_ITEM_ID from @stockChangeOIs) 
delete from ORDER_ITEM where ORDER_ITEM_ID IN(select ORDER_ITEM_ID from @stockChangeOIs) 

print 'Deliting STOCK CHANGE ITEMS'
	-- STOCK CHANGE ITEM
delete sci from STOCK_CHANGE_ITEM sci join @stockChangeItemIds i on sci.STOCK_CHANGE_ITEM_ID = i.STOCK_CHANGE_ITEM_ID
delete sci from STOCK_CHANGE_ITEM sci join @stockChangeItemIds i on sci.STOCK_CHANGE_ITEM_ID = i.ORDERED_ID
delete sci from STOCK_CHANGE_ITEM sci join @stockChangeItemIds i on sci.STOCK_CHANGE_ITEM_ID = i.REMAINING_ID
delete sci from STOCK_CHANGE_ITEM sci join @stockChangeItemIds i on sci.STOCK_CHANGE_ITEM_ID = i.PLANNED_ID
delete sci from STOCK_CHANGE_ITEM sci join @stockChangeItemIds i on sci.STOCK_CHANGE_ITEM_ID = i.PENDING_ID
delete sci from STOCK_CHANGE_ITEM sci join @stockChangeItemIds i on sci.STOCK_CHANGE_ITEM_ID = i.PREPARED_ID
--------------------------------------------------------------------------------------

print 'Deliting ORDER collections'
---------------------------DELETE ORDERS-------------------------------------------
declare @orderIds Ids
insert into @orderIds (ID)
	select ORDER_ID from ORDERS where INTERNAL_COMPANY_ID = @companyId

declare @transportIds Ids
insert into @transportIds(ID)
select TRANSPORT_ID from ORDER_TRANSPORT where ORDER_ID IN(select ID from @orderIds)

EXEC DeleteOrderCollections @orderIds

print 'Deliting ORDERS'
delete from ORDERS where ORDER_ID IN(select ID from @orderIds)
------------------------------------------------------------------------------------

---------------------------DELETE STOCK INFO-------------------------------------------
print 'Collect Stock Infos Data'
DECLARE @ListOfStockIDs TABLE(ITEM_ID int)
DECLARE @ListOfStockInfoIDs TABLE(ITEM_ID int)
DECLARE @ListOfStockInfoConfigIDs TABLE(ITEM_ID int)
DECLARE @ListOfExtraQtyIDs TABLE(ITEM_ID int)
DECLARE @ListOfBaseQtyIDs TABLE(ITEM_ID int)
DECLARE @ListOfStorageQtyIDs TABLE(ITEM_ID int)

INSERT INTO @ListOfExtraQtyIDs
SELECT sieq.STOCK_INFO_QUANTITY_ID FROM STOCK_INFO_CONFIG sic 
JOIN INTERNAL_COMPANY ic ON sic.INTERNAL_COMPANY_ID = ic.COMPANY_ID
JOIN STOCK_INFO si ON sic.STOCK_INFO_CONFIG_ID = si.STOCK_INFO_CONFIG_ID
JOIN STOCK_INFO_EXTRA_QUANTITY sieq ON si.STOCK_INFO_ID = sieq.STOCK_INFO_ID
WHERE ic.COMPANY_ID = @companyId

INSERT INTO @ListOfBaseQtyIDs
SELECT siq.STOCK_INFO_QUANTITY_ID FROM STOCK_INFO_CONFIG sic 
JOIN INTERNAL_COMPANY ic ON sic.INTERNAL_COMPANY_ID = ic.COMPANY_ID
JOIN STOCK_INFO si ON sic.STOCK_INFO_CONFIG_ID = si.STOCK_INFO_CONFIG_ID
JOIN STOCK_INFO_QUANTITY siq ON si.BASE_QUANTITY_ID = siq.STOCK_INFO_QUANTITY_ID
WHERE ic.COMPANY_ID = @companyId

INSERT INTO @ListOfStorageQtyIDs
SELECT siq.STOCK_INFO_QUANTITY_ID FROM STOCK_INFO_CONFIG sic 
JOIN INTERNAL_COMPANY ic ON sic.INTERNAL_COMPANY_ID = ic.COMPANY_ID
JOIN STOCK_INFO si ON sic.STOCK_INFO_CONFIG_ID = si.STOCK_INFO_CONFIG_ID
JOIN STOCK_INFO_QUANTITY siq ON si.STORAGE_QUANTITY_ID = siq.STOCK_INFO_QUANTITY_ID
WHERE ic.COMPANY_ID = @companyId AND 
	  si.STORAGE_QUANTITY_ID IS NOT NULL

INSERT INTO @ListOfStockIDs
SELECT s.STOCK_ID FROM STOCK_INFO_CONFIG sic 
JOIN INTERNAL_COMPANY ic ON sic.INTERNAL_COMPANY_ID = ic.COMPANY_ID
JOIN STOCK_INFO si ON sic.STOCK_INFO_CONFIG_ID = si.STOCK_INFO_CONFIG_ID
JOIN STOCK s ON si.STOCK_INFO_ID = s.STOCK_INFO_ID
WHERE ic.COMPANY_ID = @companyId

INSERT INTO @ListOfStockInfoIDs
SELECT si.STOCK_INFO_ID FROM STOCK_INFO_CONFIG sic 
JOIN INTERNAL_COMPANY ic ON sic.INTERNAL_COMPANY_ID = ic.COMPANY_ID
JOIN STOCK_INFO si ON sic.STOCK_INFO_CONFIG_ID = si.STOCK_INFO_CONFIG_ID
WHERE ic.COMPANY_ID = @companyId

INSERT INTO @ListOfStockInfoConfigIDs
SELECT sic.STOCK_INFO_CONFIG_ID FROM STOCK_INFO_CONFIG sic 
JOIN INTERNAL_COMPANY ic ON sic.INTERNAL_COMPANY_ID = ic.COMPANY_ID
JOIN STOCK_INFO si ON sic.STOCK_INFO_CONFIG_ID = si.STOCK_INFO_CONFIG_ID
WHERE ic.COMPANY_ID = @companyId

print 'Deliting Stock Inventory Request'
DECLARE @ListOfStockInventoryRequestIDs TABLE(STOCK_INVENTORY_REQUEST_ID int)

delete from STOCK_INVENTORY_REQUEST_ITEM
output deleted.REQUEST_ID into @ListOfStockInventoryRequestIDs(STOCK_INVENTORY_REQUEST_ID)
WHERE STOCK_INFO_ID IN (select ITEM_ID from @ListOfStockInfoIDs)

delete from STOCK_INVENTORY_REQUEST where STOCK_INVENTORY_REQUEST_ID IN(select STOCK_INVENTORY_REQUEST_ID from @ListOfStockInventoryRequestIDs)

DELETE FROM STOCK WHERE STOCK_ID in (SELECT ITEM_ID FROM @ListOfStockIDs)

print 'Stocks deleted.'

DELETE FROM STOCK_INFO_EXTRA_QUANTITY WHERE STOCK_INFO_QUANTITY_ID in (SELECT ITEM_ID FROM @ListOfExtraQtyIDs)

DELETE FROM STOCK_INFO_QUANTITY WHERE STOCK_INFO_QUANTITY_ID in (SELECT ITEM_ID FROM @ListOfExtraQtyIDs)
print 'Extra quantities deleted.'

DELETE FROM STOCK_INFO WHERE STOCK_INFO_ID in (SELECT ITEM_ID FROM @ListOfStockInfoIDs)
print 'Stock infos deleted.'

DELETE FROM STOCK_INFO_QUANTITY WHERE STOCK_INFO_QUANTITY_ID IN (SELECT ITEM_ID FROM @ListOfBaseQtyIDs)
print 'Base quantities deleted.'

DELETE FROM STOCK_INFO_QUANTITY WHERE STOCK_INFO_QUANTITY_ID IN (SELECT ITEM_ID FROM @ListOfStorageQtyIDs)
print 'Storage quantities deleted.'

DELETE FROM STOCK_INFO_CONFIG_EXTRA_UNIT WHERE STOCK_INFO_CONFIG_ID in (SELECT ITEM_ID FROM @ListOfStockInfoConfigIDs)
DELETE FROM STOCK_INFO_SID WHERE STOCK_INFO_CONFIG_ID in (SELECT ITEM_ID FROM @ListOfStockInfoConfigIDs)
print 'SIDs deleted.'
DELETE FROM STOCK_INFO_CONFIG WHERE STOCK_INFO_CONFIG_ID in (SELECT ITEM_ID FROM @ListOfStockInfoConfigIDs)
print 'SICs deleted.'

print 'Deliting TRANSPORTS'
----------------------- Delete Transports -------------------------------------------
EXEC DeleteTransports @transportIds

print 'Deleting unlinked TRANSPORTS'
declare @unlinkedTransports Ids
insert into @unlinkedTransports (ID)
select TRANSPORT_ID from TRANSPORT  where INTERNAL_COMPANY_ID = @companyId
EXEC DeleteTransports @unlinkedTransports
-------------------------------------------------------------------------------------

print 'Unlinking users ...'
----------------------- Unlink Persons from IC --------------------------------------
delete from pic
from PERSON_INTERNAL_COMPANY pic
join PERSON p on pic.USER_ID = p.PERSON_ID
where INTERNAL_COMPANY_ID = @companyId and p.PERSON_ID != 1

update PERSON set DEFAULT_INTERNAL_COMPANY_ID = null where DEFAULT_INTERNAL_COMPANY_ID = @companyId and PERSON_ID != 1
---------------------------------------------------------------------------------------

print 'Deleting settings and Service Accounts'
----------------------- Delete Settings and Service Account----------------------------
delete from CONFIG_SETTING_VALUE where INTERNAL_COMPANY_ID = @companyId
delete from SERVICE_ACCOUNT where INTERNAL_COMPANY_ID = @companyId
---------------------------------------------------------------------------------------

print 'Deleting locations'
----------------------- Delete Locations ----------------------------------------------
declare @locations table (LOCATION_ID int)
delete from LOCATION_INTERNAL_COMPANY 
output deleted.LOCATION_ID into @locations (LOCATION_ID)
where INTERNAL_COMPANY_ID = @companyId

delete from LOCATION where LOCATION_ID IN(select LOCATION_ID from @locations)
----------------------------------------------------------------------------------------

print 'Deleting Company Application Roles, RFERENCES and PRODUCT link'
----------- Delete Company Application Roles, RFERENCES and PRODUCT link ---------------
delete from COMPANY_APPLICATION_ROLE where INTERNAL_COMPANY_ID = @companyId -- deleteing because bug in Company delete screen ????????????
delete from REFERENCE where INTERNAL_COMPANY_ID = @companyId
delete from PRODUCT_INT_COMPANY where INTERNAL_COMPANY_ID = @companyId
---------------------------------------------------------------------------------------

print 'Deleting Operations'
--------------------------- Delete Operations ------------------------------------------
declare @operations table (OPERATION_ID int)
insert into @operations (OPERATION_ID)
select OPERATION_ID from OPERATION where INTERNAL_COMPANY_ID = @companyId

delete from DISCHARGING_OPERATION_TRANSPORT_TYPE where DISCHARGING_OPERATION_ID IN (select OPERATION_ID from @operations)
delete from LOADING_OPERATION_TRANSPORT_TYPE where LOADING_OPERATION_ID IN (select OPERATION_ID from @operations)

delete DISCHARGING_OPERATION where DISCHARGING_OPERATION_ID IN (select OPERATION_ID from @operations)
delete LOADING_OPERATION where LOADING_OPERATION_ID IN (select OPERATION_ID from @operations)
delete STOCK_CHANGE_OPERATION where STOCK_CHANGE_OPERATION_ID IN (select OPERATION_ID from @operations)
delete from OPERATION_SHIFT where OPERATION_ID IN (select OPERATION_ID from @operations)

delete from OPERATION where OPERATION_ID IN (select OPERATION_ID from @operations)
-------------------------------------------------------------------------------------------

print 'Deleting Shifts'
------------------------ Deleting shifts --------------------------------------------------
delete from SHIFT_INTERNAL_COMPANY where INTERNAL_COMPANY_ID = @companyId

delete from OPERATION_SHIFT 
where SHIFT_ID IN (select SHIFT_ID from SHIFT where SHIFT_ID NOT IN (select SHIFT_ID from SHIFT_INTERNAL_COMPANY))

delete from SHIFT where SHIFT_ID NOT IN (select SHIFT_ID from SHIFT_INTERNAL_COMPANY)
-------------------------------------------------------------------------------------------

------------------------ Deleting Transport Types And Link to Opertations -----------------------------------------
delete dott from DISCHARGING_OPERATION_TRANSPORT_TYPE dott
JOIN TRANSPORT_TYPE tt on dott.TRANSPORT_TYPE_ID = tt.TRANSPORT_TYPE_ID
WHERE INTERNAL_COMPANY_ID = @companyId

delete lott from LOADING_OPERATION_TRANSPORT_TYPE lott
JOIN TRANSPORT_TYPE tt on lott.TRANSPORT_TYPE_ID = tt.TRANSPORT_TYPE_ID
where INTERNAL_COMPANY_ID = @companyId

delete from TRANSPORT_PROPERTY_DF where TRANSPORT_TYPE_ID IN(select TRANSPORT_TYPE_ID from TRANSPORT_TYPE where INTERNAL_COMPANY_ID = @companyId)
delete from TRANSPORT_TYPE where INTERNAL_COMPANY_ID = @companyId
--------------------------------------------------------------------------------------------
	COMMIT TRANSACTION
	--ROLLBACK TRANSACTION
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION
		SELECT ERROR_NUMBER() as ErrorNumber, ERROR_LINE() as ErrorLine, ERROR_MESSAGE() as ErrorMessage
END CATCH
END
go


--PROBLEM TABLES
SELECT COUNT(*) AS 'All Discharging OR' FROM DISCHARGING_OPERATION_REPORT
SELECT COUNT(*) AS 'All Loading OR' FROM LOADING_OPERATION_REPORT
SELECT COUNT(*) AS 'All Stock Change OR' FROM STOCK_CHANGE_OPERATION_REPORT
SELECT COUNT(*) AS 'All Discharging OPLAN' FROM DISCHARGING_OPERATION_PLAN
SELECT COUNT(*) AS 'All Loading OPLAN' FROM LOADING_OPERATION_PLAN
SELECT COUNT(*) AS 'All Stock Change OPLAN' FROM STOCK_CHANGE_OPERATION_PLAN
SELECT COUNT(*) AS 'All Discharging OI GOODS' FROM DISCHARGING_ORDER_ITEM_GOODS 
SELECT COUNT(*) AS 'All Loading OI GOODS' FROM LOADING_ORDER_ITEM_GOOD 
SELECT COUNT(*) AS 'All Transport properties' FROM TRANSPORT_PROPERTY_VALUE
SELECT COUNT(*) AS 'All Transport attachments' FROM TRANSPORT_ATTACHMENT
SELECT COUNT(*) AS 'All Transport http log items' FROM TRANSPORT_HTTP_LOG_ITEM
SELECT COUNT(*) AS 'All Lashing material quantity' FROM LASHING_MATERIAL_QUANTITY
SELECT COUNT(*) AS 'All Order Item References' FROM ORDER_ITEM_REFERENCE_VALUE
SELECT COUNT(*) AS 'All Order Item ADDRESSES' FROM ORDER_ITEM_PARTNER_ADDRESS
SELECT COUNT(*) AS 'All Order Item Additional Address' FROM OPERATION_INSTRUCTION
SELECT COUNT(*) AS 'ALL OI ATTACHMENTS' FROM ORDER_ITEM_ATTACHMENT
SELECT COUNT(*) AS 'ALL OI Http Log Items' FROM ORDER_ITEM_HTTP_LOG_ITEM
SELECT COUNT(*) AS 'All Order Item Obstructions' FROM ORDER_ITEM_OBSTRUCTION
SELECT COUNT(*) AS 'All Order Transports' FROM ORDER_TRANSPORT
SELECT COUNT(*) AS 'All Order References' FROM ORDER_REFERENCE_VALUE
SELECT COUNT(*) AS 'All Order Obstructions' FROM ORDER_OBSTRUCTION
SELECT COUNT(*) AS 'All Order Additional Address' FROM OPERATION_ORDER_INSTRUCTION
SELECT COUNT(*) AS 'ALL O ATTACHMENTS' FROM ORDER_ATTACHMENT
SELECT COUNT(*) AS 'All Order ADDRESSES' FROM ORDER_PARTNER_ADDRESS
SELECT COUNT(*) AS 'STOCK_INVENTORY_REQUEST_ITEM' FROM STOCK_INVENTORY_REQUEST_ITEM
SELECT COUNT(*) AS 'All Stock' FROM STOCK
SELECT COUNT(*) AS 'STOCK_INFO_EXTRA_QUANTITY' FROM STOCK_INFO_EXTRA_QUANTITY
SELECT COUNT(*) AS 'STOCK_INFO_QUANTITY' FROM STOCK_INFO_QUANTITY
SELECT COUNT(*) AS 'STOCK_INFO_CONFIG_EXTRA_UNIT' FROM STOCK_INFO_CONFIG_EXTRA_UNIT 
SELECT COUNT(*) AS 'STOCK_INFO_SID' FROM STOCK_INFO_SID

EXEC DeleteOperationalData 'IC_VMS'

SELECT COUNT(*) AS 'All Discharging OR' FROM DISCHARGING_OPERATION_REPORT
SELECT COUNT(*) AS 'All Loading OR' FROM LOADING_OPERATION_REPORT
SELECT COUNT(*) AS 'All Stock Change OR' FROM STOCK_CHANGE_OPERATION_REPORT
SELECT COUNT(*) AS 'All Discharging OPLAN' FROM DISCHARGING_OPERATION_PLAN
SELECT COUNT(*) AS 'All Loading OPLAN' FROM LOADING_OPERATION_PLAN
SELECT COUNT(*) AS 'All Stock Change OPLAN' FROM STOCK_CHANGE_OPERATION_PLAN
SELECT COUNT(*) AS 'All Discharging OI GOODS' FROM DISCHARGING_ORDER_ITEM_GOODS 
SELECT COUNT(*) AS 'All Loading OI GOODS' FROM LOADING_ORDER_ITEM_GOOD 
SELECT COUNT(*) AS 'All Transport properties' FROM TRANSPORT_PROPERTY_VALUE
SELECT COUNT(*) AS 'All Transport attachments' FROM TRANSPORT_ATTACHMENT
SELECT COUNT(*) AS 'All Transport http log items' FROM TRANSPORT_HTTP_LOG_ITEM
SELECT COUNT(*) AS 'All Lashing material quantity' FROM LASHING_MATERIAL_QUANTITY
SELECT COUNT(*) AS 'All Order Item References' FROM ORDER_ITEM_REFERENCE_VALUE
SELECT COUNT(*) AS 'All Order Item ADDRESSES' FROM ORDER_ITEM_PARTNER_ADDRESS
SELECT COUNT(*) AS 'All Order Item Additional Address' FROM OPERATION_INSTRUCTION
SELECT COUNT(*) AS 'ALL OI ATTACHMENTS' FROM ORDER_ITEM_ATTACHMENT
SELECT COUNT(*) AS 'ALL OI Http Log Items' FROM ORDER_ITEM_HTTP_LOG_ITEM
SELECT COUNT(*) AS 'All Order Item Obstructions' FROM ORDER_ITEM_OBSTRUCTION
SELECT COUNT(*) AS 'All Order Transports' FROM ORDER_TRANSPORT
SELECT COUNT(*) AS 'All Order References' FROM ORDER_REFERENCE_VALUE
SELECT COUNT(*) AS 'All Order Obstructions' FROM ORDER_OBSTRUCTION
SELECT COUNT(*) AS 'All Order Additional Address' FROM OPERATION_ORDER_INSTRUCTION
SELECT COUNT(*) AS 'ALL O ATTACHMENTS' FROM ORDER_ATTACHMENT
SELECT COUNT(*) AS 'All Order ADDRESSES' FROM ORDER_PARTNER_ADDRESS
SELECT COUNT(*) AS 'STOCK_INVENTORY_REQUEST_ITEM' FROM STOCK_INVENTORY_REQUEST_ITEM
SELECT COUNT(*) AS 'All Stock' FROM STOCK
SELECT COUNT(*) AS 'STOCK_INFO_EXTRA_QUANTITY' FROM STOCK_INFO_EXTRA_QUANTITY
SELECT COUNT(*) AS 'STOCK_INFO_QUANTITY' FROM STOCK_INFO_QUANTITY
SELECT COUNT(*) AS 'STOCK_INFO_CONFIG_EXTRA_UNIT' FROM STOCK_INFO_CONFIG_EXTRA_UNIT 
SELECT COUNT(*) AS 'STOCK_INFO_SID' FROM STOCK_INFO_SID

drop proc DeleteTransports
drop proc DeleteOrderItemCollections
drop proc DeleteOrderCollections
drop proc DeleteOperationalData
drop type Ids


---- DELETE Report 'CMRWaybill'
--EXEC DELETE_REPORT 'CMRWaybill'

---- Delete unlinked from StockInfo StockInfoConfigs
--declare @icId int = (select COMPANY_ID from COMPANY where LOWER(CODE) = LOWER('IC_VMS'))

--declare @configs table (STOCK_INFO_CONFIG_ID int)
--insert into @configs
--select STOCK_INFO_CONFIG_ID from STOCK_INFO_CONFIG where INTERNAL_COMPANY_ID = @icId

--delete from STOCK_INFO_SID where STOCK_INFO_CONFIG_ID IN(select STOCK_INFO_CONFIG_ID from @configs)
--delete from STOCK_INFO_CONFIG_EXTRA_UNIT where STOCK_INFO_CONFIG_ID IN(select STOCK_INFO_CONFIG_ID from @configs)
--delete from STOCK_INFO_CONFIG where STOCK_INFO_CONFIG_ID IN(select STOCK_INFO_CONFIG_ID from @configs)


-- Delete IC VMS from Admin--> Config --> IC 