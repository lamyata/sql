CREATE PROCEDURE [dbo].[PrintInfo]
	@FujiProductGroupId int
AS
	declare @sicIds table (id int)
BEGIN

	set nocount on

	insert into @sicIds (id)
		select distinct sic.STOCK_INFO_CONFIG_ID
			from STOCK_INFO_CONFIG sic
			join STOCK_INFO si on si.STOCK_INFO_CONFIG_ID = sic.STOCK_INFO_CONFIG_ID
			join STOCK s on s.STOCK_INFO_ID = si.STOCK_INFO_ID
			join PRODUCT_GROUP_PRODUCT pgp on sic.PRODUCT_ID = pgp.PRODUCT_ID and pgp.PRODUCT_GROUP_ID = @FujiProductGroupId

	declare @sicCount int = ( select count (*) from @sicIds );


	declare @stockCount int = ( 
		select count (*) from STOCK s join STOCK_INFO si on s.STOCK_INFO_ID = si.STOCK_INFO_ID
			join @sicIds sicIds on si.STOCK_INFO_CONFIG_ID = sicIds.Id
	)

	declare @extraQuantityCount int = (
		select count (*) from STOCK_INFO_EXTRA_QUANTITY sieq join STOCK_INFO si on sieq.STOCK_INFO_ID = si.STOCK_INFO_ID
			join @sicIds sicIds on si.STOCK_INFO_CONFIG_ID = sicIds.Id
	)

	declare @siCount int
	select @siCount = count (*)  from STOCK_INFO si
			join @sicIds sicIds on si.STOCK_INFO_CONFIG_ID = sicIds.Id

	declare @storageQuantityCount int
	select @storageQuantityCount = count (*)  from STOCK_INFO si
			join @sicIds sicIds on si.STOCK_INFO_CONFIG_ID = sicIds.Id
			where si.STORAGE_QUANTITY_ID is not null

	declare @sisCount int = ( 
		select count (*) from STOCK_INFO_SID sis join @sicIds sicIds on sis.STOCK_INFO_CONFIG_ID = sicIds.Id
	)

	print 'STOCK INFO CONFIG: ' + cast(@sicCount as varchar(10));
	print 'STOCK: ' + cast(@stockCount as varchar(10));
	print 'EXTRA QUANTITIES: ' + cast(@extraQuantityCount as varchar(10));
	print 'STOCK INFOS: ' + cast(@siCount as varchar(10));
	print 'STORAGE QUANTITIES: ' + cast(@storageQuantityCount as varchar(10));
	print 'STOCK INFO SIS: ' + cast(@sisCount as varchar(10));

END
GO

declare @FujiProductGroupId int = (select PRODUCT_GROUP_ID from PRODUCT_GROUP where CODE = 'FUJI');

declare @deletedIds table (
 STOCK_INFO_ID int,
 STOCK_INFO_CONFIG_ID int,
 STOCK_INFO_QUANTITY_ID int,
 BASE_QUANTITY_ID int,
 STORAGE_QUANTITY_ID int
);

print 'FUJI STOCK BEFORE SCRIPT WAS RUN';
exec PrintInfo @FujiProductGroupId

delete s 
	output deleted.STOCK_INFO_ID into @deletedIds(STOCK_INFO_ID)
	from STOCK s join STOCK_INFO si on s.STOCK_INFO_ID = si.STOCK_INFO_ID
	join STOCK_INFO_CONFIG sic on si.STOCK_INFO_CONFIG_ID = sic.STOCK_INFO_CONFIG_ID
	join PRODUCT_GROUP_PRODUCT pgp on sic.PRODUCT_ID = pgp.PRODUCT_ID and pgp.PRODUCT_GROUP_ID = @FujiProductGroupId

delete sieq 
	output deleted.STOCK_INFO_QUANTITY_ID into @deletedIds(STOCK_INFO_QUANTITY_ID)
	from STOCK_INFO_EXTRA_QUANTITY sieq
	join @deletedIds d on sieq.STOCK_INFO_ID = d.STOCK_INFO_ID

delete si
 output deleted.STOCK_INFO_CONFIG_ID, deleted.BASE_QUANTITY_ID, deleted.STORAGE_QUANTITY_ID
	into @deletedIds (STOCK_INFO_CONFIG_ID, BASE_QUANTITY_ID, STORAGE_QUANTITY_ID)
 from STOCK_INFO si join @deletedIds d on si.STOCK_INFO_ID = d.STOCK_INFO_ID

delete siq
 from STOCK_INFO_QUANTITY siq
 join @deletedIds d on siq.STOCK_INFO_QUANTITY_ID = d.BASE_QUANTITY_ID
	or siq.STOCK_INFO_QUANTITY_ID = d.STORAGE_QUANTITY_ID
	or siq.STOCK_INFO_QUANTITY_ID = d.STOCK_INFO_QUANTITY_ID;

delete siceu
 from STOCK_INFO_CONFIG_EXTRA_UNIT siceu join @deletedIds d on siceu.STOCK_INFO_CONFIG_ID = d.STOCK_INFO_CONFIG_ID;

delete sis
 from STOCK_INFO_SID sis join @deletedIds d on sis.STOCK_INFO_CONFIG_ID = d.STOCK_INFO_CONFIG_ID;

delete sic
 from STOCK_INFO_CONFIG sic
 join @deletedIds d on sic.STOCK_INFO_CONFIG_ID = d.STOCK_INFO_CONFIG_ID;

print '';
print 'FUJI STOCK AFTER SCRIPT WAS RUN';
exec PrintInfo @FujiProductGroupId
drop procedure PrintInfo