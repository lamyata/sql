declare @ApplicationName nvarchar(50) = 'iTos'
INSERT INTO [dbo].[APPLICATION_ROLE]
           ([NAME]
           ,[APPLICATION_ID]
           ,[DESCRIPTION]
           ,[CREATE_USER]
           ,[CREATE_TIMESTAMP]
           ,[UPDATE_USER]
           ,[UPDATE_TIMESTAMP])
SELECT     'VMG_Operations'
           ,APPLICATION_ID
           ,'VMG_Operations',
		   'System',
		   getdate(),
		   'System',
		   getdate()
FROM [dbo].[APPLICATION]
where NAME = @ApplicationName;

INSERT INTO [dbo].[APPLICATION_ROLE]
           ([NAME]
           ,[APPLICATION_ID]
           ,[DESCRIPTION]
           ,[CREATE_USER]
           ,[CREATE_TIMESTAMP]
           ,[UPDATE_USER]
           ,[UPDATE_TIMESTAMP])
SELECT     'HH_Scanning'
           ,APPLICATION_ID
           ,'HH_Scanning',
		   'System',
		   getdate(),
		   'System',
		   getdate()
FROM [dbo].[APPLICATION]
where NAME = @ApplicationName;

exec INSERT_PAGE @ApplicationName,'OrdersDefault.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/Stevedoring/Order/Index', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/Stevedoring/Transport/Index', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'TransportTypeOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'TransportTypeDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'TransportPropertyDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'TransportPropertyOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'TransportPropertyDefaultValueDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/Stevedoring/OperationReport/Index', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/Stevedoring/Transport/Index', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/Stevedoring/Inventory/Index', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/Stevedoring/Operation/Index', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/Stevedoring/OperationReport/Index', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/Stevedoring/Order/Index', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/Financial/CustomerInvoice/Index', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'UnitGroupDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'UnitGroupOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'UnitUnionOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'UnitDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'UnitOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductUnitTempDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'WarehouseDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'WarehouseOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'WarehouseStructure.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'WarehouseTypeDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'WarehouseTypeOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'SectionTypeOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'SectionTypeDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'LocationPropertyDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'LocationPropertyOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'LocationPropertyDefaultValueDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'LocationPropertyPredefinedValueDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'LocationTypeDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'LocationTypeOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'WarehouseTypeDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'WarehouseTypeOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductStructure.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductCommercialNameDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductGroupDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductValueDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductPropertyDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductSubgroupDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductPropertyOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductDamagePropertyDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductTypeOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductTypeDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductSidTempDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductUnitTempDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'SidValueDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'SidValueOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'SidDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'SidOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'SidGroupDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'SidGroupOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductPropertyDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductPropertyOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductTypeOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductTypeDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'SubgroupDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'SubgroupPPDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'SubgroupOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ProductSubgroupDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'BarcodeTypeDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'BarcodeTypeOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'OperationsDefault.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'OperationTypeOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/Stevedoring/Operation/Index', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/Stevedoring/OperationReport/Index', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/Operation/Index', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ShiftDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ShiftOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ReferenceTypeValueDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ReferenceTypeDetail.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'ReferenceTypeOverview.aspx', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/Barcode/Index', 'HH_Scanning'
exec INSERT_PAGE @ApplicationName,'/Discharging/Index', 'HH_Scanning'
exec INSERT_PAGE @ApplicationName,'/Inbound/Index', 'HH_Scanning'
exec INSERT_PAGE @ApplicationName,'/InboundNew/Index', 'HH_Scanning'
exec INSERT_PAGE @ApplicationName,'/Operation/Index', 'HH_Scanning'
exec INSERT_PAGE @ApplicationName,'/Outbound/Index', 'HH_Scanning'
exec INSERT_PAGE @ApplicationName,'/Barcode/Index', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/Discharging/Index', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/Inbound/Index', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/InboundNew/Index', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/Operation/Index', 'VMG_Operations'
exec INSERT_PAGE @ApplicationName,'/Outbound/Index', 'VMG_Operations'