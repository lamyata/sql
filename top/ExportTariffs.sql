-- Discharging
SELECT icc.NAME,
    ti.DESCRIPTION 'Description', 
	ti.CODE 'Code', 
	case t.STATUS when 0 then 'Active' when 1 then 'NotActive' else 'Unknown' end  'TariffStatus', 
	tf.REFERENCE 'TariffFile', 
	case tf.STATUS when 0 then 'Active' when 1 then 'NotActive' else 'Unknown' end 'TariffFileStatus', 
	ti.TARIFF 'Tariff', 
	tr.TARIFF 'Tariff(Range)',
	tiu.DESCRIPTION 'Unit',
	mu.DESCRIPTION 'MeasurementUnit',
	c.NAME 'Customer', 
	o.NAME 'Operation',
	p.SHORT_DESC 'Product',
	u.DESCRIPTION 'StorageUnit',
	ti.SERVICE_ACCOUNT 'ServiceAccount',
	ti.RANGE_CALCULATION 'RangeCalculation'
FROM TARIFF t
JOIN DISCHARGING_TARIFF dt ON t.TARIFF_ID = dt.DISCHARGING_TARIFF_ID 
LEFT JOIN STOCK_INFO si ON dt.STOCK_INFO_ID = si.STOCK_INFO_ID
LEFT JOIN STOCK_INFO_CONFIG sic ON si.STOCK_INFO_CONFIG_ID = sic.STOCK_INFO_CONFIG_ID
LEFT JOIN PRODUCT p ON sic.PRODUCT_ID = p.PRODUCT_ID
LEFT JOIN UNIT u ON sic.STORAGE_UNIT_ID = u.UNIT_ID
JOIN TARIFF_INFO ti ON t.TARIFF_INFO_ID = ti.TARIFF_INFO_ID
LEFT JOIN TARIFF_INFO_RANGE tir ON ti.TARIFF_INFO_ID = tir.TARIFF_INFO_ID
LEFT JOIN TARIFF_RANGE tr ON tir.TARIFF_RANGE_ID = tr.TARIFF_RANGE_ID
LEFT JOIN UNIT tiu ON ti.UNIT_ID = tiu.UNIT_ID
LEFT JOIN MEASUREMENT_UNIT mu ON ti.MEASUREMENT_UNIT_ID = mu.MEASUREMENT_UNIT_ID
JOIN TARIFF_FILE tf ON t.TARIFF_FILE_ID = tf.TARIFF_FILE_ID 
JOIN INTERNAL_COMPANY ic ON tf.INTERNAL_COMPANY_ID = ic.COMPANYNR
JOIN COMPANY icc ON ic.COMPANYNR = icc.COMPANYNR
LEFT JOIN TARIFF_CUSTOMER tc ON tc.TARIFF_ID = t.TARIFF_ID
LEFT JOIN COMPANY c ON tc.COMPANY_ID = c.COMPANYNR
LEFT JOIN OPERATION o ON t.OPERATION_ID = o.OPERATION_ID
ORDER BY tc.COMPANY_ID, tf.REFERENCE, ti.TARIFF_INFO_ID
GO

-- Loading
SELECT icc.NAME,
    ti.DESCRIPTION 'Description', 
	ti.CODE 'Code', 
	case t.STATUS when 0 then 'Active' when 1 then 'NotActive' else 'Unknown' end  'TariffStatus', 
	tf.REFERENCE 'TariffFile', 
	case tf.STATUS when 0 then 'Active' when 1 then 'NotActive' else 'Unknown' end 'TariffFileStatus', 
	ti.TARIFF 'Tariff', 
	tr.TARIFF 'Tariff(Range)',
	tiu.DESCRIPTION 'Unit',
	mu.DESCRIPTION 'MeasurementUnit',
	c.NAME 'Customer', 
	o.NAME 'Operation',
	p.SHORT_DESC 'Product',
	u.DESCRIPTION 'StorageUnit',
	ti.SERVICE_ACCOUNT 'ServiceAccount',
	ti.RANGE_CALCULATION 'RangeCalculation'
