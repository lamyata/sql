create proc UpdateContainerInfo
	@PrefixSidValue nvarchar(250),
	@NumberSidValue nvarchar(250),
	@OwnerCompanyCode nvarchar(50),
	@NetQuantity decimal (38, 8),
	@TareQuantity decimal (38, 8),
	@SealSidValue nvarchar(250),
	@ContentSidValue nvarchar(250)
as
	declare @ContainerProductCode nvarchar(50) = 'CNT'
	declare @PrefixSidCode nvarchar (11) = 'CNT_PREFIX'
	declare @NumberSidCode nvarchar (11) = 'CNT_NR'
	declare @SealSidCode nvarchar (11) = 'CNT_SEALNR'
	declare @ContentSidCode nvarchar (11) = 'CNT_CONTENT'
	declare @GrossUnitCode nvarchar (50) = 'Gross'
	declare @TareUnitCode nvarchar (50) = 'Tare'

	declare @StockInfoId int
	declare @StockInfoConfigId int

	declare @PrefixSidId int
	declare @NumberSidId int
	declare @BaseQuantity decimal (38, 8)
begin

select @PrefixSidId = STORAGE_IDENTIFIER_ID from STORAGE_IDENTIFIER where CODE = @PrefixSidCode
select @NumberSidId = STORAGE_IDENTIFIER_ID from STORAGE_IDENTIFIER where CODE = @NumberSidCode

select top 1
	@StockInfoId = si.STOCK_INFO_ID,
	@StockInfoConfigId = sic.STOCK_INFO_CONFIG_ID
from STOCK s join STOCK_INFO si on s.STOCK_INFO_ID = si.STOCK_INFO_ID
	join STOCK_INFO_CONFIG sic on si.STOCK_INFO_CONFIG_ID = sic.STOCK_INFO_CONFIG_ID
	join PRODUCT p on sic.PRODUCT_ID = p.PRODUCT_ID and p.CODE = @ContainerProductCode
	join STOCK_INFO_SID sis on si.STOCK_INFO_CONFIG_ID = sis.STOCK_INFO_CONFIG_ID and sis.SID_ID = @PrefixSidId and sis.VALUE = @PrefixSidValue
	join STOCK_INFO_SID sis2 on si.STOCK_INFO_CONFIG_ID = sis2.STOCK_INFO_CONFIG_ID and sis2.SID_ID = @NumberSidId and sis2.VALUE = @NumberSidValue
	order by si.UPDATE_TIMESTAMP desc
	
select @BaseQuantity = QUANTITY from STOCK_INFO_QUANTITY siq join STOCK_INFO si on si.BASE_QUANTITY_ID = siq.STOCK_INFO_QUANTITY_ID and si.STOCK_INFO_ID = @StockInfoId
if not @BaseQuantity > 0 return

update siq
set QUANTITY = @TareQuantity,
	UPDATE_TIMESTAMP = GETDATE(),
	UPDATE_USER = 'la161011'
from STOCK_INFO_QUANTITY siq
	join STOCK_INFO_EXTRA_QUANTITY sieq on siq.STOCK_INFO_QUANTITY_ID = sieq.STOCK_INFO_QUANTITY_ID and sieq.STOCK_INFO_ID = @StockInfoId
	join UNIT u on siq.UNIT_ID = u.UNIT_ID and u.CODE = @TareUnitCode

update siq
set QUANTITY = @NetQuantity + @TareQuantity,
	UPDATE_TIMESTAMP = GETDATE(),
	UPDATE_USER = 'la161011'
from STOCK_INFO_QUANTITY siq
	join STOCK_INFO_EXTRA_QUANTITY sieq on siq.STOCK_INFO_QUANTITY_ID = sieq.STOCK_INFO_QUANTITY_ID and sieq.STOCK_INFO_ID = @StockInfoId
	join UNIT u on siq.UNIT_ID =u.UNIT_ID and u.CODE = @GrossUnitCode

update sic
set OWNER_ID = c.COMPANYNR,
	UPDATE_TIMESTAMP = GETDATE(),
	UPDATE_USER = 'la161011'
