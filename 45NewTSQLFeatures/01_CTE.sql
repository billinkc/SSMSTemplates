-- This query introduces common table expressions (CTE)
;
WITH BORDER_STATES (state_name, abbreviation) AS
(
    SELECT 'IOWA', 'IA'
    UNION ALL SELECT 'NEBRASKA', 'NE'
    UNION ALL SELECT 'OKLAHOMA', 'OK'
    UNION ALL SELECT 'KANSAS', 'KS'
    UNION ALL SELECT 'ILLINOIS', 'IL'
    UNION ALL SELECT 'KENTUCKY', 'KY'
    UNION ALL SELECT 'TENNESSEE', 'TN'
)
, BEST_STATE AS
(
    SELECT 'MISSOURI' AS state_name, 'MO' AS state_abbreviation
)
, JOINED AS
(
    SELECT M.*, 1 AS state_rank FROM BEST_STATE M
    UNION
    SELECT BS.*, 2 AS state_rank FROM BORDER_STATES BS
)
SELECT * FROM JOINED
