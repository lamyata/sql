CREATE procedure [dbo].[CreateProductSID]
	@ProductCode nvarchar(50),
	@SidCode nvarchar(10),
	@OperationTypes nvarchar(10),
	@SidSequence int,
	@SidDefault nvarchar(255) = null
as
	declare @ProductId int
	declare @ProductSidId int
	declare @OperationType int
	declare @SidId int
begin

	select @ProductId = PRODUCT_ID from PRODUCT where CODE like @ProductCode
	select @SidId = STORAGE_IDENTIFIER_ID from STORAGE_IDENTIFIER where CODE like @SidCode;
	INSERT INTO [dbo].[PRODUCT_STORAGE_IDENTIFIER]
			([PRODUCT_ID]
			,[SID_ID]
			,[SID_DEFAULT]
			,[SID_SEQUENCE]
			,[IS_MANDATORY]
			,[CREATE_USER]
			,[CREATE_TIMESTAMP]
			,[UPDATE_USER]
			,[UPDATE_TIMESTAMP])
		VALUES
			(@ProductId
			,@SidId
			,@SidDefault
			,@SidSequence
			,0
			,'la180328'
			,getdate()
			,'la180328'
			,getdate())
	select @ProductSidId = SCOPE_IDENTITY();

	INSERT INTO [dbo].[PRODUCT_SID_SID_VALUE]
			   ([PRODUCT_SID_ID]
			   ,[PREDEFINED_SID_VALUE_ID])
		 select
			   @ProductSidId
			   ,STORAGE_IDENTIFIER_PR_VALUE_ID
		 from STORAGE_IDENTIFIER_PR_VALUE
		 where SID_ID = @SidId

	if CHARINDEX('L', @OperationTypes) > 0
		begin
			select @OperationType = OPERATION_TYPE_ID from OPERATION_TYPE where DESCRIPTION like 'Loading'
			INSERT INTO [dbo].[PRODUCT_SID_OPERATION_TYPE]
					([PRODUCT_SID_ID]
					,[OPERATION_TYPE_ID])
				VALUES
					(@ProductSidId
					,@OperationType)
		end
	if CHARINDEX('D', @OperationTypes) > 0
		begin
			select @OperationType = OPERATION_TYPE_ID from OPERATION_TYPE where DESCRIPTION like 'Discharging'
			INSERT INTO [dbo].[PRODUCT_SID_OPERATION_TYPE]
					([PRODUCT_SID_ID]
					,[OPERATION_TYPE_ID])
				VALUES
					(@ProductSidId
					,@OperationType)
		end
	if CHARINDEX('S', @OperationTypes) > 0
		begin
			select @OperationType = OPERATION_TYPE_ID from OPERATION_TYPE where DESCRIPTION like 'StockChange'
			INSERT INTO [dbo].[PRODUCT_SID_OPERATION_TYPE]
					([PRODUCT_SID_ID]
					,[OPERATION_TYPE_ID])
				VALUES
					(@ProductSidId
					,@OperationType)
		end
	if CHARINDEX('V', @OperationTypes) > 0
		begin
			select @OperationType = OPERATION_TYPE_ID from OPERATION_TYPE where DESCRIPTION like 'VAS'
			INSERT INTO [dbo].[PRODUCT_SID_OPERATION_TYPE]
					([PRODUCT_SID_ID]
					,[OPERATION_TYPE_ID])
				VALUES
					(@ProductSidId
					,@OperationType)
		end

end

GO

set nocount on

exec CreateProductSID 'DB008A PL14', 'HS CODE', 'DLSV', 10, '3901101090';
exec CreateProductSID 'DB008A PL14', 'TRPREF', 'DLSV', 30;
exec CreateProductSID 'DB008A PL14', 'DNR', 'DLSV', 40;
exec CreateProductSID 'DB008A PL14', 'CUST', 'DLSV', 50, 'Transit';
exec CreateProductSID 'DB008A PL14', 'ORIGCC', 'DLSV', 60;
exec CreateProductSID 'DB008A PL14', 'PH', 'DLSV', 70, 'PE PEBDL';
exec CreateProductSID 'DB008A PL14', 'UNITPRICE', 'DLSV', 80;

set nocount off

drop proc [dbo].[CreateProductSID]

/*
select distinct sic.PRODUCT_ID from STOCK_INFO_CONFIG sic
	join STOCK_INFO si on sic.STOCK_INFO_CONFIG_ID = si.STOCK_INFO_CONFIG_ID
	join STOCK s on si.STOCK_INFO_ID = s.STOCK_INFO_ID
	where not exists (select * from PRODUCT_STORAGE_IDENTIFIER where PRODUCT_ID = sic.PRODUCT_ID)
	and sic._KEY_ not like '%"S":[[]]}'
*/
