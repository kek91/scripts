:: This script can be used to automate deployments to remote server.
:: Please note it requires pscp.exe as this is not included in Windows.
:: Path to pscp.exe is currently hardcoded in the functions.
:: Author: Kim Eirik Kvassheim
:: Website: https://github.com/kek91/scripts

@echo off
:: Uncomment line below (chcp 65001) if your paths use unicode characters
::chcp 65001
title DeploySCP
cls
set rootpw="INSERTPASSWORDHERE"

echo Deployment Script
echo.

:menu
echo.
echo ===================================================
echo Deployment options
echo 1) Deploy folder A (C:/projectA)
echo 2) Deploy folder B (C:/projectB)
echo 3) Deploy folder C (C:/projectC)
echo ===================================================
echo.
set /p option="Option > "

IF /i "%option%"=="1" (
    goto projecta
) ELSE (
    IF /i "%option%"=="2" (
    goto projectb
    ) ELSE (
        IF /i "%option%"=="3" (
        goto projectc
        ) ELSE (
            cls
            echo %option% is not a valid option.
            echo Please try again.
            echo.
            goto menu
        )
    )
)


:projecta
cls
echo Deploy project A
start "Deploy project A" "C:\Program Files (x86)\PuTTY\pscp.exe" -pw %rootpw% -r C:\projectA root@example.com:/var/www/html
echo Deployment complete
goto menu

:projectb
cls
echo Deploy project B
start "Deploy project B" "C:\Program Files (x86)\PuTTY\pscp.exe" -pw %rootpw% -r C:\projectB root@example.com:/var/www/html
echo Deployment complete
goto menu

:projectc
cls
echo Deploy project C
start "Deploy project C" "C:\Program Files (x86)\PuTTY\pscp.exe" -pw %rootpw% -r C:\projectC root@example.com:/var/www/html
echo Deployment complete
goto menu