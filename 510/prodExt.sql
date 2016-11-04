CREATE TABLE [dbo].[KIT](
	[KIT_ID] [int] IDENTITY(1,1) NOT NULL,
	[CODE] [nvarchar](250) NOT NULL,
	[NAME] [nvarchar](250) NOT NULL,
	[DESCRIPTION] [nvarchar](250) NULL,
	[MAIN_PRODUCT_ID] [int] NOT NULL,
	[CREATE_USER] [nvarchar](100) NOT NULL,
	[CREATE_TIMESTAMP] [datetime2](7) NOT NULL,
	[UPDATE_USER] [nvarchar](100) NOT NULL,
	[UPDATE_TIMESTAMP] [datetime2](7) NOT NULL,
    CONSTRAINT [PK_KIT] PRIMARY KEY CLUSTERED ([KIT_ID] ASC),
    CONSTRAINT [AK_KIT_Column] UNIQUE NONCLUSTERED ([CODE] ASC),
	CONSTRAINT [FK_KIT_MAIN_PRODUCT] FOREIGN KEY([MAIN_PRODUCT_ID]) REFERENCES [dbo].[WMS_PRODUCT] ([PRODUCT_ID])
)
CREATE TABLE [dbo].[KIT_ITEM](
	[KIT_ITEM_ID] [int] IDENTITY(1,1) NOT NULL,
	[KIT_ID] [int] NOT NULL,
	[PRODUCT_ID] [int] NOT NULL,
	[COUNT] [int] NOT NULL,
	[CREATE_USER] [nvarchar](100) NOT NULL,
	[CREATE_TIMESTAMP] [datetime2](7) NOT NULL,
	[UPDATE_USER] [nvarchar](100) NOT NULL,
	[UPDATE_TIMESTAMP] [datetime2](7) NOT NULL,
	CONSTRAINT [PK_KIT_ITEM] PRIMARY KEY CLUSTERED (	[KIT_ITEM_ID] ASC),
	CONSTRAINT [FK_KIT_ITEM_KIT] FOREIGN KEY([KIT_ID]) REFERENCES [dbo].[KIT] ([KIT_ID]),
	CONSTRAINT [FK_KIT_ITEM_PRODUCT] FOREIGN KEY([PRODUCT_ID]) REFERENCES [dbo].[WMS_PRODUCT] ([PRODUCT_ID])
) 
GO

create proc #CreateKit
	@Code nvarchar(250),
	@Name nvarchar(250),
	@Description nvarchar(250),
	@MainProductCode nvarchar(50)
as
	declare @MainProductId int
begin
	select @MainProductId = PRODUCT_ID from WMS_PRODUCT where CODE = @MainProductCode
INSERT INTO [dbo].[KIT]
           ([CODE]
           ,[NAME]
           ,[DESCRIPTION]
           ,[MAIN_PRODUCT_ID]
           ,[CREATE_USER]
           ,[CREATE_TIMESTAMP]
           ,[UPDATE_USER]
           ,[UPDATE_TIMESTAMP])
     VALUES
           (@Code
           ,@Name
           ,@Description
           ,@MainProductId
		 ,'script'
		 ,getdate()
		 ,'script'
		 ,getdate())
end
go

create proc #DelProd
	@ProdId int
as
begin
	delete from [PRODUCT_UNIT_TEMP] where [PRODUCT_UNIT_TEMP_ID] = (select BASE_UNIT_ID from WMS_PRODUCT where  PRODUCT_ID = @ProdId)
	delete from [PRODUCT_UNIT_TEMP] where [PRODUCT_UNIT_TEMP_ID] = (select STORAGE_UNIT_ID from [PRODUCT_STORAGE_UNIT] where  PRODUCT_ID = @ProdId)
	delete from [PRODUCT_UNIT_TEMP] where [PRODUCT_UNIT_TEMP_ID] = (select EXTRA_UNIT_ID from [PRODUCT_EXTRA_UNIT] where  PRODUCT_ID = @ProdId)
	delete from [PRODUCT_EXTRA_UNIT] where PRODUCT_ID = @ProdId
	delete from [PRODUCT_STORAGE_UNIT] where PRODUCT_ID = @ProdId
	delete from [WMS_PRODUCT_INT_COMPANY] where PRODUCT_ID = @ProdId
	delete from [WMS_PRODUCT] where PRODUCT_ID = @ProdId
end
go

create proc #DelAllProducts
as
begin
	delete from [PRODUCT_EXTRA_UNIT] 
	delete from [PRODUCT_STORAGE_UNIT] 
	delete from [WMS_PRODUCT_INT_COMPANY]
	delete from [WMS_PRODUCT]
	delete from [PRODUCT_UNIT_TEMP]

	drop table KIT_CODE
	drop table KIT_ITEM_PRODUCT_CODE
	drop table PRODUCT_KIT
end
go

