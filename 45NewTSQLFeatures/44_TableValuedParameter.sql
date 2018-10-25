-- Table Valued Parameter
-- With the table type introduced in SQL Server 2008, programming got a lot more interesting.
-- Previously to load many rows into the database, one was looking at tools like BCP or RBAR
-- inserts into a staging table or a number of different means.  TVPs have made my life far
-- more enjoyable.
--
CREATE PROCEDURE dbo.AuthorWontAdd
(
    @tvp dbo.AuthorsTableType READONLY
)
AS
BEGIN
    SET NOCOUNT ON

    -- Smart people would use the MERGE statement
    -- and never use implicit column positions
    -- Only add the new people (based on name matching, yet another bad practice)
    INSERT INTO
        dbo.AUTHORS
    SELECT
        T.firstName
    ,   T.lastName
    FROM
        @tvp T
        LEFT OUTER JOIN
            dbo.AUTHORS A
            ON A.name_last = T.lastName
            AND coalesce(A.name_first, '') = coalesce(T.firstName, '')
    WHERE
        A.author_id IS NULL

    -- Attempt to assign back to our table type
    -- The table-valued parameter "@tvp" is READONLY and cannot be modified.
    -- Compiler knows that b/c of the READONLY above
    -- Failure to use READONLY will result in
    -- The table-valued parameter "@tvp" must be declared with the READONLY option.
    UPDATE
        T
    SET
        authorId = A.author_id
    FROM
        @tvp T
        INNER JOIN
            dbo.AUTHORS A
            ON A.name_last = T.lastName
            AND coalesce(A.name_first, '') = coalesce(T.firstName, '')

    -- return the resultset
    SELECT * FROM @tvp
END
GO


IF EXISTS
(
    SELECT
        SO.*
    FROM
        dbo.sysobjects SO
    WHERE
        SO.id = OBJECT_ID('dbo.AuthorAdd')
        AND OBJECTPROPERTY(SO.id, 'IsProcedure') = 1
)
BEGIN
    PRINT 'Dropping stored procedure dbo.AuthorAdd'
    DROP PROCEDURE dbo.AuthorAdd
END
GO
CREATE PROCEDURE dbo.AuthorAdd
(
    @tvp dbo.AuthorsTableType READONLY
)
AS
BEGIN
    SET NOCOUNT ON

    -- Smart people would use the MERGE statement
    -- and never use implicit column positions
    -- Only add the new people (based on name matching, yet another bad practice)
    INSERT INTO
        dbo.AUTHORS
    SELECT
        T.firstName
    ,   T.lastName
    FROM
        @tvp T
        LEFT OUTER JOIN
            dbo.AUTHORS A
            ON A.name_last = T.lastName
            AND coalesce(A.name_first, '') = coalesce(T.firstName, '')
    WHERE
        A.author_id IS NULL

    SELECT
        T.firstName
    ,   T.lastName
    ,   A.author_id AS authorId
    ,   T.mod_date
    ,   T.mod_user
    ,   T.monotomicallyIncreasingNumber
    FROM
        @tvp T
        INNER JOIN
            dbo.AUTHORS A
            ON A.name_last = T.lastName
            AND coalesce(A.name_first, '') = coalesce(T.firstName, '')

END
GO

-- See how easy it is to use it!

DECLARE @goodAuthors dbo.AuthorsTableType

-- load them up as normal table-like object

-- use a table value constructor
INSERT INTO
    @goodAuthors
(
    firstName
,   lastName
)
VALUES
    ('John', 'Steinbeck')
,   ('Honore', 'de Balzac')
,   ('Joyce Carol', 'Oates')

EXECUTE dbo.AuthorAdd @goodAuthors

-- That's all well and good, but here's why developers will
-- love it

/*
namespace Sample
{
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Data.SqlClient;
    using System.Linq;
    using System.Text;

    public class Program
    {
        static void Main(string[] args)
        {
            string connectionString = string.Empty;
            DataSet sampleDataSet = null;
            // PFM here, best left to developers
            sampleDataSet = FakeTheFunk();

            StageData(sampleDataSet, connectionString);
        }

        /// <summary>
        /// This is a simple demo of how one would pass a dataset to a stored
        /// procedure in C#
        /// </summary>
        /// <param name="stuff">A dataset</param>
        /// <param name="connectionString"></param>
        public static void StageData(DataSet stuff, string connectionString)
        {
            SqlConnection connection = null;
            string methodName = "dbo.AuthorAdd";
            SqlCommand command = null;
            SqlDataReader dataReader = null;
            connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                command = new SqlCommand(methodName);
                command.CommandType = CommandType.StoredProcedure;
                command.Connection = connection;

                SqlParameter tvp = command.Parameters.AddWithValue("@tvp", stuff.Tables[0]);
                tvp.SqlDbType = SqlDbType.Structured;

                dataReader = command.ExecuteReader();
            }
            catch (Exception ex)
            {
                Console.WriteLine(string.Format("Failed to write data to staging tables {0}", ex));
            }
        }

        /// <summary>
        /// Load up a dataset using your favorite mechanism
        /// </summary>
        /// <returns>A pretty dataset</returns>
        public static DataSet FakeTheFunk()
        {
            DataSet ds = null;
            DataTable dt = null;
            // Set up the structure
            dt = new System.Data.DataTable("tableType", "tableNamespace");
            dt.Columns.Add("firstName", System.Type.GetType("System.String"));
            dt.Columns.Add("lastName", System.Type.GetType("System.String"));
            dt.Columns.Add("authorId", System.Type.GetType("System.Int32"));
            dt.Columns.Add("mod_date", System.Type.GetType("System.DateTime"));
            dt.Columns.Add("mod_user", System.Type.GetType("System.String"));
            dt.Columns.Add("monotomicallyIncreasingNumber", System.Type.GetType("System.Int32"));

            // gin up some rows
            DataRow dr = null;

            dr = dt.NewRow();
            dr[0] = "Langston";
            dr[1] = "Hughes";
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr[0] = "Judy";
            dr[1] = "Blume";
            dt.Rows.Add(dr);

            ds = new DataSet();
            ds.Tables.Add(dt);

            return ds;
        }
    }
}
*/



