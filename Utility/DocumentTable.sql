EXECUTE sys.sp_addextendedproperty
    @name = N'TableDocumentation'
,   @value = N'<description, nvarchar(4000),Placeholder text here>'
,   @level0type = N'Schema'
,   @level0name = '<current_schema_name, sysname, dbo>'
,   @level1type = N'Table'
,   @level1name = N'<current_table, sysname, FactShipment>';
