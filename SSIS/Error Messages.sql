-- http://msdn.microsoft.com/en-us/library/ff877994.aspx
-- Find all error messages
SELECT
    OM.operation_message_id
,   OM.operation_id
,   OM.message_time
,   OM.message_type
,   OM.message_source_type
,   OM.message
,   OM.extended_info_id
FROM
    catalog.operation_messages AS OM
WHERE
    OM.message_type = 120;

-- Generate all the messages associated to failing operations
SELECT
    OM.operation_message_id
,   OM.operation_id
,   OM.message_time
,   OM.message_type
,   OM.message_source_type
,   OM.message
,   OM.extended_info_id
FROM
    catalog.operation_messages AS OM
    INNER JOIN
    (  
        -- Find failing operations
        SELECT DISTINCT
            OM.operation_id  
        FROM
            catalog.operation_messages AS OM
        WHERE
            OM.message_type = 120
    ) D
    ON D.operation_id = OM.operation_id;

-- Find all messages associated to the last failing run
SELECT
    OM.operation_message_id
,   OM.operation_id
,   OM.message_time
,   OM.message_type
,   OM.message_source_type
,   OM.message
,   OM.extended_info_id
FROM
    catalog.operation_messages AS OM
WHERE
    OM.operation_id = 
    (  
        -- Find the last failing operation
        -- lazy assumption that biggest operation
        -- id is last. Could be incorrect if a long
        -- running process fails after a quick process
        -- has also failed
        SELECT 
            MAX(OM.operation_id)
        FROM
            catalog.operation_messages AS OM
        WHERE
            OM.message_type = 120
    );
