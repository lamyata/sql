CREATE TYPE IdTable AS TABLE (ID INT);
CREATE TYPE MultiTable AS TABLE (ID1 int, ID2 int, ID3 int, ID4 int, ID5 int)
GO

create function Flatten (@mTable MultiTable readonly)
returns @idTable TABLE (ID int)
as
begin
	insert into @idTable
	select ID1 from @mTable union
	select ID2 from @mTable union
	select ID3 from @mTable union
	select ID4 from @mTable union
	select ID5 from @mTable
	return
end
go

-- The procedure does not delete FINANCIAL_LINE data
CREATE PROC DeleteTransports(@transportIds IdTable READONLY)
AS
DECLARE @attachmentIds table ( ATTACHMENT_ID int )
DECLARE @httpLogItemIds table ( HTTP_LOG_ITEM_ID int )
BEGIN
	RAISERROR('Delete TRANSPORT_PROPERTY_VALUE',0,1)WITH NOWAIT;
	delete from TRANSPORT_PROPERTY_VALUE
	where TRANSPORT_ID in(select ID from @transportIds)

	RAISERROR('Delete TRANSPORT_ATTACHMENT',0,1)WITH NOWAIT;
	delete from TRANSPORT_ATTACHMENT
	output deleted.ATTACHMENT_ID into @attachmentIds(ATTACHMENT_ID)
	where TRANSPORT_ID in(select ID from @transportIds)

	delete a from ATTACHMENT a join @attachmentIds ai on a.ATTACHMENT_ID = ai.ATTACHMENT_ID

	RAISERROR('Delete TRANSPORT_HTTP_LOG_ITEM',0,1)WITH NOWAIT;
	delete from TRANSPORT_HTTP_LOG_ITEM
	output deleted.HTTP_LOG_ITEM_ID into @httpLogItemIds(HTTP_LOG_ITEM_ID)
	where TRANSPORT_ID in(select ID from @transportIds)

	delete hli from HTTP_LOG_ITEM hli join @httpLogItemIds li on hli.HTTP_LOG_ITEM_ID = li.HTTP_LOG_ITEM_ID

	RAISERROR('Delete LASHING_MATERIAL_QUANTITY',0,1)WITH NOWAIT;
	delete from LASHING_MATERIAL_QUANTITY where TRANSPORT_ID in(select ID from @transportIds)

	delete from TRANSPORT where TRANSPORT_ID in(select ID from @transportIds)
END
GO

CREATE PROC DeleteOrderItemCollections(@OrderItemIds IdTable READONLY)
AS
BEGIN
	PRINT 'Delete ORDER_ITEM_REFERENCE_VALUE'
	delete from ORDER_ITEM_REFERENCE_VALUE where ORDER_ITEM_ID in(select ID from @OrderItemIds)

	PRINT 'Delete PARTNER_ADDRESS'
	declare @partnerAddresses table(PARTNER_ADDRESS_ID int)
	delete from ORDER_ITEM_PARTNER_ADDRESS
	output deleted.PARTNER_ADDRESS_ID into @partnerAddresses(PARTNER_ADDRESS_ID)
	where ORDER_ITEM_ID in(select ID from @OrderItemIds)

	delete pa from PARTNER_ADDRESS pa join @partnerAddresses a on pa.PARTNER_ADDRESS_ID = a.PARTNER_ADDRESS_ID

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

	delete from DISCHARGING_ORDER_ITEM_GOODS where DISCHARGING_ORDER_ITEM_ID IN(select ID from @OrderItemIds)
	delete from LOADING_ORDER_ITEM_GOOD where LOADING_ORDER_ITEM_ID IN(select ID from @OrderItemIds)
	delete scoig
		from STOCK_CHANGE_ORDER_ITEM_GOOD scoig join @OrderItemIds oi on scoig.STOCK_CHANGE_ORDER_ITEM_ID = oi.ID
	delete voig
		from VAS_ORDER_ITEM_GOOD voig join @OrderItemIds oi on voig.VAS_ORDER_ITEM_ID = oi.ID 

	delete from DISCHARGING_ORDER_ITEM where DISCHARGING_ORDER_ITEM_ID IN(select ID from @OrderItemIds)
	delete from LOADING_ORDER_ITEM where LOADING_ORDER_ITEM_ID IN(select ID from @OrderItemIds)
	delete scoi from STOCK_CHANGE_ORDER_ITEM scoi join @OrderItemIds oi on scoi.STOCK_CHANGE_ORDER_ITEM_ID = oi.ID
	delete voi from VAS_ORDER_ITEM voi join  @OrderItemIds oi on voi.VAS_ORDER_ITEM_ID = oi.ID

	delete oifl from ORDER_ITEM_FINANCIAL_LINE oifl join @OrderItemIds oi on oifl.ORDER_ITEM_ID = oi.ID
