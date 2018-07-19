CREATE PROCEDURE [dbo].[MakeLocation]
	@Address nvarchar(20),
	@Code nvarchar(15),
	@ParentAddress nvarchar(20),
	@IcCompanyCodes nvarchar(200)	
AS
	declare @LocationId int
	declare @ParentId int
	declare @HierarchiLevel int = 0
	declare @Path nvarchar(250)
	declare @PlainPath nvarchar(250)
	DECLARE @errMsg nvarchar(500)	
BEGIN

	SELECT @LocationId = LOCATION_ID from [dbo].[LOCATION] WHERE [ADDRESS] = @Address;

	if @LocationId is null
	begin
		select
			@ParentId = LOCATION_ID,
			@HierarchiLevel = HIERARCHY_LEVEL + 1,
			@PlainPath = IsNull([PLAIN_PATH],'|') + CODE +'|',
			@Path = IsNull([PATH],'|') + cast(LOCATION_ID as nvarchar(20)) + '|'
		from
			LOCATION
		where
			[ADDRESS] = @ParentAddress

		INSERT INTO [dbo].[LOCATION]
				([CODE]
				,[ADDRESS]
				,[STATUS]
				,[HAS_CHILDREN]
				,[HIERARCHY_LEVEL]
				,[PARENT_ID]
				,[PATH]
				,[PLAIN_PATH]
				,[CREATE_USER]
				,[CREATE_TIMESTAMP]
				,[UPDATE_USER]
				,[UPDATE_TIMESTAMP])
		 VALUES
			   (@Code
			   ,@Address
			   ,0
			   ,0
			   ,@HierarchiLevel
			   ,@ParentId
			   ,@Path
			   ,@PlainPath
			   ,'la180305'
			   ,getdate()
			   ,'la180305'
			   ,getdate())

		select @LocationId = SCOPE_IDENTITY();		   

		-- Update parent's "HasChildren" property
		UPDATE LOCATION
		SET HAS_CHILDREN = 1
		WHERE LOCATION_ID IN
		(
			SELECT PARENT_ID FROM LOCATION
			WHERE STATUS = 0 AND PARENT_ID IS NOT NULL AND PARENT_ID = @ParentId
			GROUP BY PARENT_ID
		)
	end
	
	--Insert locaiton for all internal companies
	IF @LocationId is not null and @IcCompanyCodes IS NOT NULL
	BEGIN
				 
		DECLARE @pos INT
		DECLARE @len INT
		DECLARE @value NVARCHAR(50)
		
		SET @pos = 0
		SET @len = 0
		SET @IcCompanyCodes = @IcCompanyCodes + ','
		
		WHILE CHARINDEX(',', @IcCompanyCodes, @pos+1)>0
		BEGIN
			SET @len = CHARINDEX(',', @IcCompanyCodes, @pos+1) - @pos
			SET @value = SUBSTRING(@IcCompanyCodes, @pos, @len)

			DECLARE @icId INT;
			SELECT @icId = COMPANY_ID from [dbo].[COMPANY] WHERE [CODE] = @value;
			
			--Check if the company exists
			IF (@icId is null)
			BEGIN
				;select @errMsg = 'Company with code ' + @value +' does not exist. Could not insert location.'
				;THROW 51000, @errMsg, 1;
			END

			--insert ic (if not exists) to location and recursively to all its parents 
			;WITH Loc(LOCATION_ID, PARENT_ID) AS	(
				select LOCATION_ID, PARENT_ID from LOCATION where LOCATION_ID = @LocationId
					union all
				select l.LOCATION_ID, l.PARENT_ID from LOCATION l join Loc on Loc.PARENT_ID = l.LOCATION_ID
			)
			INSERT INTO [dbo].[LOCATION_INTERNAL_COMPANY]
				([LOCATION_ID]
				,[INTERNAL_COMPANY_ID])
			SELECT
				LOCATION_ID, @icId
			from Loc
			WHERE NOT EXISTS (
				select * from LOCATION_INTERNAL_COMPANY WHERE
				LOCATION_ID = Loc.LOCATION_ID and INTERNAL_COMPANY_ID = @icId
			)				
				
			SET @pos = CHARINDEX(',', @IcCompanyCodes, @pos+@len) + 1

		END		
		
	END	

END
go

set nocount on

exec MakeLocation 'R2JA','A','R2J','IC_VMHZP'
exec MakeLocation 'R2JB','B','R2J','IC_VMHZP'
exec MakeLocation 'R2JC','C','R2J','IC_VMHZP'
exec MakeLocation 'R2JD','D','R2J','IC_VMHZP'
exec MakeLocation 'R2JE','E','R2J','IC_VMHZP'
exec MakeLocation 'R2JF','F','R2J','IC_VMHZP'
exec MakeLocation 'R2JG','G','R2J','IC_VMHZP'
exec MakeLocation 'R2JH','H','R2J','IC_VMHZP'
exec MakeLocation 'R2JI','I','R2J','IC_VMHZP'
exec MakeLocation 'R2JJ','J','R2J','IC_VMHZP'
exec MakeLocation 'R2JK','K','R2J','IC_VMHZP'
exec MakeLocation 'R2JL','L','R2J','IC_VMHZP'
exec MakeLocation 'R2JM','M','R2J','IC_VMHZP'
exec MakeLocation 'R2JN','N','R2J','IC_VMHZP'
exec MakeLocation 'R2JO','O','R2J','IC_VMHZP'
exec MakeLocation 'R2JP','P','R2J','IC_VMHZP'
exec MakeLocation 'R2JQ','Q','R2J','IC_VMHZP'
exec MakeLocation 'R2JR','R','R2J','IC_VMHZP'
exec MakeLocation 'R2JS','S','R2J','IC_VMHZP'
exec MakeLocation 'R2JT','T','R2J','IC_VMHZP'

