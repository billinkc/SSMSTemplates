# SSMSTemplates
Template queries I use with SQL Server

Usage
---
If you have not already done so, open SQL Server Management Studio, SSMS, and click
View -> Template Explorer (Ctrl + Alt + T)

Doing that will create a version specific set of folders under app data Templates/Sql

Copy the contents of these folders into that path and then re-open SSMS as it only scans that folder when it opens (or if you manually create a new template)

Common (aka what I have installed) paths
---

Remember that if you're working with these paths from the command line, you will want to wrap them with double quotes as those spaces don't play nicely

- SSMS 2017 (140) Microsoft\SQL Server Management Studio\14.0\Template

- SSMS 18 %appdata%\Microsoft\SQL Server Management Studio\18.0\Templates\Sql

- SSMS 19 %appdata%\Microsoft\SQL Server Management Studio\19.0\Templates\Sql

Feeling bold?
---
DeployTemplates.bat will copy the folders into your path, assuming you've created the templates
