
CREATE FUNCTION [dbo].[SetSidKeyValue] (
	@key nvarchar(max),
	@sidId int,
	@newValue nvarchar(250)
)
RETURNS nvarchar(max)
AS
    BEGIN
		declare @sidStart int;
		declare @sidEnd int;
		declare @sidStartTag varchar(20);
		declare @sidEndTag varchar(10);

		set @sidStartTag = '{"' + CAST(@sidId as VARCHAR) + '":"';

		set @sidStart = CHARINDEX(@sidStartTag, @key);
		if @sidStart = 0 return @key;

		set @sidEndTag = '"},';
		set @sidEnd = CHARINDEX(@sidEndTag, @key, @sidStart);

		if @sidEnd = 0 -- sid is last in the _KEY_
		begin
			set @sidStartTag = ',{"' + CAST(@sidId as VARCHAR) + '":"';
			set @sidStart = CHARINDEX(@sidStartTag, @key);
			if @sidStart = 0 -- sid is also first in the _KEY_
			begin
				set @sidStartTag = '{"' + CAST(@sidId as VARCHAR) + '":"';
				set @sidStart = CHARINDEX(@sidStartTag, @key);
			end
			set @sidEndTag = '"}';
			set @sidEnd = CHARINDEX(@sidEndTag, @key, @sidStart);
		end

		return STUFF(@key, @sidStart, @sidEnd - @sidStart + LEN(@sidEndTag), @sidStartTag + @newValue + @sidEndTag);

    END

GO

BEGIN TRY
	BEGIN TRAN