exec MakeLocation 'R2JA1','1','R2JA','IC_VMHZP'
exec MakeLocation 'R2JA2','2','R2JA','IC_VMHZP'
exec MakeLocation 'R2JA3','3','R2JA','IC_VMHZP'
exec MakeLocation 'R2JA4','4','R2JA','IC_VMHZP'
exec MakeLocation 'R2JA5','5','R2JA','IC_VMHZP'
exec MakeLocation 'R2JB1','1','R2JB','IC_VMHZP'
exec MakeLocation 'R2JB2','2','R2JB','IC_VMHZP'
exec MakeLocation 'R2JB3','3','R2JB','IC_VMHZP'
exec MakeLocation 'R2JB4','4','R2JB','IC_VMHZP'
exec MakeLocation 'R2JB5','5','R2JB','IC_VMHZP'
exec MakeLocation 'R2JC1','1','R2JC','IC_VMHZP'
exec MakeLocation 'R2JC2','2','R2JC','IC_VMHZP'
exec MakeLocation 'R2JC3','3','R2JC','IC_VMHZP'
exec MakeLocation 'R2JC4','4','R2JC','IC_VMHZP'
exec MakeLocation 'R2JC5','5','R2JC','IC_VMHZP'
exec MakeLocation 'R2JD1','1','R2JD','IC_VMHZP'
exec MakeLocation 'R2JD2','2','R2JD','IC_VMHZP'
exec MakeLocation 'R2JD3','3','R2JD','IC_VMHZP'
exec MakeLocation 'R2JD4','4','R2JD','IC_VMHZP'
exec MakeLocation 'R2JD5','5','R2JD','IC_VMHZP'
exec MakeLocation 'R2JE1','1','R2JE','IC_VMHZP'
exec MakeLocation 'R2JE2','2','R2JE','IC_VMHZP'
exec MakeLocation 'R2JE3','3','R2JE','IC_VMHZP'
exec MakeLocation 'R2JE4','4','R2JE','IC_VMHZP'
exec MakeLocation 'R2JE5','5','R2JE','IC_VMHZP'
exec MakeLocation 'R2JF1','1','R2JF','IC_VMHZP'
exec MakeLocation 'R2JF2','2','R2JF','IC_VMHZP'
exec MakeLocation 'R2JF3','3','R2JF','IC_VMHZP'
exec MakeLocation 'R2JF4','4','R2JF','IC_VMHZP'
exec MakeLocation 'R2JF5','5','R2JF','IC_VMHZP'
exec MakeLocation 'R2JG1','1','R2JG','IC_VMHZP'
exec MakeLocation 'R2JG2','2','R2JG','IC_VMHZP'
exec MakeLocation 'R2JG3','3','R2JG','IC_VMHZP'
exec MakeLocation 'R2JG4','4','R2JG','IC_VMHZP'
exec MakeLocation 'R2JG5','5','R2JG','IC_VMHZP'
exec MakeLocation 'R2JH1','1','R2JH','IC_VMHZP'
exec MakeLocation 'R2JH2','2','R2JH','IC_VMHZP'
exec MakeLocation 'R2JH3','3','R2JH','IC_VMHZP'
exec MakeLocation 'R2JH4','4','R2JH','IC_VMHZP'
exec MakeLocation 'R2JH5','5','R2JH','IC_VMHZP'
exec MakeLocation 'R2JI1','1','R2JI','IC_VMHZP'
exec MakeLocation 'R2JI2','2','R2JI','IC_VMHZP'
exec MakeLocation 'R2JI3','3','R2JI','IC_VMHZP'
exec MakeLocation 'R2JI4','4','R2JI','IC_VMHZP'
exec MakeLocation 'R2JI5','5','R2JI','IC_VMHZP'
exec MakeLocation 'R2JJ1','1','R2JJ','IC_VMHZP'
exec MakeLocation 'R2JJ2','2','R2JJ','IC_VMHZP'
exec MakeLocation 'R2JJ3','3','R2JJ','IC_VMHZP'
exec MakeLocation 'R2JJ4','4','R2JJ','IC_VMHZP'
exec MakeLocation 'R2JJ5','5','R2JJ','IC_VMHZP'
exec MakeLocation 'R2JK1','1','R2JK','IC_VMHZP'
exec MakeLocation 'R2JK2','2','R2JK','IC_VMHZP'
exec MakeLocation 'R2JK3','3','R2JK','IC_VMHZP'
exec MakeLocation 'R2JK4','4','R2JK','IC_VMHZP'
exec MakeLocation 'R2JK5','5','R2JK','IC_VMHZP'
exec MakeLocation 'R2JL1','1','R2JL','IC_VMHZP'
exec MakeLocation 'R2JL2','2','R2JL','IC_VMHZP'
exec MakeLocation 'R2JL3','3','R2JL','IC_VMHZP'
exec MakeLocation 'R2JL4','4','R2JL','IC_VMHZP'
exec MakeLocation 'R2JL5','5','R2JL','IC_VMHZP'
exec MakeLocation 'R2JM1','1','R2JM','IC_VMHZP'
exec MakeLocation 'R2JM2','2','R2JM','IC_VMHZP'
exec MakeLocation 'R2JM3','3','R2JM','IC_VMHZP'
exec MakeLocation 'R2JM4','4','R2JM','IC_VMHZP'
exec MakeLocation 'R2JM5','5','R2JM','IC_VMHZP'
exec MakeLocation 'R2JN1','1','R2JN','IC_VMHZP'
exec MakeLocation 'R2JN2','2','R2JN','IC_VMHZP'
exec MakeLocation 'R2JN3','3','R2JN','IC_VMHZP'
exec MakeLocation 'R2JN4','4','R2JN','IC_VMHZP'
exec MakeLocation 'R2JN5','5','R2JN','IC_VMHZP'
exec MakeLocation 'R2JO1','1','R2JO','IC_VMHZP'
exec MakeLocation 'R2JO2','2','R2JO','IC_VMHZP'
exec MakeLocation 'R2JO3','3','R2JO','IC_VMHZP'
exec MakeLocation 'R2JO4','4','R2JO','IC_VMHZP'
exec MakeLocation 'R2JO5','5','R2JO','IC_VMHZP'
exec MakeLocation 'R2JP1','1','R2JP','IC_VMHZP'
exec MakeLocation 'R2JP2','2','R2JP','IC_VMHZP'
exec MakeLocation 'R2JP3','3','R2JP','IC_VMHZP'
exec MakeLocation 'R2JP4','4','R2JP','IC_VMHZP'
exec MakeLocation 'R2JP5','5','R2JP','IC_VMHZP'
exec MakeLocation 'R2JQ1','1','R2JQ','IC_VMHZP'
exec MakeLocation 'R2JQ2','2','R2JQ','IC_VMHZP'
exec MakeLocation 'R2JQ3','3','R2JQ','IC_VMHZP'
exec MakeLocation 'R2JQ4','4','R2JQ','IC_VMHZP'
exec MakeLocation 'R2JQ5','5','R2JQ','IC_VMHZP'
exec MakeLocation 'R2JR1','1','R2JR','IC_VMHZP'
exec MakeLocation 'R2JR2','2','R2JR','IC_VMHZP'
exec MakeLocation 'R2JR3','3','R2JR','IC_VMHZP'
exec MakeLocation 'R2JR4','4','R2JR','IC_VMHZP'
exec MakeLocation 'R2JR5','5','R2JR','IC_VMHZP'
exec MakeLocation 'R2JS1','1','R2JS','IC_VMHZP'
exec MakeLocation 'R2JS2','2','R2JS','IC_VMHZP'
exec MakeLocation 'R2JS3','3','R2JS','IC_VMHZP'
exec MakeLocation 'R2JS4','4','R2JS','IC_VMHZP'
exec MakeLocation 'R2JS5','5','R2JS','IC_VMHZP'
exec MakeLocation 'R2JT1','1','R2JT','IC_VMHZP'
exec MakeLocation 'R2JT2','2','R2JT','IC_VMHZP'
exec MakeLocation 'R2JT3','3','R2JT','IC_VMHZP'
exec MakeLocation 'R2JT4','4','R2JT','IC_VMHZP'
exec MakeLocation 'R2JT5','5','R2JT','IC_VMHZP'

