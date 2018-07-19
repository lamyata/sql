declare @updateUser varchar(15) = 'la180320';
declare @SidSequence int = 5;
declare @SidDefaultValue varchar(10) = 'FFS';
declare @StockSidDefaultValue varchar(10) = 'FFS';
DECLARE @new_key nvarchar(MAX) = '';
declare @emptyString nvarchar = '';
declare @nullString nvarchar(4) = 'null';
declare @FujiProductGroupId int = (select PRODUCT_GROUP_ID from PRODUCT_GROUP where CODE = 'FUJI');
declare @FujiQualifSidId int = (select STORAGE_IDENTIFIER_ID from STORAGE_IDENTIFIER where CODE = 'FUJI_QUALIF');

select * from STORAGE_IDENTIFIER where STORAGE_IDENTIFIER_ID = @FujiQualifSidId
select * from STORAGE_IDENTIFIER_PR_VALUE where SID_ID = @FujiQualifSidId
select * from PRODUCT_STORAGE_IDENTIFIER where SID_ID = @FujiQualifSidId
select * from PRODUCT_SID_SID_VALUE pssv join PRODUCT_STORAGE_IDENTIFIER psi
	on pssv.PRODUCT_SID_ID =  psi.PRODUCT_STORAGE_IDENTIFIER_ID and psi.SID_ID = @FujiQualifSidId
select * from [STOCK_INFO_SID] sis where sis.SID_ID = @FujiQualifSidId