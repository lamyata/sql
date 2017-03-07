--restore filelistonly from disk='C:\1\iTos_20160810.BAK'

RESTORE DATABASE [iTosVMG_160810] FROM DISK='C:\1\iTos_20160810.bak' 
WITH FILE = 1, 
RECOVERY, REPLACE, STATS = 5,
MOVE 'iTos' TO 'C:\Program Files\Microsoft SQL Server\MSSQL11.MAIN\MSSQL\DATA\iTosVMG_160810.mdf', 
MOVE 'iTos_log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL11.MAIN\MSSQL\DATA\iTosVMG_160810_0.ldf'

--RESTORE DATABASE [iTosVMG_160810] WITH RECOVERY
------------------
--restore filelistonly from disk='P:\vs7_vmg09s_user\vmg09s\backup\iTos_20161215.BAK'

ALTER DATABASE [itos-uat.vanmoergroup.com] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
RESTORE DATABASE [itos-uat.vanmoergroup.com] FROM DISK='P:\vs7_vmg09s_user\vmg09s\backup\iTos_20161215.BAK' 
WITH FILE = 1, 
RECOVERY, REPLACE, STATS = 5,
MOVE 'iTos' TO 'P:\vs7_vmg09s_user\vmg09s\itos-uat.vanmoergroup.com_Primary.mdf', 
MOVE 'iTos_log' TO 'P:\vs7_vmg09s_log\vmg09s\itos-uat.vanmoergroup.com_Primary.ldf'
GO