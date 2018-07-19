declare @sgnIcId int = (select COMPANY_ID from COMPANY where CODE = 'IC_SGN')
update p set CODE = 'old_' + CODE
	from  PRODUCT p join PRODUCT_INT_COMPANY pic on p.PRODUCT_ID = pic.PRODUCT_ID and pic.INTERNAL_COMPANY_ID = @sgnIcId