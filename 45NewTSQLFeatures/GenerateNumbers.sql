-- Code via Itzik Ben-Gan
-- Reset to jive with my syntax preference
CREATE FUNCTION
    dbo.GenerateNumbers
(
    @n as bigint
)
RETURNS TABLE
RETURN
    WITH L0 AS
    (
        SELECT
            0 AS C
        UNION ALL
        SELECT
            0
    )
    , L1 AS
    (
        SELECT
            0 AS c
        FROM
            L0 AS A
            CROSS JOIN L0 AS B
    )
    , L2 AS
    (
        SELECT
            0 AS c
        FROM
            L1 AS A
            CROSS JOIN L1 AS B
    )
    , L3 AS
    (
        SELECT
            0 AS c
        FROM
            L2 AS A
            CROSS JOIN L2 AS B
    )
    , L4 AS
    (
        SELECT
            0 AS c
        FROM
            L3 AS A
            CROSS JOIN L3 AS B
    )
    , L5 AS
    (
        SELECT
            0 AS c
        FROM
            L4 AS A
            CROSS JOIN L4 AS B
    )
    , NUMS AS
    (
        SELECT
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS number
        FROM
            L5
    )
    SELECT top (@n)
        number
    FROM
        NUMS
    ORDER BY
        number
GO

