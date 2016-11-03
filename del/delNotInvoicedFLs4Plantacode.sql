declare @deletedIds table (FL_ID int, TI_ID int)

insert into @deletedIds (FL_ID)
select fl.FINANCIAL_LINE_ID from FINANCIAL_LINE fl join LOCATION_FINANCIAL_LINE lfl on fl.FINANCIAL_LINE_ID = lfl.FINANCIAL_LINE_ID and fl.PARTNER_ID = 11
	and fl.VALUE_DATE between '1-OCT-2016' and '31-OCT-2016'
	and fl.FINANCIAL_LINE_ID not in (select CHILD_FINANCIAL_LINE_ID from FINANCIAL_LINE_LINE)
update d set d.TI_ID = fl.TARIFF_INFO_ID from @deletedIds d join FINANCIAL_LINE fl on d.FL_ID = fl.FINANCIAL_LINE_ID

delete lfl from LOCATION_FINANCIAL_LINE lfl join @deletedIds d on lfl.FINANCIAL_LINE_ID = d.FL_ID
delete fl from FINANCIAL_LINE fl join @deletedIds d on fl.FINANCIAL_LINE_ID = d.FL_ID
delete ti from TARIFF_INFO ti join @deletedIds d on ti.TARIFF_INFO_ID = d.TI_ID