USE DemoDb

/*
DBCC TRACEON(460)
DBCC TRACEOFF(460)
*/

DROP TABLE IF EXISTS dbo.SoB
CREATE TABLE dbo.SoB
(
	Col1 varchar(13)
,	Col2 varchar(19)
);

INSERT INTO
	dbo.SoB
SELECT
*
FROM
(
VALUES
( 'BB', 'BB' ), 
( 'CCC', 'CCC' ), 
( 'DDDD', 'DDDD' ), 
( 'EEEEE', 'EEEEE' ), 
( 'FFFFFF', 'FFFFFF' ), 
( 'GGGGGGG', 'GGGGGGG' ), 
( 'HHHHHHHH', 'HHHHHHHH' ), 
( 'IIIIIIIII', 'IIIIIIIII' ), 
( 'JJJJJJJJJJ', 'JJJJJJJJJJ' ), 
( 'KKKKKKKKKKK', 'KKKKKKKKKKK' ), 
( 'LLLLLLLLLLLL', 'LLLLLLLLLLLL' ), 
( 'MMMMMMMMMMMMM', 'MMMMMMMMMMMMM' ), 
( 'NNNNNNNNNNNNNN', 'NNNNNNNNNNNNNN' ), 
( 'OOOOOOOOOOOOOOO', 'OOOOOOOOOOOOOOO' ), 
( 'PPPPPPPPPPPPPPPP', 'PPPPPPPPPPPPPPPP' ), 
( 'QQQQQQQQQQQQQQQQQ', 'QQQQQQQQQQQQQQQQQ' ), 
( 'RRRRRRRRRRRRRRRRRR', 'RRRRRRRRRRRRRRRRRR' ), 
( 'SSSSSSSSSSSSSSSSSSS', 'SSSSSSSSSSSSSSSSSSS' ), 
( 'T', 'T' ), 
( 'UU', 'UU' ), 
( 'VVV', 'VVV' ), 
( 'WWWW', 'WWWW' ), 
( 'XXXXX', 'XXXXX' ), 
( 'YYYYYY', 'YYYYYY' ), 
( 'ZZZZZZZ', 'ZZZZZZZ' ), 
( 'AAAAAAAA', 'AAAAAAAA' ), 
( 'BBBBBBBBB', 'BBBBBBBBB' ), 
( 'CCCCCCCCCC', 'CCCCCCCCCC' ), 
( 'DDDDDDDDDDD', 'DDDDDDDDDDD' ), 
( 'EEEEEEEEEEEE', 'EEEEEEEEEEEE' ), 
( 'FFFFFFFFFFFFF', 'FFFFFFFFFFFFF' ), 
( 'GGGGGGGGGGGGGG', 'GGGGGGGGGGGGGG' ), 
( 'HHHHHHHHHHHHHHH', 'HHHHHHHHHHHHHHH' ), 
( 'IIIIIIIIIIIIIIII', 'IIIIIIIIIIIIIIII' ), 
( 'JJJJJJJJJJJJJJJJJ', 'JJJJJJJJJJJJJJJJJ' ), 
( 'KKKKKKKKKKKKKKKKKK', 'KKKKKKKKKKKKKKKKKK' ), 
( 'LLLLLLLLLLLLLLLLLLL', 'LLLLLLLLLLLLLLLLLLL' ), 
( 'M', 'M' ), 
( 'NN', 'NN' ), 
( 'OOO', 'OOO' ), 
( 'PPPP', 'PPPP' ), 
( 'QQQQQ', 'QQQQQ' ), 
( 'RRRRRR', 'RRRRRR' ), 
( 'SSSSSSS', 'SSSSSSS' ), 
( 'TTTTTTTT', 'TTTTTTTT' ), 
( 'UUUUUUUUU', 'UUUUUUUUU' ), 
( 'VVVVVVVVVV', 'VVVVVVVVVV' ), 
( 'WWWWWWWWWWW', 'WWWWWWWWWWW' ), 
( 'XXXXXXXXXXXX', 'XXXXXXXXXXXX' ), 
( 'YYYYYYYYYYYYY', 'YYYYYYYYYYYYY' ), 
( 'ZZZZZZZZZZZZZZ', 'ZZZZZZZZZZZZZZ' ), 
( 'AAAAAAAAAAAAAAA', 'AAAAAAAAAAAAAAA' ), 
( 'BBBBBBBBBBBBBBBB', 'BBBBBBBBBBBBBBBB' ), 
( 'CCCCCCCCCCCCCCCCC', 'CCCCCCCCCCCCCCCCC' ), 
( 'DDDDDDDDDDDDDDDDDD', 'DDDDDDDDDDDDDDDDDD' ), 
( 'EEEEEEEEEEEEEEEEEEE', 'EEEEEEEEEEEEEEEEEEE' ), 
( 'F', 'F' ), 
( 'GG', 'GG' ), 
( 'HHH', 'HHH' ), 
( 'IIII', 'IIII' ), 
( 'JJJJJ', 'JJJJJ' ), 
( 'KKKKKK', 'KKKKKK' ), 
( 'LLLLLLL', 'LLLLLLL' ), 
( 'MMMMMMMM', 'MMMMMMMM' ), 
( 'NNNNNNNNN', 'NNNNNNNNN' ), 
( 'OOOOOOOOOO', 'OOOOOOOOOO' ), 
( 'PPPPPPPPPPP', 'PPPPPPPPPPP' ), 
( 'QQQQQQQQQQQQ', 'QQQQQQQQQQQQ' ), 
( 'RRRRRRRRRRRRR', 'RRRRRRRRRRRRR' ), 
( 'SSSSSSSSSSSSSS', 'SSSSSSSSSSSSSS' ), 
( 'TTTTTTTTTTTTTTT', 'TTTTTTTTTTTTTTT' ), 
( 'UUUUUUUUUUUUUUUU', 'UUUUUUUUUUUUUUUU' ), 
( 'VVVVVVVVVVVVVVVVV', 'VVVVVVVVVVVVVVVVV' ), 
( 'WWWWWWWWWWWWWWWWWW', 'WWWWWWWWWWWWWWWWWW' ), 
( 'XXXXXXXXXXXXXXXXXXX', 'XXXXXXXXXXXXXXXXXXX' ), 
( 'Y', 'Y' ), 
( 'ZZ', 'ZZ' ), 
( 'AAA', 'AAA' ), 
( 'BBBB', 'BBBB' ), 
( 'CCCCC', 'CCCCC' ), 
( 'DDDDDD', 'DDDDDD' ), 
( 'EEEEEEE', 'EEEEEEE' ), 
( 'FFFFFFFF', 'FFFFFFFF' ), 
( 'GGGGGGGGG', 'GGGGGGGGG' ), 
( 'HHHHHHHHHH', 'HHHHHHHHHH' ), 
( 'IIIIIIIIIII', 'IIIIIIIIIII' ), 
( 'JJJJJJJJJJJJ', 'JJJJJJJJJJJJ' ), 
( 'KKKKKKKKKKKKK', 'KKKKKKKKKKKKK' ), 
( 'LLLLLLLLLLLLLL', 'LLLLLLLLLLLLLL' ), 
( 'MMMMMMMMMMMMMMM', 'MMMMMMMMMMMMMMM' ), 
( 'NNNNNNNNNNNNNNNN', 'NNNNNNNNNNNNNNNN' ), 
( 'OOOOOOOOOOOOOOOOO', 'OOOOOOOOOOOOOOOOO' ), 
( 'PPPPPPPPPPPPPPPPPP', 'PPPPPPPPPPPPPPPPPP' ), 
( 'QQQQQQQQQQQQQQQQQQQ', 'QQQQQQQQQQQQQQQQQQQ' ), 
( 'R', 'R' ), 
( 'SS', 'SS' ), 
( 'TTT', 'TTT' ), 
( 'UUUU', 'UUUU' ), 
( 'VVVVV', 'VVVVV' ), 
( 'WWWWWW', 'WWWWWW' ), 
( 'XXXXXXX', 'XXXXXXX' ), 
( 'YYYYYYYY', 'YYYYYYYY' ), 
( 'ZZZZZZZZZ', 'ZZZZZZZZZ' ), 
( 'AAAAAAAAAA', 'AAAAAAAAAA' ), 
( 'BBBBBBBBBBB', 'BBBBBBBBBBB' ), 
( 'CCCCCCCCCCCC', 'CCCCCCCCCCCC' ), 
( 'DDDDDDDDDDDDD', 'DDDDDDDDDDDDD' ), 
( 'EEEEEEEEEEEEEE', 'EEEEEEEEEEEEEE' ), 
( 'FFFFFFFFFFFFFFF', 'FFFFFFFFFFFFFFF' ), 
( 'GGGGGGGGGGGGGGGG', 'GGGGGGGGGGGGGGGG' ), 
( 'HHHHHHHHHHHHHHHHH', 'HHHHHHHHHHHHHHHHH' ), 
( 'IIIIIIIIIIIIIIIIII', 'IIIIIIIIIIIIIIIIII' ), 
( 'JJJJJJJJJJJJJJJJJJJ', 'JJJJJJJJJJJJJJJJJJJ' ), 
( 'K', 'K' ), 
( 'LL', 'LL' ), 
( 'MMM', 'MMM' ), 
( 'NNNN', 'NNNN' ), 
( 'OOOOO', 'OOOOO' ), 
( 'PPPPPP', 'PPPPPP' ), 
( 'QQQQQQQ', 'QQQQQQQ' )
)D(Col1, Col2)


--SELECT
--	REPLICATE(char(D.c), D.l)
--,	REPLICATE(char(D.c), D.l)
--FROM
--(
--	-- 1 to 120
--	SELECT TOP 120
--		65 + ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) % 26 AS c
--	,	1 + ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) % 19 AS l
--	FROM
--		sys.all_columns AS AC
--)D

/*
DROP TABLE IF EXISTS #SoB;
DECLARE @sql nvarchar(max) = (
SELECT
	CONCAT('CREATE TABLE #SoB ('
	,	STRING_AGG
		(
			CONCAT
			(
				'Col_'
			,	RIGHT(CONCAT('000' , D.rn), 3)
			,	' varchar('
			,	CAST((rn * RAND(rn)* 29) as int) % 67 +1
			,	')'
			)
		,	',' + CHAR(13)
		)
	,	')'
	,	';'
	)
FROM
	(
		SELECT TOP 100 ROW_NUMBER() OVER (ORDER BY(SELECT NULL))
		FROM
			sys.all_columns AS AC
	)D(rn)
);

PRINT @sql;
EXECUTE sys.sp_executesql @sql, N'';

-- Let's load it with data

--INSERT INTO #SoB

*/