END
GO

CREATE PROC DeleteOrderCollections(@orderIds IdTable READONLY)
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

	PRINT 'Delete ORDER_PARTNER_ADDRESS'
		declare @partnerAddresses table(PARTNER_ADDRESS_ID int)
		delete from ORDER_PARTNER_ADDRESS
		output deleted.PARTNER_ADDRESS_ID into @partnerAddresses(PARTNER_ADDRESS_ID)
		where ORDER_ID in(select ID from @orderIds)

		delete pa from PARTNER_ADDRESS pa join @partnerAddresses a on pa.PARTNER_ADDRESS_ID = a.PARTNER_ADDRESS_ID
END
GO

create proc DeleteStockInfos @stockInfoIds IdTable readonly as
begin

	DECLARE @eqIds IdTable;
	declare	@stockData table (SIC_ID int, BQ_ID int, SQ_ID int)
	insert into @stockData (SIC_ID, BQ_ID, SQ_ID)
		select si.STOCK_INFO_CONFIG_ID, si.BASE_QUANTITY_ID, si.STORAGE_QUANTITY_ID
		FROM STOCK_INFO si WHERE STOCK_INFO_ID in (select ID from @stockInfoIds )
	
	-- save eq IDs
	INSERT INTO @eqIds
	SELECT sieq.STOCK_INFO_QUANTITY_ID FROM STOCK_INFO_EXTRA_QUANTITY sieq WHERE sieq.STOCK_INFO_ID in (select ID from @stockInfoIds )
	
	-- delete eqs
	DELETE FROM STOCK_INFO_EXTRA_QUANTITY WHERE STOCK_INFO_QUANTITY_ID in (SELECT ID FROM @eqIds)
	DELETE FROM STOCK_INFO_QUANTITY WHERE STOCK_INFO_QUANTITY_ID in (SELECT ID FROM @eqIds)
	-- delete si
	DELETE FROM STOCK_INFO WHERE STOCK_INFO_ID in (select ID from @stockInfoIds )
	-- delete bq
	DELETE FROM STOCK_INFO_QUANTITY WHERE STOCK_INFO_QUANTITY_ID in (select BQ_ID from @stockData)
	DELETE FROM STOCK_INFO_QUANTITY WHERE STOCK_INFO_QUANTITY_ID in (select SQ_ID from @stockData)

	declare @orphanedSics IdTable;
	insert into @orphanedSics select SIC_ID from @stockData sd where not exists (select 1 from STOCK_INFO where STOCK_INFO_CONFIG_ID = sd.SIC_ID)
	delete from STOCK_INFO_CONFIG_EXTRA_UNIT where STOCK_INFO_CONFIG_ID in (select ID from @orphanedSics)
	delete from STOCK_INFO_SID where STOCK_INFO_CONFIG_ID in (select ID from @orphanedSics)
	delete from STOCK_INFO_CONFIG where STOCK_INFO_CONFIG_ID in (select ID from @orphanedSics)

end
go

