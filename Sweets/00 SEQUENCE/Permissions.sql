-- Permissions for manipulation of sequence object
-- http://msdn.microsoft.com/en-us/library/ff877867(v=sql.110).aspx
--CREATE SEQUENCE, ALTER, or CONTROL permission on the SCHEMA
GRANT 
	CREATE SEQUENCE 
	ON SCHEMA::dbo 
	TO [public];

GRANT
	ALTER
	ON SCHEMA::dbo
	TO [public];

GRANT
	CONTROL
	ON SCHEMA::dbo
	TO [public];

-- Permissions to use the sequence object
-- http://msdn.microsoft.com/en-us/library/ff878370(v=sql.110).aspx
GRANT 
	UPDATE 
	ON OBJECT::dbo.ASCIISequence 
	TO [public];
