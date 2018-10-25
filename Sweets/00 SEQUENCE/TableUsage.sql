IF EXISTS (SELECT * FROM sys.tables ST WHERE ST.name = 'Student' AND ST.schema_id = schema_id('dbo'))
BEGIN
    DROP TABLE dbo.Student
END

IF EXISTS (SELECT * FROM sys.sequences SEQ WHERE SEQ.name = 'AlphaSequence' AND SEQ.schema_id = schema_id('dbo'))
BEGIN
    DROP SEQUENCE dbo.AlphaSequence
END

IF EXISTS (SELECT * FROM sys.sequences SEQ WHERE SEQ.name = 'NumericSequence' AND SEQ.schema_id = schema_id('dbo'))
BEGIN
    DROP SEQUENCE dbo.NumericSequence
END


CREATE SEQUENCE
    dbo.AlphaSequence
    AS tinyint
    START WITH 65
    INCREMENT BY 1
    MINVALUE 65
    MAXVALUE 90
    CYCLE
    -- Leave size to the database engine
    -- Actual value may vary over time based on whims of MS
    CACHE 26;


CREATE SEQUENCE
    dbo.NumericSequence
    AS int
    START WITH 0
    INCREMENT BY 1;

CREATE TABLE
    dbo.Student
(
    student_id varchar(10) PRIMARY KEY NOT NULL
        DEFAULT(CONCAT(char(NEXT VALUE FOR dbo.AlphaSequence), '-', NEXT VALUE FOR dbo.NumericSequence) )
,   student_name varchar(50) NOT NULL
)

INSERT INTO
    dbo.Student
    (student_name)
VALUES
    ('Padraig Pearse')
,   ('Willie Pearse')
,   ('Thomas MacDonagh')
,   ('Thomas Clarke')
,   ('Joseph Plunkett')
,   ('Edward Daly')
,   ('Michael O''Hanrahan')
,   ('John MacBride')
,   ('Eamonn Ceannt')
,   ('Michael Mallin')
,   ('Sean Heuston')
,   ('Conn Colbert')
,   ('James Connolly')
,   ('Sean MacDiarmada')
,   ('Fiona Plunkett')
,   ('Eamon de Valera')
,   ('Tomas Ceannt')
,   ('')
,   ('')
,   ('')
,   ('')
,   ('')
,   ('')
,   ('')
,   ('')
,   ('')
,   ('')
,   ('')
,   ('')
,   ('')

SELECT * FROM dbo.Student
ORDER BY 1

   