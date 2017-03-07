--select * from PRODUCT_STORAGE_UNIT psu join PRODUCT_UNIT pu on psu.STORAGE_UNIT_ID = pu.PRODUCT_UNIT_ID

create table bak_STORAGE_UNIT_COEFFS (PRODUCT_UNIT_ID int, COEF decimal (16,8))
insert into bak_STORAGE_UNIT_COEFFS select PRODUCT_UNIT_ID, COEF from PRODUCT_UNIT pu, PRODUCT_STORAGE_UNIT psu where pu.PRODUCT_UNIT_ID = psu.STORAGE_UNIT_ID
update pu set COEF = null from PRODUCT_UNIT pu, PRODUCT_STORAGE_UNIT psu where pu.PRODUCT_UNIT_ID = psu.STORAGE_UNIT_ID
 
--select * from bak_STORAGE_UNIT_COEFFS

--to restore SU coeffs run the following:
--update pu set COEF = psu.COEF from PRODUCT_UNIT pu, bak_STORAGE_UNIT_COEFFS psu where pu.PRODUCT_UNIT_ID = psu.PRODUCT_UNIT_ID