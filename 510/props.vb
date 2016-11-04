Private Sub Workbook_Open()

    ParseProducts
    ParseSids
    ParseProps

End Sub

Private Sub ParseProps()

    Dim wsSids As Worksheet
    Dim wsOutSids As Worksheet
    Dim lineIx As Integer
    Dim outLineIx As Long
    Dim prodCode As String
    
    Const SidStartColIx As Integer = 6
    Const DataStartLineIx As Integer = 2
     
    Set wsSids = Sheets("SIDs")
    Set wsOutSids = AddOutputSheet("Prop Cmd")
    
    lineIx = DataStartLineIx
    outLineIx = 1
    
    Set curCell = wsSids.Cells(lineIx, 1)
    prodCode = Trim(curCell)
    
    While prodCode <> ""
    
        Dim sidCode As String
        Dim sidColIx As Integer
        sidColIx = SidStartColIx
        
        
        For i% = 0 To 1
            propCode = Trim(wsSids.Cells(1, sidColIx + i))
            defValue = wsSids.Cells(lineIx, sidColIx + i) & ""
            wsOutSids.Cells(outLineIx, 1) = "exec #AttachProperty2Product '" + prodCode + "','" + propCode + "','" + defValue + "'"
            outLineIx = outLineIx + 1
        Next i
        
        lineIx = lineIx + 1
        Set curCell = wsSids.Cells(lineIx, 1)
        prodCode = Trim(curCell)
    Wend

End Sub

Private Sub ParseSids()

    Dim wsSids As Worksheet
    Dim wsOutSids As Worksheet
    Dim lineIx As Integer
    Dim outLineIx As Long
    Dim prodCode As String
    
    Const SidStartColIx As Integer = 8
    Const DataStartLineIx As Integer = 2
     
    Set wsSids = Sheets("SIDs")
    Set wsOutSids = AddOutputSheet("Sid Cmd")
    
    lineIx = DataStartLineIx
    outLineIx = 1
    
    Set firstCell = wsSids.Cells(lineIx, 1)
    prodCode = Trim(firstCell)
    
    While prodCode <> ""
    
        Dim sidCode As String
        Dim sidColIx As Integer
        sidColIx = SidStartColIx
        
        sidCode = Trim(wsSids.Cells(1, sidColIx))
        
        While sidCode <> ""
        
            sidData = wsSids.Cells(lineIx, sidColIx) & ""
            If sidData <> "" Then
                
                Dim CreateProcedureScript As String
                
                parsedSidData = Split(sidData, "/")
                opeationTypes = parsedSidData(0)
                sidDefault = parsedSidData(1)
                sidSequence = parsedSidData(2)
                If sidCode = "SI" Then
                    CreateProcedureScript = "exec #CreateProductSIDCompany"
                ElseIf sidCode = "CUST" Then
                    CreateProcedureScript = "exec #CreateProductSIDCombo"
                Else
                    CreateProcedureScript = "exec #CreateProductSID"
                End If
                sidOutData = opeationTypes & "'," & sidSequence & ",'" & sidDefault & "'"
                wsOutSids.Cells(outLineIx, 1) = CreateProcedureScript + " '" + prodCode + "','" + sidCode + "','" + sidOutData
                outLineIx = outLineIx + 1
            End If
            
            sidColIx = sidColIx + 1
            sidCode = Trim(wsSids.Cells(1, sidColIx))
        
        Wend
        
        lineIx = lineIx + 1
        Set firstCell = wsSids.Cells(lineIx, 1)
        prodCode = Trim(firstCell)
        
    Wend

End Sub

Private Function AddOutputSheet(sheetName As String)

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
      outputCell.Value = "exec #CreateProduct '" & prodCode & "','" & shortDesc & "','" & prodGroupCode & _
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
            extraUnitCoeff = Replace(parsedExtraData(0), ",", ".")
            measurementUnitDesc = parsedExtraData(1)
            outputCell.Value = outputCell.Value & ",'" & extraUnitCode & "'," & extraUnitCoeff & ",'" & measurementUnitDesc & "'"
        End If
      Next
      
      ixLine = ixLine + 1
      Set firstCell = wsProducts.Cells(ixLine, 1)
      prodCode = Trim(firstCell)
     
   Wend

End Sub





