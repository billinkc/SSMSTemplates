SELECT 
    *
,   HASHBYTES('SHA1', UQ.EntityJson) AS HashKey
,   HASHBYTES('SHA1', CK.ValuesJson) AS ChangeKey
FROM 
    master.dbo.spt_values AS SV
    CROSS APPLY
    (
        SELECT
            SV.name
        FOR JSON PATH, ROOT('pk'), INCLUDE_NULL_VALUES
    ) UQ(EntityJson)
    CROSS APPLY
    (
        SELECT
            SV.number
        ,   SV.type
        ,   SV.low
        ,   SV.high
        ,   SV.status
        FOR JSON PATH, ROOT('vals'), INCLUDE_NULL_VALUES
    )CK(ValuesJson);
