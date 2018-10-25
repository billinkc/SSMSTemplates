-- Don't forget indexing!
ALTER TABLE 
    <current_schema_name, sysname, dbo>.<current_table, sysname, FactShipment>
    ADD CONSTRAINT <contraint_name, sysname, fk_CurrentTableRefTable> 
    FOREIGN KEY 
    (
        <current_constraint_column_name,sysname,MyColumn1>
    )
    REFERENCES <reference_schema_name, sysname, dbo>.<reference_table,sysname,ReferenceTable>
    (
        <reference_constraint_column_name,sysname,MyColumn1>
    );
