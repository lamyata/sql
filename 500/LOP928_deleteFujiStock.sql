CREATE PROC print_Messg
	@msg varchar (50),
	@rows int
AS
BEGIN
    print (@msg + ': ' + cast (@rows as varchar (10) ) + ' rows');
END
GO

create PROCEDURE print_Nfo
	@FujiProductGroupId int
AS
	declare @sicIds table (id int)
	declare @prdIds table (id int)
BEGIN

	set nocount on

	insert into @prdIds
		select distinct PRODUCT_ID from PRODUCT_GROUP_PRODUCT where PRODUCT_GROUP_ID = @FujiProductGroupId

	insert into @sicIds (id)
		select distinct sic.STOCK_INFO_CONFIG_ID
			from STOCK_INFO_CONFIG sic
			join STOCK_INFO si on si.STOCK_INFO_CONFIG_ID = sic.STOCK_INFO_CONFIG_ID
			join PRODUCT_GROUP_PRODUCT pgp on sic.PRODUCT_ID = pgp.PRODUCT_ID and pgp.PRODUCT_GROUP_ID = @FujiProductGroupId

	declare @sicCount int = ( select count (*) from @sicIds );

	declare @stockCount int = ( 
		select count (*) from STOCK s join STOCK_INFO si on s.STOCK_INFO_ID = si.STOCK_INFO_ID
			join @sicIds sicIds on si.STOCK_INFO_CONFIG_ID = sicIds.id
	)

	declare @extraQuantityCount int = (
		select count (*) from STOCK_INFO_EXTRA_QUANTITY sieq join STOCK_INFO si on sieq.STOCK_INFO_ID = si.STOCK_INFO_ID
			join @sicIds sicIds on si.STOCK_INFO_CONFIG_ID = sicIds.id
	)

	declare @siCount int
	select @siCount = count (*)  from STOCK_INFO si
			join @sicIds sicIds on si.STOCK_INFO_CONFIG_ID = sicIds.id

	declare @storageQuantityCount int
	select @storageQuantityCount = count (*)  from STOCK_INFO si
			join @sicIds sicIds on si.STOCK_INFO_CONFIG_ID = sicIds.id
			where si.STORAGE_QUANTITY_ID is not null

	declare @sisCount int = ( 
		select count (*) from STOCK_INFO_SID sis join @sicIds sicIds on sis.STOCK_INFO_CONFIG_ID = sicIds.id
	)

	declare @prdCount int = ( select count (*) from @prdIds );
	declare @prdSidCount int = ( select count (*) from PRODUCT_STORAGE_IDENTIFIER psi join @prdIds prdIds on psi.PRODUCT_ID = prdIds.id );

	exec print_Messg 'PRODUCTS',  @prdCount;
	exec print_Messg 'PRODUCT_STORAGE_IDENTIFIER', @prdSidCount;
	exec print_Messg 'STOCK INFO CONFIG', @sicCount;
	exec print_Messg 'STOCK', @stockCount;
	exec print_Messg 'EXTRA QUANTITIES', @extraQuantityCount;
	exec print_Messg 'STOCK INFOS', @siCount;
	exec print_Messg 'STORAGE QUANTITIES', @storageQuantityCount;
	exec print_Messg 'STOCK_INFO_SID', @sisCount;
	print '';

END
GO

declare @FujiProductGroupId int = (select PRODUCT_GROUP_ID from PRODUCT_GROUP where CODE = 'FJ_SV');

declare @deletedIds table (
 STOCK_INFO_ID int,
 STOCK_INFO_CONFIG_ID int,
 STOCK_INFO_QUANTITY_ID int,
 BASE_QUANTITY_ID int,
 STORAGE_QUANTITY_ID int,
 PRODUCT_ID int,
 PRODUCT_STORAGE_IDENTIFIER_ID int,
 BASE_UNIT_ID int,
 STORAGE_UNIT_ID int,
 EXTRA_UNIT_ID int
);

declare @rows int;

