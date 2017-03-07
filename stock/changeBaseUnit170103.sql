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

		return STUFF(@key, @valueStart, @valueEnd-@valueStart-1, @newValue);

    END

GO

CREATE PROC ChangeBaseUnit
	@ProductCode nvarchar(50),
	@OldUnitCode nvarchar(50),
	@NewUnitCode nvarchar(50)
AS
	declare @ProductId int;
	declare @OldUnitId int;
	declare @NewUnitId int;
	declare @updateUser nvarchar(15) = 'sys170103';
BEGIN
	select @ProductId = PRODUCT_ID from PRODUCT where CODE = @ProductCode;
	select @OldUnitId = UNIT_ID from UNIT where CODE = @OldUnitCode;
	select @NewUnitId = UNIT_ID from UNIT where CODE = @NewUnitCode;

	update pu
	set
		UNIT_ID = @NewUnitId,
		UPDATE_TIMESTAMP = GETDATE(),
		UPDATE_USER = @updateUser
	from PRODUCT_UNIT pu
	join PRODUCT p on p.BASE_UNIT_ID = pu.PRODUCT_UNIT_ID and p.CODE = @ProductCode and pu.UNIT_ID = @OldUnitId

	update siq
	set
		UNIT_ID = @NewUnitId,
		UPDATE_TIMESTAMP = GETDATE(),
		UPDATE_USER = @updateUser
	from STOCK_INFO_QUANTITY siq
	join STOCK_INFO si on siq.STOCK_INFO_QUANTITY_ID = si.BASE_QUANTITY_ID
	join STOCK_INFO_CONFIG sic on si.STOCK_INFO_CONFIG_ID = sic.STOCK_INFO_CONFIG_ID and sic.PRODUCT_ID = @ProductId; 

	update STOCK_INFO_CONFIG set
		BASE_UNIT_ID = @NewUnitId,
		_KEY_ = dbo.SetKeyValue (_KEY_, '"BU":', '"', @NewUnitId),
		HASH_KEY = CAST(hashbytes('SHA1', dbo.SetKeyValue (_KEY_, '"BU":', '"', @NewUnitId)) AS BINARY(20)),	
		UPDATE_TIMESTAMP = GETDATE(),
		UPDATE_USER = @updateUser 
	where PRODUCT_ID = @ProductId;
	
END
go

BEGIN TRY
	BEGIN TRAN


exec ChangeBaseUnit
	@ProductCode = '12243_A',
	@OldUnitCode = 'IBC',
	@NewUnitCode = 'BAG'
			
	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK
		SELECT ERROR_NUMBER() as ErrorNumber, ERROR_MESSAGE() as ErrorMessage
END CATCH

DROP FUNCTION [dbo].[SetKeyValue]
drop proc ChangeBaseUnit

