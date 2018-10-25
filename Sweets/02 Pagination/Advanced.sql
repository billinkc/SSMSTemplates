DECLARE
    @FETCHING TABLE
(
    fetching_id int identity(10,10) NOT NULL PRIMARY KEY
,   meta varchar(20) NOT NULL
)

INSERT INTO
    @FETCHING
VALUES
    ('Crunchie')
,   ('Lion')
,   ('Turkish Delight')
,   ('Taste')
,   ('Penguin')
,   ('Star Bar')
,   ('Dairy milk')
,   ('Moro')
,   ('Flake')
,   ('Timeout')
,	('Wispa')

DECLARE @count int;
SELECT @count = count(1) %3 FROM @FETCHING F;

SELECT
    F.*
FROM
    @FETCHING F
ORDER BY
    1
OFFSET @count ROWS
FETCH NEXT (SELECT month(CURRENT_TIMESTAMP)) ROWS ONLY;