print 'FUJI STOCK BEFORE SCRIPT WAS RUN';
exec print_Nfo @FujiProductGroupId

begin tran

set nocount on

insert into @deletedIds (STOCK_INFO_CONFIG_ID)
	select distinct STOCK_INFO_CONFIG_ID from STOCK_INFO_CONFIG sic
		join PRODUCT_GROUP_PRODUCT pgp on sic.PRODUCT_ID = pgp.PRODUCT_ID and pgp.PRODUCT_GROUP_ID = @FujiProductGroupId

delete s 
	from STOCK s join STOCK_INFO si on s.STOCK_INFO_ID = si.STOCK_INFO_ID
	join @deletedIds d on si.STOCK_INFO_CONFIG_ID = d.STOCK_INFO_CONFIG_ID
	exec print_Messg 'Delete STOCK', @@ROWCOUNT;

delete sieq 
	output deleted.STOCK_INFO_QUANTITY_ID into @deletedIds(STOCK_INFO_QUANTITY_ID)
	from STOCK_INFO_EXTRA_QUANTITY sieq join STOCK_INFO si on sieq.STOCK_INFO_ID = si.STOCK_INFO_ID
	join @deletedIds d on si.STOCK_INFO_CONFIG_ID = d.STOCK_INFO_CONFIG_ID
	exec print_Messg 'Delete STOCK_INFO_EXTRA_QUANTITY', @@ROWCOUNT;

delete siri
	from STOCK_INVENTORY_REQUEST_ITEM siri
	join STOCK_INFO si on si.STOCK_INFO_ID = siri.STOCK_INFO_ID
	join @deletedIds d on si.STOCK_INFO_CONFIG_ID = d.STOCK_INFO_CONFIG_ID
	exec print_Messg 'Delete STOCK_INVENTORY_REQUEST_ITEM', @@ROWCOUNT;

delete si
 output deleted.STOCK_INFO_ID, deleted.BASE_QUANTITY_ID, deleted.STORAGE_QUANTITY_ID
	into @deletedIds (STOCK_INFO_ID, BASE_QUANTITY_ID, STORAGE_QUANTITY_ID)
 from STOCK_INFO si join @deletedIds d on si.STOCK_INFO_CONFIG_ID = d.STOCK_INFO_CONFIG_ID
	exec print_Messg 'Delete STOCK_INFO', @@ROWCOUNT;

delete siq
 from STOCK_INFO_QUANTITY siq
 join @deletedIds d on siq.STOCK_INFO_QUANTITY_ID = d.BASE_QUANTITY_ID
	or siq.STOCK_INFO_QUANTITY_ID = d.STORAGE_QUANTITY_ID
	or siq.STOCK_INFO_QUANTITY_ID = d.STOCK_INFO_QUANTITY_ID;
	exec print_Messg 'Delete STOCK_INFO_QUANTITY', @@ROWCOUNT;

delete siceu
 from STOCK_INFO_CONFIG_EXTRA_UNIT siceu join @deletedIds d on siceu.STOCK_INFO_CONFIG_ID = d.STOCK_INFO_CONFIG_ID;
	exec print_Messg 'Delete STOCK_INFO_CONFIG_EXTRA_UNIT', @@ROWCOUNT;

delete sis
 from STOCK_INFO_SID sis join @deletedIds d on sis.STOCK_INFO_CONFIG_ID = d.STOCK_INFO_CONFIG_ID;
	exec print_Messg 'Delete STOCK_INFO_SID', @@ROWCOUNT;

delete sic
 from STOCK_INFO_CONFIG sic
 join @deletedIds d on sic.STOCK_INFO_CONFIG_ID = d.STOCK_INFO_CONFIG_ID;
	exec print_Messg 'Delete STOCK_INFO_CONFIG', @@ROWCOUNT;

