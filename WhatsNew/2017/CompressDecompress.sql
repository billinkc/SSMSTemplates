SELECT
*
,   DECOMPRESS(D.gziped) AS NotSoFast
,   CAST(DECOMPRESS(D.gziped) AS nvarchar(max)) AS ApplyTyping
FROM
(
SELECT 
    COMPRESS(N'It looks like you''re giving a presentation...')
)D(gziped);