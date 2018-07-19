declare @updateUser varchar(15) = 'la180109';
declare @EvianProductGroupId int = (select PRODUCT_GROUP_ID from PRODUCT_GROUP where CODE = 'EVIAN');
declare @SequenceSidId int = (select STORAGE_IDENTIFIER_ID from STORAGE_IDENTIFIER where CODE = 'SEQ');

declare @maxSequences table (ProdId int, Seq int)
insert into @maxSequences
select psi.PRODUCT_ID, max(psi.SID_SEQUENCE)
from PRODUCT_STORAGE_IDENTIFIER psi join PRODUCT_GROUP_PRODUCT pgp on psi.PRODUCT_ID = pgp.PRODUCT_ID and pgp.PRODUCT_GROUP_ID = @EvianProductGroupId
group by psi.PRODUCT_ID 

INSERT INTO [dbo].[PRODUCT_STORAGE_IDENTIFIER]
           ([PRODUCT_ID]
           ,[SID_ID]
           ,[SID_SEQUENCE]
           ,[IS_MANDATORY]
           ,[CREATE_USER]
           ,[CREATE_TIMESTAMP]
           ,[UPDATE_USER]
           ,[UPDATE_TIMESTAMP])
     SELECT
           PRODUCT_ID
           ,@SequenceSidId
           ,ms.Seq + 10
           ,0 -- IS_MANDATORY
           ,@updateUser
		   ,GETDATE()
		   ,@updateUser
		   ,GETDATE()
	FROM PRODUCT_GROUP_PRODUCT pgp, @maxSequences ms
	WHERE pgp.PRODUCT_GROUP_ID = @EvianProductGroupId
	AND ms.ProdId = pgp.PRODUCT_ID

INSERT INTO [dbo].[PRODUCT_SID_OPERATION_TYPE]
        ([PRODUCT_SID_ID]
        ,[OPERATION_TYPE_ID])
    SELECT
		psi.PRODUCT_STORAGE_IDENTIFIER_ID,
		ot.OPERATION_TYPE_ID
	FROM PRODUCT_STORAGE_IDENTIFIER psi, PRODUCT_GROUP_PRODUCT pgp, OPERATION_TYPE ot
	WHERE psi.PRODUCT_ID = pgp.PRODUCT_ID and pgp.PRODUCT_GROUP_ID = @EvianProductGroupId and psi.SID_ID = @SequenceSidId
		and ot.[DESCRIPTION] = 'Loading'
