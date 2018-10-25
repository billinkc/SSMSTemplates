-- 2008+
-- Merge, aka upsert.  Handles inserts, updates and deletes
-- in a single statement

CREATE PROCEDURE
    stage.PublishAll
AS
BEGIN
    SET NOCOUNT ON

    -- these tables aren't the best example as
    -- there are only two columns available

    MERGE
        live.WORKS AS T
    USING
    (
        SELECT
            [message_text]
        ,   [author_id]
        FROM
            stage.WORKS
    ) AS S
    ON
    (
        T.[message_text] = S.[message_text]
        AND T.[author_id] = S.[author_id]
    )
    WHEN
        MATCHED THEN
        UPDATE
        SET
            T.[message_text] = S.[message_text]
        ,   T.[author_id] = S.[author_id]
    WHEN
        NOT MATCHED THEN
        INSERT
        (
            [message_text]
        ,   [author_id]
        )
        VALUES
        (
            [message_text]
        ,   [author_id]
        );

END
GO
