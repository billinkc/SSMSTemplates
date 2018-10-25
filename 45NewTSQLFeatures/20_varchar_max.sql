DECLARE @mortals varchar(8000)
SET @mortals = REPLICATE('X', 8000)
SET @mortals = @mortals + 'X'
SELECT LEN(@mortals) AS mortal_length

SET @mortals = REPLICATE('X', 8001)
--SET @mortals = @mortals + 'X'
SELECT LEN(@mortals) AS mortal_length

-- 8000 characters is for mortals
DECLARE @vcm varchar(max)
-- Funny note, replicate only works up to 8000
SET @vcm = REPLICATE('X', 12000)
SET @vcm = @vcm + 'X'

SELECT LEN(@vcm) AS vcm_length, @vcm