FROM TARIFF t
JOIN LOADING_TARIFF dt ON t.TARIFF_ID = dt.LOADING_TARIFF_ID 
LEFT JOIN STOCK_INFO si ON dt.STOCK_INFO_ID = si.STOCK_INFO_ID
LEFT JOIN STOCK_INFO_CONFIG sic ON si.STOCK_INFO_CONFIG_ID = sic.STOCK_INFO_CONFIG_ID
LEFT JOIN PRODUCT p ON sic.PRODUCT_ID = p.PRODUCT_ID
LEFT JOIN UNIT u ON sic.STORAGE_UNIT_ID = u.UNIT_ID
JOIN TARIFF_INFO ti ON t.TARIFF_INFO_ID = ti.TARIFF_INFO_ID
LEFT JOIN TARIFF_INFO_RANGE tir ON ti.TARIFF_INFO_ID = tir.TARIFF_INFO_ID
LEFT JOIN TARIFF_RANGE tr ON tir.TARIFF_RANGE_ID = tr.TARIFF_RANGE_ID
LEFT JOIN UNIT tiu ON ti.UNIT_ID = tiu.UNIT_ID
LEFT JOIN MEASUREMENT_UNIT mu ON ti.MEASUREMENT_UNIT_ID = mu.MEASUREMENT_UNIT_ID
JOIN TARIFF_FILE tf ON t.TARIFF_FILE_ID = tf.TARIFF_FILE_ID 
JOIN INTERNAL_COMPANY ic ON tf.INTERNAL_COMPANY_ID = ic.COMPANYNR
JOIN COMPANY icc ON ic.COMPANYNR = icc.COMPANYNR
LEFT JOIN TARIFF_CUSTOMER tc ON tc.TARIFF_ID = t.TARIFF_ID
LEFT JOIN COMPANY c ON tc.COMPANY_ID = c.COMPANYNR
LEFT JOIN OPERATION o ON t.OPERATION_ID = o.OPERATION_ID
ORDER BY tc.COMPANY_ID, tf.REFERENCE, ti.TARIFF_INFO_ID
GO

-- VAS
SELECT icc.NAME,
    ti.DESCRIPTION 'Description', 
	ti.CODE 'Code', 
	case t.STATUS when 0 then 'Active' when 1 then 'NotActive' else 'Unknown' end  'TariffStatus', 
	tf.REFERENCE 'TariffFile', 
	case tf.STATUS when 0 then 'Active' when 1 then 'NotActive' else 'Unknown' end 'TariffFileStatus', 
	ti.TARIFF 'Tariff', 
	tr.TARIFF 'Tariff(Range)',
	tiu.DESCRIPTION 'Unit',
	mu.DESCRIPTION 'MeasurementUnit',
	c.NAME 'Customer', 
	o.NAME 'Operation',
	NULL 'Product',
	NULL 'StorageUnit',
	ti.SERVICE_ACCOUNT 'ServiceAccount',	
	ti.RANGE_CALCULATION 'RangeCalculation'
FROM TARIFF t
JOIN VAS_TARIFF dt ON t.TARIFF_ID = dt.VAS_TARIFF_ID 
JOIN TARIFF_INFO ti ON t.TARIFF_INFO_ID = ti.TARIFF_INFO_ID
LEFT JOIN TARIFF_INFO_RANGE tir ON ti.TARIFF_INFO_ID = tir.TARIFF_INFO_ID
LEFT JOIN TARIFF_RANGE tr ON tir.TARIFF_RANGE_ID = tr.TARIFF_RANGE_ID
LEFT JOIN UNIT tiu ON ti.UNIT_ID = tiu.UNIT_ID
LEFT JOIN MEASUREMENT_UNIT mu ON ti.MEASUREMENT_UNIT_ID = mu.MEASUREMENT_UNIT_ID
JOIN TARIFF_FILE tf ON t.TARIFF_FILE_ID = tf.TARIFF_FILE_ID 
JOIN INTERNAL_COMPANY ic ON tf.INTERNAL_COMPANY_ID = ic.COMPANYNR
JOIN COMPANY icc ON ic.COMPANYNR = icc.COMPANYNR
LEFT JOIN TARIFF_CUSTOMER tc ON tc.TARIFF_ID = t.TARIFF_ID
LEFT JOIN COMPANY c ON tc.COMPANY_ID = c.COMPANYNR
LEFT JOIN OPERATION o ON t.OPERATION_ID = o.OPERATION_ID
ORDER BY tc.COMPANY_ID, tf.REFERENCE, ti.TARIFF_INFO_ID
GO

