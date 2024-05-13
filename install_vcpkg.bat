@echo off
setlocal
set VCPKG_DIR=%~dp0vcpkg
set VCPKG_REPO=https://github.com/microsoft/vcpkg
set VCPKG_BRANCH=master
if not exist %VCPKG_DIR% (
    echo Cloning vcpkg...
    git clone %VCPKG_REPO% %VCPKG_DIR%
)
cd %VCPKG_DIR%
echo Checking out vcpkg branch...
git checkout %VCPKG_BRANCH%
echo Bootstrapping vcpkg...
bootstrap-vcpkg.bat
echo Installing dependencies...
vcpkg install
cd %~dp0
echo vcpkg installation and dependency installation complete.
endlocal
