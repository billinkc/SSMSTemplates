SET NOCOUNT ON;

IF EXISTS (SELECT OBJECT_ID('tempdb..#HistoricalValues'))
BEGIN
    DROP TABLE #HistoricalValues;
END


IF EXISTS (SELECT OBJECT_ID('tempdb..#WorkHistory'))
BEGIN
    DROP TABLE #WorkHistory;
END
GO
CREATE TABLE 
    #HistoricalValues
(
    EffectiveDate date NOT NULL
,   Code char(2) NOT NULL
,   Description varchar(50) NOT NULL
,   PRIMARY KEY
    (
        EffectiveDate
    ,   Code
    )
);

CREATE TABLE
    #WorkHistory
(
    TreatmentDate date NOT NULL
,   Patient varchar(50) NOT NULL
,   PRIMARY KEY
    (
        TreatmentDate
    ,   Patient
    )
);


WITH SRC (EffectiveDate, Code, Description) AS
(
    SELECT CAST('1900-01-01' AS date), 'IA', 'Mad house'
    UNION ALL SELECT CAST('1920-01-01' AS date), 'IA', 'Looney bin'
    UNION ALL SELECT CAST('1928-08-30' AS date), 'IA', 'cuckoo''s nest'
    UNION ALL SELECT CAST('1944-11-17' AS date), 'IA', 'wacky shack'
    UNION ALL SELECT CAST('1960-03-02' AS date), 'IA', 'bedlam'
    UNION ALL SELECT CAST('1987-06-01' AS date), 'IA', 'funny farm'
    UNION ALL SELECT CAST('2013-01-01' AS date), 'IA', 'mental health facility'
    UNION ALL SELECT CAST('1900-01-01' AS date), 'XX', 'Other'
)
INSERT INTO
    #HistoricalValues
SELECT 
    SRC.EffectiveDate
,   SRC.Code
,   SRC.Description 
FROM 
    SRC;

WITH SRC (TreatmentDate, Patient, lazycutandpaste) AS
(
    SELECT CAST('1900-01-01' AS date), 'Old man winter', NULL
    UNION ALL SELECT CAST('1919-12-31' AS date), 'Erik the Red', NULL
    UNION ALL SELECT CAST('1920-01-01' AS date), 'Olaf', NULL
    UNION ALL SELECT CAST('1928-08-30' AS date), 'IA', NULL
    UNION ALL SELECT CAST('1944-11-17' AS date), 'IA', NULL
    UNION ALL SELECT CAST('1960-03-02' AS date), 'IA', 'bedlam'
    UNION ALL SELECT CAST('1987-06-01' AS date), 'IA', 'funny farm'
    UNION ALL SELECT CAST('2013-01-01' AS date), 'IA', 'mental health facility'
    UNION ALL SELECT CAST('1900-01-01' AS date), 'XX', 'Other'
)
INSERT INTO
    #WorkHistory
SELECT
    SRC.TreatmentDate
,   SRC.Patient
FROM
    SRC;


SELECT 
    HV.EffectiveDate
,   HV.Code
,   HV.Description 
FROM 
    #HistoricalValues AS HV;

SELECT 
    HV.EffectiveDate
,   LEAD(EffectiveDate, 1, NULL) OVER (PARTITION BY HV.Code ORDER BY HV.EffectiveDate ASC) AS NoDefaultProvided
,   LEAD(EffectiveDate, 1, DATEFROMPARTS(9999,12,31)) OVER (PARTITION BY HV.Code ORDER BY HV.EffectiveDate ASC) AS DefaultProvided
,   DATEADD(d, -1, LEAD(EffectiveDate, 1, DATEFROMPARTS(9999,12,31)) OVER (PARTITION BY HV.Code ORDER BY HV.EffectiveDate ASC)) AS EffectiveEndDateWrongForLast
,   COALESCE(DATEADD(d, -1, LEAD(EffectiveDate, 1, NULL) OVER (PARTITION BY HV.Code ORDER BY HV.EffectiveDate ASC)), DATEFROMPARTS(9999,12,31)) AS EffectiveEndDate
,   HV.Code
,   HV.Description 
FROM 
    #HistoricalValues AS HV;