-- Stock Change
SELECT icc.NAME,
    ti.DESCRIPTION 'Description', 
	ti.CODE 'Code', 
	case t.STATUS when 0 then 'Active' when 1 then 'NotActive' else 'Unknown' end  'TariffStatus', 
	tf.REFERENCE 'TariffFile', 
	case tf.STATUS when 0 then 'Active' when 1 then 'NotActive' else 'Unknown' end 'TariffFileStatus', 
	ti.TARIFF 'Tariff', 
	tr.TARIFF 'Tariff(Range)',
	tiu.DESCRIPTION 'Unit',
	mu.DESCRIPTION 'MeasurementUnit',
	c.NAME 'Customer', 
	o.NAME 'Operation',
	NULL 'Product',
	NULL 'StorageUnit',
	ti.SERVICE_ACCOUNT 'ServiceAccount',	
	ti.RANGE_CALCULATION 'RangeCalculation'
FROM TARIFF t
JOIN STOCK_CHANGE_TARIFF dt ON t.TARIFF_ID = dt.STOCK_CHANGE_TARIFF_ID 
JOIN TARIFF_INFO ti ON t.TARIFF_INFO_ID = ti.TARIFF_INFO_ID
LEFT JOIN TARIFF_INFO_RANGE tir ON ti.TARIFF_INFO_ID = tir.TARIFF_INFO_ID
LEFT JOIN TARIFF_RANGE tr ON tir.TARIFF_RANGE_ID = tr.TARIFF_RANGE_ID
LEFT JOIN UNIT tiu ON ti.UNIT_ID = tiu.UNIT_ID
LEFT JOIN MEASUREMENT_UNIT mu ON ti.MEASUREMENT_UNIT_ID = mu.MEASUREMENT_UNIT_ID
JOIN TARIFF_FILE tf ON t.TARIFF_FILE_ID = tf.TARIFF_FILE_ID 
JOIN INTERNAL_COMPANY ic ON tf.INTERNAL_COMPANY_ID = ic.COMPANYNR
JOIN COMPANY icc ON ic.COMPANYNR = icc.COMPANYNR
LEFT JOIN TARIFF_CUSTOMER tc ON tc.TARIFF_ID = t.TARIFF_ID
LEFT JOIN COMPANY c ON tc.COMPANY_ID = c.COMPANYNR
LEFT JOIN OPERATION o ON t.OPERATION_ID = o.OPERATION_ID
ORDER BY tc.COMPANY_ID, tf.REFERENCE, ti.TARIFF_INFO_ID
GO

-- Additional
SELECT icc.NAME,
    ti.DESCRIPTION 'Description', 
	ti.CODE 'Code', 
	case t.STATUS when 0 then 'Active' when 1 then 'NotActive' else 'Unknown' end  'TariffStatus', 
	tf.REFERENCE 'TariffFile', 
	case tf.STATUS when 0 then 'Active' when 1 then 'NotActive' else 'Unknown' end 'TariffFileStatus', 
	ti.TARIFF 'Tariff', 
	tr.TARIFF 'Tariff(Range)',
	tiu.DESCRIPTION 'Unit',
	mu.DESCRIPTION 'MeasurementUnit',
	c.NAME 'Customer', 
	o.NAME 'Operation',
	NULL 'Product',
	NULL 'StorageUnit',
	ti.SERVICE_ACCOUNT 'ServiceAccount',	
	ti.RANGE_CALCULATION 'RangeCalculation'
