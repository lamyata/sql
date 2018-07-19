-- select FLs
select * from (
select ORDER_ITEM_ID as ENT_ID, 'OI' as TYPE, FINANCIAL_LINE_ID from ORDER_ITEM_FINANCIAL_LINE
union
select OPERATION_REPORT_ID, 'RPT', FINANCIAL_LINE_ID from OPERATION_REPORT_FINANCIAL_LINE
union
select LOCATION_ID, 'L', FINANCIAL_LINE_ID from LOCATION_FINANCIAL_LINE
union
select TRANSPORT_ID, 'T', FINANCIAL_LINE_ID from TRANSPORT_FINANCIAL_LINE
union
select FINANCIAL_LINE_ID, 'PARENT', CHILD_FINANCIAL_LINE_ID from FINANCIAL_LINE_LINE
) as FL
where FL.FINANCIAL_LINE_ID in (127545, 118960)

--select * from FINANCIAL_LINE_LINE where CHILD_FINANCIAL_LINE_ID in (5363, 5364, 10656, 10657)
declare @deletedIds table (FL_ID int, TI_ID int)
insert into @deletedIds (FL_ID) values (5353), (5354), (5355), (5356), (5357), (5358), (5359), (5360), (5361), (5362), (5363), (5364), (10656), (10657), (10672), (10673), (10684), (10685), (10658), (10659), (10660), (10661), (10662), (10663), (10664), (10665), (10666), (10674), (10675), (10676), (10677), (10678), (10679), (10680), (10686), (10687), (10688), (10689), (10690), (10691), (10692), (10693), (10694), (10695), (10696), (10697), (10294), (10296), (10698), (10699), (10719), (10720), (10733), (10735), (10295), (10297), (10298), (10299), (10300), (10301), (10302), (10303), (10304), (10305), (10306), (10307), (10308), (10700), (10701), (10702), (10703), (10704), (10705), (10706), (10707), (10708), (10709), (10710), (10721), (10722), (10723), (10724), (10725), (10726), (10727), (10728), (10729), (10730), (10731), (10734), (10736), (10737), (10738), (10739), (10740), (10741), (10742), (10743), (10744), (10745), (10746), (10747)
update d set d.TI_ID = fl.TARIFF_INFO_ID from @deletedIds d join FINANCIAL_LINE fl on d.FL_ID = fl.FINANCIAL_LINE_ID

-------delete financial lines from order items
select * from ORDER_ITEM_FINANCIAL_LINE where ORDER_ITEM_ID in ( 11313, 11315, 11316 )
select * from OPERATION_REPORT_FINANCIAL_LINE orfl join OPERATION_REPORT rpt on orfl.OPERATION_REPORT_ID = rpt.OPERATION_REPORT_ID and rpt.ORDER_ITEM_ID in ( 11313, 11315, 11316 )
--	join FINANCIAL_LINE_LINE fll on orfl.FINANCIAL_LINE_ID = fll.CHILD_FINANCIAL_LINE_ID -- join to FLL to make sure fls have not been added to invoices - should return no lines

declare @deleteIds table (FL_ID int, TI_ID int)
insert into @deleteIds (FL_ID) select orfl.FINANCIAL_LINE_ID
from OPERATION_REPORT_FINANCIAL_LINE orfl join OPERATION_REPORT rpt on orfl.OPERATION_REPORT_ID = rpt.OPERATION_REPORT_ID and rpt.ORDER_ITEM_ID in ( 11313, 11315, 11316 )
update d set d.TI_ID = fl.TARIFF_INFO_ID from @deleteIds d join FINANCIAL_LINE fl on d.FL_ID = fl.FINANCIAL_LINE_ID;

delete oifl from ORDER_ITEM_FINANCIAL_LINE oifl join @deleteIds d on oifl.FINANCIAL_LINE_ID = d.FL_ID
delete orfl from OPERATION_REPORT_FINANCIAL_LINE orfl join @deleteIds d on orfl.FINANCIAL_LINE_ID = d.FL_ID
delete lfl from LOCATION_FINANCIAL_LINE lfl join @deleteIds d on lfl.FINANCIAL_LINE_ID = d.FL_ID
delete fl from FINANCIAL_LINE fl join @deleteIds d on fl.FINANCIAL_LINE_ID = d.FL_ID
delete ti from TARIFF_INFO ti join @deleteIds d on ti.TARIFF_INFO_ID = d.TI_ID

