--select * from LOADING_OPERATION_PLAN where PLANNED_ID in  (13958, 13959, 13960, 13961, 13962, 13963, 13964)
--	or REMAINING_ID in  (13958, 13959, 13960, 13961, 13962, 13963, 13964)
--	or ORDERED_ID in (13958, 13959, 13960, 13961, 13962, 13963, 13964)
--	or PENDING_ID in  (13958, 13959, 13960, 13961, 13962, 13963, 13964)

--select * from STOCK_INFO_CONFIG where OWNER_ID = 1

update STOCK_INFO_CONFIG set OWNER_ID = 1776,
	_KEY_ = REPLACE(_KEY_,',"O":1,',',"O":1776,'),
	HASH_KEY = CAST(hashbytes('SHA1', REPLACE(_KEY_,',"O":1,',',"O":1776,')) AS BINARY(20)),	
	UPDATE_TIMESTAMP = GETDATE(),
	UPDATE_USER = 'sys161230'
where OWNER_ID = 1