FROM TARIFF t
JOIN ADDITIONAL_TARIFF dt ON t.TARIFF_ID = dt.ADDITIONAL_TARIFF_ID
JOIN TARIFF_INFO ti ON t.TARIFF_INFO_ID = ti.TARIFF_INFO_ID
LEFT JOIN TARIFF_INFO_RANGE tir ON ti.TARIFF_INFO_ID = tir.TARIFF_INFO_ID
LEFT JOIN TARIFF_RANGE tr ON tir.TARIFF_RANGE_ID = tr.TARIFF_RANGE_ID
LEFT JOIN UNIT tiu ON ti.UNIT_ID = tiu.UNIT_ID
LEFT JOIN MEASUREMENT_UNIT mu ON ti.MEASUREMENT_UNIT_ID = mu.MEASUREMENT_UNIT_ID
JOIN TARIFF_FILE tf ON t.TARIFF_FILE_ID = tf.TARIFF_FILE_ID 
JOIN INTERNAL_COMPANY ic ON tf.INTERNAL_COMPANY_ID = ic.COMPANYNR
JOIN COMPANY icc ON ic.COMPANYNR = icc.COMPANYNR
LEFT JOIN TARIFF_CUSTOMER tc ON tc.TARIFF_ID = t.TARIFF_ID
LEFT JOIN COMPANY c ON tc.COMPANY_ID = c.COMPANYNR
LEFT JOIN OPERATION o ON t.OPERATION_ID = o.OPERATION_ID
ORDER BY tc.COMPANY_ID, tf.REFERENCE, ti.TARIFF_INFO_ID
GO

-- Administrative
SELECT icc.NAME,
    ti.DESCRIPTION 'Description', 
	ti.CODE 'Code', 
	case t.STATUS when 0 then 'Active' when 1 then 'NotActive' else 'Unknown' end  'TariffStatus', 
	tf.REFERENCE 'TariffFile', 
	case tf.STATUS when 0 then 'Active' when 1 then 'NotActive' else 'Unknown' end 'TariffFileStatus', 
	ti.TARIFF 'Tariff', 
	tr.TARIFF 'Tariff(Range)',
	tiu.DESCRIPTION 'Unit',
	mu.DESCRIPTION 'MeasurementUnit',
	c.NAME 'Customer', 
	o.NAME 'Operation',
	NULL 'Product',
	NULL 'StorageUnit',
	ti.SERVICE_ACCOUNT 'ServiceAccount',	
	ti.RANGE_CALCULATION 'RangeCalculation'
FROM TARIFF t
JOIN ADMINISTRATIVE_TARIFF dt ON t.TARIFF_ID = dt.ADMINISTRATIVE_TARIFF_ID
JOIN TARIFF_INFO ti ON t.TARIFF_INFO_ID = ti.TARIFF_INFO_ID
LEFT JOIN TARIFF_INFO_RANGE tir ON ti.TARIFF_INFO_ID = tir.TARIFF_INFO_ID
LEFT JOIN TARIFF_RANGE tr ON tir.TARIFF_RANGE_ID = tr.TARIFF_RANGE_ID
LEFT JOIN UNIT tiu ON ti.UNIT_ID = tiu.UNIT_ID
LEFT JOIN MEASUREMENT_UNIT mu ON ti.MEASUREMENT_UNIT_ID = mu.MEASUREMENT_UNIT_ID
JOIN TARIFF_FILE tf ON t.TARIFF_FILE_ID = tf.TARIFF_FILE_ID 
JOIN INTERNAL_COMPANY ic ON tf.INTERNAL_COMPANY_ID = ic.COMPANYNR
JOIN COMPANY icc ON ic.COMPANYNR = icc.COMPANYNR
LEFT JOIN TARIFF_CUSTOMER tc ON tc.TARIFF_ID = t.TARIFF_ID
LEFT JOIN COMPANY c ON tc.COMPANY_ID = c.COMPANYNR
LEFT JOIN OPERATION o ON t.OPERATION_ID = o.OPERATION_ID
ORDER BY tc.COMPANY_ID, tf.REFERENCE, ti.TARIFF_INFO_ID
GO

