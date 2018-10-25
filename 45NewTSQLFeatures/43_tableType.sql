-- 2008+
-- Table Type
-- 2008 introduced a new object type that is a table.  This is different from the base
-- table objects in the data in this table is not persisted.  It is also different from
-- temporary tables (#table) and table variables (@table) in that it has a definite
-- signature.  Think of it more like a primative type (int, char, etc) in that every
-- instance of it will have the form.  The real value of this comes from the
-- ability to be used as a parameter to method calls.
--
-- The assignment of permissions on the object is just a little bit different than you may be used to.

--

IF EXISTS
(
    SELECT
        *
    FROM
        sys.types T
    WHERE
        T.name = 'AuthorsTableType'
)
BEGIN
    PRINT 'Dropping type dbo.AuthorsTableType'
    DROP TYPE dbo.AuthorsTableType
END
PRINT 'Creating type dbo.AuthorsTableType'
GO

CREATE TYPE
    [dbo].[AuthorsTableType] AS TABLE
(
    [firstName] varchar(50) NULL
,   [lastName] varchar(50) NOT NULL
,   [authorId] int NULL
,   [mod_date] datetime NOT NULL default(current_timestamp)
,   [mod_user] nvarchar(128) NOT NULL default(system_user)
,   [monotomicallyIncreasingNumber] int identity(1,1) NOT NULL PRIMARY KEY
)

GO
GRANT EXECUTE ON TYPE::dbo.AuthorsTableType TO public
GO

SET NOCOUNT ON

DECLARE @goodAuthors dbo.AuthorsTableType
DECLARE @badAuthors dbo.AuthorsTableType

-- load them up as normal table-like object

-- use a table value constructor
INSERT INTO
    @goodAuthors
(
    firstName
,   lastName
)
VALUES
    ('John', 'Steinbeck')
,   ('Honore', 'de Balzac')
,   ('Joyce Carol', 'Oates')

SELECT * FROM @goodAuthors

BEGIN TRY
    INSERT INTO
        @badAuthors
    (
        firstName
    ,   lastName
    )
    SELECT 'Ooops', 'Violate table defintion'
    UNION ALL SELECT '@sqltech', NULL
END TRY
BEGIN CATCH
SELECT
    ERROR_NUMBER()AS error_number --returns the number of the error.
,   ERROR_SEVERITY() AS error_severity --returns the severity.
,   ERROR_STATE()AS error_state  --returns the error state number.
,   ERROR_PROCEDURE() AS error_procedure --returns the name of the stored procedure or trigger where the error occurred.
,   ERROR_LINE() AS error_line --returns the line number inside the routine that caused the error.
,   ERROR_MESSAGE() AS error_message --returns the complete text of the error message. The text includes the values supplied for any substitutable parameters, such as lengths, object names, or times.
END CATCH
SELECT * FROM @badAuthors
