SELECT
    EMC.*
FROM
    catalog.event_message_context AS EMC
    INNER JOIN
    catalog.event_message_context AS AM
    ON AM.event_message_id = EMC.event_message_id
        AND AM.context_source_name = EMC.context_source_name
        AND AM.context_depth = EMC.context_depth
        AND AM.package_path = EMC.package_path
WHERE
    -- Assuming OLE DB Destination
    AM.property_name = 'AccessMode'
    -- Father forgive me for this join criteria
    AND EMC.property_name =
        CASE
            AM.property_value
                -- Need to validate these values, look approximate
                WHEN 0 THEN 'OpenRowset'
                WHEN 3 THEN 'OpenRowset'
                --WHEN 4 THEN ''
                ELSE 'OpenRowsetVariable'
        END 
    AND EMC.event_message_id IN
    (
        SELECT
            DISTINCT
            EM.event_message_id
        FROM
            catalog.event_messages AS EM
        WHERE
            -- if you know the specific operation/execution id, use it here
            --EM.operation_id = @id
            1=1
            AND EM.message_type = 120
    );
