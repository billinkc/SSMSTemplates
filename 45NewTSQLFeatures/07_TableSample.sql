-- TableSample
-- Tablesample is a hint to SQL Server to just grab some rows. Which
-- rows? If you're asking "which rows", tablesample isn't for you. No,
-- tablesample is a hint to SQL Server that you're in a lascivious mood
-- and you just want some data now. It's clean data, no dirty reads but
-- you might get some really odd, inconsistent results if you try to do
-- things like apply filtering. Best use I've found so far is quasi-
-- psuedo-random sampling of data. It's not random enough for true random
-- so don't treat it as such but if you just want a drink of the data in
-- the table, it's probably "good enough," assuming you remember the
-- syntax.

-- The TABLESAMPLE clause is a different sort of animal. Conceptually,
-- one may think it's nothing more than an ugly synonym for TOP or LIMIT,
-- if you're using a different RDBMS vendor. However, from a query
-- processing perspective, TOP can't run until after the query has been
-- run through the wringer which for large tables might negate any
-- performance savings. At least based on my chapter 1 understanding of
-- logical query processing. It's an odd duck because it either includes
-- a page of information or it doesn't. The query plan will always
-- indicate it's a table scan but it will only read from disk if the
-- selected pages, something something. At this point, read the BOL
-- article above because we are unfortunately way beyond my SQL Server
-- knowledge zone.
-- Calls to tablesample can either be deterministic or non-
-- deterministic based on whether the REPEATABLE option is used. Activity
-- in the database that affects data pages may also affect the
-- deterministic-ness of your REPEATABLE option. These activities include
-- "inserting, updating, deleting, index rebuilding, index defragmenting,
-- restoring a database, and attaching a database" Consult your DBA if
-- you experience eye watering, mouth watering, flower watering or if
-- your queries last for more than 4 hours.

-- Syntax
-- TABLESAMPLE is a clause in your FROM statement. From BOL, the
-- syntax is TABLESAMPLE [SYSTEM] (sample_number [ PERCENT | ROWS ])
-- [REPEATABLE (repeat_seed)]. As tablesample requires real tables, none
-- of the jiggered up examples I have used thus far will work. Rather
-- than forcing you to have adventureworks installed, I figured querying
-- against master.dbo.spt_values seemed a safe table to assume will exist
-- on your machine. What I wasn't ready for, was seeing the caveat about
-- pages of data and maybe you won't get anything back. The other
-- surprise was just how variable "10 rows" can be in result sets. In the
-- handful of times I reran, I saw sets ranging from empty, to 47 to 149.
-- Changing it from rows to percent didn't really dial back the
-- variability like I'd have thought based on this statement in BOL "When
-- a number of rows is specified, instead of a percentage based on the
-- total number of rows in the table, that number is converted into a
-- percentage of the rows and, therefore, pages that should be returned.
-- The TABLESAMPLE operation is then performed with that computed
-- percentage." I still saw some pretty big swings from 0 to 61 to 358
-- rows.
-- 

SELECT COUNT(1) rc FROM master.dbo.spt_values T


SELECT * FROM master.dbo.spt_values T tablesample (10 rows)


-- What to notice
-- The rows or percentage supplied to TABLESAMPLE has some fairly wild
-- variability based on table width and how it physically got laid onto
-- disk. If you need to provide an upper bound to that variability, use
-- tablesample with TOP. Don't trust REPEATABLE unless you are working
-- against a read-only database.
-- 
-- Availability
-- SQL Server 2005+