declare @updateUser nvarchar(50) = 'sys161208';
declare @sidValues table (Value nvarchar(50))
insert into @sidValues values ('A02204'), ('A02208'), ('A02282'), ('A02161'), ('A02214'), ('A02215'), ('A02230'), ('A02232'), ('A02231'), ('A02165'), ('A02234'), ('A02566'), 
	('A02567'), ('A02307'), ('A02281'), ('A02285'), ('A02255'), ('A02409'), ('A02201'), ('A02237'), ('A02399'), ('A02146'), ('A02182'), ('A02257'), ('A02324'), ('A02465'),
	('A02221'), ('A02220'), ('A02188'), ('A02218'), ('A02275'), ('A02173'), ('A02435'), ('A02531'), ('A02416'), ('A02222'), ('A02421'), ('A02405'), ('A02520'), ('A02238'),
	('A02544'), ('A02251'), ('A02328'), ('A02551'), ('A02552'), ('A02254'), ('A02191'), ('A02264'), ('A02193'), ('A02192'), ('A02194'), ('A02164'), ('A02160'), ('A02272'),
	('A02162'), ('A02163'), ('A02263'), ('A02245'), ('A02518'), ('A02252'), ('A02195'), ('A02244'), ('A02198'), ('A02197'), ('A02431'), ('A02330'), ('A02170'), ('A02448'),
	('A02219'), ('A02418'), ('A02181'), ('A02411'), ('A02347'), ('A02185'), ('A02434'), ('A02186'), ('A02184'), ('A02187'), ('A02189'), ('A02190'), ('A02140'), ('A02265'),
	('A02340'), ('A02304'), ('A02303'), ('A02196'), ('A02521'), ('A02183'), ('A02239'), ('A02536'), ('A02200'), ('A02535'), ('A02269'), ('A02267'), ('A02154'), ('A02151'),
	('A02199'), ('A02424'), ('A02288'), ('A02283'), ('A02561'), ('A02246'), ('A02322'), ('A02315'), ('A02294'), ('A02261'), ('A02273'), ('A02539'), ('A02537'), ('A02538'),
	('A02540'), ('A02157'), ('A02259'), ('A02262'), ('A02290'), ('A02289'), ('A02564'), ('A02295'), ('A02296'), ('A02390'), ('A02512'), ('A02298'), ('A02300'), ('A02505'),
	('A02450'), ('A02451'), ('A02447'), ('A02443'), ('A02440'), ('A02441'), ('A02302'), ('A02355'), ('A02258'), ('A02384'), ('A02489'), ('A02471'), ('A02236'), ('A02378'),
	('A02473'), ('A02511'), ('A02371'), ('A02354'), ('A02352'), ('A02274'), ('A02387'), ('A02175'), ('A02519'), ('A02379'), ('A02494'), ('A02144'), ('A02377'), ('A02369'),
	('A02345'), ('A02351'), ('A02344'), ('A02529'), ('A02530'), ('A02327'), ('A02305'), ('A02372'), ('A02373'), ('A02367'), ('A02370'), ('A02562'), ('A02477'), ('A02490'),
	('A02491'), ('A02468'), ('A02323'), ('A02277'), ('A02463'), ('A02461'), ('A02462'), ('A02203'), ('A02202'), ('A02374'), ('A02466'), ('A02497'), ('A02415'), ('A02278'),
	('A02349'), ('A02510'), ('A02509'), ('A02506'), ('A02499'), ('A02560'), ('A02527'), ('A02353'), ('A02320'), ('A02242'), ('A02243'), ('A02337'), ('A02455'), ('A02517'),
	('A02513'), ('A02525'), ('A02439'), ('A02502'), ('A02332'), ('A02453'), ('A02486'), ('A02481'), ('A02464'), ('A02389'), ('A02380'), ('A02343'), ('A02253'), ('A02250'),
	('A02248'), ('A02425'), ('A02449'), ('A02508'), ('A02321'), ('A02312'), ('A02316'), ('A02366'), ('A02317'), ('A02313'), ('A02143'), ('A02386'), ('A02408'), ('A02325'),
	('A02319'), ('A02306'), ('A02141'), ('A02385'), ('A02268'), ('A02297'), ('A02309'), ('A02310'), ('A02368'), ('A02383'), ('A02174'), ('A02145'), ('A02395'), ('A02166'),
	('A02229'), ('A02504'), ('A02454'), ('A02397'), ('A02396'), ('A02545'), ('A02402'), ('A02350'), ('A02388'), ('A02391'), ('A02176'), ('A02329'), ('A02177'), ('A02532'),
	('A02142'), ('A02394'), ('A02547'), ('A02446'), ('A02266'), ('A02507'), ('A02498'), ('A02152'), ('A02153'), ('A02155'), ('A02158'), ('A02445'), ('A02442'), ('A02430'),
	('A02433'), ('A02444'), ('A02438'), ('A02488'), ('A02478'), ('A02286'), ('A02287'), ('A02528'), ('A02178'), ('A02179'), ('A02526'), ('A02524'), ('A02550'), ('A02256'),
	('A02260'), ('A02419'), ('A02423'), ('A02469'), ('A02470'), ('A02417'), ('A02422'), ('A02180'), ('A02437'), ('A02479'), ('A02485'), ('A02483'), ('A02484'), ('A02339'),
	('A02338'), ('A02336'), ('A02335'), ('A02459'), ('A02457'), ('A02458'), ('A02460'), ('A02428'), ('A02429'), ('A02407'), ('A02406'), ('A02410'), ('A02172'), ('A02436'),
	('A02432'), ('A02426'), ('A02427'), ('A02326'), ('A02420'), ('A02284'), ('A02308'), ('A02280'), ('A02293'), ('A02398'), ('A02291'), ('A02279'), ('A02514'), ('A02549'),
	('A02271'), ('A02559'), ('A02501'), ('A02487'), ('A02548'), ('A02492'), ('A02480'), ('A02476'), ('A02482'), ('A02292'), ('A02270'), ('A02495'), ('A02474'), ('A02475'),
	('A02554'), ('A02500'), ('A02456'), ('A02452'), ('A02233'), ('A02223'), ('A02207'), ('A02206'), ('A02359'), ('A02358'), ('A02356'), ('A02569'), ('A02568'), ('A02393'),
	('A02276'), ('A02556'), ('A02555'), ('A02213'), ('A02209'), ('A02205'), ('A02210'), ('A02150'), ('A02147'), ('A02392'), ('A02216'), ('A02217'), ('A02212'), ('A02211'),
	('A02241'), ('A02249'), ('A02240'), ('A02235')
--select * from @sidValues

