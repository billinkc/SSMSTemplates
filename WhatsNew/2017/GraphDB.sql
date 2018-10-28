SET NOCOUNT ON;
DROP TABLE IF EXISTS dbo.THING;
DROP TABLE IF EXISTS dbo.PEEP;
DROP TABLE IF EXISTS dbo.FEELING;

CREATE TABLE dbo.THING
(
	ThingSk int IDENTITY(1,1) NOT NULL CONSTRAINT PK_dbo_THING PRIMARY KEY
,	ThingName varchar(50) NOT NULL CONSTRAINT UQ_dbo_THING_ThingName UNIQUE
) AS NODE;

INSERT INTO dbo.THING
(
    ThingName
)
VALUES ('Chocolate'), ('Huskers'), ('Lil'' Red'), ('Colorado teams');

CREATE TABLE dbo.PEEP
(
	PeepSk int IDENTITY(1,1) NOT NULL CONSTRAINT PK_dbo_PEEP PRIMARY KEY
,	PeepName varchar(50) NOT NULL CONSTRAINT UQ_dbo_PEEP_PeepName UNIQUE
) AS NODE;

INSERT INTO dbo.PEEP
(
    PeepName
)
VALUES
	('Mike'), ('John'), ('Bill'), ('Ann');

CREATE TABLE dbo.FEELING
(
	FeelingType varchar(30) NOT NULL
) AS EDGE;


-- Create associations
INSERT INTO
	dbo.FEELING
SELECT
	-- This is special as heck, don't wrap with square brackets
	P.$node_id AS from_id
,	T.$node_id AS to_id
,	F.Feeling AS FeelingName
FROM
	dbo.PEEP AS P	
	CROSS APPLY
		dbo.THING AS T
	CROSS APPLY
	(
		SELECT	
			CASE P.PeepName
				WHEN 'Bill' THEN
					CASE T.ThingName 
						WHEN 'Lil'' Red' THEN 'Creeped out'
						WHEN 'Colorado Teams' THEN NULL
						ELSE 'Likes'
					END
				WHEN 'John' THEN
					CASE T.ThingName 
						WHEN 'Colorado Teams' THEN 'Dislikes'
						ELSE 'Likes'
					END
				WHEN 'Mike' THEN
					CASE T.ThingName 
						WHEN 'Colorado Teams' THEN 'Likes'
						WHEN 'Chocolate' THEN 'Dislikes'
						ELSE NULL
					END
				WHEN 'Ann' THEN
					CASE T.ThingName 
						WHEN 'Chocolate' THEN 'Loves'
						ELSE NULL
					END
			END
	) F(Feeling)
			
WHERE
	F.Feeling IS NOT NULL;

-----------------------------------------------------------
-- Setup complete
-----------------------------------------------------------

-- Who feels a thing
SELECT
	P.PeepName
,	F.FeelingType
,	T.ThingName
FROM
	dbo.PEEP AS P
	,	dbo.THING AS T
	,	dbo.FEELING AS F
WHERE
	MATCH(P-(F)->T);

-- Do any things feel a peep?
SELECT
	P.PeepName
,	F.FeelingType
,	T.ThingName
FROM
	dbo.PEEP AS P
	,	dbo.THING AS T
	,	dbo.FEELING AS F
WHERE
	MATCH(P<-(F)-T);

-- Who has feelings for chocolate
SELECT
	P.PeepName
,	F.FeelingType
,	T.ThingName
FROM
	dbo.PEEP AS P
	,	dbo.THING AS T
	,	dbo.FEELING AS F
WHERE
	MATCH(P-(F)->T)
	AND T.ThingName = 'Chocolate';

-- Who has feelings for Colorado teams
SELECT
	P.PeepName
,	F.FeelingType
,	T.ThingName
FROM
	dbo.PEEP AS P
	,	dbo.THING AS T
	,	dbo.FEELING AS F
WHERE
	MATCH(P-(F)->T)
	AND T.ThingName = 'Colorado Teams';


-- Is there really someone who has feelings for both chocolate and CO teams?
SELECT
	P.PeepName
,	F1.FeelingType
,	T1.ThingName
,	F2.FeelingType
,	T2.ThingName
FROM
	dbo.PEEP AS P
	,	dbo.THING AS T1
	,	dbo.THING AS T2
	,	dbo.FEELING AS F1
	,	dbo.FEELING AS F2
WHERE
	MATCH(P-(F1)->T1) AND MATCH(P-(F2)->T2)
	AND T1.ThingName = 'Chocolate' AND T2.ThingName = 'Colorado Teams'
