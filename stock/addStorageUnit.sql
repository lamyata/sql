CREATE FUNCTION [dbo].[SetKeyValue] (
	@key nvarchar(max),
	@startTag nvarchar(50),
	@endTag nvarchar(50),
	@newValue nvarchar(250)
)
RETURNS nvarchar(max)
AS
    BEGIN
		declare @start int;
		declare @valueStart int;
		declare @valueEnd int;

		set @start = CHARINDEX(@startTag, @key);
		if @start = 0 return @key;

		set @valueStart = @start + LEN(@startTag);
		set @valueEnd = CHARINDEX(@endTag, @key, @valueStart);

		return STUFF(@key, @valueStart, @valueEnd-@valueStart-len(@endTag), @newValue);

    END

GO

declare @StorageUnitIds table (PRODUCT_ID int, STORAGE_UNIT_ID int, UNIT_ID int, COEF decimal(16,8));
insert into @StorageUnitIds (PRODUCT_ID, STORAGE_UNIT_ID) select PRODUCT_ID, min(STORAGE_UNIT_ID) from PRODUCT_STORAGE_UNIT group by PRODUCT_ID
update su set UNIT_ID = pu.UNIT_ID, COEF = pu.COEF from @StorageUnitIds su join PRODUCT_UNIT pu on su.STORAGE_UNIT_ID = pu.PRODUCT_UNIT_ID

declare @user varchar(20) = 'sys170207';
declare @icId int = (select COMPANY_ID from COMPANY where CODE = 'IC_ACV')
declare @StockInfoStorageQuantity table (STOCK_INFO_QUANTITY_ID int, STOCK_INFO_ID int);

BEGIN TRY
	BEGIN TRAN
	
	MERGE
	INTO    STOCK_INFO_QUANTITY siq
	USING	(
		SELECT ceiling(bq.QUANTITY / su.COEF), su.UNIT_ID, si.STOCK_INFO_ID
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
	OUTPUT  INSERTED.STOCK_INFO_QUANTITY_ID, newSiq.STOCK_INFO_ID
	INTO    @StockInfoStorageQuantity;

	update si set
		STORAGE_QUANTITY_ID = sisq.STOCK_INFO_QUANTITY_ID,
		UPDATE_USER = @user,
		UPDATE_TIMESTAMP = GETDATE()
	from STOCK_INFO si join @StockInfoStorageQuantity sisq on si.STOCK_INFO_ID = sisq.STOCK_INFO_ID

	update sic set
		STORAGE_UNIT_ID = siq.UNIT_ID,
		_KEY_ = dbo.SetKeyValue (_KEY_, '"SU":', ',"', siq.UNIT_ID),
		HASH_KEY = CAST(hashbytes('SHA1', dbo.SetKeyValue (_KEY_, '"SU":', ',"', siq.UNIT_ID)) AS BINARY(20)),	
		UPDATE_USER = @user,
		UPDATE_TIMESTAMP = GETDATE()
	from STOCK_INFO si join STOCK_INFO_CONFIG sic on si.STOCK_INFO_CONFIG_ID = sic.STOCK_INFO_CONFIG_ID 
		join @StockInfoStorageQuantity sisq on sisq.STOCK_INFO_ID = si.STOCK_INFO_ID 
		join STOCK_INFO_QUANTITY siq on sisq.STOCK_INFO_QUANTITY_ID = siq.STOCK_INFO_QUANTITY_ID
	
	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK
		SELECT ERROR_NUMBER() as ErrorNumber, ERROR_MESSAGE() as ErrorMessage
END CATCH

DROP FUNCTION [dbo].[SetKeyValue]