from STOCK_INFO_CONFIG sic, COMPANY c
where c.CODE = @OwnerCompanyCode and sic.STOCK_INFO_CONFIG_ID = @StockInfoConfigId

update sis
set VALUE = @SealSidValue,
	UPDATE_TIMESTAMP = GETDATE(),
	UPDATE_USER = 'la161011'
from STOCK_INFO_SID sis join STORAGE_IDENTIFIER si on si.STORAGE_IDENTIFIER_ID = sis.SID_ID and sis.STOCK_INFO_CONFIG_ID = @StockInfoConfigId and si.CODE = @SealSidCode

update sis
set VALUE = @ContentSidValue,
	UPDATE_TIMESTAMP = GETDATE(),
	UPDATE_USER = 'la161011'
from STOCK_INFO_SID sis join STORAGE_IDENTIFIER si on si.STORAGE_IDENTIFIER_ID = sis.SID_ID and sis.STOCK_INFO_CONFIG_ID = @StockInfoConfigId and si.CODE = @ContentSidCode

end
go

exec UpdateContainerInfo 'TGHU','0153075','MSC',0,2200,'','empty'
exec UpdateContainerInfo 'TGHU','0481990','MSC',26790,2200,'AB642404','full'
exec UpdateContainerInfo 'TGHU','0809672','MSC',24000,2200,'AB642422','full'
exec UpdateContainerInfo 'MEDU','1023132','MSC',0,2200,'','empty'
exec UpdateContainerInfo 'MEDU','1145803','MSC',26530,2200,'AB642495','full'
exec UpdateContainerInfo 'XINU','1196096','MSC',0,2200,'','empty'
exec UpdateContainerInfo 'MEDU','1240842','MSC',24000,2200,'AB642470','full'
exec UpdateContainerInfo 'MEDU','1271490','MSC',26640,2200,'AB642401','full'
exec UpdateContainerInfo 'MEDU','1371101','MSC',26650,2200,'AB642408','full'
exec UpdateContainerInfo 'CXDU','1398570','MSC',24000,2200,'AB642429','full'
exec UpdateContainerInfo 'MEDU','1412828','MSC',0,2200,'','empty'
exec UpdateContainerInfo 'MEDU','1527597','MSC',0,2200,'','empty'
exec UpdateContainerInfo 'MEDU','1644799','MSC',24000,2200,'AB642445','full'
exec UpdateContainerInfo 'MEDU','1645202','MSC',26190,2200,'AB642494','full'
exec UpdateContainerInfo 'TRHU','1730194','MSC',26520,2200,'AB642497','full'
exec UpdateContainerInfo 'MEDU','1758889','MSC',27480,2200,'AB642405','full'
exec UpdateContainerInfo 'MEDU','1865790','MSC',0,2200,'','empty'
exec UpdateContainerInfo 'GVCU','2030573','MSC',0,2200,'','empty'
exec UpdateContainerInfo 'TCKU','2072119','MSC',24000,2200,'AB642442','full'
exec UpdateContainerInfo 'TCLU','2092283','MSC',0,2200,'','empty'
exec UpdateContainerInfo 'TRHU','2095719','MSC',24000,2200,'AB642425','full'
exec UpdateContainerInfo 'MEDU','2145942','MSC',26300,2200,'AB642409','full'
exec UpdateContainerInfo 'TCLU','2181950','MSC',0,2200,'','empty'
exec UpdateContainerInfo 'MEDU','2191700','MSC',26540,2200,'AB642406','full'
exec UpdateContainerInfo 'TCLU','2370682','MSC',0,2200,'','empty'
exec UpdateContainerInfo 'MEDU','2376828','MSC',24000,2200,'AB642443','full'
exec UpdateContainerInfo 'MEDU','2415159','MSC',0,2200,'','empty'
exec UpdateContainerInfo 'MSCU','2488689','MSC',24000,2200,'AB642424','full'
exec UpdateContainerInfo 'DFSU','2497800','MSC',24000,2200,'AB642449','full'
exec UpdateContainerInfo 'MEDU','2656602','MSC',0,2200,'','empty'
exec UpdateContainerInfo 'MEDU','2729680','MSC',0,2200,'','empty'
exec UpdateContainerInfo 'TGHU','2876392','MSC',0,2200,'','empty'
exec UpdateContainerInfo 'MEDU','2892932','MSC',24000,2200,'AB642462','full'
exec UpdateContainerInfo 'GLDU','2898271','MSC',0,2200,'','empty'
exec UpdateContainerInfo 'DFSU','2910641','MSC',0,2200,'','empty'
exec UpdateContainerInfo 'MEDU','3002550','MSC',24000,2200,'AB642461','full'
exec UpdateContainerInfo 'CAIU','3053304','MSC',24000,2200,'AB642427','full'
exec UpdateContainerInfo 'MEDU','3119589','MSC',26690,2200,'AB642498','full'
exec UpdateContainerInfo 'IPXU','3130348','MSC',0,2200,'','empty'
exec UpdateContainerInfo 'MEDU','3175089','MSC',27020,2200,'AB642499','full'
exec UpdateContainerInfo 'TCKU','3388020','MSC',26630,2200,'AB642493','full'
exec UpdateContainerInfo 'MEDU','3488340','MSC',24000,2200,'AB642421','full'
exec UpdateContainerInfo 'MSCU','3520430','MSC',0,2200,'','empty'
exec UpdateContainerInfo 'MSCU','3529838','MSC',26500,2200,'AB642496','full'
exec UpdateContainerInfo 'TRLU','3538297','MSC',0,2200,'','empty'
exec UpdateContainerInfo 'MSCU','3545206','MSC',0,2200,'','empty'
exec UpdateContainerInfo 'MSCU','3556160','MSC',27780,2200,'AB642403','full'
exec UpdateContainerInfo 'MSCU','3574122','MSC',0,2200,'','empty'
exec UpdateContainerInfo 'CLHU','3611155','MSC',0,2200,'','full'
exec UpdateContainerInfo 'GLDU','3739079','MSC',26580,2200,'AB642407','full'
exec UpdateContainerInfo 'MEDU','3835691','MSC',24000,2200,'AB642448','full'
exec UpdateContainerInfo 'IPXU','3849856','MSC',24000,2200,'AB642447','full'
exec UpdateContainerInfo 'MEDU','3858038','MSC',26370,2200,'AB642402','full'
exec UpdateContainerInfo 'MSCU','3863260','MSC',24000,2200,'AB642426','full'
exec UpdateContainerInfo 'MEDU','3868988','MSC',24000,2200,'AB642428','full'
exec UpdateContainerInfo 'MEDU','3879391','MSC',0,2200,'','empty'
exec UpdateContainerInfo 'MEDU','3897121','MSC',24000,2200,'AB642450','full'
exec UpdateContainerInfo 'TEMU','3942795','MSC',26680,2200,'AB642410','full'
exec UpdateContainerInfo 'GLDU','3949352','MSC',0,2200,'','empty'
exec UpdateContainerInfo 'MSCU','3987682','MSC',0,2200,'','empty'
exec UpdateContainerInfo 'GLDU','3992214','MSC',0,2200,'','empty'
exec UpdateContainerInfo 'FCIU','4625491','MSC',0,2200,'','empty'
exec UpdateContainerInfo 'GLDU','5075019','MSC',24000,2200,'AB642469','full'
exec UpdateContainerInfo 'GLDU','5491314','MSC',26740,2200,'AB642500','full'
exec UpdateContainerInfo 'GLDU','5562418','MSC',24000,2200,'AB642446','full'
exec UpdateContainerInfo 'MSCU','6277088','MSC',24000,2200,'AB642350','full'
exec UpdateContainerInfo 'MSCU','6608930','MSC',24000,2200,'AB642441','full'
exec UpdateContainerInfo 'MEDU','6742416','MSC',24000,2200,'AB642444','full'
exec UpdateContainerInfo 'GLDU','9468539','MSC',24000,2200,'AB642423','full'
exec UpdateContainerInfo 'TTNU','3960153','MARFRET',0,2210,'','empty'

