:: Credit to ItsGotToMakeSense, from a Reddit post: https://www.reddit.com/r/usefulscripts/comments/5ec5ha/batch_a_script_to_view_the_wireless_ssids_and/
:: This is an enhanced version, adding multiple color functionality.

@echo off
setlocal EnableDelayedExpansion

:START
color 07
call :initColor
cls

title View wireless SSID list

::Display list of SSIDs stored in this computer and prompt user to choose one
Netsh wlan show profiles
Echo If you wish to view the security key for one of the above SSIDs,
Set /p SSID=enter its name here: 
echo.

::Detect whether the user's chosen SSID is in the list
Netsh wlan show profiles | find /i "%SSID%" > NUL || call :applyColor 47 "   Sorry, that SSID is not found.   " nossid

:VIEWKEY
::The below spacing is deliberately wide for readability of results when a security key is displayed
call :applyColor 27 "    SSID                   : %SSID%    "

::Display key content if available
netsh wlan show profile name="%SSID%" key=clear | find "Key Content" || call :applyColor 47 "  The security key is not found for this SSID.  " nokey
echo.
pause
echo.

::Give the user a chance to view another key
choice /c YN /m "Do you want to view another?"
If errorlevel 2 goto EXIT
If errorlevel 1 goto start

:EXIT
exit /b

:: Credit to Jeb for color conversion routine. See URL http://stackoverflow.com/questions/4339649/how-to-have-multiple-colors-in-a-windows-batch-file
:initColor
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)
<nul > X set /p ".=."
exit /b

:applyColor
set "param=^%~2" !
set "param=!param:"=\"!"
findstr /p /A:%1 "." "!param!\..\X" nul
<nul set /p ".=%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%"
del X
echo.
if "%3"=="nossid" pause & goto:start
if "%3"=="nokey" pause & goto:start
exit /b