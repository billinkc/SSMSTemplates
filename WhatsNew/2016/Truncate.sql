DROP TABLE IF EXISTS dbo.PartitionDemo;

--
IF EXISTS(SELECT * FROM sys.partition_schemes AS PS WHERE PS.name = 'psPartitionDemo')
BEGIN
    DROP PARTITION SCHEME psPartitionDemo;
END

IF EXISTS(SELECT * FROM sys.partition_functions AS PF WHERE PF.name = 'pfPartitionDemo')
BEGIN
    DROP PARTITION FUNCTION pfPartitionDemo;
END

CREATE PARTITION FUNCTION pfPartitionDemo (tinyint) 
AS RANGE LEFT FOR VALUES(0,1,2,3,4,5,6,7,8,9);

CREATE PARTITION SCHEME psPartitionDemo  
    AS PARTITION pfPartitionDemo
    ALL TO ([PRIMARY]); 


CREATE TABLE
    dbo.PartitionDemo
(
    PartitionKey tinyint NOT NULL
,   Col1 varchar(50) NOT NULL
) ON psPartitionDemo(PartitionKey);

INSERT INTO
    dbo.PartitionDemo
(
    PartitionKey
,   Col1
)
SELECT
*
FROM
    (
        SELECT
        *
        FROM
        (
            VALUES
                (0)
            ,   (1)
            ,   (2)
            ,   (2)
            ,   (3)
            ,   (3)
            ,   (3)
            ,   (4)
            ,   (4)
            ,   (4)
            ,   (4)
            ,   (5)
            ,   (5)
            ,   (5)
            ,   (5)
            ,   (5)
            ,   (6)
            ,   (6)
            ,   (6)
            ,   (6)
            ,   (6)
            ,   (6)
            ,   (7)
            ,   (8)
            ,   (9)
        ) PK(PartitionKey)
        CROSS APPLY
        (
            SELECT
                REPLICATE(CHAR(65 +PK.PartitionKey), 50)
        ) V(Col1)
    )D(PartitionKey, Col1)
WHERE
    NOT EXISTS
    (
        SELECT * FROM dbo.PartitionDemo AS PD WHERE PD.PartitionKey = D.PartitionKey
    )

SELECT * FROM dbo.PartitionDemo;

TRUNCATE TABLE dbo.PartitionDemo WITH (PARTITIONS (2,4, 6 TO 8)); 
SELECT * FROM dbo.PartitionDemo;
