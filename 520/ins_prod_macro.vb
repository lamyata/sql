Private Sub Workbook_Open()
    MsgBox "This is a macro"
    outIx = 1
    
    
    For i = 2 To 537
        
      Dim firstCell, outputCell
      Dim prodCode
      Set firstCell = Cells(i, 1)

      prodCode = firstCell
      shortDesc = Replace(Cells(i, 2), "'", "''")
      prodGroupCode = Cells(i, 3)
      prodTypeDesc = Cells(i, 4)
      barcodeTypeDesc = Cells(i, 5)
      baseUnitCode = Cells(i, 8)
      
      Set outputCell = Cells(i, 13)
      outputCell.Value = "exec CreateProduct '" & prodCode & "','" & shortDesc & "','" & prodGroupCode & _
            "','" & prodTypeDesc & "','" & barcodeTypeDesc & "','" & baseUnitCode & "'"
        
      Dim storageUnitCode As String, storageUnitCoeff As Double
      storageUnitCode = ""
      
      storageUnitInfo = Cells(i, 9) & ""
      If storageUnitInfo <> "" Then
        parsedStorageUnitInfo = Split(storageUnitInfo, "/")
        storageUnitCode = parsedStorageUnitInfo(0)
        storageUnitCoeff = parsedStorageUnitInfo(1)
        outputCell.Value = outputCell.Value & ",'" & storageUnitCode & "'," & storageUnitCoeff
      Else
        outputCell.Value = outputCell.Value & ", null, 0"
      End If

      For j = 10 To 11
        extraUnitCode = Cells(1, j)
        extraData = Cells(i, j) & ""
        If extraData <> "" Then
            parsedExtraData = Split(extraData, "/")
            extraUnitCoeff = parsedExtraData(0)
            measurementUnitDesc = parsedExtraData(1)
            outputCell.Value = outputCell.Value & ",'" & extraUnitCode & "'," & extraUnitCoeff & ",'" & measurementUnitDesc & "'"
        End If
      Next
     
    Next
End Sub