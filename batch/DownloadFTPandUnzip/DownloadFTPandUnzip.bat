:: Story

:: We had to set up a scheduled task to download a zip file from
:: a FTP server every day, and then overwrite the existing file.

:: The zip filename was dynamically updated with the current date
:: so this script mainly does 3 things:
:: 1 - generate file name based on todays date
:: 2 - connect to ftp and download file
:: 3 - unzip the archive and clean the temp files



@echo off
title DownloadFTPandUnzip

:: Generate filename based on todays date
FOR /F "TOKENS=1* DELIMS= " %%A IN ('DATE/T') DO SET CDATE=%%B
FOR /F "TOKENS=1,2 eol=/ DELIMS=/ " %%A IN ('DATE/T') DO SET mm=%%B
FOR /F "TOKENS=1,2 DELIMS=/ eol=/" %%A IN ('echo %CDATE%') DO SET dd=%%B
FOR /F "TOKENS=2,3 DELIMS=/ " %%A IN ('echo %CDATE%') DO SET yyyy=%%B
SET date=%dd%-%mm%-%yyyy%
SET filename=Archive_%date%.zip

:: Create FTP commands and export to temp file
echo user FTPUSERNAME FTPPASSWORD>ftp.ftp
echo get "/path/to/%filename%" "C:\temp\%filename%">>ftp.ftp
echo bye>>ftp.ftp

:: Connect to FTP server and issue the commands
@ftp -n -s:ftp.ftp sftp.example.com

:: Overwrite existing file
if exist "\\server\destination\file.nwd" (
	del "\\server\destination\file.nwd"
)

:: Exctract the ZIP file
setlocal
cd /d %~dp0
Call :UnZipFile "\\server\destination" "C:\temp\%filename%"

:: Clean temp files
del "C:\temp\%filename%"
del "ftp.ftp"

:: Done
exit /b

:: Unzip, source: http://stackoverflow.com/a/21709923/3492590
:UnZipFile <ExtractTo> <newzipfile>
set vbs="unzip.vbs"
if exist %vbs% del /f /q %vbs%
>%vbs%  echo Set fso = CreateObject("Scripting.FileSystemObject")
>>%vbs% echo If NOT fso.FolderExists(%1) Then
>>%vbs% echo fso.CreateFolder(%1)
>>%vbs% echo End If
>>%vbs% echo set objShell = CreateObject("Shell.Application")
>>%vbs% echo set FilesInZip=objShell.NameSpace(%2).items
>>%vbs% echo objShell.NameSpace(%1).CopyHere(FilesInZip)
>>%vbs% echo Set fso = Nothing
>>%vbs% echo Set objShell = Nothing
cscript //nologo %vbs%
if exist %vbs% del /f /q %vbs%