BEGIN TRY
	BEGIN TRAN

declare @OrderItemId int = 30647

declare @deletedIds table (
 OPERATION_REPORT_ID int,
 OPERATION_PLAN_ID int,
 OPERATION_CONTEXT_ID int,
 TARIFF_INFO_ID int,
 STOCK_INFO_ID int, 
 STOCK_INFO_CONFIG_ID int,
 STOCK_INFO_QUANTITY_ID int
);

declare @siIds table (ID1 int, ID2 int, ID3 int)

insert into @deletedIds (OPERATION_REPORT_ID, OPERATION_PLAN_ID, OPERATION_CONTEXT_ID, TARIFF_INFO_ID)
	select OPERATION_REPORT_ID, PLAN_ID, CONTEXT_ID, TARIFF_INFO_ID from OPERATION_REPORT
	where ORDER_ITEM_ID = @OrderItemId

print 'deleting operation reports'

delete lor
	output deleted.REPORTED_ID into @siIds(ID1)
	from LOADING_OPERATION_REPORT lor join @deletedIds d on lor.LOADING_OPERATION_REPORT_ID = d.OPERATION_REPORT_ID
delete dor
	output deleted.REPORTED_ID into @siIds(ID1)
	from DISCHARGING_OPERATION_REPORT dor join @deletedIds d on dor.DISCHARGING_OPERATION_REPORT_ID = d.OPERATION_REPORT_ID
insert into @siIds(ID1) select vif.STOCK_INFO_ID from VAS_OPERATION_REPORT vor join VAS_ITEM_FROM vif on vor.REPORTED_ID = vif.VAS_ITEM_ID join @deletedIds d on vor.VAS_OPERATION_REPORT_ID = d.OPERATION_REPORT_ID
insert into @siIds(ID1) select vit.STOCK_INFO_ID from VAS_OPERATION_REPORT vor join VAS_ITEM_TO vit on vor.REPORTED_ID = vit.VAS_ITEM_ID join @deletedIds d on vor.VAS_OPERATION_REPORT_ID = d.OPERATION_REPORT_ID
delete vor from VAS_OPERATION_REPORT vor join @deletedIds d on vor.VAS_OPERATION_REPORT_ID = d.OPERATION_REPORT_ID
insert into @siIds(ID1, ID2) select sci.FROM_ID, sci.TO_ID from STOCK_CHANGE_OPERATION_REPORT scor join STOCK_CHANGE_ITEM sci on scor.REPORTED_ID = sci.STOCK_CHANGE_ITEM_ID join @deletedIds d on scor.STOCK_CHANGE_OPERATION_REPORT_ID = d.OPERATION_REPORT_ID
delete sor from STOCK_CHANGE_OPERATION_REPORT sor join @deletedIds d on sor.STOCK_CHANGE_OPERATION_REPORT_ID = d.OPERATION_REPORT_ID
delete r from OPERATION_REPORT r join @deletedIds d on r.OPERATION_REPORT_ID = d.OPERATION_REPORT_ID
delete ti from TARIFF_INFO ti join @deletedIds d on ti.TARIFF_INFO_ID = d.TARIFF_INFO_ID

print 'deleting plans'

