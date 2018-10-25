DECLARE
    @operation_id bigint = 938;

WITH SRC AS
(
    SELECT
        OM.message
    ,   CHARINDEX('->', OM.message) AS arrow
    ,   CHARINDEX(':', OM.message, CHARINDEX('->', OM.message)) AS colon
    ,   LEN(OM.message) AS length
    ,   RIGHT(OM.message, LEN(OM.message) - CHARINDEX('->', OM.message) -1) AS elements
    FROM
        catalog.operation_messages AS OM
    WHERE
        OM.message_type= 110
        AND OM.message_source_type = 60
        AND OM.message LIKE '%research%'
        AND OM.operation_id = @operation_id
)
, PARSED AS
(
    SELECT
        SRC.message
    ,   CHARINDEX(':', SRC.elements) AS colon
    ,   LEN(SRC.elements) AS length
    ,   SRC.elements
    ,   LEFT(SRC.elements, CHARINDEX(':', SRC.elements) -1) AS EmployeeID
    ,   RIGHT(SRC.elements, LEN(SRC.elements) - CHARINDEX(':', SRC.elements)) AS EventDate
    FROM
        SRC
)
SELECT
    *
FROM
    PARSED;
