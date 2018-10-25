--OUTPUT
--http://msdn.microsoft.com/en-us/library/ms177564.aspx
--Has access to inserted/deleted virtual tables
--Can dump to table variable, physical table or spool rows

DECLARE @Works TABLE
(
    mtext varchar(50)
,   author_id int
)

INSERT INTO
    stage.WORKS
(
    message_text
,   author_id
)
OUTPUT
    INSERTED.*
INTO
    @Works
SELECT
    'Damn braces; Bless relaxes' AS message_text
,   A.author_id
FROM
    dbo.authors A
WHERE
    A.name_last = 'blake'
union all
SELECT
    'Exuberance is beauty' AS message_text
,   A.author_id
FROM
    dbo.authors A
WHERE
    A.name_last = 'blake'


SELECT W.* FROM @Works W

--------------------------------------------------------------------------------
-- load up some staging data
--------------------------------------------------------------------------------
INSERT INTO
    stage.WORKS
(
    message_text
,   author_id
)
OUTPUT
    INSERTED.*
SELECT
    'My fingers emit sparks of fire with expectations of my future labors' AS message_text
,   A.author_id
FROM
    dbo.authors A
WHERE
    A.name_last = 'blake'
UNION ALL
SELECT
    'The mind can make a heaven out of hell and a hell out of heaven' AS message_text
,   A.author_id
FROM
    dbo.authors A
WHERE
    A.name_last = 'milton'
UNION ALL
SELECT
    'If the fool would persist in his folly he would become wise' AS message_text
,   A.author_id
FROM
    dbo.authors A
WHERE
    A.name_last = 'blake'
UNION ALL
SELECT
    'Excess of sorrow laughs. Excess of joy weeps' AS message_text
,   A.author_id
FROM
    dbo.authors A
WHERE
    A.name_last = 'blake'
GO
