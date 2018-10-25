-- SEQUENCE
-- http://msdn.microsoft.com/en-us/library/ff878091(v=sql.110).aspx

-- Bog simple sequence
CREATE SEQUENCE dbo.DefaultSequence;

-- What, you were expecting 1?
SELECT 
    NEXT VALUE FOR dbo.DefaultSequence AS foo;

-- Default is bigint, starts at minimum value



CREATE SEQUENCE 
    dbo.ExplicitDefaultSequence
    AS bigint
    START WITH -9223372036854775808
    INCREMENT BY 1
    NO MINVALUE 
    NO MAXVALUE
    NO CYCLE
    -- Leave size to the database engine
    -- Actual value may vary over time based on whims of MS
    CACHE;


SELECT 
    SEQ.name
,   SEQ.minimum_value
,   SEQ.maximum_value

,   SEQ.start_value
,   SEQ.current_value

,   SEQ.cache_size
,   SEQ.increment

,   SEQ.is_cycling
,   SEQ.is_cached
,   SEQ.is_exhausted
FROM 
    sys.sequences SEQ
WHERE
    (
        SEQ.name = 'DefaultSequence'
        OR SEQ.name = 'ExplicitDefaultSequence'
    )
    AND SEQ.schema_id = SCHEMA_ID('dbo')
