insert into PRODUCT_GROUP_PRODUCT select pg.PRODUCT_GROUP_ID, p.PRODUCT_ID from PRODUCT_GROUP pg , PRODUCT where pg.CODE = '1106107' and p.CODE = '1001'  -- 520 prods - 8hrs

declare @PG_SU table (GRP varchar(20), SU varchar(20), COEF decimal(10,5))                                                                                            -- 8 hrs
insert into @PG_SU values ('1000', 'P750', 750), ('1000', 'P900', 900), ('1000', 'P960', 960), ('1000', 'P1000', 1000); -- . . .

insert into PRODUCT_STORAGE_UNIT select PRODUCT_ID, UNIT_ID, COEF from PRODUCT p join PRODUCT_GROUP_PRODUCT pgp on p.                                                 -- 8 hrs
