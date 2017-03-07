declare @StorageUnitIds table (PRODUCT_ID int, STORAGE_UNIT_ID int, UNIT_ID int, COEF decimal(16,8));
insert into @StorageUnitIds (PRODUCT_ID, STORAGE_UNIT_ID) select PRODUCT_ID, min(STORAGE_UNIT_ID) from PRODUCT_STORAGE_UNIT group by PRODUCT_ID
update su set UNIT_ID = pu.UNIT_ID, COEF = pu.COEF from @StorageUnitIds su join PRODUCT_UNIT pu on su.STORAGE_UNIT_ID = pu.PRODUCT_UNIT_ID

declare @user varchar(20) = 'sys170228';
declare @icId int = (select COMPANY_ID from COMPANY where CODE = 'IC_ACV')
create table StockInfoStorageQuantity (STOCK_INFO_ID int, STOCK_INFO_QUANTITY_ID int);
	
MERGE
INTO    STOCK_INFO_QUANTITY siq
USING	(
	SELECT case 1 < bq.QUANTITY / su.COEF < 2 then 1 else ceiling(bq.QUANTITY / su.COEF) end, su.UNIT_ID, si.STOCK_INFO_ID
FROM STOCK_INFO si
	join STOCK_INFO_CONFIG sic on si.STOCK_INFO_CONFIG_ID = sic.STOCK_INFO_CONFIG_ID
		and sic.INTERNAL_COMPANY_ID <> @icId and si.STORAGE_QUANTITY_ID is null
	join @StorageUnitIds su on sic.PRODUCT_ID = su.PRODUCT_ID
	join STOCK_INFO_QUANTITY bq on si.BASE_QUANTITY_ID = bq.STOCK_INFO_QUANTITY_ID 
) newSiq ([QUANTITY], UNIT_ID, STOCK_INFO_ID)
ON      (1 = 0)
WHEN NOT MATCHED THEN
INSERT  ([QUANTITY], UNIT_ID, CREATE_USER, CREATE_TIMESTAMP, UPDATE_USER, UPDATE_TIMESTAMP)
VALUES  ([QUANTITY], UNIT_ID, @user, getdate(), @user, getdate())
OUTPUT  newSiq.STOCK_INFO_ID, INSERTED.STOCK_INFO_QUANTITY_ID
INTO    StockInfoStorageQuantity;

update si set
	STORAGE_QUANTITY_ID = sisq.STOCK_INFO_QUANTITY_ID,
	UPDATE_USER = @user,
	UPDATE_TIMESTAMP = GETDATE()
from STOCK_INFO si join StockInfoStorageQuantity sisq on si.STOCK_INFO_ID = sisq.STOCK_INFO_ID

SET NOCOUNT ON;

declare @stockInfoId int;
declare @quantityId int;

DECLARE sisqCursor CURSOR FOR
SELECT STOCK_INFO_ID, STOCK_INFO_QUANTITY_ID FROM StockInfoStorageQuantity
OPEN sisqCursor;
FETCH NEXT FROM sisqCursor
INTO @stockInfoId, @quantityId

WHILE @@FETCH_STATUS = 0
BEGIN

	declare @tempNewKey nvarchar(max)

	update sic
	set
		@tempNewKey = REPLACE(_KEY_,
							  '"SU":null,',
							  '"SU":' + CONVERT(nvarchar(10), siq.UNIT_ID) + ','),
		STORAGE_UNIT_ID = siq.UNIT_ID,
		_KEY_ = @tempNewKey,
		HASH_KEY = CAST(hashbytes('SHA1', @tempNewKey) AS BINARY(20)),	
		UPDATE_USER = @user,
		UPDATE_TIMESTAMP = GETDATE()
	from
		 STOCK_INFO si
	join STOCK_INFO_CONFIG sic on si.STOCK_INFO_CONFIG_ID = sic.STOCK_INFO_CONFIG_ID and si.STOCK_INFO_ID = @stockInfoId
	join STOCK_INFO_QUANTITY siq on siq.STOCK_INFO_QUANTITY_ID = @quantityId

	FETCH NEXT FROM sisqCursor
	INTO @stockInfoId, @quantityId
END		

CLOSE sisqCursor;
DEALLOCATE sisqCursor;
drop table StockInfoStorageQuantity;
SET NOCOUNT OFF;