drop proc UpdateContainerInfo



--declare @pfx nvarchar(250) = 'TGHU'
--declare @nr nvarchar(250) = '0481990'

--select si.STOCK_INFO_ID, sic.STOCK_INFO_CONFIG_ID, sic.OWNER_ID, sis.VALUE, sis2.VALUE, bq.QUANTITY as Base,
--	siq.UNIT_ID, siq.MEASUREMENT_UNIT_ID, siq.QUANTITY, sisSealNr.VALUE as SEAL_NR, sisCnt.VALUE as CONTENT
--from STOCK s join STOCK_INFO si on s.STOCK_INFO_ID = si.STOCK_INFO_ID
--	join STOCK_INFO_CONFIG sic on si.STOCK_INFO_CONFIG_ID = sic.STOCK_INFO_CONFIG_ID and sic.PRODUCT_ID = 10
--	join STOCK_INFO_SID sis on si.STOCK_INFO_CONFIG_ID = sis.STOCK_INFO_CONFIG_ID and sis.SID_ID = 27 and sis.VALUE = @pfx
--	join STOCK_INFO_SID sis2 on si.STOCK_INFO_CONFIG_ID = sis2.STOCK_INFO_CONFIG_ID and sis2.SID_ID = 28 and sis2.VALUE = @nr
--	join STOCK_INFO_QUANTITY bq on bq.STOCK_INFO_QUANTITY_ID = si.BASE_QUANTITY_ID
--	join STOCK_INFO_EXTRA_QUANTITY sieq on sieq.STOCK_INFO_ID = si.STOCK_INFO_ID
--	join STOCK_INFO_QUANTITY siq on sieq.STOCK_INFO_QUANTITY_ID = siq.STOCK_INFO_QUANTITY_ID
--	join STOCK_INFO_SID sisSealNr on si.STOCK_INFO_CONFIG_ID = sisSealNr.STOCK_INFO_CONFIG_ID and sisSealNr.SID_ID = 31
--	join STOCK_INFO_SID sisCnt on si.STOCK_INFO_CONFIG_ID = sisCnt.STOCK_INFO_CONFIG_ID and sisCnt.SID_ID = 42

