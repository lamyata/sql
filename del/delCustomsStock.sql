declare @ContainerProductCode nvarchar(50) = 'CNT';

declare @deletedIds table (
 STOCK_INFO_ID int,
 STOCK_INFO_CONFIG_ID int,
 STOCK_INFO_QUANTITY_ID int,
 BASE_QUANTITY_ID int,
 STORAGE_QUANTITY_ID int
);

delete cs
output deleted.STOCK_INFO_ID into @deletedIds(STOCK_INFO_ID)
from CUSTOMS_STOCK cs join STOCK_INFO si on cs.STOCK_INFO_ID = si.STOCK_INFO_ID
join STOCK_INFO_CONFIG sic on si.STOCK_INFO_CONFIG_ID = sic.STOCK_INFO_CONFIG_ID
join PRODUCT p on sic.PRODUCT_ID = p.PRODUCT_ID and p.CODE = @ContainerProductCode;

delete sieq
output deleted.STOCK_INFO_QUANTITY_ID into @deletedIds(STOCK_INFO_QUANTITY_ID)
from STOCK_INFO_EXTRA_QUANTITY sieq
join @deletedIds d on sieq.STOCK_INFO_ID = d.STOCK_INFO_ID;

update d
set STOCK_INFO_CONFIG_ID = si.STOCK_INFO_CONFIG_ID, BASE_QUANTITY_ID = si.BASE_QUANTITY_ID, STORAGE_QUANTITY_ID = si.STORAGE_QUANTITY_ID
from @deletedIds d join STOCK_INFO si on d.STOCK_INFO_ID = si.STOCK_INFO_ID

delete sis
from STOCK_INFO_SID sis join @deletedIds d on sis.STOCK_INFO_CONFIG_ID = d.STOCK_INFO_CONFIG_ID;

delete si
from STOCK_INFO si join @deletedIds d on si.STOCK_INFO_ID = d.STOCK_INFO_ID;

delete siceu
from STOCK_INFO_CONFIG_EXTRA_UNIT siceu join @deletedIds d on siceu.STOCK_INFO_CONFIG_ID = d.STOCK_INFO_CONFIG_ID;

delete sic
	from STOCK_INFO_CONFIG sic join @deletedIds d on sic.STOCK_INFO_CONFIG_ID = d.STOCK_INFO_CONFIG_ID

delete from STOCK_INFO_QUANTITY where STOCK_INFO_QUANTITY_ID in (
	select STOCK_INFO_QUANTITY_ID from @deletedIds union
	select BASE_QUANTITY_ID from @deletedIds union
	select STORAGE_QUANTITY_ID from @deletedIds
)