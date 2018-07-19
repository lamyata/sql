select distinct sic.PRODUCT_ID from STOCK_INFO_CONFIG sic
	join STOCK_INFO si on sic.STOCK_INFO_CONFIG_ID = si.STOCK_INFO_CONFIG_ID
	join STOCK s on si.STOCK_INFO_ID = s.STOCK_INFO_ID
	where not exists (select * from PRODUCT_STORAGE_IDENTIFIER where PRODUCT_ID = sic.PRODUCT_ID)
	and sic._KEY_ not like '%"S":[[]]}'
