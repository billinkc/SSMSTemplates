-- Roll out based on author_id

SELECT
    *
FROM
    stage.WORKS


SELECT
    *
FROM
    stage.WORKS W
    PIVOT
    (
        count(works_id)
        FOR author_id in
        (
            [1]
        ,   [2]
        ) 
    ) AS P