exec MakeLocation 'R2JA101','01','R2JA1','IC_VMHZP'
exec MakeLocation 'R2JA102','02','R2JA1','IC_VMHZP'
exec MakeLocation 'R2JA103','03','R2JA1','IC_VMHZP'
exec MakeLocation 'R2JA104','04','R2JA1','IC_VMHZP'
exec MakeLocation 'R2JA201','01','R2JA2','IC_VMHZP'
exec MakeLocation 'R2JA202','02','R2JA2','IC_VMHZP'
exec MakeLocation 'R2JA203','03','R2JA2','IC_VMHZP'
exec MakeLocation 'R2JA204','04','R2JA2','IC_VMHZP'
exec MakeLocation 'R2JA301','01','R2JA3','IC_VMHZP'
exec MakeLocation 'R2JA302','02','R2JA3','IC_VMHZP'
exec MakeLocation 'R2JA303','03','R2JA3','IC_VMHZP'
exec MakeLocation 'R2JA304','04','R2JA3','IC_VMHZP'
exec MakeLocation 'R2JA401','01','R2JA4','IC_VMHZP'
exec MakeLocation 'R2JA402','02','R2JA4','IC_VMHZP'
exec MakeLocation 'R2JA403','03','R2JA4','IC_VMHZP'
exec MakeLocation 'R2JA404','04','R2JA4','IC_VMHZP'
exec MakeLocation 'R2JA501','01','R2JA5','IC_VMHZP'
exec MakeLocation 'R2JA502','02','R2JA5','IC_VMHZP'
exec MakeLocation 'R2JA503','03','R2JA5','IC_VMHZP'
exec MakeLocation 'R2JA504','04','R2JA5','IC_VMHZP'
exec MakeLocation 'R2JB101','01','R2JB1','IC_VMHZP'
exec MakeLocation 'R2JB102','02','R2JB1','IC_VMHZP'
exec MakeLocation 'R2JB103','03','R2JB1','IC_VMHZP'
exec MakeLocation 'R2JB104','04','R2JB1','IC_VMHZP'
exec MakeLocation 'R2JB201','01','R2JB2','IC_VMHZP'
exec MakeLocation 'R2JB202','02','R2JB2','IC_VMHZP'
exec MakeLocation 'R2JB203','03','R2JB2','IC_VMHZP'
exec MakeLocation 'R2JB204','04','R2JB2','IC_VMHZP'
exec MakeLocation 'R2JB301','01','R2JB3','IC_VMHZP'
exec MakeLocation 'R2JB302','02','R2JB3','IC_VMHZP'
exec MakeLocation 'R2JB303','03','R2JB3','IC_VMHZP'
exec MakeLocation 'R2JB304','04','R2JB3','IC_VMHZP'
exec MakeLocation 'R2JB401','01','R2JB4','IC_VMHZP'
exec MakeLocation 'R2JB402','02','R2JB4','IC_VMHZP'
exec MakeLocation 'R2JB403','03','R2JB4','IC_VMHZP'
exec MakeLocation 'R2JB404','04','R2JB4','IC_VMHZP'
exec MakeLocation 'R2JB501','01','R2JB5','IC_VMHZP'
exec MakeLocation 'R2JB502','02','R2JB5','IC_VMHZP'
exec MakeLocation 'R2JB503','03','R2JB5','IC_VMHZP'
exec MakeLocation 'R2JB504','04','R2JB5','IC_VMHZP'
exec MakeLocation 'R2JC101','01','R2JC1','IC_VMHZP'
exec MakeLocation 'R2JC102','02','R2JC1','IC_VMHZP'
exec MakeLocation 'R2JC103','03','R2JC1','IC_VMHZP'
exec MakeLocation 'R2JC104','04','R2JC1','IC_VMHZP'
exec MakeLocation 'R2JC201','01','R2JC2','IC_VMHZP'
exec MakeLocation 'R2JC202','02','R2JC2','IC_VMHZP'
exec MakeLocation 'R2JC203','03','R2JC2','IC_VMHZP'
exec MakeLocation 'R2JC204','04','R2JC2','IC_VMHZP'
exec MakeLocation 'R2JC301','01','R2JC3','IC_VMHZP'
exec MakeLocation 'R2JC302','02','R2JC3','IC_VMHZP'
exec MakeLocation 'R2JC303','03','R2JC3','IC_VMHZP'
exec MakeLocation 'R2JC304','04','R2JC3','IC_VMHZP'
exec MakeLocation 'R2JC401','01','R2JC4','IC_VMHZP'
exec MakeLocation 'R2JC402','02','R2JC4','IC_VMHZP'
exec MakeLocation 'R2JC403','03','R2JC4','IC_VMHZP'
exec MakeLocation 'R2JC404','04','R2JC4','IC_VMHZP'
exec MakeLocation 'R2JC501','01','R2JC5','IC_VMHZP'
exec MakeLocation 'R2JC502','02','R2JC5','IC_VMHZP'
exec MakeLocation 'R2JC503','03','R2JC5','IC_VMHZP'
exec MakeLocation 'R2JC504','04','R2JC5','IC_VMHZP'
exec MakeLocation 'R2JD101','01','R2JD1','IC_VMHZP'
exec MakeLocation 'R2JD102','02','R2JD1','IC_VMHZP'
exec MakeLocation 'R2JD103','03','R2JD1','IC_VMHZP'
exec MakeLocation 'R2JD104','04','R2JD1','IC_VMHZP'
exec MakeLocation 'R2JD201','01','R2JD2','IC_VMHZP'
exec MakeLocation 'R2JD202','02','R2JD2','IC_VMHZP'
exec MakeLocation 'R2JD203','03','R2JD2','IC_VMHZP'
exec MakeLocation 'R2JD204','04','R2JD2','IC_VMHZP'
exec MakeLocation 'R2JD301','01','R2JD3','IC_VMHZP'
exec MakeLocation 'R2JD302','02','R2JD3','IC_VMHZP'
exec MakeLocation 'R2JD303','03','R2JD3','IC_VMHZP'
exec MakeLocation 'R2JD304','04','R2JD3','IC_VMHZP'
exec MakeLocation 'R2JD401','01','R2JD4','IC_VMHZP'
exec MakeLocation 'R2JD402','02','R2JD4','IC_VMHZP'
exec MakeLocation 'R2JD403','03','R2JD4','IC_VMHZP'
exec MakeLocation 'R2JD404','04','R2JD4','IC_VMHZP'
exec MakeLocation 'R2JD501','01','R2JD5','IC_VMHZP'
exec MakeLocation 'R2JD502','02','R2JD5','IC_VMHZP'
exec MakeLocation 'R2JD503','03','R2JD5','IC_VMHZP'
exec MakeLocation 'R2JD504','04','R2JD5','IC_VMHZP'
exec MakeLocation 'R2JE101','01','R2JE1','IC_VMHZP'
exec MakeLocation 'R2JE102','02','R2JE1','IC_VMHZP'
exec MakeLocation 'R2JE103','03','R2JE1','IC_VMHZP'
exec MakeLocation 'R2JE104','04','R2JE1','IC_VMHZP'
exec MakeLocation 'R2JE201','01','R2JE2','IC_VMHZP'
exec MakeLocation 'R2JE202','02','R2JE2','IC_VMHZP'
exec MakeLocation 'R2JE203','03','R2JE2','IC_VMHZP'
exec MakeLocation 'R2JE204','04','R2JE2','IC_VMHZP'
exec MakeLocation 'R2JE301','01','R2JE3','IC_VMHZP'
exec MakeLocation 'R2JE302','02','R2JE3','IC_VMHZP'
exec MakeLocation 'R2JE303','03','R2JE3','IC_VMHZP'
exec MakeLocation 'R2JE304','04','R2JE3','IC_VMHZP'
exec MakeLocation 'R2JE401','01','R2JE4','IC_VMHZP'
exec MakeLocation 'R2JE402','02','R2JE4','IC_VMHZP'
exec MakeLocation 'R2JE403','03','R2JE4','IC_VMHZP'
exec MakeLocation 'R2JE404','04','R2JE4','IC_VMHZP'
exec MakeLocation 'R2JE501','01','R2JE5','IC_VMHZP'
exec MakeLocation 'R2JE502','02','R2JE5','IC_VMHZP'
exec MakeLocation 'R2JE503','03','R2JE5','IC_VMHZP'
exec MakeLocation 'R2JE504','04','R2JE5','IC_VMHZP'
exec MakeLocation 'R2JF101','01','R2JF1','IC_VMHZP'
exec MakeLocation 'R2JF102','02','R2JF1','IC_VMHZP'
exec MakeLocation 'R2JF103','03','R2JF1','IC_VMHZP'
exec MakeLocation 'R2JF104','04','R2JF1','IC_VMHZP'
exec MakeLocation 'R2JF201','01','R2JF2','IC_VMHZP'
exec MakeLocation 'R2JF202','02','R2JF2','IC_VMHZP'
exec MakeLocation 'R2JF203','03','R2JF2','IC_VMHZP'
exec MakeLocation 'R2JF204','04','R2JF2','IC_VMHZP'
exec MakeLocation 'R2JF301','01','R2JF3','IC_VMHZP'
exec MakeLocation 'R2JF302','02','R2JF3','IC_VMHZP'
exec MakeLocation 'R2JF303','03','R2JF3','IC_VMHZP'
exec MakeLocation 'R2JF304','04','R2JF3','IC_VMHZP'
exec MakeLocation 'R2JF401','01','R2JF4','IC_VMHZP'
exec MakeLocation 'R2JF402','02','R2JF4','IC_VMHZP'
exec MakeLocation 'R2JF403','03','R2JF4','IC_VMHZP'
exec MakeLocation 'R2JF404','04','R2JF4','IC_VMHZP'
exec MakeLocation 'R2JF501','01','R2JF5','IC_VMHZP'
exec MakeLocation 'R2JF502','02','R2JF5','IC_VMHZP'
exec MakeLocation 'R2JF503','03','R2JF5','IC_VMHZP'
exec MakeLocation 'R2JF504','04','R2JF5','IC_VMHZP'
exec MakeLocation 'R2JG101','01','R2JG1','IC_VMHZP'
exec MakeLocation 'R2JG102','02','R2JG1','IC_VMHZP'
exec MakeLocation 'R2JG103','03','R2JG1','IC_VMHZP'
exec MakeLocation 'R2JG104','04','R2JG1','IC_VMHZP'
exec MakeLocation 'R2JG201','01','R2JG2','IC_VMHZP'
exec MakeLocation 'R2JG202','02','R2JG2','IC_VMHZP'
exec MakeLocation 'R2JG203','03','R2JG2','IC_VMHZP'
exec MakeLocation 'R2JG204','04','R2JG2','IC_VMHZP'
exec MakeLocation 'R2JG301','01','R2JG3','IC_VMHZP'
exec MakeLocation 'R2JG302','02','R2JG3','IC_VMHZP'
exec MakeLocation 'R2JG303','03','R2JG3','IC_VMHZP'
exec MakeLocation 'R2JG304','04','R2JG3','IC_VMHZP'
exec MakeLocation 'R2JG401','01','R2JG4','IC_VMHZP'
exec MakeLocation 'R2JG402','02','R2JG4','IC_VMHZP'
exec MakeLocation 'R2JG403','03','R2JG4','IC_VMHZP'
exec MakeLocation 'R2JG404','04','R2JG4','IC_VMHZP'
exec MakeLocation 'R2JG501','01','R2JG5','IC_VMHZP'
exec MakeLocation 'R2JG502','02','R2JG5','IC_VMHZP'
exec MakeLocation 'R2JG503','03','R2JG5','IC_VMHZP'
exec MakeLocation 'R2JG504','04','R2JG5','IC_VMHZP'
exec MakeLocation 'R2JH101','01','R2JH1','IC_VMHZP'
exec MakeLocation 'R2JH102','02','R2JH1','IC_VMHZP'
exec MakeLocation 'R2JH103','03','R2JH1','IC_VMHZP'
exec MakeLocation 'R2JH104','04','R2JH1','IC_VMHZP'
exec MakeLocation 'R2JH201','01','R2JH2','IC_VMHZP'
exec MakeLocation 'R2JH202','02','R2JH2','IC_VMHZP'
exec MakeLocation 'R2JH203','03','R2JH2','IC_VMHZP'
exec MakeLocation 'R2JH204','04','R2JH2','IC_VMHZP'
exec MakeLocation 'R2JH301','01','R2JH3','IC_VMHZP'
exec MakeLocation 'R2JH302','02','R2JH3','IC_VMHZP'
exec MakeLocation 'R2JH303','03','R2JH3','IC_VMHZP'
exec MakeLocation 'R2JH304','04','R2JH3','IC_VMHZP'
exec MakeLocation 'R2JH401','01','R2JH4','IC_VMHZP'
exec MakeLocation 'R2JH402','02','R2JH4','IC_VMHZP'
exec MakeLocation 'R2JH403','03','R2JH4','IC_VMHZP'
exec MakeLocation 'R2JH404','04','R2JH4','IC_VMHZP'
exec MakeLocation 'R2JH501','01','R2JH5','IC_VMHZP'
exec MakeLocation 'R2JH502','02','R2JH5','IC_VMHZP'
exec MakeLocation 'R2JH503','03','R2JH5','IC_VMHZP'
exec MakeLocation 'R2JH504','04','R2JH5','IC_VMHZP'
exec MakeLocation 'R2JI101','01','R2JI1','IC_VMHZP'
exec MakeLocation 'R2JI102','02','R2JI1','IC_VMHZP'
exec MakeLocation 'R2JI103','03','R2JI1','IC_VMHZP'
exec MakeLocation 'R2JI104','04','R2JI1','IC_VMHZP'
exec MakeLocation 'R2JI201','01','R2JI2','IC_VMHZP'
exec MakeLocation 'R2JI202','02','R2JI2','IC_VMHZP'
exec MakeLocation 'R2JI203','03','R2JI2','IC_VMHZP'
exec MakeLocation 'R2JI204','04','R2JI2','IC_VMHZP'
exec MakeLocation 'R2JI301','01','R2JI3','IC_VMHZP'
exec MakeLocation 'R2JI302','02','R2JI3','IC_VMHZP'
exec MakeLocation 'R2JI303','03','R2JI3','IC_VMHZP'
exec MakeLocation 'R2JI304','04','R2JI3','IC_VMHZP'
exec MakeLocation 'R2JI401','01','R2JI4','IC_VMHZP'
exec MakeLocation 'R2JI402','02','R2JI4','IC_VMHZP'
exec MakeLocation 'R2JI403','03','R2JI4','IC_VMHZP'
exec MakeLocation 'R2JI404','04','R2JI4','IC_VMHZP'
exec MakeLocation 'R2JI501','01','R2JI5','IC_VMHZP'
exec MakeLocation 'R2JI502','02','R2JI5','IC_VMHZP'
exec MakeLocation 'R2JI503','03','R2JI5','IC_VMHZP'
exec MakeLocation 'R2JI504','04','R2JI5','IC_VMHZP'
exec MakeLocation 'R2JJ101','01','R2JJ1','IC_VMHZP'
exec MakeLocation 'R2JJ102','02','R2JJ1','IC_VMHZP'
exec MakeLocation 'R2JJ103','03','R2JJ1','IC_VMHZP'
exec MakeLocation 'R2JJ104','04','R2JJ1','IC_VMHZP'
exec MakeLocation 'R2JJ201','01','R2JJ2','IC_VMHZP'
exec MakeLocation 'R2JJ202','02','R2JJ2','IC_VMHZP'
exec MakeLocation 'R2JJ203','03','R2JJ2','IC_VMHZP'
exec MakeLocation 'R2JJ204','04','R2JJ2','IC_VMHZP'
exec MakeLocation 'R2JJ301','01','R2JJ3','IC_VMHZP'
exec MakeLocation 'R2JJ302','02','R2JJ3','IC_VMHZP'
exec MakeLocation 'R2JJ303','03','R2JJ3','IC_VMHZP'
exec MakeLocation 'R2JJ304','04','R2JJ3','IC_VMHZP'
exec MakeLocation 'R2JJ401','01','R2JJ4','IC_VMHZP'
exec MakeLocation 'R2JJ402','02','R2JJ4','IC_VMHZP'
exec MakeLocation 'R2JJ403','03','R2JJ4','IC_VMHZP'
exec MakeLocation 'R2JJ404','04','R2JJ4','IC_VMHZP'
exec MakeLocation 'R2JJ501','01','R2JJ5','IC_VMHZP'
exec MakeLocation 'R2JJ502','02','R2JJ5','IC_VMHZP'
exec MakeLocation 'R2JJ503','03','R2JJ5','IC_VMHZP'
exec MakeLocation 'R2JJ504','04','R2JJ5','IC_VMHZP'
exec MakeLocation 'R2JK101','01','R2JK1','IC_VMHZP'
exec MakeLocation 'R2JK102','02','R2JK1','IC_VMHZP'
exec MakeLocation 'R2JK103','03','R2JK1','IC_VMHZP'
exec MakeLocation 'R2JK104','04','R2JK1','IC_VMHZP'
exec MakeLocation 'R2JK201','01','R2JK2','IC_VMHZP'
exec MakeLocation 'R2JK202','02','R2JK2','IC_VMHZP'
exec MakeLocation 'R2JK203','03','R2JK2','IC_VMHZP'
exec MakeLocation 'R2JK204','04','R2JK2','IC_VMHZP'
exec MakeLocation 'R2JK301','01','R2JK3','IC_VMHZP'
exec MakeLocation 'R2JK302','02','R2JK3','IC_VMHZP'
exec MakeLocation 'R2JK303','03','R2JK3','IC_VMHZP'
exec MakeLocation 'R2JK304','04','R2JK3','IC_VMHZP'
exec MakeLocation 'R2JK401','01','R2JK4','IC_VMHZP'
exec MakeLocation 'R2JK402','02','R2JK4','IC_VMHZP'
exec MakeLocation 'R2JK403','03','R2JK4','IC_VMHZP'
exec MakeLocation 'R2JK404','04','R2JK4','IC_VMHZP'
exec MakeLocation 'R2JK501','01','R2JK5','IC_VMHZP'
exec MakeLocation 'R2JK502','02','R2JK5','IC_VMHZP'
exec MakeLocation 'R2JK503','03','R2JK5','IC_VMHZP'
exec MakeLocation 'R2JK504','04','R2JK5','IC_VMHZP'
exec MakeLocation 'R2JL101','01','R2JL1','IC_VMHZP'
exec MakeLocation 'R2JL102','02','R2JL1','IC_VMHZP'
exec MakeLocation 'R2JL103','03','R2JL1','IC_VMHZP'
exec MakeLocation 'R2JL104','04','R2JL1','IC_VMHZP'
exec MakeLocation 'R2JL201','01','R2JL2','IC_VMHZP'
exec MakeLocation 'R2JL202','02','R2JL2','IC_VMHZP'
exec MakeLocation 'R2JL203','03','R2JL2','IC_VMHZP'
exec MakeLocation 'R2JL204','04','R2JL2','IC_VMHZP'
exec MakeLocation 'R2JL301','01','R2JL3','IC_VMHZP'
exec MakeLocation 'R2JL302','02','R2JL3','IC_VMHZP'
exec MakeLocation 'R2JL303','03','R2JL3','IC_VMHZP'
exec MakeLocation 'R2JL304','04','R2JL3','IC_VMHZP'
exec MakeLocation 'R2JL401','01','R2JL4','IC_VMHZP'
exec MakeLocation 'R2JL402','02','R2JL4','IC_VMHZP'
exec MakeLocation 'R2JL403','03','R2JL4','IC_VMHZP'
exec MakeLocation 'R2JL404','04','R2JL4','IC_VMHZP'
exec MakeLocation 'R2JL501','01','R2JL5','IC_VMHZP'
exec MakeLocation 'R2JL502','02','R2JL5','IC_VMHZP'
exec MakeLocation 'R2JL503','03','R2JL5','IC_VMHZP'
exec MakeLocation 'R2JL504','04','R2JL5','IC_VMHZP'
exec MakeLocation 'R2JM101','01','R2JM1','IC_VMHZP'
exec MakeLocation 'R2JM102','02','R2JM1','IC_VMHZP'
exec MakeLocation 'R2JM103','03','R2JM1','IC_VMHZP'
exec MakeLocation 'R2JM104','04','R2JM1','IC_VMHZP'
exec MakeLocation 'R2JM201','01','R2JM2','IC_VMHZP'
exec MakeLocation 'R2JM202','02','R2JM2','IC_VMHZP'
exec MakeLocation 'R2JM203','03','R2JM2','IC_VMHZP'
exec MakeLocation 'R2JM204','04','R2JM2','IC_VMHZP'
exec MakeLocation 'R2JM301','01','R2JM3','IC_VMHZP'
exec MakeLocation 'R2JM302','02','R2JM3','IC_VMHZP'
exec MakeLocation 'R2JM303','03','R2JM3','IC_VMHZP'
exec MakeLocation 'R2JM304','04','R2JM3','IC_VMHZP'
exec MakeLocation 'R2JM401','01','R2JM4','IC_VMHZP'
exec MakeLocation 'R2JM402','02','R2JM4','IC_VMHZP'
exec MakeLocation 'R2JM403','03','R2JM4','IC_VMHZP'
exec MakeLocation 'R2JM404','04','R2JM4','IC_VMHZP'
exec MakeLocation 'R2JM501','01','R2JM5','IC_VMHZP'
exec MakeLocation 'R2JM502','02','R2JM5','IC_VMHZP'
exec MakeLocation 'R2JM503','03','R2JM5','IC_VMHZP'
exec MakeLocation 'R2JM504','04','R2JM5','IC_VMHZP'
exec MakeLocation 'R2JN101','01','R2JN1','IC_VMHZP'
exec MakeLocation 'R2JN102','02','R2JN1','IC_VMHZP'
exec MakeLocation 'R2JN103','03','R2JN1','IC_VMHZP'
exec MakeLocation 'R2JN104','04','R2JN1','IC_VMHZP'
exec MakeLocation 'R2JN201','01','R2JN2','IC_VMHZP'
exec MakeLocation 'R2JN202','02','R2JN2','IC_VMHZP'
exec MakeLocation 'R2JN203','03','R2JN2','IC_VMHZP'
exec MakeLocation 'R2JN204','04','R2JN2','IC_VMHZP'
exec MakeLocation 'R2JN301','01','R2JN3','IC_VMHZP'
exec MakeLocation 'R2JN302','02','R2JN3','IC_VMHZP'
exec MakeLocation 'R2JN303','03','R2JN3','IC_VMHZP'
exec MakeLocation 'R2JN304','04','R2JN3','IC_VMHZP'
exec MakeLocation 'R2JN401','01','R2JN4','IC_VMHZP'
exec MakeLocation 'R2JN402','02','R2JN4','IC_VMHZP'
exec MakeLocation 'R2JN403','03','R2JN4','IC_VMHZP'
exec MakeLocation 'R2JN404','04','R2JN4','IC_VMHZP'
exec MakeLocation 'R2JN501','01','R2JN5','IC_VMHZP'
exec MakeLocation 'R2JN502','02','R2JN5','IC_VMHZP'
exec MakeLocation 'R2JN503','03','R2JN5','IC_VMHZP'
exec MakeLocation 'R2JN504','04','R2JN5','IC_VMHZP'
exec MakeLocation 'R2JO101','01','R2JO1','IC_VMHZP'
exec MakeLocation 'R2JO102','02','R2JO1','IC_VMHZP'
exec MakeLocation 'R2JO103','03','R2JO1','IC_VMHZP'
exec MakeLocation 'R2JO104','04','R2JO1','IC_VMHZP'
exec MakeLocation 'R2JO201','01','R2JO2','IC_VMHZP'
exec MakeLocation 'R2JO202','02','R2JO2','IC_VMHZP'
exec MakeLocation 'R2JO203','03','R2JO2','IC_VMHZP'
exec MakeLocation 'R2JO204','04','R2JO2','IC_VMHZP'
exec MakeLocation 'R2JO301','01','R2JO3','IC_VMHZP'
exec MakeLocation 'R2JO302','02','R2JO3','IC_VMHZP'
exec MakeLocation 'R2JO303','03','R2JO3','IC_VMHZP'
exec MakeLocation 'R2JO304','04','R2JO3','IC_VMHZP'
exec MakeLocation 'R2JO401','01','R2JO4','IC_VMHZP'
exec MakeLocation 'R2JO402','02','R2JO4','IC_VMHZP'
exec MakeLocation 'R2JO403','03','R2JO4','IC_VMHZP'
exec MakeLocation 'R2JO404','04','R2JO4','IC_VMHZP'
exec MakeLocation 'R2JO501','01','R2JO5','IC_VMHZP'
exec MakeLocation 'R2JO502','02','R2JO5','IC_VMHZP'
exec MakeLocation 'R2JO503','03','R2JO5','IC_VMHZP'
exec MakeLocation 'R2JO504','04','R2JO5','IC_VMHZP'
exec MakeLocation 'R2JP101','01','R2JP1','IC_VMHZP'
exec MakeLocation 'R2JP102','02','R2JP1','IC_VMHZP'
exec MakeLocation 'R2JP103','03','R2JP1','IC_VMHZP'
exec MakeLocation 'R2JP104','04','R2JP1','IC_VMHZP'
exec MakeLocation 'R2JP201','01','R2JP2','IC_VMHZP'
exec MakeLocation 'R2JP202','02','R2JP2','IC_VMHZP'
exec MakeLocation 'R2JP203','03','R2JP2','IC_VMHZP'
exec MakeLocation 'R2JP204','04','R2JP2','IC_VMHZP'
exec MakeLocation 'R2JP301','01','R2JP3','IC_VMHZP'
exec MakeLocation 'R2JP302','02','R2JP3','IC_VMHZP'
exec MakeLocation 'R2JP303','03','R2JP3','IC_VMHZP'
exec MakeLocation 'R2JP304','04','R2JP3','IC_VMHZP'
exec MakeLocation 'R2JP401','01','R2JP4','IC_VMHZP'
exec MakeLocation 'R2JP402','02','R2JP4','IC_VMHZP'
exec MakeLocation 'R2JP403','03','R2JP4','IC_VMHZP'
exec MakeLocation 'R2JP404','04','R2JP4','IC_VMHZP'
exec MakeLocation 'R2JP501','01','R2JP5','IC_VMHZP'
exec MakeLocation 'R2JP502','02','R2JP5','IC_VMHZP'
exec MakeLocation 'R2JP503','03','R2JP5','IC_VMHZP'
exec MakeLocation 'R2JP504','04','R2JP5','IC_VMHZP'
exec MakeLocation 'R2JQ101','01','R2JQ1','IC_VMHZP'
exec MakeLocation 'R2JQ102','02','R2JQ1','IC_VMHZP'
exec MakeLocation 'R2JQ103','03','R2JQ1','IC_VMHZP'
exec MakeLocation 'R2JQ104','04','R2JQ1','IC_VMHZP'
exec MakeLocation 'R2JQ201','01','R2JQ2','IC_VMHZP'
exec MakeLocation 'R2JQ202','02','R2JQ2','IC_VMHZP'
exec MakeLocation 'R2JQ203','03','R2JQ2','IC_VMHZP'
exec MakeLocation 'R2JQ204','04','R2JQ2','IC_VMHZP'
exec MakeLocation 'R2JQ301','01','R2JQ3','IC_VMHZP'
exec MakeLocation 'R2JQ302','02','R2JQ3','IC_VMHZP'
exec MakeLocation 'R2JQ303','03','R2JQ3','IC_VMHZP'
exec MakeLocation 'R2JQ304','04','R2JQ3','IC_VMHZP'
exec MakeLocation 'R2JQ401','01','R2JQ4','IC_VMHZP'
exec MakeLocation 'R2JQ402','02','R2JQ4','IC_VMHZP'
exec MakeLocation 'R2JQ403','03','R2JQ4','IC_VMHZP'
exec MakeLocation 'R2JQ404','04','R2JQ4','IC_VMHZP'
exec MakeLocation 'R2JQ501','01','R2JQ5','IC_VMHZP'
exec MakeLocation 'R2JQ502','02','R2JQ5','IC_VMHZP'
exec MakeLocation 'R2JQ503','03','R2JQ5','IC_VMHZP'
exec MakeLocation 'R2JQ504','04','R2JQ5','IC_VMHZP'
exec MakeLocation 'R2JR101','01','R2JR1','IC_VMHZP'
exec MakeLocation 'R2JR102','02','R2JR1','IC_VMHZP'
exec MakeLocation 'R2JR103','03','R2JR1','IC_VMHZP'
exec MakeLocation 'R2JR104','04','R2JR1','IC_VMHZP'
exec MakeLocation 'R2JR201','01','R2JR2','IC_VMHZP'
exec MakeLocation 'R2JR202','02','R2JR2','IC_VMHZP'
exec MakeLocation 'R2JR203','03','R2JR2','IC_VMHZP'
exec MakeLocation 'R2JR204','04','R2JR2','IC_VMHZP'
exec MakeLocation 'R2JR301','01','R2JR3','IC_VMHZP'
exec MakeLocation 'R2JR302','02','R2JR3','IC_VMHZP'
exec MakeLocation 'R2JR303','03','R2JR3','IC_VMHZP'
exec MakeLocation 'R2JR304','04','R2JR3','IC_VMHZP'
exec MakeLocation 'R2JR401','01','R2JR4','IC_VMHZP'
exec MakeLocation 'R2JR402','02','R2JR4','IC_VMHZP'
exec MakeLocation 'R2JR403','03','R2JR4','IC_VMHZP'
exec MakeLocation 'R2JR404','04','R2JR4','IC_VMHZP'
exec MakeLocation 'R2JR501','01','R2JR5','IC_VMHZP'
exec MakeLocation 'R2JR502','02','R2JR5','IC_VMHZP'
exec MakeLocation 'R2JR503','03','R2JR5','IC_VMHZP'
exec MakeLocation 'R2JR504','04','R2JR5','IC_VMHZP'
exec MakeLocation 'R2JS101','01','R2JS1','IC_VMHZP'
exec MakeLocation 'R2JS102','02','R2JS1','IC_VMHZP'
exec MakeLocation 'R2JS103','03','R2JS1','IC_VMHZP'
exec MakeLocation 'R2JS104','04','R2JS1','IC_VMHZP'
exec MakeLocation 'R2JS201','01','R2JS2','IC_VMHZP'
exec MakeLocation 'R2JS202','02','R2JS2','IC_VMHZP'
exec MakeLocation 'R2JS203','03','R2JS2','IC_VMHZP'
exec MakeLocation 'R2JS204','04','R2JS2','IC_VMHZP'
exec MakeLocation 'R2JS301','01','R2JS3','IC_VMHZP'
exec MakeLocation 'R2JS302','02','R2JS3','IC_VMHZP'
exec MakeLocation 'R2JS303','03','R2JS3','IC_VMHZP'
exec MakeLocation 'R2JS304','04','R2JS3','IC_VMHZP'
exec MakeLocation 'R2JS401','01','R2JS4','IC_VMHZP'
exec MakeLocation 'R2JS402','02','R2JS4','IC_VMHZP'
exec MakeLocation 'R2JS403','03','R2JS4','IC_VMHZP'
exec MakeLocation 'R2JS404','04','R2JS4','IC_VMHZP'
exec MakeLocation 'R2JS501','01','R2JS5','IC_VMHZP'
exec MakeLocation 'R2JS502','02','R2JS5','IC_VMHZP'
exec MakeLocation 'R2JS503','03','R2JS5','IC_VMHZP'
exec MakeLocation 'R2JS504','04','R2JS5','IC_VMHZP'
exec MakeLocation 'R2JT101','01','R2JT1','IC_VMHZP'
exec MakeLocation 'R2JT102','02','R2JT1','IC_VMHZP'
exec MakeLocation 'R2JT103','03','R2JT1','IC_VMHZP'
exec MakeLocation 'R2JT104','04','R2JT1','IC_VMHZP'
exec MakeLocation 'R2JT201','01','R2JT2','IC_VMHZP'
exec MakeLocation 'R2JT202','02','R2JT2','IC_VMHZP'
exec MakeLocation 'R2JT203','03','R2JT2','IC_VMHZP'
exec MakeLocation 'R2JT204','04','R2JT2','IC_VMHZP'
exec MakeLocation 'R2JT301','01','R2JT3','IC_VMHZP'
exec MakeLocation 'R2JT302','02','R2JT3','IC_VMHZP'
exec MakeLocation 'R2JT303','03','R2JT3','IC_VMHZP'
exec MakeLocation 'R2JT304','04','R2JT3','IC_VMHZP'
exec MakeLocation 'R2JT401','01','R2JT4','IC_VMHZP'
exec MakeLocation 'R2JT402','02','R2JT4','IC_VMHZP'
exec MakeLocation 'R2JT403','03','R2JT4','IC_VMHZP'
exec MakeLocation 'R2JT404','04','R2JT4','IC_VMHZP'
exec MakeLocation 'R2JT501','01','R2JT5','IC_VMHZP'
exec MakeLocation 'R2JT502','02','R2JT5','IC_VMHZP'
exec MakeLocation 'R2JT503','03','R2JT5','IC_VMHZP'
exec MakeLocation 'R2JT504','04','R2JT5','IC_VMHZP'

set nocount off
drop proc [dbo].[MakeLocation]
