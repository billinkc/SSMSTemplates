@echo off

REM These folders are intended to be copied into your SSMS templates folder. 
REM In theory, the batch file here should properly copy them but it's theoretical at this point.
REM Never trust code from the internet.


set sql18=%appdata%\Microsoft\SQL Server Management Studio\18.0\Templates\Sql
set sql19=%appdata%\Microsoft\SQL Server Management Studio\19.0\Templates\Sql
SET found=0

if exist "%sql18%" ( echo "Copying to %sql18%"
ROBOCOPY %~dp0 "%sql18%" *.sql /E
SET found=1
)

if exist "%sql19%" ( echo "Copying to %sql19%"
ROBOCOPY %~dp0 "%sql19%" *.sql /E
SET found=1
)

if %found% EQU 0 ECHO "No Templates folder found"

pause
