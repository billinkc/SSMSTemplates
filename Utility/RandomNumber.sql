-- Integer range
SELECT
    FLOOR(RAND() * (<upper_bound, int, 10> - <lower_bound, int, 1> + 1)) + <lower_bound, int, 1>;

-- Decimal range
SELECT
    FLOOR(RAND() * (<upper_bound, int, 10> - <lower_bound, int, 1> + 1)) + <lower_bound, int, 1>;
