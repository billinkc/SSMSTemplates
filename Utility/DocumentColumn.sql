EXECUTE sys.sp_addextendedproperty
    @name = N'ColumnDocumentation'
,   @value = N'<description, nvarchar(4000),Placeholder text here>'
,   @level0type = N'Schema'
,   @level0name = '<current_schema_name, sysname, dbo>'
,   @level1type = N'Table'
,   @level1name = N'<current_table, sysname, FactShipment>'
,   @level2type = N'Column'
,   @level2name = N'<current_column, sysname, DateSk>';