declare @stats table (object_id int, name nvarchar(50), before int, after int)
insert into @stats (object_id, name, before, after) select distinct o.object_id, o.name, sum(ps.row_count), 0
from sys.objects o, sys.dm_db_partition_stats ps where o.object_id = ps.object_id and o.type = 'U' and ps.index_id in (0, 1)
group by o.object_id, o.name

--create table ORIG_IDS (n varchar(50), id int)
--insert into ORIG_IDS select 'STOCK_INFO', STOCK_INFO_ID from STOCK_INFO
--insert into ORIG_IDS select 'STOCK_INFO_CONFIG', STOCK_INFO_CONFIG_ID from STOCK_INFO_CONFIG
--insert into ORIG_IDS select 'OPERATION_CONTEXT', OPERATION_CONTEXT_ID from OPERATION_CONTEXT
--insert into ORIG_IDS select 'OPERATION_PLAN', OPERATION_PLAN_ID from OPERATION_PLAN
--insert into ORIG_IDS select 'ORDER_ITEM', ORDER_ITEM_ID from ORDER_ITEM
--insert into ORIG_IDS select 'DISCHARGING_ORDER_ITEM', DISCHARGING_ORDER_ITEM_ID  from DISCHARGING_ORDER_ITEM
--insert into ORIG_IDS select 'LOADING_ORDER_ITEM', LOADING_ORDER_ITEM_ID  from LOADING_ORDER_ITEM
--insert into ORIG_IDS select 'DISCHARGING_OPERATION_PLAN', DISCHARGING_OPERATION_PLAN_ID  from DISCHARGING_OPERATION_PLAN
--insert into ORIG_IDS select 'OPERATION_INSTRUCTION', OPERATION_INSTRUCTION_ID  from OPERATION_INSTRUCTION
--RAISERROR('Saving ORDER IDs',0,1)WITH NOWAIT;
--insert into ORIG_IDS select 'ORDER', ORDER_ID  from ORDERS
--insert into ORIG_IDS select 'OPERATION_ORDER_INSTRUCTION', OPERATION_ORDER_INSTRUCTION_ID  from OPERATION_ORDER_INSTRUCTION
--insert into ORIG_IDS select 'OPERATION_REPORT', OPERATION_REPORT_ID  from OPERATION_REPORT
--insert into ORIG_IDS select 'DISCHARGING_OPERATION_REPORT', DISCHARGING_OPERATION_REPORT_ID  from DISCHARGING_OPERATION_REPORT
--insert into ORIG_IDS select 'VAS_ORDER_ITEM', VAS_ORDER_ITEM_ID  from VAS_ORDER_ITEM
--insert into ORIG_IDS select 'STOCK_CHANGE_ITEM', STOCK_CHANGE_ITEM_ID  from STOCK_CHANGE_ITEM
--insert into ORIG_IDS select 'STOCK_CHANGE_ORDER_ITEM', STOCK_CHANGE_ORDER_ITEM_ID  from STOCK_CHANGE_ORDER_ITEM
--insert into ORIG_IDS select 'LOADING_OPERATION_REPORT', LOADING_OPERATION_REPORT_ID  from LOADING_OPERATION_REPORT
--insert into ORIG_IDS select 'STOCK_CHANGE_OPERATION_PLAN', STOCK_CHANGE_OPERATION_PLAN_ID  from STOCK_CHANGE_OPERATION_PLAN

declare @orderIds IdTable, @oiIds IdTable, @rptIds IdTable, @ctxIds IdTable, @customerIds IdTable;
insert into @customerIds select COMPANY_ID from COMPANY where CODE in ( 'CRF_VLBN', 'INTOLI2100' )
--SELECT * FROM @customerIds

--declare @si IdTable;
RAISERROR('Collect OI ids',0,1)WITH NOWAIT;
	
