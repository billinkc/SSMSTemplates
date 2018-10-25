-- NTILE()
-- The NTILE function is the fourth of four windowing functions
-- introduced in SQL Server 2005. NTILE takes a different approach to
-- paritioning data. ROW_NUMBER, RANK and DENSE_RANK will generate
-- variable sized buckets of data based on the partition key(s). NTILE
-- attempts to split the data into equal, fixed size buckets. BOL has a
-- comprehensive page comparing the ranking functions if you want a quick
-- visual reference on their effects.
-- Syntax
-- The syntax for NTILE differs slightly from the other window functions.
-- It's NTILE(@BUCKET_COUNT) OVER ([PARTITION BY _] ORDER BY _) , where
-- @BUCKET_COUNT is a positive integer or bigint value. Using a fast
-- number generator calendar, I added a call to NTILE() based on event
-- date to introduce a rank column.

-- Example of using NTILE to split 30 numbers
-- into 10 and 4 equal sized buckets
SELECT
    GN.number
,   NTILE(10) OVER (ORDER BY GN.number) AS thirds
,   NTILE(4) OVER (ORDER BY GN.number) AS quartile
FROM
    dbo.GenerateNumbers(30) GN


-- What to notice
-- The, backwardsly named, thirds column was evenly partitioned with the
-- NTILE function. As expected, ten buckets were created and each hold 3
-- sets of numbers (3 * 10 = 30). Quartile column as expected was 4
-- buckets of 8, or is it 4 buckets of 7? 4 * 8 = 32; 4 * 7 = 28. Neither
-- is the correct answer. In cases where the rows can't be broken out
-- into even buckets, NTILE will fill from the top down so there is at
-- most a 1 count difference between the first and last bucket.
--
-- Availability
-- SQL Server 2005+