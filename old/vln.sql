-- 325	2	1	2016-05-04 00:00:00.0000000	2016-06-03 00:00:00.0000000	1	160380	1	0	1	2476.00	2476.00	1.000000	48	48	NULL	2016-06-02 00:00:00.0000000	KAL	2016-06-02 14:51:24.0000000	KAL	2016-06-02 14:51:27.2600000	0	160380
-- 365	2	1	2016-05-29 00:00:00.0000000	2016-06-28 00:00:00.0000000	1	160420	1	0	1	809.80	809.80	1.000000	48	48	NULL	2016-06-03 00:00:00.0000000	KAL	2016-06-03 10:33:41.0000000	KAL	2016-06-03 10:33:43.9400000	0	160420
--Seq 160402 160420

--update FINANCIAL_LINE set FINANCIAL_DOCUMENT_ID = null where FINANCIAL_LINE_ID = 2618
--delete from OPERATION_REPORT_FINANCIAL_LINE where FINANCIAL_LINE_ID = 1549 and OPERATION_REPORT_ID = 8470

--delete from FINANCIAL_LINE where FINANCIAL_LINE_ID in (2652, 1670)
--delete from FINANCIAL_LINE_LINE where FINANCIAL_LINE_ID = 2652
--delete from OPERATION_REPORT_FINANCIAL_LINE where FINANCIAL_LINE_ID = 1670

/*
388	2	1	2016-05-31 00:00:00.0000000	2016-06-30 00:00:00.0000000	1	160443	1	0	1	4258.28	4258.28	1.000000	48	48	NULL	2016-06-03 00:00:00.0000000	KAL	2016-06-03 13:18:27.0000000	KAL	2016-06-03 13:18:30.8400000	0	160443
389	2	1	2016-05-18 00:00:00.0000000	2016-06-17 00:00:00.0000000	1	160444	1	0	1	3282.27	3282.27	1.000000	48	48	NULL	2016-06-03 00:00:00.0000000	KAL	2016-06-03 13:31:30.0000000	KAL	2016-06-03 13:31:33.6700000	0	160444
396	11	1	2016-05-31 00:00:00.0000000	2016-06-30 00:00:00.0000000	1	160450	1	0	1	1149.07	1149.07	1.000000	48	48	NULL	2016-06-07 00:00:00.0000000	KAL	2016-06-07 22:43:59.0000000	KAL	2016-06-07 22:45:29.3000000	0	160450
*/