declare @sidValuePairs table (STOCK_INFO_CONFIG_ID int, CoilNr1 nvarchar(2000), CoilNr2 nvarchar(2000))
insert into @sidValuePairs (STOCK_INFO_CONFIG_ID, CoilNr2) select sis.STOCK_INFO_CONFIG_ID, sis.[VALUE]
	from STOCK_INFO_SID sis join STOCK_INFO_CONFIG sic on sis.STOCK_INFO_CONFIG_ID = sic.STOCK_INFO_CONFIG_ID and sis.SID_ID in (54) and sic.OWNER_ID = 549
		join @sidValues sv on sis.VALUE = sv.Value
		join STOCK_INFO si on si.STOCK_INFO_CONFIG_ID = sic.STOCK_INFO_CONFIG_ID
		join STOCK s on s.STOCK_INFO_ID = si.STOCK_INFO_ID
update @sidValuePairs set CoilNr1 = sis.[VALUE]
	from STOCK_INFO_SID sis join @sidValuePairs svp on sis.STOCK_INFO_CONFIG_ID = svp.STOCK_INFO_CONFIG_ID and sis.SID_ID in (53)

--select * from @sidValuePairs
--select * from STOCK_INFO_SID sis join @sidValuePairs svp on sis.STOCK_INFO_CONFIG_ID = svp.STOCK_INFO_CONFIG_ID and sis.SID_ID in (53, 54)
--select * from STOCK_INFO_CONFIG sic join @sidValuePairs svp on sic.STOCK_INFO_CONFIG_ID = svp.STOCK_INFO_CONFIG_ID

update sic set
	_KEY_ = dbo.[SetSidKeyValue](dbo.[SetSidKeyValue](_KEY_, 53, CoilNr2), 54, CoilNr1),
	HASH_KEY = CAST(hashbytes('SHA1', dbo.[SetSidKeyValue](dbo.[SetSidKeyValue](_KEY_, 53, CoilNr2), 54, CoilNr1)) AS BINARY(20)),
	UPDATE_TIMESTAMP = GETDATE(),
	UPDATE_USER = @updateUser
	FROM STOCK_INFO_CONFIG sic, @sidValuePairs svp
	WHERE sic.STOCK_INFO_CONFIG_ID = svp.STOCK_INFO_CONFIG_ID --AND sis.SID_ID = @catSidId and sis.[VALUE] = @oldCatValue

update sis set
	[VALUE] = CoilNr2,
	UPDATE_TIMESTAMP = GETDATE(),
	UPDATE_USER = @updateUser
	from STOCK_INFO_SID sis, @sidValuePairs svp
	WHERE sis.STOCK_INFO_CONFIG_ID = svp.STOCK_INFO_CONFIG_ID and SID_ID = 53

update sis set
	[VALUE] = CoilNr1,
	UPDATE_TIMESTAMP = GETDATE(),
	UPDATE_USER = @updateUser
	from STOCK_INFO_SID sis, @sidValuePairs svp
	WHERE sis.STOCK_INFO_CONFIG_ID = svp.STOCK_INFO_CONFIG_ID and SID_ID = 54

--select * from STOCK_INFO_SID sis join @sidValuePairs svp on sis.STOCK_INFO_CONFIG_ID = svp.STOCK_INFO_CONFIG_ID and sis.SID_ID in (53, 54)
--select * from STOCK_INFO_CONFIG sic join @sidValuePairs svp on sic.STOCK_INFO_CONFIG_ID = svp.STOCK_INFO_CONFIG_ID

	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK
		SELECT ERROR_NUMBER() as ErrorNumber, ERROR_MESSAGE() as ErrorMessage
END CATCH

drop function [dbo].[SetSidKeyValue] 

--select * from STOCK_INFO_SID sis join STOCK_INFO_CONFIG sic on sis.STOCK_INFO_CONFIG_ID = sic.STOCK_INFO_CONFIG_ID and sis.SID_ID in (54) and sic.OWNER_ID = 549
--	join @sidValues sv on sis.VALUE = sv.Value

--update sis set [VALUE] = 
--from STOCK_INFO_SID sis join STOCK_INFO_CONFIG sic on sis.STOCK_INFO_CONFIG_ID = sic.STOCK_INFO_CONFIG_ID and sis.SID_ID in (54) and sic.OWNER_ID = 549
--	join @sidValues sv on sis.VALUE = sv.Value 
