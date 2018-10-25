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

SELECT * FROM @FETCHING F ORDER BY 1

-- OFFSET 5 means skip the first 5 rows
SELECT
    F.*
FROM
    @FETCHING F
ORDER BY
    1
OFFSET 5 ROWS
FETCH NEXT 3 rows ONLY;


