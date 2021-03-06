update pu set UNIT_ID = 15, UPDATE_USER = 'sys160811', UPDATE_TIMESTAMP = GETDATE() 
	from PRODUCT_UNIT pu join PRODUCT p on pu.PRODUCT_UNIT_ID = p.BASE_UNIT_ID and p.PRODUCT_ID = 2612 and pu.UNIT_ID = 18
update sic set BASE_UNIT_ID = 15, _KEY_ = REPLACE(_KEY_,',"BU":18,',',"BU":15,'), SHORT_KEY = REPLACE(SHORT_KEY,',"BU":18,',',"BU":15,'), UPDATE_USER = 'sys160811', UPDATE_TIMESTAMP = GETDATE()
	from STOCK s
	inner join STOCK_INFO si on si.STOCK_INFO_ID = s.STOCK_INFO_ID
	inner join STOCK_INFO_CONFIG sic on sic.STOCK_INFO_CONFIG_ID = si.STOCK_INFO_CONFIG_ID
	where sic.INTERNAL_COMPANY_ID = 299
	and sic.PRODUCT_ID = 2612
	and BASE_UNIT_ID = 18
update b_siq set UNIT_ID = 15, UPDATE_USER = 'sys160811', UPDATE_TIMESTAMP = GETDATE()
	from STOCK s
	inner join STOCK_INFO si on si.STOCK_INFO_ID = s.STOCK_INFO_ID
	inner join STOCK_INFO_CONFIG sic on sic.STOCK_INFO_CONFIG_ID = si.STOCK_INFO_CONFIG_ID
	inner join STOCK_INFO_QUANTITY b_siq on si.BASE_QUANTITY_ID = b_siq.STOCK_INFO_QUANTITY_ID
	where sic.INTERNAL_COMPANY_ID = 299
	and sic.PRODUCT_ID = 2612
	and UNIT_ID =  18