SELECT
    W.works_id
,   W.message_text
,   A.author_id
,   A.name_last
,   A.name_first
FROM
    stage.WORKS W
    inner join
        dbo.AUTHORS A
        on A.author_id = W.author_id
FOR
    XML AUTO

SELECT
    W.works_id
,   W.message_text
,   A.author_id
,   A.name_last
,   A.name_first
FROM
    stage.WORKS W
    inner join
        dbo.AUTHORS A
        on A.author_id = W.author_id
FOR
    XML AUTO, ELEMENTS

SELECT
    W.works_id
,   W.message_text
,   A.author_id
,   A.name_last
,   A.name_first
FROM
    stage.WORKS W
    inner join
        dbo.AUTHORS A
        on A.author_id = W.author_id
FOR
    XML RAW, ROOT('Root')