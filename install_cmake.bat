@echo off
setlocal

:: Define the CMake version to install
set "CMAKE_VERSION=3.25.0"
set "CMAKE_ZIP=cmake-%CMAKE_VERSION%-windows-x86_64.zip"
set "CMAKE_DIR=cmake-%CMAKE_VERSION%-windows-x86_64"

:: Define the URL to download CMake
set "CMAKE_URL=https://github.com/Kitware/CMake/releases/download/v%CMAKE_VERSION%/%CMAKE_ZIP%"

:: Define the local directory to install CMake
set "INSTALL_DIR=%~dp0cmake"

:: Create the installation directory if it doesn't exist
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

:: Change to the installation directory
pushd "%INSTALL_DIR%"

:: Download CMake if it hasn't been downloaded already
if not exist "%CMAKE_ZIP%" (
    echo Downloading CMake %CMAKE_VERSION%...
    powershell -Command "Invoke-WebRequest -Uri %CMAKE_URL% -OutFile %CMAKE_ZIP%"
)

:: Unzip CMake if it hasn't been unzipped already
if not exist "%CMAKE_DIR%" (
    echo Extracting CMake...
    powershell -Command "Expand-Archive -Path %CMAKE_ZIP% -DestinationPath ."
)

:: Add CMake bin directory to PATH
set "CMAKE_BIN=%INSTALL_DIR%\%CMAKE_DIR%\bin"
set "PATH=%CMAKE_BIN%;%PATH%"

:: Verify the installation by checking the CMake version
echo Verifying CMake installation...
cmake --version

:: Cleanup
popd

echo CMake installation completed successfully.
endlocal
pause