declare @orderItemSeqs table (order_id int, sequence int)
insert into @orderItemSeqs values 
	(7095,10),(7096,10),(7106,10),(7280,10),(7353,10),(8011,10),(8211,10),(8212,10),(8360,90),(8882,20),(8882,10),(9863,10),(16367,10),(16987,40),
	(16987,150),(20711,60),(20711,190),(20711,200),(20711,220),(21431,1020),(21431,1330),(21431,220),(21945,10),(25270,30),(25644,10),(25645,10),
	(26224,30),(26340,50),(27927,10),(28800,10),(47023,10),(30292,10),(30292,20),(30292,30),(37455,10),(38651,10),(48228,100),(48228,120),(48228,130),
	(48228,200),(19486,10),(33549,10),(33549,40),(33549,30),(33549,20),(33549,70),(33549,60),(33549,50)
insert into @oiIds select ORDER_ITEM_ID from ORDER_ITEM oi join @orderItemSeqs ois on oi.ORDER_ID = ois.order_id and oi.SEQUENCE = ois.sequence;
select * @oiIds
INSERT INTO @oiIds SELECT ORDER_ITEM_ID FROM ORDER_ITEM oi JOIN ORDERS o ON oi.ORDER_ID = o.ORDER_ID join @customerIds c on o.CUSTOMER_ID = c.ID

declare @rptCtxIds table (RPT_ID int, CTX_ID int)
insert into @rptCtxIds select OPERATION_REPORT_ID, CONTEXT_ID from OPERATION_REPORT where ORDER_ITEM_ID in (select ID from @oiIds)
insert into @rptIds select RPT_ID from @rptCtxIds;
insert into @ctxIds select CTX_ID from @rptCtxIds;

