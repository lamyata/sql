select * into bak_LOCATION_INTERNAL_COMPANY from LOCATION_INTERNAL_COMPANY
select * into bak_location from LOCATION

INSERT INTO [dbo].[LOCATION_INTERNAL_COMPANY]
           ([LOCATION_ID]
           ,[INTERNAL_COMPANY_ID])
     SELECT
           l.LOCATION_ID
           ,c.COMPANYNR
	FROM [LOCATION] l, COMPANY c
	WHERE l.CODE = 'BRH' and c.CODE = 'IC_VMHZP'

INSERT INTO [dbo].[LOCATION_INTERNAL_COMPANY]
           ([LOCATION_ID]
           ,[INTERNAL_COMPANY_ID])
     SELECT
           l.LOCATION_ID
           ,c.COMPANYNR
	FROM [LOCATION] l, COMPANY c
	WHERE l.PLAIN_PATH like '|BRH|%' and c.CODE = 'IC_VMHZP'

exec CreateLocation 'X7','X7','Loods7',0,'Wharehouse','X','','',null,null,null
exec CreateLocation 'X7A','X7A','Level A',0,'Level','X7','','',null,null,null
exec CreateLocation 'X7B','X7B','Level B',0,'Level','X7','','',null,null,null
exec CreateLocation 'X7C','X7C','Level C',0,'Level','X7','','',null,null,null
exec CreateLocation 'X7D','X7D','Level D',0,'Level','X7','','',null,null,null
exec CreateLocation 'X7E','X7E','Level E',0,'Level','X7','','',null,null,null
exec CreateLocation 'X7F','X7F','Level F',0,'Level','X7','','',null,null,null
exec CreateLocation 'X7G','X7G','Level G',0,'Level','X7','','',null,null,null
exec CreateLocation 'X7H','X7H','Level H',0,'Level','X7','','',null,null,null
exec CreateLocation 'X7I','X7I','Level I',0,'Level','X7','','',null,null,null
exec CreateLocation 'X7J','X7J','Level J',0,'Level','X7','','',null,null,null
exec CreateLocation 'X7K','X7K','Level K',0,'Level','X7','','',null,null,null
exec CreateLocation 'X7L','X7L','Level L',0,'Level','X7','','',null,null,null
exec CreateLocation 'X7A1','X7A1','X7A1',0,'Position','X7A','','',null,null,null
exec CreateLocation 'X7A2','X7A2','X7A2',0,'Position','X7A','','',null,null,null
exec CreateLocation 'X7A3','X7A3','X7A3',0,'Position','X7A','','',null,null,null
exec CreateLocation 'X7A4','X7A4','X7A4',0,'Position','X7A','','',null,null,null
exec CreateLocation 'X7A5','X7A5','X7A5',0,'Position','X7A','','',null,null,null
exec CreateLocation 'X7A6','X7A6','X7A6',0,'Position','X7A','','',null,null,null
exec CreateLocation 'X7A7','X7A7','X7A7',0,'Position','X7A','','',null,null,null
exec CreateLocation 'X7A8','X7A8','X7A8',0,'Position','X7A','','',null,null,null
exec CreateLocation 'X7A9','X7A9','X7A9',0,'Position','X7A','','',null,null,null
exec CreateLocation 'X7A10','X7A10','X7A10',0,'Position','X7A','','',null,null,null
exec CreateLocation 'X7A11','X7A11','X7A11',0,'Position','X7A','','',null,null,null
exec CreateLocation 'X7A12','X7A12','X7A12',0,'Position','X7A','','',null,null,null
exec CreateLocation 'X7A13','X7A13','X7A13',0,'Position','X7A','','',null,null,null
exec CreateLocation 'X7A14','X7A14','X7A14',0,'Position','X7A','','',null,null,null
exec CreateLocation 'X7A15','X7A15','X7A15',0,'Position','X7A','','',null,null,null
exec CreateLocation 'X7A16','X7A16','X7A16',0,'Position','X7A','','',null,null,null
exec CreateLocation 'X7A17','X7A17','X7A17',0,'Position','X7A','','',null,null,null
exec CreateLocation 'X7A18','X7A18','X7A18',0,'Position','X7A','','',null,null,null
exec CreateLocation 'X7A19','X7A19','X7A19',0,'Position','X7A','','',null,null,null
exec CreateLocation 'X7A20','X7A20','X7A20',0,'Position','X7A','','',null,null,null
exec CreateLocation 'X7B1','X7B1','X7B1',0,'Position','X7B','','',null,null,null
exec CreateLocation 'X7B2','X7B2','X7B2',0,'Position','X7B','','',null,null,null
exec CreateLocation 'X7B3','X7B3','X7B3',0,'Position','X7B','','',null,null,null
exec CreateLocation 'X7B4','X7B4','X7B4',0,'Position','X7B','','',null,null,null
exec CreateLocation 'X7B5','X7B5','X7B5',0,'Position','X7B','','',null,null,null
exec CreateLocation 'X7B6','X7B6','X7B6',0,'Position','X7B','','',null,null,null
exec CreateLocation 'X7B7','X7B7','X7B7',0,'Position','X7B','','',null,null,null
exec CreateLocation 'X7B8','X7B8','X7B8',0,'Position','X7B','','',null,null,null
exec CreateLocation 'X7B9','X7B9','X7B9',0,'Position','X7B','','',null,null,null
exec CreateLocation 'X7B10','X7B10','X7B10',0,'Position','X7B','','',null,null,null
exec CreateLocation 'X7B11','X7B11','X7B11',0,'Position','X7B','','',null,null,null
exec CreateLocation 'X7B12','X7B12','X7B12',0,'Position','X7B','','',null,null,null
exec CreateLocation 'X7B13','X7B13','X7B13',0,'Position','X7B','','',null,null,null
exec CreateLocation 'X7B14','X7B14','X7B14',0,'Position','X7B','','',null,null,null
exec CreateLocation 'X7B15','X7B15','X7B15',0,'Position','X7B','','',null,null,null
exec CreateLocation 'X7B16','X7B16','X7B16',0,'Position','X7B','','',null,null,null
exec CreateLocation 'X7B17','X7B17','X7B17',0,'Position','X7B','','',null,null,null
exec CreateLocation 'X7B18','X7B18','X7B18',0,'Position','X7B','','',null,null,null
exec CreateLocation 'X7B19','X7B19','X7B19',0,'Position','X7B','','',null,null,null
exec CreateLocation 'X7B20','X7B20','X7B20',0,'Position','X7B','','',null,null,null
exec CreateLocation 'X7C1','X7C1','X7C1',0,'Position','X7C','','',null,null,null
exec CreateLocation 'X7C2','X7C2','X7C2',0,'Position','X7C','','',null,null,null
exec CreateLocation 'X7C3','X7C3','X7C3',0,'Position','X7C','','',null,null,null
exec CreateLocation 'X7C4','X7C4','X7C4',0,'Position','X7C','','',null,null,null
exec CreateLocation 'X7C5','X7C5','X7C5',0,'Position','X7C','','',null,null,null
exec CreateLocation 'X7C6','X7C6','X7C6',0,'Position','X7C','','',null,null,null
exec CreateLocation 'X7C7','X7C7','X7C7',0,'Position','X7C','','',null,null,null
exec CreateLocation 'X7C8','X7C8','X7C8',0,'Position','X7C','','',null,null,null
exec CreateLocation 'X7C9','X7C9','X7C9',0,'Position','X7C','','',null,null,null
exec CreateLocation 'X7C10','X7C10','X7C10',0,'Position','X7C','','',null,null,null
exec CreateLocation 'X7C11','X7C11','X7C11',0,'Position','X7C','','',null,null,null
exec CreateLocation 'X7C12','X7C12','X7C12',0,'Position','X7C','','',null,null,null
exec CreateLocation 'X7C13','X7C13','X7C13',0,'Position','X7C','','',null,null,null
exec CreateLocation 'X7C14','X7C14','X7C14',0,'Position','X7C','','',null,null,null
exec CreateLocation 'X7C15','X7C15','X7C15',0,'Position','X7C','','',null,null,null
exec CreateLocation 'X7C16','X7C16','X7C16',0,'Position','X7C','','',null,null,null
exec CreateLocation 'X7C17','X7C17','X7C17',0,'Position','X7C','','',null,null,null
exec CreateLocation 'X7C18','X7C18','X7C18',0,'Position','X7C','','',null,null,null
exec CreateLocation 'X7C19','X7C19','X7C19',0,'Position','X7C','','',null,null,null
exec CreateLocation 'X7C20','X7C20','X7C20',0,'Position','X7C','','',null,null,null
exec CreateLocation 'X7D1','X7D1','X7D1',0,'Position','X7D','','',null,null,null
exec CreateLocation 'X7D2','X7D2','X7D2',0,'Position','X7D','','',null,null,null
exec CreateLocation 'X7D3','X7D3','X7D3',0,'Position','X7D','','',null,null,null
exec CreateLocation 'X7D4','X7D4','X7D4',0,'Position','X7D','','',null,null,null
exec CreateLocation 'X7D5','X7D5','X7D5',0,'Position','X7D','','',null,null,null
exec CreateLocation 'X7D6','X7D6','X7D6',0,'Position','X7D','','',null,null,null
exec CreateLocation 'X7D7','X7D7','X7D7',0,'Position','X7D','','',null,null,null
exec CreateLocation 'X7D8','X7D8','X7D8',0,'Position','X7D','','',null,null,null
exec CreateLocation 'X7D9','X7D9','X7D9',0,'Position','X7D','','',null,null,null
exec CreateLocation 'X7D10','X7D10','X7D10',0,'Position','X7D','','',null,null,null
exec CreateLocation 'X7D11','X7D11','X7D11',0,'Position','X7D','','',null,null,null
exec CreateLocation 'X7D12','X7D12','X7D12',0,'Position','X7D','','',null,null,null
exec CreateLocation 'X7D13','X7D13','X7D13',0,'Position','X7D','','',null,null,null
exec CreateLocation 'X7D14','X7D14','X7D14',0,'Position','X7D','','',null,null,null
exec CreateLocation 'X7D15','X7D15','X7D15',0,'Position','X7D','','',null,null,null
exec CreateLocation 'X7D16','X7D16','X7D16',0,'Position','X7D','','',null,null,null
exec CreateLocation 'X7D17','X7D17','X7D17',0,'Position','X7D','','',null,null,null
exec CreateLocation 'X7D18','X7D18','X7D18',0,'Position','X7D','','',null,null,null
exec CreateLocation 'X7D19','X7D19','X7D19',0,'Position','X7D','','',null,null,null
exec CreateLocation 'X7D20','X7D20','X7D20',0,'Position','X7D','','',null,null,null
exec CreateLocation 'X7E1','X7E1','X7E1',0,'Position','X7E','','',null,null,null
exec CreateLocation 'X7E2','X7E2','X7E2',0,'Position','X7E','','',null,null,null
exec CreateLocation 'X7E3','X7E3','X7E3',0,'Position','X7E','','',null,null,null
exec CreateLocation 'X7E4','X7E4','X7E4',0,'Position','X7E','','',null,null,null
exec CreateLocation 'X7E5','X7E5','X7E5',0,'Position','X7E','','',null,null,null
exec CreateLocation 'X7E6','X7E6','X7E6',0,'Position','X7E','','',null,null,null
exec CreateLocation 'X7E7','X7E7','X7E7',0,'Position','X7E','','',null,null,null
exec CreateLocation 'X7E8','X7E8','X7E8',0,'Position','X7E','','',null,null,null
exec CreateLocation 'X7E9','X7E9','X7E9',0,'Position','X7E','','',null,null,null
exec CreateLocation 'X7E10','X7E10','X7E10',0,'Position','X7E','','',null,null,null
exec CreateLocation 'X7E11','X7E11','X7E11',0,'Position','X7E','','',null,null,null
exec CreateLocation 'X7E12','X7E12','X7E12',0,'Position','X7E','','',null,null,null
exec CreateLocation 'X7E13','X7E13','X7E13',0,'Position','X7E','','',null,null,null
exec CreateLocation 'X7E14','X7E14','X7E14',0,'Position','X7E','','',null,null,null
exec CreateLocation 'X7E15','X7E15','X7E15',0,'Position','X7E','','',null,null,null
exec CreateLocation 'X7E16','X7E16','X7E16',0,'Position','X7E','','',null,null,null
exec CreateLocation 'X7E17','X7E17','X7E17',0,'Position','X7E','','',null,null,null
exec CreateLocation 'X7E18','X7E18','X7E18',0,'Position','X7E','','',null,null,null
exec CreateLocation 'X7E19','X7E19','X7E19',0,'Position','X7E','','',null,null,null
exec CreateLocation 'X7E20','X7E20','X7E20',0,'Position','X7E','','',null,null,null
exec CreateLocation 'X7F1','X7F1','X7F1',0,'Position','X7F','','',null,null,null
exec CreateLocation 'X7F2','X7F2','X7F2',0,'Position','X7F','','',null,null,null
exec CreateLocation 'X7F3','X7F3','X7F3',0,'Position','X7F','','',null,null,null
exec CreateLocation 'X7F4','X7F4','X7F4',0,'Position','X7F','','',null,null,null
exec CreateLocation 'X7F5','X7F5','X7F5',0,'Position','X7F','','',null,null,null
exec CreateLocation 'X7F6','X7F6','X7F6',0,'Position','X7F','','',null,null,null
exec CreateLocation 'X7F7','X7F7','X7F7',0,'Position','X7F','','',null,null,null
exec CreateLocation 'X7F8','X7F8','X7F8',0,'Position','X7F','','',null,null,null
exec CreateLocation 'X7F9','X7F9','X7F9',0,'Position','X7F','','',null,null,null
exec CreateLocation 'X7F10','X7F10','X7F10',0,'Position','X7F','','',null,null,null
exec CreateLocation 'X7F11','X7F11','X7F11',0,'Position','X7F','','',null,null,null
exec CreateLocation 'X7F12','X7F12','X7F12',0,'Position','X7F','','',null,null,null
exec CreateLocation 'X7F13','X7F13','X7F13',0,'Position','X7F','','',null,null,null
exec CreateLocation 'X7F14','X7F14','X7F14',0,'Position','X7F','','',null,null,null
exec CreateLocation 'X7F15','X7F15','X7F15',0,'Position','X7F','','',null,null,null
exec CreateLocation 'X7F16','X7F16','X7F16',0,'Position','X7F','','',null,null,null
exec CreateLocation 'X7F17','X7F17','X7F17',0,'Position','X7F','','',null,null,null
exec CreateLocation 'X7F18','X7F18','X7F18',0,'Position','X7F','','',null,null,null
exec CreateLocation 'X7F19','X7F19','X7F19',0,'Position','X7F','','',null,null,null
exec CreateLocation 'X7F20','X7F20','X7F20',0,'Position','X7F','','',null,null,null
exec CreateLocation 'X7G1','X7G1','X7G1',0,'Position','X7G','','',null,null,null
exec CreateLocation 'X7G2','X7G2','X7G2',0,'Position','X7G','','',null,null,null
exec CreateLocation 'X7G3','X7G3','X7G3',0,'Position','X7G','','',null,null,null
exec CreateLocation 'X7G4','X7G4','X7G4',0,'Position','X7G','','',null,null,null
exec CreateLocation 'X7G5','X7G5','X7G5',0,'Position','X7G','','',null,null,null
exec CreateLocation 'X7G6','X7G6','X7G6',0,'Position','X7G','','',null,null,null
exec CreateLocation 'X7G7','X7G7','X7G7',0,'Position','X7G','','',null,null,null
exec CreateLocation 'X7G8','X7G8','X7G8',0,'Position','X7G','','',null,null,null
exec CreateLocation 'X7G9','X7G9','X7G9',0,'Position','X7G','','',null,null,null
exec CreateLocation 'X7G10','X7G10','X7G10',0,'Position','X7G','','',null,null,null
exec CreateLocation 'X7G11','X7G11','X7G11',0,'Position','X7G','','',null,null,null
exec CreateLocation 'X7G12','X7G12','X7G12',0,'Position','X7G','','',null,null,null
exec CreateLocation 'X7G13','X7G13','X7G13',0,'Position','X7G','','',null,null,null
exec CreateLocation 'X7G14','X7G14','X7G14',0,'Position','X7G','','',null,null,null
exec CreateLocation 'X7G15','X7G15','X7G15',0,'Position','X7G','','',null,null,null
exec CreateLocation 'X7G16','X7G16','X7G16',0,'Position','X7G','','',null,null,null
exec CreateLocation 'X7G17','X7G17','X7G17',0,'Position','X7G','','',null,null,null
exec CreateLocation 'X7G18','X7G18','X7G18',0,'Position','X7G','','',null,null,null
exec CreateLocation 'X7G19','X7G19','X7G19',0,'Position','X7G','','',null,null,null
exec CreateLocation 'X7G20','X7G20','X7G20',0,'Position','X7G','','',null,null,null
exec CreateLocation 'X7H1','X7H1','X7H1',0,'Position','X7H','','',null,null,null
exec CreateLocation 'X7H2','X7H2','X7H2',0,'Position','X7H','','',null,null,null
exec CreateLocation 'X7H3','X7H3','X7H3',0,'Position','X7H','','',null,null,null
exec CreateLocation 'X7H4','X7H4','X7H4',0,'Position','X7H','','',null,null,null
exec CreateLocation 'X7H5','X7H5','X7H5',0,'Position','X7H','','',null,null,null
exec CreateLocation 'X7H6','X7H6','X7H6',0,'Position','X7H','','',null,null,null
exec CreateLocation 'X7H7','X7H7','X7H7',0,'Position','X7H','','',null,null,null
exec CreateLocation 'X7H8','X7H8','X7H8',0,'Position','X7H','','',null,null,null
exec CreateLocation 'X7H9','X7H9','X7H9',0,'Position','X7H','','',null,null,null
exec CreateLocation 'X7H10','X7H10','X7H10',0,'Position','X7H','','',null,null,null
exec CreateLocation 'X7H11','X7H11','X7H11',0,'Position','X7H','','',null,null,null
exec CreateLocation 'X7H12','X7H12','X7H12',0,'Position','X7H','','',null,null,null
exec CreateLocation 'X7H13','X7H13','X7H13',0,'Position','X7H','','',null,null,null
exec CreateLocation 'X7H14','X7H14','X7H14',0,'Position','X7H','','',null,null,null
exec CreateLocation 'X7H15','X7H15','X7H15',0,'Position','X7H','','',null,null,null
exec CreateLocation 'X7H16','X7H16','X7H16',0,'Position','X7H','','',null,null,null
exec CreateLocation 'X7H17','X7H17','X7H17',0,'Position','X7H','','',null,null,null
exec CreateLocation 'X7H18','X7H18','X7H18',0,'Position','X7H','','',null,null,null
exec CreateLocation 'X7H19','X7H19','X7H19',0,'Position','X7H','','',null,null,null
exec CreateLocation 'X7H20','X7H20','X7H20',0,'Position','X7H','','',null,null,null
exec CreateLocation 'X7I1','X7I1','X7I1',0,'Position','X7I','','',null,null,null
exec CreateLocation 'X7I2','X7I2','X7I2',0,'Position','X7I','','',null,null,null
exec CreateLocation 'X7I3','X7I3','X7I3',0,'Position','X7I','','',null,null,null
exec CreateLocation 'X7I4','X7I4','X7I4',0,'Position','X7I','','',null,null,null
exec CreateLocation 'X7I5','X7I5','X7I5',0,'Position','X7I','','',null,null,null
exec CreateLocation 'X7I6','X7I6','X7I6',0,'Position','X7I','','',null,null,null
exec CreateLocation 'X7I7','X7I7','X7I7',0,'Position','X7I','','',null,null,null
exec CreateLocation 'X7I8','X7I8','X7I8',0,'Position','X7I','','',null,null,null
exec CreateLocation 'X7I9','X7I9','X7I9',0,'Position','X7I','','',null,null,null
exec CreateLocation 'X7I10','X7I10','X7I10',0,'Position','X7I','','',null,null,null
exec CreateLocation 'X7I11','X7I11','X7I11',0,'Position','X7I','','',null,null,null
exec CreateLocation 'X7I12','X7I12','X7I12',0,'Position','X7I','','',null,null,null
exec CreateLocation 'X7I13','X7I13','X7I13',0,'Position','X7I','','',null,null,null
exec CreateLocation 'X7I14','X7I14','X7I14',0,'Position','X7I','','',null,null,null
exec CreateLocation 'X7I15','X7I15','X7I15',0,'Position','X7I','','',null,null,null
exec CreateLocation 'X7I16','X7I16','X7I16',0,'Position','X7I','','',null,null,null
exec CreateLocation 'X7I17','X7I17','X7I17',0,'Position','X7I','','',null,null,null
exec CreateLocation 'X7I18','X7I18','X7I18',0,'Position','X7I','','',null,null,null
exec CreateLocation 'X7I19','X7I19','X7I19',0,'Position','X7I','','',null,null,null
exec CreateLocation 'X7I20','X7I20','X7I20',0,'Position','X7I','','',null,null,null
exec CreateLocation 'X7J1','X7J1','X7J1',0,'Position','X7J','','',null,null,null
exec CreateLocation 'X7J2','X7J2','X7J2',0,'Position','X7J','','',null,null,null
exec CreateLocation 'X7J3','X7J3','X7J3',0,'Position','X7J','','',null,null,null
exec CreateLocation 'X7J4','X7J4','X7J4',0,'Position','X7J','','',null,null,null
exec CreateLocation 'X7J5','X7J5','X7J5',0,'Position','X7J','','',null,null,null
exec CreateLocation 'X7J6','X7J6','X7J6',0,'Position','X7J','','',null,null,null
exec CreateLocation 'X7J7','X7J7','X7J7',0,'Position','X7J','','',null,null,null
exec CreateLocation 'X7J8','X7J8','X7J8',0,'Position','X7J','','',null,null,null
exec CreateLocation 'X7J9','X7J9','X7J9',0,'Position','X7J','','',null,null,null
exec CreateLocation 'X7J10','X7J10','X7J10',0,'Position','X7J','','',null,null,null
exec CreateLocation 'X7J11','X7J11','X7J11',0,'Position','X7J','','',null,null,null
exec CreateLocation 'X7J12','X7J12','X7J12',0,'Position','X7J','','',null,null,null
exec CreateLocation 'X7J13','X7J13','X7J13',0,'Position','X7J','','',null,null,null
exec CreateLocation 'X7J14','X7J14','X7J14',0,'Position','X7J','','',null,null,null
exec CreateLocation 'X7J15','X7J15','X7J15',0,'Position','X7J','','',null,null,null
exec CreateLocation 'X7J16','X7J16','X7J16',0,'Position','X7J','','',null,null,null
exec CreateLocation 'X7J17','X7J17','X7J17',0,'Position','X7J','','',null,null,null
exec CreateLocation 'X7J18','X7J18','X7J18',0,'Position','X7J','','',null,null,null
exec CreateLocation 'X7J19','X7J19','X7J19',0,'Position','X7J','','',null,null,null
exec CreateLocation 'X7J20','X7J20','X7J20',0,'Position','X7J','','',null,null,null
exec CreateLocation 'X7K1','X7K1','X7K1',0,'Position','X7K','','',null,null,null
exec CreateLocation 'X7K2','X7K2','X7K2',0,'Position','X7K','','',null,null,null
exec CreateLocation 'X7K3','X7K3','X7K3',0,'Position','X7K','','',null,null,null
exec CreateLocation 'X7K4','X7K4','X7K4',0,'Position','X7K','','',null,null,null
exec CreateLocation 'X7K5','X7K5','X7K5',0,'Position','X7K','','',null,null,null
exec CreateLocation 'X7K6','X7K6','X7K6',0,'Position','X7K','','',null,null,null
exec CreateLocation 'X7K7','X7K7','X7K7',0,'Position','X7K','','',null,null,null
exec CreateLocation 'X7K8','X7K8','X7K8',0,'Position','X7K','','',null,null,null
exec CreateLocation 'X7K9','X7K9','X7K9',0,'Position','X7K','','',null,null,null
exec CreateLocation 'X7K10','X7K10','X7K10',0,'Position','X7K','','',null,null,null
exec CreateLocation 'X7K11','X7K11','X7K11',0,'Position','X7K','','',null,null,null
exec CreateLocation 'X7K12','X7K12','X7K12',0,'Position','X7K','','',null,null,null
exec CreateLocation 'X7K13','X7K13','X7K13',0,'Position','X7K','','',null,null,null
exec CreateLocation 'X7K14','X7K14','X7K14',0,'Position','X7K','','',null,null,null
exec CreateLocation 'X7K15','X7K15','X7K15',0,'Position','X7K','','',null,null,null
exec CreateLocation 'X7K16','X7K16','X7K16',0,'Position','X7K','','',null,null,null
exec CreateLocation 'X7K17','X7K17','X7K17',0,'Position','X7K','','',null,null,null
exec CreateLocation 'X7K18','X7K18','X7K18',0,'Position','X7K','','',null,null,null
exec CreateLocation 'X7K19','X7K19','X7K19',0,'Position','X7K','','',null,null,null
exec CreateLocation 'X7K20','X7K20','X7K20',0,'Position','X7K','','',null,null,null
exec CreateLocation 'X7L1','X7L1','X7L1',0,'Position','X7L','','',null,null,null
exec CreateLocation 'X7L2','X7L2','X7L2',0,'Position','X7L','','',null,null,null
exec CreateLocation 'X7L3','X7L3','X7L3',0,'Position','X7L','','',null,null,null
exec CreateLocation 'X7L4','X7L4','X7L4',0,'Position','X7L','','',null,null,null
exec CreateLocation 'X7L5','X7L5','X7L5',0,'Position','X7L','','',null,null,null
exec CreateLocation 'X7L6','X7L6','X7L6',0,'Position','X7L','','',null,null,null
exec CreateLocation 'X7L7','X7L7','X7L7',0,'Position','X7L','','',null,null,null
exec CreateLocation 'X7L8','X7L8','X7L8',0,'Position','X7L','','',null,null,null
exec CreateLocation 'X7L9','X7L9','X7L9',0,'Position','X7L','','',null,null,null
exec CreateLocation 'X7L10','X7L10','X7L10',0,'Position','X7L','','',null,null,null
exec CreateLocation 'X7L11','X7L11','X7L11',0,'Position','X7L','','',null,null,null
exec CreateLocation 'X7L12','X7L12','X7L12',0,'Position','X7L','','',null,null,null
exec CreateLocation 'X7L13','X7L13','X7L13',0,'Position','X7L','','',null,null,null
exec CreateLocation 'X7L14','X7L14','X7L14',0,'Position','X7L','','',null,null,null
exec CreateLocation 'X7L15','X7L15','X7L15',0,'Position','X7L','','',null,null,null
exec CreateLocation 'X7L16','X7L16','X7L16',0,'Position','X7L','','',null,null,null
exec CreateLocation 'X7L17','X7L17','X7L17',0,'Position','X7L','','',null,null,null
exec CreateLocation 'X7L18','X7L18','X7L18',0,'Position','X7L','','',null,null,null
exec CreateLocation 'X7L19','X7L19','X7L19',0,'Position','X7L','','',null,null,null
exec CreateLocation 'X7L20','X7L20','X7L20',0,'Position','X7L','','',null,null,null

insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7A' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7B' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7C' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7D' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7E' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7F' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7G' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7H' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7I' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7J' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7K' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7L' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7A1' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7A2' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7A3' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7A4' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7A5' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7A6' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7A7' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7A8' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7A9' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7A10' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7A11' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7A12' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7A13' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7A14' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7A15' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7A16' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7A17' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7A18' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7A19' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7A20' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7B1' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7B2' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7B3' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7B4' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7B5' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7B6' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7B7' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7B8' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7B9' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7B10' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7B11' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7B12' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7B13' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7B14' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7B15' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7B16' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7B17' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7B18' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7B19' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7B20' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7C1' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7C2' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7C3' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7C4' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7C5' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7C6' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7C7' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7C8' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7C9' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7C10' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7C11' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7C12' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7C13' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7C14' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7C15' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7C16' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7C17' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7C18' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7C19' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7C20' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7D1' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7D2' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7D3' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7D4' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7D5' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7D6' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7D7' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7D8' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7D9' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7D10' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7D11' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7D12' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7D13' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7D14' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7D15' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7D16' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7D17' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7D18' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7D19' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7D20' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7E1' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7E2' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7E3' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7E4' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7E5' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7E6' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7E7' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7E8' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7E9' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7E10' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7E11' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7E12' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7E13' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7E14' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7E15' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7E16' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7E17' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7E18' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7E19' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7E20' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7F1' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7F2' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7F3' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7F4' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7F5' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7F6' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7F7' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7F8' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7F9' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7F10' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7F11' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7F12' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7F13' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7F14' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7F15' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7F16' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7F17' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7F18' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7F19' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7F20' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7G1' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7G2' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7G3' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7G4' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7G5' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7G6' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7G7' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7G8' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7G9' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7G10' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7G11' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7G12' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7G13' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7G14' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7G15' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7G16' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7G17' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7G18' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7G19' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7G20' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7H1' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7H2' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7H3' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7H4' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7H5' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7H6' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7H7' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7H8' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7H9' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7H10' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7H11' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7H12' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7H13' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7H14' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7H15' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7H16' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7H17' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7H18' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7H19' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7H20' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7I1' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7I2' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7I3' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7I4' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7I5' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7I6' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7I7' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7I8' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7I9' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7I10' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7I11' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7I12' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7I13' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7I14' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7I15' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7I16' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7I17' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7I18' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7I19' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7I20' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7J1' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7J2' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7J3' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7J4' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7J5' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7J6' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7J7' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7J8' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7J9' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7J10' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7J11' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7J12' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7J13' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7J14' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7J15' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7J16' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7J17' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7J18' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7J19' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7J20' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7K1' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7K2' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7K3' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7K4' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7K5' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7K6' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7K7' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7K8' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7K9' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7K10' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7K11' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7K12' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7K13' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7K14' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7K15' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7K16' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7K17' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7K18' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7K19' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7K20' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7L1' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7L2' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7L3' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7L4' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7L5' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7L6' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7L7' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7L8' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7L9' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7L10' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7L11' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7L12' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7L13' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7L14' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7L15' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7L16' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7L17' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7L18' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7L19' and c.CODE = 'IC_VMHZP'
insert into [dbo].[LOCATION_INTERNAL_COMPANY] ( [LOCATION_ID],[INTERNAL_COMPANY_ID]) select l.LOCATION_ID, c.COMPANYNR from LOCATION l, COMPANY c WHERE l.ADDRESS ='X7L20' and c.CODE = 'IC_VMHZP'