/*

Private Sub Workbook_Open()

    ParseKits

End Sub

Private Sub ParseKits()

    Const KitsSheetName As String = "Kit_Composition_overview"
    Const outKitSheetName As String = "Kit Cmd"
    Const outKitItemSheetName As String = "Kit Item Cmd"
    Const outKitCodesSheetName As String = "Kit Codes"
    Const outKitItemProdCodesSheetName As String = "Kit Item Prods"
    Const firstDataLine As Integer = 3
    Const codeColumn As Integer = 1
    Const nameColumn As Integer = 2
    Const descColumn As Integer = 3
    
    Dim wsKits As Worksheet, outKitSheet As Worksheet, outKitItemSheet As Worksheet, outKitCodeSheet As Worksheet, outKitItemProdSheet As Worksheet
    
    Set wsKits = Sheets(KitsSheetName)
    Set outKitSheet = AddOutputSheet(outKitSheetName)
    Set outKitCodeSheet = AddOutputSheet(outKitCodesSheetName)
    Set outKitItemSheet = AddOutputSheet(outKitItemSheetName)
    Set outKitItemProdSheet = AddOutputSheet(outKitItemProdCodesSheetName)

    Dim ixLine As Integer, outKitIxLine As Integer, outKitItemIxLine As Integer, curCell, outputCell
    Dim kitCode As String, kitName As String, kitDescr As String
    Dim mainProdCode As String
    
    ixLine = firstDataLine
    Set curCell = wsKits.Cells(ixLine, codeColumn)
    kitCode = Trim(curCell)
    outKitIxLine = 1: outKitItemIxLine = 1
    
    While kitCode <> "" And ixLine < 17
        
      kitName = Replace(wsKits.Cells(ixLine, nameColumn), "'", "''")
      kitDescr = wsKits.Cells(ixLine, descColumn)
      mainProdCode = ""
      
      Dim i As Integer, itemDesc As String, itemQty As String
      
      For i = 0 To 5
        itemDesc = Replace(wsKits.Cells(ixLine, descColumn + i * 2 + 1) & "", "-", "")
        If itemDesc <> "" Then
            If InStr(1, itemDesc, "bar code") > 0 Then
                mainProdCode = Split(itemDesc, " ")(0)
                itemDesc = mainProdCode
            End If
            itemQty = wsKits.Cells(ixLine, descColumn + i * 2 + 2)
            Set outputCell = outKitItemSheet.Cells(outKitItemIxLine, 1)
            outputCell.Value = "exec #CreateKitItem '" & kitCode & "', '" & Trim(itemDesc) & "', " & itemQty
            Set outputCell = outKitItemProdSheet.Cells(outKitItemIxLine, 1)
            outputCell.Value = "insert into KIT_ITEM_PRODUCT_CODE values ('" & Trim(itemDesc) & "')"
            outKitItemIxLine = outKitItemIxLine + 1
        End If
      Next i
      If mainProdCode <> "" Then
        Set outputCell = outKitSheet.Cells(outKitIxLine, 1)
        outputCell.Value = "exec #CreateKit '" & kitCode & "', '" & kitName & "', '" & kitDescr & "', '" & mainProdCode & "'"
        outKitIxLine = outKitIxLine + 1
        Set outputCell = outKitCodeSheet.Cells(outKitIxLine, 1)
        outputCell.Value = "insert into KIT_CODE values ('" & kitCode & "')"
      End If
      
      ixLine = ixLine + 1
      Set curCell = wsKits.Cells(ixLine, codeColumn)
      kitCode = Trim(curCell)
     
    Wend

End Sub

Private Function AddOutputSheet(sheetName As String)

    Dim wsOutSheet As Worksheet
    
    On Error Resume Next
    Set wsOutSheet = Sheets(sheetName)
    Application.DisplayAlerts = False
    wsOutSheet.Delete
    Application.DisplayAlerts = True
    On Error GoTo 0
    Set wsOutSheet = Sheets.Add(After:=Sheets(ThisWorkbook.Sheets.Count))
    wsOutSheet.Name = sheetName
    Set AddOutputSheet = wsOutSheet

End Function

Private Sub ParseProducts()

    Dim wsProducts As Worksheet
    
    Dim ixLine
    Dim prodCode
    Dim firstCell, outputCell
    
    ixLine = 2
    Set wsProducts = Sheets("Products")
    
    Dim wsOutProducts As Worksheet
    Set wsOutProducts = AddOutputSheet("Prod Cmd")
    
    Set firstCell = wsProducts.Cells(ixLine, 1)
    prodCode = Trim(firstCell)
    
    While prodCode <> ""
        
      shortDesc = Replace(wsProducts.Cells(ixLine, 2), "'", "''")
      prodGroupCode = wsProducts.Cells(ixLine, 3)
      prodTypeDesc = wsProducts.Cells(ixLine, 4)
      barcodeTypeDesc = wsProducts.Cells(ixLine, 5)
      baseUnitCode = wsProducts.Cells(ixLine, 8)
      
      Set outputCell = wsOutProducts.Cells(ixLine, 1)
      outputCell.Value = "exec CreateProduct '" & prodCode & "','" & shortDesc & "','" & prodGroupCode & _
            "','" & prodTypeDesc & "','" & barcodeTypeDesc & "','" & baseUnitCode & "'"
        
      Dim storageUnitCode As String, storageUnitCoeff As Double
      storageUnitCode = ""
      
      storageUnitInfo = wsProducts.Cells(ixLine, 9) & ""
      If storageUnitInfo <> "" Then
        parsedStorageUnitInfo = Split(storageUnitInfo, "/")
        storageUnitCode = parsedStorageUnitInfo(0)
        storageUnitCoeff = parsedStorageUnitInfo(1)
        outputCell.Value = outputCell.Value & ",'" & storageUnitCode & "'," & storageUnitCoeff
      Else
        outputCell.Value = outputCell.Value & ", null, 0"
      End If

      For j = 10 To 11
        extraUnitCode = wsProducts.Cells(1, j)
        extraData = wsProducts.Cells(ixLine, j) & ""
        If extraData <> "" Then
            parsedExtraData = Split(extraData, "/")
            extraUnitCoeff = parsedExtraData(0)
            measurementUnitDesc = parsedExtraData(1)
            outputCell.Value = outputCell.Value & ",'" & extraUnitCode & "'," & extraUnitCoeff & ",'" & measurementUnitDesc & "'"
        End If
      Next
      
      ixLine = ixLine + 1
      Set firstCell = wsProducts.Cells(ixLine, 1)
      prodCode = Trim(firstCell)
     
   Wend

End Sub

*/

Product cant be found, code: 01647001

