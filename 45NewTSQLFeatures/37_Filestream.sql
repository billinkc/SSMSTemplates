-- 2008+
-- filestream

-- http://technet.microsoft.com/en-us/library/bb933993.aspx
-- http://www.sqlskills.com/blogs/paul/category/FILESTREAM.aspx
-- http://msdn.microsoft.com/en-us/library/cc949109.aspx
-- http://technet.microsoft.com/en-us/library/bb522469.aspx

-- It's ok database, you can do it
EXEC sp_configure filestream_access_level, 2
RECONFIGURE

-- Add a filegroup with type filestream

ALTER DATABASE
    FOURTY_FIVE
ADD
    FILEGROUP SomethingWitty
    CONTAINS FILESTREAM
GO

ALTER DATABASE
    FOURTY_FIVE
ADD FILE
(
    NAME= 'SomethingClever'
,   FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\FOURTY_FIVE_filestream.ndf'
)
TO FILEGROUP SomethingWitty
GO
