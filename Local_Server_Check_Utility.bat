@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Local Server Check Utility

color 0D
chcp 65001 >nul

set "REPORTROOT=%USERPROFILE%\Desktop\ServerReports"
if not exist "%REPORTROOT%" md "%REPORTROOT%" >nul 2>&1

:ASKHOST
cls
echo ============================================================
echo Local Server Check Utility
echo ============================================================
echo.
set /p TARGET="Enter server name or IP address: "
if "%TARGET%"=="" goto :ASKHOST

:MAIN
cls
echo ============================================================
echo Local Server Check Utility
echo ============================================================
echo.
echo Target: %TARGET%
echo Report Folder: %REPORTROOT%
echo.
echo [1] Ping check
echo [2] DNS lookup
echo [3] Reverse DNS lookup
echo [4] Trace route
echo [5] SMB port 445 check
echo [6] RDP port 3389 check
echo [7] WinRM port 5985 check
echo [8] HTTPS port 443 check
echo [9] HTTP port 80 check
echo [A] SQL port 1433 check
echo [B] Net view check
echo [C] Full check
echo [D] Change target
echo [E] Create report
echo [F] Open report folder
echo [0] Exit
echo.
set /p CHO="Selection: "

if "%CHO%"=="1" goto :PING
if "%CHO%"=="2" goto :DNS
if "%CHO%"=="3" goto :REVDNS
if "%CHO%"=="4" goto :TRACE
if "%CHO%"=="5" goto :PORT445
if "%CHO%"=="6" goto :PORT3389
if "%CHO%"=="7" goto :PORT5985
if "%CHO%"=="8" goto :PORT443
if "%CHO%"=="9" goto :PORT80
if /I "%CHO%"=="A" goto :PORT1433
if /I "%CHO%"=="B" goto :NETVIEW
if /I "%CHO%"=="C" goto :FULL
if /I "%CHO%"=="D" goto :ASKHOST
if /I "%CHO%"=="E" goto :REPORT
if /I "%CHO%"=="F" goto :OPENFOLDER
if "%CHO%"=="0" goto :END
goto :MAIN

:PING
cls
echo ============================================================
echo Ping check
echo ============================================================
echo.
ping %TARGET%
echo.
pause
goto :MAIN

:DNS
cls
echo ============================================================
echo DNS lookup
echo ============================================================
echo.
nslookup %TARGET%
echo.
pause
goto :MAIN

:REVDNS
cls
echo ============================================================
echo Reverse DNS lookup
echo ============================================================
echo.
for /f "tokens=2 delims=[]" %%I in ('ping -n 1 %TARGET% ^| findstr /I "["') do set "RESOLVEDIP=%%I"
if defined RESOLVEDIP (
  nslookup !RESOLVEDIP!
) else (
  echo Could not resolve target IP for reverse lookup.
)
echo.
pause
goto :MAIN

:TRACE
cls
echo ============================================================
echo Trace route
echo ============================================================
echo.
tracert %TARGET%
echo.
pause
goto :MAIN

:PORT445
cls
echo ============================================================
echo SMB port 445 check
echo ============================================================
echo.
powershell -NoProfile -ExecutionPolicy Bypass -Command "Test-NetConnection -ComputerName '%TARGET%' -Port 445"
echo.
pause
goto :MAIN

:PORT3389
cls
echo ============================================================
echo RDP port 3389 check
echo ============================================================
echo.
powershell -NoProfile -ExecutionPolicy Bypass -Command "Test-NetConnection -ComputerName '%TARGET%' -Port 3389"
echo.
pause
goto :MAIN

:PORT5985
cls
echo ============================================================
echo WinRM port 5985 check
echo ============================================================
echo.
powershell -NoProfile -ExecutionPolicy Bypass -Command "Test-NetConnection -ComputerName '%TARGET%' -Port 5985"
echo.
pause
goto :MAIN

:PORT443
cls
echo ============================================================
echo HTTPS port 443 check
echo ============================================================
echo.
powershell -NoProfile -ExecutionPolicy Bypass -Command "Test-NetConnection -ComputerName '%TARGET%' -Port 443"
echo.
pause
goto :MAIN

:PORT80
cls
echo ============================================================
echo HTTP port 80 check
echo ============================================================
echo.
powershell -NoProfile -ExecutionPolicy Bypass -Command "Test-NetConnection -ComputerName '%TARGET%' -Port 80"
echo.
pause
goto :MAIN

:PORT1433
cls
echo ============================================================
echo SQL port 1433 check
echo ============================================================
echo.
powershell -NoProfile -ExecutionPolicy Bypass -Command "Test-NetConnection -ComputerName '%TARGET%' -Port 1433"
echo.
pause
goto :MAIN