DELETE pgp
	output deleted.PRODUCT_ID into @deletedIds (PRODUCT_ID)
	FROM PRODUCT_GROUP_PRODUCT pgp where pgp.PRODUCT_GROUP_ID = @FujiProductGroupId
	exec print_Messg 'Delete PRODUCT_GROUP_PRODUCT', @@ROWCOUNT;

delete pic FROM PRODUCT_INT_COMPANY pic join @deletedIds d	on pic.PRODUCT_ID = d.PRODUCT_ID
	exec print_Messg 'Delete PRODUCT_INT_COMPANY', @@ROWCOUNT;

DELETE pc FROM PRODUCT_COMPANY pc join @deletedIds d	on pc.PRODUCT_ID = d.PRODUCT_ID
	exec print_Messg 'Delete PRODUCT_COMPANY', @@ROWCOUNT;

DELETE pl FROM PRODUCT_LOCATION pl join @deletedIds d	on pl.PRODUCT_ID = d.PRODUCT_ID;
	exec print_Messg 'Delete PRODUCT_LOCATION', @@ROWCOUNT;

delete psi
	output deleted.PRODUCT_STORAGE_IDENTIFIER_ID into @deletedIds (PRODUCT_STORAGE_IDENTIFIER_ID)
	from PRODUCT_STORAGE_IDENTIFIER psi join @deletedIds d	on psi.PRODUCT_ID = d.PRODUCT_ID;
	exec print_Messg 'Delete PRODUCT_STORAGE_IDENTIFIER', @@ROWCOUNT;

delete psot
	from PRODUCT_SID_OPERATION_TYPE psot join @deletedIds d on psot.PRODUCT_SID_ID = d.PRODUCT_STORAGE_IDENTIFIER_ID;
	exec print_Messg 'Delete PRODUCT_SID_OPERATION_TYPE', @@ROWCOUNT;

delete pssv	from PRODUCT_SID_SID_VALUE pssv join @deletedIds d on pssv.PRODUCT_SID_ID = d.PRODUCT_STORAGE_IDENTIFIER_ID;
	exec print_Messg 'Delete PRODUCT_SID_SID_VALUE', @@ROWCOUNT;
delete ppv	from PRODUCT_PROPERTY_VALUE ppv join @deletedIds d on ppv.PRODUCT_ID = d.PRODUCT_ID;
	exec print_Messg 'Delete PRODUCT_PROPERTY_VALUE', @@ROWCOUNT;

delete peu
	output deleted.EXTRA_UNIT_ID into @deletedIds (EXTRA_UNIT_ID)
	from PRODUCT_EXTRA_UNIT peu join @deletedIds d on peu.PRODUCT_ID = d.PRODUCT_ID; 
	exec print_Messg 'Delete PRODUCT_EXTRA_UNIT', @@ROWCOUNT;

delete psu
	output deleted.STORAGE_UNIT_ID into @deletedIds (STORAGE_UNIT_ID)
	from PRODUCT_STORAGE_UNIT psu join @deletedIds d on psu.PRODUCT_ID = d.PRODUCT_ID;
	exec print_Messg 'Delete PRODUCT_STORAGE_UNIT', @@ROWCOUNT;

delete p 
	output deleted.BASE_UNIT_ID into @deletedIds (BASE_UNIT_ID)
	from PRODUCT p join @deletedIds d on p.PRODUCT_ID = d.PRODUCT_ID;
	exec print_Messg 'Delete PRODUCT', @@ROWCOUNT;

delete pu from PRODUCT_UNIT pu join @deletedIds d on pu.PRODUCT_UNIT_ID = d.BASE_UNIT_ID
	or pu.PRODUCT_UNIT_ID = d.STORAGE_UNIT_ID or pu.PRODUCT_UNIT_ID = d.EXTRA_UNIT_ID;
    exec print_Messg 'Delete PRODUCT_UNIT', @@ROWCOUNT;

set nocount off

print '';
print 'FUJI STOCK AFTER SCRIPT WAS RUN';
exec print_Nfo @FujiProductGroupId
rollback

drop procedure print_Nfo
drop procedure print_Messg
