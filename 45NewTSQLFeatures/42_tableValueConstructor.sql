-- 2008+
--table value constructor (VALUES allows for anonymous table declaration) {2008}
--http://technet.microsoft.com/en-us/library/dd776382.aspx

DECLARE
    @T TABLE
(
    t_id int identity(1,1) NOT NULL PRIMARY KEY
,   val varchar(30) NOT NULL
,   zee_date datetime
)

INSERT INTO
    @T
VALUES
    ('Franz Ferdinand', '1914-06-28')
,   ('Eamon de Valera', '1973-06-25')


SELECT T.* FROM @T T