:NETVIEW
cls
echo ============================================================
echo Net view check
echo ============================================================
echo.
net view \\%TARGET%
echo.
pause
goto :MAIN

:FULL
cls
echo ============================================================
echo Full check
echo ============================================================
echo.
echo [1/10] Ping check
ping %TARGET%
echo.
echo [2/10] DNS lookup
nslookup %TARGET%
echo.
echo [3/10] Reverse DNS lookup
set "RESOLVEDIP="
for /f "tokens=2 delims=[]" %%I in ('ping -n 1 %TARGET% ^| findstr /I "["') do set "RESOLVEDIP=%%I"
if defined RESOLVEDIP (
  nslookup !RESOLVEDIP!
) else (
  echo Could not resolve target IP for reverse lookup.
)
echo.
echo [4/10] Trace route
tracert %TARGET%
echo.
echo [5/10] SMB port 445 check
powershell -NoProfile -ExecutionPolicy Bypass -Command "Test-NetConnection -ComputerName '%TARGET%' -Port 445"
echo.
echo [6/10] RDP port 3389 check
powershell -NoProfile -ExecutionPolicy Bypass -Command "Test-NetConnection -ComputerName '%TARGET%' -Port 3389"
echo.
echo [7/10] WinRM port 5985 check
powershell -NoProfile -ExecutionPolicy Bypass -Command "Test-NetConnection -ComputerName '%TARGET%' -Port 5985"
echo.
echo [8/10] HTTPS port 443 check
powershell -NoProfile -ExecutionPolicy Bypass -Command "Test-NetConnection -ComputerName '%TARGET%' -Port 443"
echo.
echo [9/10] HTTP port 80 check
powershell -NoProfile -ExecutionPolicy Bypass -Command "Test-NetConnection -ComputerName '%TARGET%' -Port 80"
echo.
echo [10/10] SQL port 1433 check
powershell -NoProfile -ExecutionPolicy Bypass -Command "Test-NetConnection -ComputerName '%TARGET%' -Port 1433"
echo.
pause
goto :MAIN

:REPORT
cls
echo [*] Creating report...
echo.
for /f %%I in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HH-mm-ss"') do set STAMP=%%I
set "SAFEHOST=%TARGET::=-%"
set "SAFEHOST=%SAFEHOST:/=-%"
set "SAFEHOST=%SAFEHOST:\=-%"
set "OUTFILE=%REPORTROOT%\Server_Check_%SAFEHOST%_%STAMP%.txt"

(
echo ============================================================
echo Local Server Check Report
echo ============================================================
echo Date: %DATE% %TIME%
echo Computer: %COMPUTERNAME%
echo User: %USERNAME%
echo Target: %TARGET%
echo ============================================================
echo.

echo [1] Ping check
ping %TARGET%
echo.

echo [2] DNS lookup
nslookup %TARGET%
echo.

echo [3] Reverse DNS lookup
set "RESOLVEDIP="
for /f "tokens=2 delims=[]" %%I in ('ping -n 1 %TARGET% ^| findstr /I "["') do set "RESOLVEDIP=%%I"
if defined RESOLVEDIP (
  nslookup !RESOLVEDIP!
) else (
  echo Could not resolve target IP for reverse lookup.
)
echo.

echo [4] Trace route
tracert %TARGET%
echo.

echo [5] SMB port 445 check
powershell -NoProfile -ExecutionPolicy Bypass -Command "Test-NetConnection -ComputerName '%TARGET%' -Port 445"
echo.

echo [6] RDP port 3389 check
powershell -NoProfile -ExecutionPolicy Bypass -Command "Test-NetConnection -ComputerName '%TARGET%' -Port 3389"
echo.

echo [7] WinRM port 5985 check
powershell -NoProfile -ExecutionPolicy Bypass -Command "Test-NetConnection -ComputerName '%TARGET%' -Port 5985"
echo.

echo [8] HTTPS port 443 check
powershell -NoProfile -ExecutionPolicy Bypass -Command "Test-NetConnection -ComputerName '%TARGET%' -Port 443"
echo.

echo [9] HTTP port 80 check
powershell -NoProfile -ExecutionPolicy Bypass -Command "Test-NetConnection -ComputerName '%TARGET%' -Port 80"
echo.

echo [10] SQL port 1433 check
powershell -NoProfile -ExecutionPolicy Bypass -Command "Test-NetConnection -ComputerName '%TARGET%' -Port 1433"
echo.

echo [11] Net view check
net view \\%TARGET%
echo.

) > "%OUTFILE%" 2>&1

echo Report created:
echo %OUTFILE%
echo.
pause
goto :MAIN

:OPENFOLDER
start "" explorer.exe "%REPORTROOT%"
goto :MAIN

:END
endlocal
exit /b
