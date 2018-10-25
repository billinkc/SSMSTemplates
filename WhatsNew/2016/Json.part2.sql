DROP TABLE IF EXISTS #Sales;
DROP TABLE IF EXISTS #SalesDetail;

CREATE TABLE #Sales
(
    RecordKey int NOT NULL
,   SalesDate date NOT NULL
,   CONSTRAINT PK_tmp_Sales PRIMARY KEY(RecordKey)
);

INSERT INTO
    #Sales
SELECT
    1 AS RecordKey
,   CAST('2017-01-13' AS date) AS SalesDate;

CREATE TABLE #SalesDetail
(
    RecordKey int NOT NULL
,   SalesRecordKey int NOT NULL
,   Quantity int NOT NULL
,   CONSTRAINT PK_tmp_SalesDetail PRIMARY KEY(RecordKey)
);

INSERT INTO
    #SalesDetail
SELECT
    1 AS RecordKey
,   1 AS SalesRecordKey
,   100 AS Quantity
UNION ALL
SELECT
    2 AS RecordKey
,   1 AS SalesRecordKey
,   50 AS Quantity;

DECLARE
    @jsonAuto nvarchar(max)
,   @jsonPath nvarchar(max);

SELECT
    @jsonAuto = (
SELECT
    S.RecordKey AS SalesRecordKey
,   S.SalesDate
,   SD.RecordKey AS SalesDetailRecordKey
,   SD.Quantity
FROM
    #Sales AS S
    INNER JOIN
        #SalesDetail AS SD
        ON SD.SalesRecordKey = S.RecordKey
FOR JSON AUTO
)
,   @jsonPath = (
SELECT
    S.RecordKey AS SalesRecordKey
,   S.SalesDate
,   SD.RecordKey AS SalesDetailRecordKey
,   SD.Quantity
FROM
    #Sales AS S
    INNER JOIN
        #SalesDetail AS SD
        ON SD.SalesRecordKey = S.RecordKey
FOR JSON PATH
);

/*
-- Make json look less ugly
-- https://jsonformatter.curiousconcept.com/
-- JSON AUTO
[
    {
        "SalesRecordKey":1,
        "SalesDate":"2017-01-13",
        "SD":[
            {
                "SalesDetailRecordKey":1,
                "Quantity":100
            },
            {
                "SalesDetailRecordKey":2,
                "Quantity":50
            }
        ]
    }
]

-- JSON PATH
[
    {
        "SalesRecordKey":1,
        "SalesDate":"2017-01-13",
        "SalesDetailRecordKey":1,
        "Quantity":100
    },
    {
        "SalesRecordKey":1,
        "SalesDate":"2017-01-13",
        "SalesDetailRecordKey":2,
        "Quantity":50
    }
]

*/

SELECT 
    OJ.RecordKey
,   OJ.SalesDate
--,   OJ.SD
,   SD.Quantity
FROM
    OPENJSON(@jsonAuto) 
    WITH
    (
        RecordKey int '$.SalesRecordKey'
    ,   SalesDate date '$.SalesDate'
    ,   SD nvarchar(max) AS JSON
    )AS OJ
    CROSS APPLY
        OPENJSON(OJ.SD)
    WITH
    (
        Quantity int '$.Quantity'
    ) AS SD

SELECT 
*
FROM
    OPENJSON(@jsonPath) 
    WITH
    (
        RecordKey int '$.SalesRecordKey'
    ,   SalesDate date '$.SalesDate'
    ,   Quantity int '$.Quantity'
    )AS OJ;

-- Default schema example
/*
value of the Type column	JSON data type
0	null
1	string
2	int
3	true/false
4	array
5	object
*/
SELECT 
*
FROM
    OPENJSON(@jsonPath) AS OJ;
