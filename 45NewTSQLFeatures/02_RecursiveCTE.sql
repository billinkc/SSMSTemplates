-- This query demonstrates recursion by counting down from 100 to 0
;
WITH BASE AS
(
    -- Anchor query
    SELECT 100 AS anchor
    
    -- recursive query
    -- notice that I can reference BASE
    UNION ALL
    SELECT B.anchor -1 FROM BASE B WHERE B.anchor > 0
    
)
SELECT B.* FROM BASE B



-- This query demonstrates recursion by counting down from 101 to 0
-- The MAXRECURSION hint allows us to override the default for good or ill
;
WITH BASE AS
(
    -- Anchor query
    SELECT 101 AS anchor
    
    -- recursive query
    -- notice that I can reference BASE
    UNION ALL
    SELECT B.anchor -1 FROM BASE B WHERE B.anchor > 0
    
)
SELECT B.* 
FROM BASE B 
OPTION (maxrecursion 101)

