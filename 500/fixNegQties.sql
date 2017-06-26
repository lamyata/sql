update siq set QUANTITY = -QUANTITY
--select siq.*
from STOCK s join STOCK_INFO si on s.STOCK_INFO_ID = si.STOCK_INFO_ID and s.STOCK_ID between 764954 and 765048
	join STOCK_INFO_QUANTITY siq on si.BASE_QUANTITY_ID = siq.STOCK_INFO_QUANTITY_ID

update siq set QUANTITY = -QUANTITY
--select siq.*
from STOCK s join STOCK_INFO si on s.STOCK_INFO_ID = si.STOCK_INFO_ID and s.STOCK_ID between 764954 and 765048
	join STOCK_INFO_EXTRA_QUANTITY sieq on si.STOCK_INFO_ID = sieq.STOCK_INFO_ID
	join STOCK_INFO_QUANTITY siq on sieq.STOCK_INFO_QUANTITY_ID = siq.STOCK_INFO_QUANTITY_ID
	
-- select * from PRODUCT where PRODUCT_ID = 4447
-- select * from COMPANY where COMPANY_ID = 575