--begin tran
--exec UpdateContainerInfo 'TGHU','0481990','MSC',26790,2200,'AB642404','full'

--select si.STOCK_INFO_ID, sic.STOCK_INFO_CONFIG_ID, sic.OWNER_ID, sis.VALUE, sis2.VALUE, bq.QUANTITY as Base,
--	siq.UNIT_ID, siq.MEASUREMENT_UNIT_ID, siq.QUANTITY, sisSealNr.VALUE as SEAL_NR, sisCnt.VALUE as CONTENT
--from STOCK s join STOCK_INFO si on s.STOCK_INFO_ID = si.STOCK_INFO_ID
--	join STOCK_INFO_CONFIG sic on si.STOCK_INFO_CONFIG_ID = sic.STOCK_INFO_CONFIG_ID and sic.PRODUCT_ID = 10
--	join STOCK_INFO_SID sis on si.STOCK_INFO_CONFIG_ID = sis.STOCK_INFO_CONFIG_ID and sis.SID_ID = 27 and sis.VALUE = @pfx
--	join STOCK_INFO_SID sis2 on si.STOCK_INFO_CONFIG_ID = sis2.STOCK_INFO_CONFIG_ID and sis2.SID_ID = 28 and sis2.VALUE = @nr
--	join STOCK_INFO_QUANTITY bq on bq.STOCK_INFO_QUANTITY_ID = si.BASE_QUANTITY_ID
--	join STOCK_INFO_EXTRA_QUANTITY sieq on sieq.STOCK_INFO_ID = si.STOCK_INFO_ID
--	join STOCK_INFO_QUANTITY siq on sieq.STOCK_INFO_QUANTITY_ID = siq.STOCK_INFO_QUANTITY_ID
--	join STOCK_INFO_SID sisSealNr on si.STOCK_INFO_CONFIG_ID = sisSealNr.STOCK_INFO_CONFIG_ID and sisSealNr.SID_ID = 31
--	join STOCK_INFO_SID sisCnt on si.STOCK_INFO_CONFIG_ID = sisCnt.STOCK_INFO_CONFIG_ID and sisCnt.SID_ID = 42
--rollba