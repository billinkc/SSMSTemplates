DECLARE
    @log float = 2
,   @base float = 2.718281828

-- Let's graph it
-- http://en.wikipedia.org/wiki/Natural_logarithm
-- Not a perfect match but good enough for demo purpose

; WITH SRC (x_axis, y_axis) AS
(
SELECT
    D.x
,    LOG(D.x, @base)
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
    ,   (8.0)
    ) D (x)
)
-- Tip of the hat to Adam Machanic for the graph-o-matic code
-- http://sqlblog.com/blogs/adam_machanic/
SELECT
	geometry::STGeomFromText
	(
		'LINESTRING( ' +		
			STUFF
			(
				(
					SELECT
						',' + CONVERT(VARCHAR, p.x_axis) + ' ' + CONVERT(VARCHAR, p.y_axis)
					FROM
					(
						SELECT
							v.x_axis, 
							v.y_axis * factors.y_axis_scale_factor AS y_axis
						FROM SRC AS v
						CROSS JOIN
						(
							SELECT 
								((MAX(x_axis) - MIN(x_axis)) / (MAX(y_axis) - MIN(y_axis))) * 0.55 AS y_axis_scale_factor
							FROM SRC
						) AS factors
					) AS p
					FOR XML 
						PATH(''), 
						TYPE
				).value('.', 'VARCHAR(MAX)'),
				1,
				1,
				''
			) + 
		')', 
		0
	).STBuffer(q.STBuffer) AS shape
FROM
(
	SELECT
		((MAX(x_axis) - MIN(x_axis)) / 100) * 0.25 AS STBuffer
	FROM SRC
) AS q