BEGIN TRY

	BEGIN TRANSACTION

		-- HANDHELD SHIFTING O REPORTS
		declare @hhShiftings table(	STOCK_CHANGE_ITEM_ID int, OPERATION_REPORT_ID int );
		delete scor
			output deleted.REPORTED_ID, deleted.STOCK_CHANGE_OPERATION_REPORT_ID
				into @hhShiftings(STOCK_CHANGE_ITEM_ID, OPERATION_REPORT_ID)
			from STOCK_CHANGE_OPERATION_REPORT scor
				join STOCK_CHANGE_ITEM sci on scor.REPORTED_ID = sci.STOCK_CHANGE_ITEM_ID
				join STOCK_INFO si on si.STOCK_INFO_ID = sci.TO_ID
				join STOCK_INFO_CONFIG sic on sic.STOCK_INFO_CONFIG_ID = si.STOCK_INFO_CONFIG_ID
				join OPERATION_REPORT r on scor.STOCK_CHANGE_OPERATION_REPORT_ID = r.OPERATION_REPORT_ID
				where (r.ORDER_ITEM_ID is null) and (sic.OWNER_ID in (select ID from @customerIds));
		insert into @rptIds select OPERATION_REPORT_ID from @hhShiftings

		print 'Deliting OPERATION REPORTS'
		delete from DISCHARGING_OPERATION_REPORT where DISCHARGING_OPERATION_REPORT_ID in (select ID from @rptIds)
		delete from LOADING_OPERATION_REPORT where LOADING_OPERATION_REPORT_ID in (select ID from @rptIds)
		delete from STOCK_CHANGE_OPERATION_REPORT where STOCK_CHANGE_OPERATION_REPORT_ID in (select ID from @rptIds)
		delete from VAS_OPERATION_REPORT where VAS_OPERATION_REPORT_ID in (select ID from @rptIds)
		delete from OPERATION_REPORT where OPERATION_REPORT_ID in (select ID from @rptIds)
				or OPERATION_REPORT_ID in (select OPERATION_REPORT_ID from @hhShiftings)

		print 'Deliting OPERATION PLANS'
		declare @siMTable MultiTable, @scMTable MultiTable, @vMTable MultiTable;
		delete dop
			output deleted.PLANNED_ID, deleted.REMAINING_ID, deleted.ORDERED_ID, deleted.PENDING_ID, deleted.PREPARED_ID into @siMTable (ID1, ID2, ID3, ID4, ID5)
		from DISCHARGING_OPERATION_PLAN dop
			join OPERATION_PLAN op on dop.DISCHARGING_OPERATION_PLAN_ID = op.OPERATION_PLAN_ID
			join @oiIds oi on op.ORDER_ITEM_ID = oi.ID
		delete lop
			output deleted.PLANNED_ID, deleted.REMAINING_ID, deleted.ORDERED_ID, deleted.PENDING_ID, deleted.PREPARED_ID into @siMTable (ID1, ID2, ID3, ID4, ID5)
		from LOADING_OPERATION_PLAN lop
			join OPERATION_PLAN op on lop.LOADING_OPERATION_PLAN_ID = op.OPERATION_PLAN_ID
			join @oiIds oi on op.ORDER_ITEM_ID = oi.ID
		delete scop 
			output deleted.PLANNED_ID, deleted.REMAINING_ID, deleted.ORDERED_ID, deleted.PENDING_ID, deleted.PREPARED_ID into @scMTable (ID1, ID2, ID3, ID4, ID5)
			from STOCK_CHANGE_OPERATION_PLAN scop
				join OPERATION_PLAN op on scop.STOCK_CHANGE_OPERATION_PLAN_ID = op.OPERATION_PLAN_ID
				join @oiIds oi on op.ORDER_ITEM_ID = oi.ID
		delete vop
			output deleted.PLANNED_ID, deleted.REMAINING_ID, deleted.ORDERED_ID, deleted.PENDING_ID, deleted.PREPARED_ID into @vMTable (ID1, ID2, ID3, ID4, ID5)
			from VAS_OPERATION_PLAN vop
			join OPERATION_PLAN op on vop.VAS_OPERATION_PLAN_ID = op.OPERATION_PLAN_ID
			join @oiIds oi on op.ORDER_ITEM_ID = oi.ID

		delete from OPERATION_PLAN
			output deleted.CONTEXT_ID into @ctxIds
			where ORDER_ITEM_ID IN(select ID from @oiIds)

		print 'Deleting Operation Contexts...'
		delete from OPERATION_CONTEXT where OPERATION_CONTEXT_ID IN(select ID from @ctxIds)

		EXEC DeleteOrderItemCollections @oiIds
		delete from ORDER_ITEM
			output deleted.ORDER_ID into @orderIds
			where ORDER_ITEM_ID IN(select ID from @oiIds)

		delete o from @orderIds o join ORDER_ITEM oi on o.ID = oi.ORDER_ID -- don't delete orders that have more OIs in them

		print 'Deliting LOADING OI PICKING LISTS'
		-- OI PICKING_LIST
		declare @pickingIds IdTable, @prepGoodIds IdTable;

		delete oipl 
		output deleted.PICKING_LIST_ID into @pickingIds
		from ORDER_ITEM_PICKING_LIST oipl join @oiIds oi on oi.ID = oipl.ORDER_ITEM_ID 

		delete plpg
		output deleted.PREPARED_GOOD_ID into @prepGoodIds
		from PICKING_LIST_PREPARED_GOOD plpg join @pickingIds p on plpg.PICKING_LIST_ID = p.ID

		print 'Deliting LOADING PREPARED_GOOD'
		delete pg from PREPARED_GOOD pg join @prepGoodIds p on pg.PREPARED_GOOD_ID = p.ID

		delete plop
		-- output opIds ?
		from PICKING_LIST_OPERATION_PLAN plop join @pickingIds p on plop.PICKING_LIST_ID = p.ID

		declare @siIds IdTable, @scItemIds IdTable, @vasItemIds IdTable;
		insert into @siIds select * from Flatten ( @siMTable );
		insert into @scItemIds select * from Flatten (@scMTable);
		insert into @scItemIds select STOCK_CHANGE_ITEM_ID from @hhShiftings;
		insert into @siIds select FROM_ID from STOCK_CHANGE_ITEM where STOCK_CHANGE_ITEM_ID in (select ID from @scItemIds)
		insert into @siIds select TO_ID from STOCK_CHANGE_ITEM where STOCK_CHANGE_ITEM_ID in (select ID from @scItemIds)
		insert into @vasItemIds select * from Flatten (@vMTable);
		insert into @siIds select STOCK_INFO_ID from VAS_ITEM_FROM where VAS_ITEM_ID in (select ID from @vasItemIds)
		insert into @siIds select STOCK_INFO_ID from VAS_ITEM_TO where VAS_ITEM_ID in (select ID from @vasItemIds)
			
		declare @sirIds IdTable;
		delete from STOCK_INVENTORY_REQUEST
			output deleted.STOCK_INVENTORY_REQUEST_ID into @sirIds
			where ENTITY_ID in (select ID from @rptIds) and ENTITY_TYPE like '%OperationReport%'
				or ENTITY_ID in (select ID from @prepGoodIds) and ENTITY_TYPE like '%PreparedGood%'
		declare @stockIds IdTable;
		delete from STOCK_INVENTORY_REQUEST_ITEM
			output deleted.STOCK_ID into @stockIds 
			where REQUEST_ID in (select ID from @sirIds)
		delete from STOCK
			output deleted.STOCK_INFO_ID into @siIds
			where STOCK_ID in (select ID from @stockIds)

		print 'Deliting STOCK CHANGE ITEMS'
		delete sci
		from STOCK_CHANGE_ITEM sci join @scItemIds i on sci.STOCK_CHANGE_ITEM_ID = i.ID 

		delete from VAS_ITEM where VAS_ITEM_ID in (select ID from @vasItemIds)
		delete from VAS_ITEM_FROM where VAS_ITEM_ID in (select ID from @vasItemIds)
		delete from VAS_ITEM_TO where VAS_ITEM_ID in (select ID from @vasItemIds)

		print 'Deliting ORDERs'

		declare @transportIds IdTable
		insert into @transportIds(ID)
		select TRANSPORT_ID from ORDER_TRANSPORT where ORDER_ID IN(select ID from @orderIds)
		delete t from @transportIds t join ORDER_TRANSPORT ot on t.ID = ot.TRANSPORT_ID
		delete t from @transportIds t join DISCHARGING_OPERATION_PLAN dop on t.ID = dop.TRANSPORT_ID
		delete t from @transportIds t join DISCHARGING_OPERATION_REPORT dor on t.ID = dor.TRANSPORT_ID
		delete t from @transportIds t join LOADING_OPERATION_PLAN lop on t.ID = lop.TRANSPORT_ID
		delete t from @transportIds t join LOADING_OPERATION_REPORT lor on t.ID = lor.TRANSPORT_ID

		EXEC DeleteOrderCollections @orderIds

		delete from ORDERS where ORDER_ID IN(select ID from @orderIds)

		RAISERROR('Deliting STOCK INFOs',0,1)WITH NOWAIT;
		exec DeleteStockInfos @siIds

		RAISERROR('Deliting TRANSPORTs',0,1)WITH NOWAIT;
		EXEC DeleteTransports @transportIds

	update s set after = after + ps.row_count from @stats s, sys.dm_db_partition_stats ps where s.object_id = ps.object_id
	select *, before-after deleted from @stats where before>after order by deleted desc

	COMMIT TRANSACTION

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION
		SELECT ERROR_NUMBER() as ErrorNumber, ERROR_LINE() as ErrorLine, ERROR_MESSAGE() as ErrorMessage
END CATCH

drop proc DeleteTransports
drop proc DeleteOrderItemCollections
drop proc DeleteOrderCollections
drop proc DeleteStockInfos
drop function Flatten
drop type IdTable
drop type MultiTable