insert into @siIds(ID1) select vif.STOCK_INFO_ID from VAS_OPERATION_PLAN vop join VAS_ITEM_FROM vif on vif.VAS_ITEM_ID in (vop.PLANNED_ID, vop.PENDING_ID, vop.REMAINING_ID) join @deletedIds d on vop.VAS_OPERATION_PLAN_ID = d.OPERATION_PLAN_ID
insert into @siIds(ID1) select vit.STOCK_INFO_ID from VAS_OPERATION_PLAN vop join VAS_ITEM_TO vit on vit.VAS_ITEM_ID in (vop.PLANNED_ID, vop.PENDING_ID, vop.REMAINING_ID) join @deletedIds d on vop.VAS_OPERATION_PLAN_ID = d.OPERATION_PLAN_ID
insert into @siIds(ID1, ID2, ID3) select lop.PLANNED_ID, lop.PENDING_ID, lop.REMAINING_ID from LOADING_OPERATION_PLAN lop join @deletedIds d on lop.LOADING_OPERATION_PLAN_ID = d.OPERATION_PLAN_ID
insert into @siIds (ID1, ID2, ID3) select dop.PLANNED_ID, dop.PENDING_ID, dop.REMAINING_ID from DISCHARGING_OPERATION_PLAN dop join @deletedIds d on dop.DISCHARGING_OPERATION_PLAN_ID = d.OPERATION_PLAN_ID
insert into @siIds (ID1, ID2) select sci.FROM_ID, sci.TO_ID from STOCK_CHANGE_OPERATION_PLAN scop join STOCK_CHANGE_ITEM sci on sci.STOCK_CHANGE_ITEM_ID in (scop.PLANNED_ID, scop.PENDING_ID, scop.REMAINING_ID) join @deletedIds d on scop.STOCK_CHANGE_OPERATION_PLAN_ID = d.OPERATION_PLAN_ID
delete lop from LOADING_OPERATION_PLAN lop join @deletedIds d on lop.LOADING_OPERATION_PLAN_ID = d.OPERATION_PLAN_ID
delete dop from DISCHARGING_OPERATION_PLAN dop join @deletedIds d on dop.DISCHARGING_OPERATION_PLAN_ID = d.OPERATION_PLAN_ID
delete vop from VAS_OPERATION_PLAN vop join @deletedIds d on vop.VAS_OPERATION_PLAN_ID = d.OPERATION_PLAN_ID
delete sop from STOCK_CHANGE_OPERATION_PLAN sop join @deletedIds d on sop.STOCK_CHANGE_OPERATION_PLAN_ID = d.OPERATION_PLAN_ID
delete op
	output deleted.OPERATION_PLAN_ID, deleted.CONTEXT_ID into @deletedIds(OPERATION_PLAN_ID, OPERATION_CONTEXT_ID)
	from OPERATION_PLAN op join @deletedIds d on op.OPERATION_PLAN_ID = d.OPERATION_PLAN_ID

delete oc from OPERATION_CONTEXT oc join @deletedIds d on oc.OPERATION_CONTEXT_ID = d.OPERATION_CONTEXT_ID

insert into @deletedIds (STOCK_INFO_ID) select ID1 from @siIds union select ID2 from @siIds union select ID3 from @siIds
insert into @deletedIds (STOCK_INFO_CONFIG_ID) select si.STOCK_INFO_CONFIG_ID from STOCK_INFO si join @deletedIds d on si.STOCK_INFO_ID = d.STOCK_INFO_ID
insert into @deletedIds (STOCK_INFO_QUANTITY_ID) select si.BASE_QUANTITY_ID from STOCK_INFO si join @deletedIds d on si.STOCK_INFO_ID = d.STOCK_INFO_ID
insert into @deletedIds (STOCK_INFO_QUANTITY_ID) select si.STORAGE_QUANTITY_ID from STOCK_INFO si join @deletedIds d on si.STOCK_INFO_ID = d.STOCK_INFO_ID and si.STORAGE_QUANTITY_ID is not null
insert into @deletedIds (STOCK_INFO_QUANTITY_ID) select sieq.STOCK_INFO_QUANTITY_ID from STOCK_INFO_EXTRA_QUANTITY sieq join @deletedIds d on sieq.STOCK_INFO_ID = d.STOCK_INFO_ID

print 'deleting stock'

delete sis from STOCK_INFO_SID sis join @deletedIds d on sis.STOCK_INFO_CONFIG_ID = d.STOCK_INFO_CONFIG_ID
delete siceu from STOCK_INFO_CONFIG_EXTRA_UNIT siceu join @deletedIds d on siceu.STOCK_INFO_CONFIG_ID = d.STOCK_INFO_CONFIG_ID
delete sieq from STOCK_INFO_EXTRA_QUANTITY sieq join @deletedIds d on sieq.STOCK_INFO_ID = d.STOCK_INFO_ID
delete from STOCK_INFO where STOCK_INFO_ID in (select STOCK_INFO_ID from @deletedIds)
delete sic from STOCK_INFO_CONFIG sic join @deletedIds d on sic.STOCK_INFO_CONFIG_ID = d.STOCK_INFO_CONFIG_ID
delete siq from STOCK_INFO_QUANTITY siq join  @deletedIds d on siq.STOCK_INFO_QUANTITY_ID = d.STOCK_INFO_QUANTITY_ID

	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK
		SELECT ERROR_NUMBER() as ErrorNumber, ERROR_MESSAGE() as ErrorMessage
END CATCH