-- Warehouse Rent 
SELECT icc.NAME,
    ti.DESCRIPTION 'Description', 
	ti.CODE 'Code', 
	case t.STATUS when 0 then 'Active' when 1 then 'NotActive' else 'Unknown' end  'TariffStatus', 
	tf.REFERENCE 'TariffFile', 
	case tf.STATUS when 0 then 'Active' when 1 then 'NotActive' else 'Unknown' end 'TariffFileStatus', 
	ti.TARIFF 'Tariff', 
	tr.TARIFF 'Tariff(Range)',
	tiu.DESCRIPTION 'Unit',
	mu.DESCRIPTION 'MeasurementUnit',
	c.NAME 'Customer', 
	o.NAME 'Operation',
	p.SHORT_DESC 'Product',
	u.DESCRIPTION 'StorageUnit',
	ti.SERVICE_ACCOUNT 'ServiceAccount',
	ti.RANGE_CALCULATION 'RangeCalculation',
	dt.PERIOD 'Period',
	case dt.PERIOD_TYPE when 0 then 'Day' when 1 then 'Week' when 2 then 'Month' end 'PeriodType',
	dt.FREE_PERIOD 'Period',
	case dt.FREE_PERIOD_TYPE when 0 then 'Day' when 1 then 'Week' when 2 then 'Month' end 'FreePeriodType'
FROM TARIFF t
JOIN WAREHOUSE_RENT_TARIFF dt ON t.TARIFF_ID = dt.WAREHOUSE_RENT_TARIFF_ID 
LEFT JOIN STOCK_INFO si ON dt.STOCK_INFO_ID = si.STOCK_INFO_ID
LEFT JOIN STOCK_INFO_CONFIG sic ON si.STOCK_INFO_CONFIG_ID = sic.STOCK_INFO_CONFIG_ID
LEFT JOIN PRODUCT p ON sic.PRODUCT_ID = p.PRODUCT_ID
LEFT JOIN UNIT u ON sic.STORAGE_UNIT_ID = u.UNIT_ID
JOIN TARIFF_INFO ti ON t.TARIFF_INFO_ID = ti.TARIFF_INFO_ID
LEFT JOIN TARIFF_INFO_RANGE tir ON ti.TARIFF_INFO_ID = tir.TARIFF_INFO_ID
LEFT JOIN TARIFF_RANGE tr ON tir.TARIFF_RANGE_ID = tr.TARIFF_RANGE_ID
LEFT JOIN UNIT tiu ON ti.UNIT_ID = tiu.UNIT_ID
LEFT JOIN MEASUREMENT_UNIT mu ON ti.MEASUREMENT_UNIT_ID = mu.MEASUREMENT_UNIT_ID
JOIN TARIFF_FILE tf ON t.TARIFF_FILE_ID = tf.TARIFF_FILE_ID 
JOIN INTERNAL_COMPANY ic ON tf.INTERNAL_COMPANY_ID = ic.COMPANYNR
JOIN COMPANY icc ON ic.COMPANYNR = icc.COMPANYNR
LEFT JOIN TARIFF_CUSTOMER tc ON tc.TARIFF_ID = t.TARIFF_ID
LEFT JOIN COMPANY c ON tc.COMPANY_ID = c.COMPANYNR
LEFT JOIN OPERATION o ON t.OPERATION_ID = o.OPERATION_ID
ORDER BY tc.COMPANY_ID, tf.REFERENCE, ti.TARIFF_INFO_ID
GO