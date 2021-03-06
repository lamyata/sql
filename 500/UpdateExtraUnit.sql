create proc #UpdateExtraUnit
	@ProductCode nvarchar(50),
	@UnitCode nvarchar(50),
	@Coeff decimal(16,8),
	@Weight nvarchar(20) = ''
as
begin

	if @Weight = N'G' set @Coeff = @Coeff / 1000
	update put set COEF = @Coeff
	 from PRODUCT_UNIT_TEMP put join PRODUCT_EXTRA_UNIT peu on put.PRODUCT_UNIT_TEMP_ID = peu.EXTRA_UNIT_ID
		join WMS_UNIT u on put.UNIT_ID = u.UNIT_ID
		join WMS_PRODUCT p on peu.PRODUCT_ID = p.PRODUCT_ID
		where p.CODE = @ProductCode and u.CODE = @UnitCode
end
go
exec #UpdateExtraUnit '00624201', 'Gross', 124



update put set COEF = 123
 from PRODUCT_UNIT_TEMP put join PRODUCT_EXTRA_UNIT peu on put.PRODUCT_UNIT_TEMP_ID = peu.EXTRA_UNIT_ID
	join WMS_UNIT u on put.UNIT_ID = u.UNIT_ID
	join WMS_PRODUCT p on peu.PRODUCT_ID = p.PRODUCT_ID
	where p.CODE = '00624201' and u.CODE = 'Gross'

select *
 from PRODUCT_UNIT_TEMP put join PRODUCT_EXTRA_UNIT peu on put.PRODUCT_UNIT_TEMP_ID = peu.EXTRA_UNIT_ID
	join WMS_UNIT u on put.UNIT_ID = u.UNIT_ID
	join WMS_PRODUCT p on peu.PRODUCT_ID = p.PRODUCT_ID
	where p.CODE = '00624201' and u.CODE = 'Gross'