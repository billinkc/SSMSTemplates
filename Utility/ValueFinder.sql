SET NOCOUNT ON;

DECLARE
    -- actual query 
    @query nvarchar(max)
    -- templated query
,   @template nvarchar(max)
    -- string value we wish to find
    -- Length of 50 is arbitrary
,   @searchKey varchar(50);

SET
    @searchKey = '<Search Term, varchar(50), value>';

-- Return column & schema/table combo anywhere
-- there is data in the column that starts like the
-- search key.
SELECT
    @template = N'
    SELECT TOP 1 
        ''<COLUMN_NAME/>'' AS cname
    , ''<SCHEMA/>.<TABLE_NAME/>'' AS tname 
    FROM 
        <SCHEMA/>.<TABLE_NAME/> T 
    WHERE 
        T.<COLUMN_NAME/> LIKE ''<TARGET/>%''';

SELECT
    @template = REPLACE(@template, '<TARGET/>', @searchKey);

DECLARE 
    CSR CURSOR
FOR
-- Iterate through all the columns that are
-- character data types and are at least
-- as long as the search key
SELECT
    ISC.TABLE_SCHEMA
,   ISC.TABLE_NAME
,   ISC.COLUMN_NAME
FROM
    INFORMATION_SCHEMA.COLUMNS ISC
WHERE
    -- filter out tables/views I know I can skip
    ISC.TABLE_NAME not like 'x%'
    AND
    (
        ISC.DATA_TYPE IN ('char', 'nchar', 'varchar', 'nvarchar')
        AND ISC.CHARACTER_MAXIMUM_LENGTH >= LEN(@searchKey)
    );

-- Cursor variables for capturing candidate schemas, tables and columns
DECLARE
    @table_schema sysname
,   @table_name sysname
,   @column_name sysname;

DECLARE
    @RESULTS TABLE
(
    column_name sysname
,   table_schema nvarchar(500) NOT NULL
);

OPEN
    CSR;

FETCH NEXT
FROM
    CSR
INTO
    @table_schema
,   @table_name
,   @column_name;

WHILE (@@FETCH_STATUS = 0)
BEGIN
    -- stub in actual names, make 'em safe via quotename function
    SET @query = REPLACE(@template, '<SCHEMA/>', quotename(@table_schema));
    SET @query = REPLACE(@query, '<TABLE_NAME/>', quotename(@table_name));
    SET @query = REPLACE(@query, '<COLUMN_NAME/>', quotename(@column_name));

    BEGIN TRY
        --PRINT @query
        
        -- Dump results into a table variable
        INSERT INTO
            @RESULTS
        EXECUTE(@query);
        
    END TRY
    BEGIN CATCH
        -- print failing query
        PRINT @query;
        
    END CATCH
    FETCH NEXT
    FROM
        CSR
    INTO
        @table_schema
    ,   @table_name
    ,   @column_name;
END
CLOSE CSR;
DEALLOCATE CSR;

-- Show all the columns and fully qualified tables
-- that contained the value
SELECT 
    R.column_name
,   R.table_schema
,   'SELECT T.* FROM ' + R.table_schema + ' T WHERE T.' + R.column_name + ' LIKE  ''' + @searchKey + '%''' AS explore_query
FROM 
    @results R;
