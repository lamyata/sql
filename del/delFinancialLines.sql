--select * from FINANCIAL_LINE_LINE where CHILD_FINANCIAL_LINE_ID in (5363, 5364, 10656, 10657)
declare @deletedIds table (FL_ID int, TI_ID int)
insert into @deletedIds (FL_ID) values (5353), (5354), (5355), (5356), (5357), (5358), (5359), (5360), (5361), (5362), (5363), (5364), (10656), (10657), (10672), (10673), (10684), (10685), (10658), (10659), (10660), (10661), (10662), (10663), (10664), (10665), (10666), (10674), (10675), (10676), (10677), (10678), (10679), (10680), (10686), (10687), (10688), (10689), (10690), (10691), (10692), (10693), (10694), (10695), (10696), (10697), (10294), (10296), (10698), (10699), (10719), (10720), (10733), (10735), (10295), (10297), (10298), (10299), (10300), (10301), (10302), (10303), (10304), (10305), (10306), (10307), (10308), (10700), (10701), (10702), (10703), (10704), (10705), (10706), (10707), (10708), (10709), (10710), (10721), (10722), (10723), (10724), (10725), (10726), (10727), (10728), (10729), (10730), (10731), (10734), (10736), (10737), (10738), (10739), (10740), (10741), (10742), (10743), (10744), (10745), (10746), (10747)
update d set d.TI_ID = fl.TARIFF_INFO_ID from @deletedIds d join FINANCIAL_LINE fl on d.FL_ID = fl.FINANCIAL_LINE_ID

delete lfl from LOCATION_FINANCIAL_LINE lfl join @deletedIds d on lfl.FINANCIAL_LINE_ID = d.FL_ID
delete fl from FINANCIAL_LINE fl join @deletedIds d on fl.FINANCIAL_LINE_ID = d.FL_ID
delete ti from TARIFF_INFO ti join @deletedIds d on ti.TARIFF_INFO_ID = d.TI_ID
