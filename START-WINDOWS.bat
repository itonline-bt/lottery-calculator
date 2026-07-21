@echo off
setlocal
cd /d "%~dp0"
title Lottery Calculator - local server
set PORT=8777

echo.
echo   =========================================
echo    Lottery Calculator
echo    http://localhost:%PORT%/index.html
echo   =========================================
echo   Close this window to stop the server.
echo.

where py >nul 2>nul
if not errorlevel 1 goto usepy

where python >nul 2>nul
if not errorlevel 1 goto usepython

where node >nul 2>nul
if not errorlevel 1 goto usenode

goto useps

:usepy
start "" "http://localhost:%PORT%/index.html"
py -m http.server %PORT%
goto end

:usepython
start "" "http://localhost:%PORT%/index.html"
python -m http.server %PORT%
goto end

:usenode
start "" "http://localhost:%PORT%/index.html"
npx --yes http-server -p %PORT% -c-1 .
goto end

:useps
echo   Python / Node not found - using built-in PowerShell server.
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0server.ps1"
if errorlevel 1 (
  echo.
  echo   Server could not start.
  echo   Alternative: open index.html in Chrome, then
  echo   Menu  ..  Cast, save and share  ..  Create shortcut
  echo   and tick "Open as window".
  echo.
  pause
)

:end