--- dump financial line info
declare @deleteIds table (FL_ID int, TI_ID int, TR_ID int)
insert into @deleteIds (FL_ID) values (327602)
update d set d.TI_ID = fl.TARIFF_INFO_ID from @deleteIds d join FINANCIAL_LINE fl on d.FL_ID = fl.FINANCIAL_LINE_ID
insert into @deleteIds (TR_ID) select TARIFF_RANGE_ID from TARIFF_INFO_RANGE tir join @deleteIds d on tir.TARIFF_INFO_ID = d.TI_ID

select * from FINANCIAL_LINE_LINE fll join @deleteIds d on fll.FINANCIAL_LINE_ID = d.FL_ID
select * from FINANCIAL_LINE_LINE fll join @deleteIds d on fll.CHILD_FINANCIAL_LINE_ID = d.FL_ID
select * from ORDER_ITEM_FINANCIAL_LINE oifl join @deleteIds d on oifl.FINANCIAL_LINE_ID = d.FL_ID
select * from OPERATION_REPORT_FINANCIAL_LINE orfl join @deleteIds d on orfl.FINANCIAL_LINE_ID = d.FL_ID
select * from LOCATION_FINANCIAL_LINE lfl join @deleteIds d on lfl.FINANCIAL_LINE_ID = d.FL_ID
select * from TRANSPORT_FINANCIAL_LINE tfl join @deleteIds d on tfl.FINANCIAL_LINE_ID = d.FL_ID
select * from FINANCIAL_LINE fl join @deleteIds d on fl.FINANCIAL_LINE_ID = d.FL_ID
select * from TARIFF_INFO ti join @deleteIds d on ti.TARIFF_INFO_ID = d.TI_ID
select * from TARIFF_RANGE tr join @deleteIds d on  tr.TARIFF_RANGE_ID = d.TR_ID
select * from TARIFF_INFO_RANGE tir join @deleteIds d on tir.TARIFF_INFO_ID = d.TI_ID

--- del financial lines
declare @deleteIds table (FL_ID int, TI_ID int, TR_ID int)
insert into @deleteIds (FL_ID) values (327602)
update d set d.TI_ID = fl.TARIFF_INFO_ID from @deleteIds d join FINANCIAL_LINE fl on d.FL_ID = fl.FINANCIAL_LINE_ID
insert into @deleteIds (TR_ID) select TARIFF_RANGE_ID from TARIFF_INFO_RANGE tir join @deleteIds d on tir.TARIFF_INFO_ID = d.TI_ID

BEGIN TRY
	BEGIN TRANSACTION

delete oifl from ORDER_ITEM_FINANCIAL_LINE oifl join @deleteIds d on oifl.FINANCIAL_LINE_ID = d.FL_ID
delete orfl from OPERATION_REPORT_FINANCIAL_LINE orfl join @deleteIds d on orfl.FINANCIAL_LINE_ID = d.FL_ID
delete lfl from LOCATION_FINANCIAL_LINE lfl join @deleteIds d on lfl.FINANCIAL_LINE_ID = d.FL_ID
delete tfl from TRANSPORT_FINANCIAL_LINE tfl join @deleteIds d on tfl.FINANCIAL_LINE_ID = d.FL_ID
delete fl from FINANCIAL_LINE fl join @deleteIds d on fl.FINANCIAL_LINE_ID = d.FL_ID
delete tir from TARIFF_INFO_RANGE tir join @deleteIds d on tir.TARIFF_INFO_ID = d.TI_ID
delete ti from TARIFF_INFO ti join @deleteIds d on ti.TARIFF_INFO_ID = d.TI_ID
delete tr from TARIFF_RANGE tr join @deleteIds d on  tr.TARIFF_RANGE_ID = d.TR_ID

	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION
		SELECT ERROR_NUMBER() as ErrorNumber, ERROR_MESSAGE() as ErrorMessage
END CATCH
GO

--- del financial lines for invoice (you may need to add range here!)
declare @FinancialDocumentId int = 2062
declare @deleteIds table (FL_ID int, TI_ID int)
insert into @deleteIds (FL_ID) select FINANCIAL_LINE_ID from FINANCIAL_LINE where FINANCIAL_DOCUMENT_ID = @FinancialDocumentId
-- comment the following statement if you only want to detach the fls from the invoice w/o deleting them
insert into @deleteIds (FL_ID) select CHILD_FINANCIAL_LINE_ID from FINANCIAL_LINE_LINE fll join FINANCIAL_LINE fl on fll.FINANCIAL_LINE_ID = fl.FINANCIAL_LINE_ID
	and fl.FINANCIAL_DOCUMENT_ID = @FinancialDocumentId
