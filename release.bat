@echo off
setlocal

REM Define source and destination directories
set "SCRIPT_DIR=%~dp0"
set "SOURCE_DIR=%SCRIPT_DIR%build\Debug"
set "DEST_DIR=%SCRIPT_DIR%release"
set "ZIP_FILE=%SCRIPT_DIR%compressed"

REM Create the destination directory if it doesn't exist
if not exist "%DEST_DIR%" (
    mkdir "%DEST_DIR%"
)
rmdir "%DEST_DIR%"
mkdir "%DEST_DIR%"
REM Copy the required files from source to destination
copy "%SOURCE_DIR%\RT3DGE_Encoding.lib" "%DEST_DIR%\"
copy "%SOURCE_DIR%\RT3DGE_Encoding.dll" "%DEST_DIR%\"

REM Get the current timestamp in the format YYYYMMDD-HHMMSS
for /f "tokens=1-6 delims=.:/ " %%a in ("%date% %time%") do (
    set "YYYY=%%c"
    set "MM=%%a"
    set "DD=%%b"
    set "HH=%%d"
    set "MN=%%e"
    set "SS=%%f"
)
set "TIMESTAMP=%YYYY%%MM%%DD%-%HH%%MN%%SS%"

REM Check if PowerShell is available
where powershell >nul 2>&1
if errorlevel 1 (
    echo PowerShell is not installed or not in the PATH.
    exit /b 1
)

REM Create a zip file of the destination directory using PowerShell
mkdir "%ZIP_FILE%"
powershell -command "Compress-Archive -Path '%DEST_DIR%\*' -DestinationPath '%ZIP_FILE%\release-%TIMESTAMP%.zip' -Force"

REM Check if the zip file was created successfully
if exist "%ZIP_FILE%" (
    echo The files were successfully copied and zipped.
) else (
    echo There was an error creating the zip file.
    exit /b 1
)

endlocal
pause
exit /b 0
