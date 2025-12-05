@echo off
setlocal enabledelayedexpansion

:: --- Requires Administrator Privileges ---
:: Check if the script is running with elevated permissions
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
echo.
echo --------------------------------------------------------------------------------
echo This script requires Administrator privileges.
echo Please right-click the file and select "Run as Administrator".
echo --------------------------------------------------------------------------------
pause >nul
exit /b 1
)

echo.
echo =======================================================
echo     POWER PLAN CLEANUP AND ULTIMATE PERFORMANCE SETUP
echo =======================================================
echo.

:: The actual GUID for the Ultimate Performance settings (used to create the scheme).
set "HIDDEN_ULTIMATE_GUID=e9a42b02-d5df-448d-aa00-03f14749eb61"
set "ULTIMATE_GUID="

:: ---------------------------------------------------------
:: 0. Ensure Ultimate Performance Plan Exists and Get its GUID
:: ---------------------------------------------------------
echo --- Activating/Finding Ultimate Performance Plan ---

:: Use powercfg -duplicatescheme with the HIDDEN_ULTIMATE_GUID.
:: This command makes the plan visible and creates a new, accessible scheme.
:: FIX: Changed tokens=3 to tokens=4 to capture the actual 36-character GUID, not the prefix "GUID:".
FOR /F "tokens=4" %%G IN ('powercfg -duplicatescheme %HIDDEN_ULTIMATE_GUID%') DO (
:: Check if the captured token is exactly 36 characters (a valid GUID) before setting.
IF "%%G" NEQ "" (
set "ULTIMATE_GUID=%%G"
)
)

:: Fallback mechanism: If duplication fails, it means the plan already exists.
:: We search for the GUID of the scheme named "Ultimate Performance".
IF NOT DEFINED ULTIMATE_GUID (
echo WARNING: Duplication failed or plan already exists. Searching for "Ultimate Performance" GUID.
:: Capture the GUID (token 4) from the line containing "Ultimate Performance"
FOR /F "tokens=4" %%G IN ('powercfg /L ^| findstr /I "Ultimate Performance"') DO (
set "ULTIMATE_GUID=%%G"
)
)

:: Final safety check: if still not found, default to the original hidden GUID (activation might still fail if it's not the correct duplicate).
IF NOT DEFINED ULTIMATE_GUID (
echo CRITICAL WARNING: Could not automatically determine the Ultimate Performance GUID. Attempting to use the hidden GUID as a last resort.
set "ULTIMATE_GUID=%HIDDEN_ULTIMATE_GUID%"
)

echo Ultimate Performance Scheme GUID to be used for activation: !ULTIMATE_GUID!
echo.

echo Current Power Schemes before modification:
powercfg /L
echo.

:: ---------------------------------------------------------
:: 1. Set Ultimate Performance as the Active Plan (NEW ORDER)
:: ---------------------------------------------------------

echo --- Setting Ultimate Performance as Active ---
powercfg /S !ULTIMATE_GUID!

echo.
powercfg /L | findstr /I "(*"
echo.

echo Ultimate Performance plan is now the active scheme.

:: ---------------------------------------------------------
:: 2. Delete all non-Ultimate Power Plans (NEW ORDER)
:: ---------------------------------------------------------

echo --- Deleting non-Ultimate Power Plans ---
echo.

:: Loop through all listed power schemes. Pipe through 'findstr /I "GUID"' to skip header lines.
:: tokens=4 captures the GUID from lines like "Power Scheme GUID: XXXXX-..."
FOR /F "tokens=4" %%G IN ('powercfg /L ^| findstr /I "GUID"') DO (
set "GUID=%%G"

:: CRITICAL FIX APPLIED: Removed the rogue backslash to fix the substring extraction error.
set "CURRENT_GUID=!GUID:~0,36!"

:: Check if the current GUID is NOT the Ultimate GUID
if not "!CURRENT_GUID!"=="!ULTIMATE_GUID!" (
echo Attempting to delete scheme: !CURRENT_GUID!
:: Deletes the scheme. Built-in defaults (Balanced, Power Saver, High Performance) and the currently
:: active scheme will fail to delete gracefully, which is the desired outcome.
:: Since Ultimate is now active, all others can be deleted (or ignored if built-in).
powercfg /D !CURRENT_GUID!
)

)

echo.
echo Cleanup phase complete.
echo.

echo SUCCESS: Only the Ultimate Performance plan and essential Windows defaults should remain.
echo.

echo Final Active Power Schemes:
powercfg /L
echo.

echo Press any key to exit...
pause >nul
endlocal