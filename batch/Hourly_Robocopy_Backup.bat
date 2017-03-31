:: Description: Batch script for creating a Scheduled Task which will run 
::              another .bat file which does a robocopy command to make
::              incremental backups for the destination directory (and sub-directories).
::              The scheduled task is scheduled to run every hour.

:: Usage:	    Simply run this bat script and configure source and destination directories

:: Note:        If the source directory and sub-directories are very large 
::              the script can take a while to complete the first time.
::              After that it only does incremental backups and will normally run a lot quicker.

:: Author:	     Kim Eirik Kvassheim
:: Website:	     https://github.com/kek91

@echo off

title Setup Robocopy Backup
echo.
echo Configure hourly incremental backups with Robocopy and Task Scheduler
echo.

echo Step 1 - Configuration: Locations
echo.
set /p src=Source directory: 
set /p dest=Destination directory: 
(
echo cd %userprofile%\Desktop
echo robocopy "%src%" "%dest%" /E /W:1 /R:1 /XC /log+:"robocopy_log.txt"
)> %userprofile%\robocopy.bat

echo.
echo Step 2 - Creating Scheduled Task...
echo.
schtasks /create /tn "Robocopy Backup" /tr "%userprofile%\robocopy.bat" /SC HOURLY
echo.
echo Complete!
echo.

pause