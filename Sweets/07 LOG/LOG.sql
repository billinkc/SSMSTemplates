-- LOG
-- http://msdn.microsoft.com/en-us/library/ms190319(v=sql.110).aspx
-- Now supports an optional base

DECLARE
    @log float = 2
,   @base float = 2.718281828

SELECT
    LOG(D.fn, @base)
FROM
    (
        VALUES
        (0.0001)
    ,   (0.1)
    ,   (0.2)
    ,   (0.3)
    ,   (0.4)
    ,   (0.5)
    ,   (0.6)
    ,   (0.7)
    ,   (0.8)
    ,   (0.9)
    ,   (1.0)
    ,   (2.0)
    ,   (2.0)
    ,   (3.0)
    ,   (4.0)
    ) D (fn)