update d set d.TI_ID = fl.TARIFF_INFO_ID from @deleteIds d join FINANCIAL_LINE fl on d.FL_ID = fl.FINANCIAL_LINE_ID

BEGIN TRY
	BEGIN TRANSACTION

delete fll from FINANCIAL_LINE_LINE fll join @deleteIds d on fll.FINANCIAL_LINE_ID = d.FL_ID
delete oifl from ORDER_ITEM_FINANCIAL_LINE oifl join @deleteIds d on oifl.FINANCIAL_LINE_ID = d.FL_ID
delete orfl from OPERATION_REPORT_FINANCIAL_LINE orfl join @deleteIds d on orfl.FINANCIAL_LINE_ID = d.FL_ID
delete lfl from LOCATION_FINANCIAL_LINE lfl join @deleteIds d on lfl.FINANCIAL_LINE_ID = d.FL_ID
delete fl from FINANCIAL_LINE fl join @deleteIds d on fl.FINANCIAL_LINE_ID = d.FL_ID
delete ti from TARIFF_INFO ti join @deleteIds d on ti.TARIFF_INFO_ID = d.TI_ID

	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION
		SELECT ERROR_NUMBER() as ErrorNumber, ERROR_MESSAGE() as ErrorMessage
END CATCH
GO

--- del unlinked financial lines
declare @deleteIds table (FL_ID int, TI_ID int, TARIFF_RANGE_ID int)
insert into @deleteIds (FL_ID)
select fl.FINANCIAL_LINE_ID from
FINANCIAL_LINE fl left join
(
select ORDER_ITEM_ID as ENT_ID, 'OI' as TYPE, FINANCIAL_LINE_ID from ORDER_ITEM_FINANCIAL_LINE
union
select OPERATION_REPORT_ID, 'RPT', FINANCIAL_LINE_ID from OPERATION_REPORT_FINANCIAL_LINE
union
select LOCATION_ID, 'L', FINANCIAL_LINE_ID from LOCATION_FINANCIAL_LINE
union
select TRANSPORT_ID, 'T', FINANCIAL_LINE_ID from TRANSPORT_FINANCIAL_LINE
) xfl
on fl.FINANCIAL_LINE_ID = xfl.FINANCIAL_LINE_ID
where fl.PARTNER_ID = 516 and xfl.ENT_ID is null
and fl.FINANCIAL_LINE_ID not in (select CHILD_FINANCIAL_LINE_ID from FINANCIAL_LINE_LINE)
and fl.FINANCIAL_LINE_ID not in (select FINANCIAL_LINE_ID from FINANCIAL_LINE_LINE)
update d set d.TI_ID = fl.TARIFF_INFO_ID from @deleteIds d join FINANCIAL_LINE fl on d.FL_ID = fl.FINANCIAL_LINE_ID
update d set d.TARIFF_RANGE_ID = fl.TARIFF_RANGE_ID from @deleteIds d join FINANCIAL_LINE fl on d.FL_ID = fl.FINANCIAL_LINE_ID

BEGIN TRY
	BEGIN TRANSACTION

delete oifl from ORDER_ITEM_FINANCIAL_LINE oifl join @deleteIds d on oifl.FINANCIAL_LINE_ID = d.FL_ID
delete orfl from OPERATION_REPORT_FINANCIAL_LINE orfl join @deleteIds d on orfl.FINANCIAL_LINE_ID = d.FL_ID
delete lfl from LOCATION_FINANCIAL_LINE lfl join @deleteIds d on lfl.FINANCIAL_LINE_ID = d.FL_ID
delete fl from FINANCIAL_LINE fl join @deleteIds d on fl.FINANCIAL_LINE_ID = d.FL_ID
delete tir from TARIFF_INFO_RANGE tir join @deleteIds d on tir.TARIFF_INFO_ID = d.TI_ID
delete ti from TARIFF_INFO ti join @deleteIds d on ti.TARIFF_INFO_ID = d.TI_ID
delete tr from TARIFF_RANGE tr join @deleteIds d on tr.TARIFF_RANGE_ID = d.TARIFF_RANGE_ID

	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION
		SELECT ERROR_NUMBER() as ErrorNumber, ERROR_MESSAGE() as ErrorMessage
END CATCH
GO

-- three ways to find WHR financial lines:
select * from FINANCIAL_LINE fl where lower(DESCRIPTION) like '%rent%' 
select * from FINANCIAL_LINE fl where CREATE_USER = 'iTos_JOB_PR'
select * from FINANCIAL_LINE fl join LOCATION_FINANCIAL_LINE lfl on fl.FINANCIAL_LINE_ID = lfl.FINANCIAL_LINE_ID