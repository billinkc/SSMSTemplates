-- ASCII character sequences
CREATE SEQUENCE 
    dbo.ASCIISequence
    AS tinyint
    START WITH 32
    INCREMENT BY 1
    MINVALUE 32
    MAXVALUE 128
    CYCLE
    -- Leave size to the database engine
    -- Actual value may vary over time based on whims of MS
    CACHE 32;

DECLARE 
    @sequence_name nvarchar(776) = N'dbo.ASCIISequence' 
    -- Change this value to force a cycle
,   @range_size bigint =  32
,   @range_first_value sql_variant = NULL
,   @range_last_value sql_variant = NULL  
,   @range_cycle_count int = NULL
,   @sequence_increment sql_variant = NULL
,   @sequence_min_value sql_variant = NULL
,   @sequence_max_value sql_variant = NULL;

EXECUTE sp_sequence_get_range  
    @sequence_name 
,   @range_size
,   @range_first_value OUTPUT
,   @range_last_value OUTPUT
,   @range_cycle_count OUTPUT
,   @sequence_increment OUTPUT
,   @sequence_min_value OUTPUT
,   @sequence_max_value OUTPUT; 

SELECT
    @range_first_value AS range_first_value
,   @range_last_value AS range_last_value 
,   @range_cycle_count AS range_cycle_count 
,   @sequence_increment AS sequence_increment
,   @sequence_min_value AS sequence_min_value
,   @sequence_max_value AS sequence_max_value; 


; WITH NUMBERS (number) AS
(
    SELECT 32
    UNION ALL
    SELECT
        N.number + 1
    FROM
        NUMBERS N
    WHERE
        N.number < 128 
)
SELECT 
    char(N.number) AS character
,   char(N.number) + ' ' 
    + char(NEXT VALUE FOR dbo.ASCIISequence OVER (ORDER BY N.number DESC)) AS smush
FROM
    NUMBERS N
