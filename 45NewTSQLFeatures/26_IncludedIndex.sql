http://msdn.microsoft.com/en-us/library/ms190806(v=SQL.90).aspx
-- included columns

-- this is a terrible index
CREATE INDEX inc
on dbo.AUTHORS (name_last)
INCLUDE(name_first)