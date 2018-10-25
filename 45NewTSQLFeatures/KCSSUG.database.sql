SET NOCOUNT ON
GO
CREATE DATABASE
    FOURTY_FIVE
GO
USE FOURTY_FIVE
GO
--------------------------------------------------------------------------------
-- Create a domain for the staging data
--------------------------------------------------------------------------------
CREATE SCHEMA stage
GO
--------------------------------------------------------------------------------
-- Domain for production data
--------------------------------------------------------------------------------
CREATE SCHEMA live
GO
--------------------------------------------------------------------------------
-- create users for each domain
-- DBAs will have thoughts on best approach for this
-- Database role or application role?  TODO:  ask DBAs
-- http://blogs.msdn.com/raulga/archive/2006/07/03/655587.aspx
--------------------------------------------------------------------------------
CREATE USER [stageUSER] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[stage]
GO
CREATE USER [liveUSER] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[live]
GO
ALTER AUTHORIZATION ON SCHEMA::[stage] TO [stageUSER]
GO
ALTER AUTHORIZATION ON SCHEMA::[live] TO [liveUSER]
GO
--------------------------------------------------------------------------------
-- Create tables
--------------------------------------------------------------------------------
CREATE TABLE stage.WORKS
(
    works_id int identity(1, 1) NOT NULL PRIMARY KEY
,   message_text varchar(max) NOT NULL
,   author_id int NOT NULL
)
GO
CREATE TABLE live.WORKS
(
    works_id int identity(1, 1) NOT NULL PRIMARY KEY
,   message_text varchar(max) NOT NULL
,   author_id int NOT NULL
)
CREATE TABLE dbo.AUTHORS
(
    author_id int identity(1, 1) NOT NULL PRIMARY KEY CLUSTERED
,   name_first varchar(50) NULL
,   name_last varchar(50) NOT NULL
)
GO
--------------------------------------------------------------------------------
-- Establish foreign key relationships
--------------------------------------------------------------------------------
ALTER TABLE
    stage.WORKS
ADD CONSTRAINT
    FK_STAGE_WORKS_AUTHORS
    FOREIGN KEY
    (
        author_id
    )
    REFERENCES
        dbo.AUTHORS
        (
            author_id
        )
    ON UPDATE
        NO ACTION
    ON DELETE
        NO ACTION
GO
ALTER TABLE
    live.WORKS
ADD CONSTRAINT
    FK_LIVE_WORKS_AUTHORS
    FOREIGN KEY
    (
        author_id
    )
    REFERENCES
        dbo.AUTHORS
        (
            author_id
        )
    ON UPDATE
        NO ACTION
    ON DELETE
        NO ACTION
GO
--------------------------------------------------------------------------------
-- Sample process of publishing data from stage to prod
--------------------------------------------------------------------------------
CREATE PROCEDURE
    stage.Publish
(
    @works_id int
)
AS
BEGIN
    SET NOCOUNT ON

    INSERT INTO
        live.WORKS
    (
        message_text
    ,   author_id
    )
    SELECT
        W.message_text
    ,   W.author_id
    FROM
        stage.WORKS W
    WHERE
        W.works_id = @works_id
END
GO
--------------------------------------------------------------------------------
-- load up author list
--------------------------------------------------------------------------------
INSERT INTO
    dbo.authors
(
    name_first
,   name_last
)
SELECT
    'John'
,   'Milton'
UNION ALL
SELECT
    'William'
,   'Blake'
GO


/*
-- cleanup
drop table live.works
drop table stage.works
drop table dbo.authors
drop procedure stage.publish
drop schema stage
drop schema live
drop function dbo.GenerateNumbers
-- or we could just drop the database and that'd really clean things up
-- use master
-- DROP DATABASE FOURTY_FIVE
*/


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

CREATE FUNCTION DBO.LessThan10(@input int)
returns TABLE
AS RETURN
(
SELECT smallee
FROM
(
SELECT 0 as smallee
union all select 1
union all select 2
union all select 3
union all select 4
union all select 5
union all select 6
union all select 7
union all select 8
union all select 9
) D
WHERE D.smallee = @input
)
;
