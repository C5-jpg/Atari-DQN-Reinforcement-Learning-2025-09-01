@echo off
echo ========================================
echo Installing CUDA 11.8 Toolkit
echo ========================================
echo.

cd /d %~dp0\..

if not exist "cuda\cuda_11.8.0_522.06_windows.exe" (
    echo ERROR: CUDA installer not found at cuda\cuda_11.8.0_522.06_windows.exe
    echo Please ensure the CUDA installer is present.
    pause
    exit /b 1
)

echo Installing CUDA Toolkit 11.8...
echo This may take 10-15 minutes. Please wait...
echo.

REM Install CUDA with silent flags
cuda\cuda_11.8.0_522.06_windows.exe -s -noreboot -noexecutefile -nofinishpage

if %errorlevel% neq 0 (
    echo ERROR: CUDA installation failed with error code %errorlevel%
    echo Please check the installation logs and try again.
    pause
    exit /b 1
)

echo.
echo CUDA installation completed successfully!

REM Verify CUDA installation
echo Verifying CUDA installation...
if exist "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v11.8\bin\nvcc.exe" (
    echo CUDA binaries found at expected location.
) else (
    echo WARNING: CUDA binaries not found at expected location.
    echo Please check if installation completed properly.
)

REM Add CUDA to PATH for current session
set "CUDA_HOME=C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v11.8"
set "PATH=%CUDA_HOME%\bin;%PATH%"

echo.
echo Testing CUDA installation...
nvcc --version >nul 2>&1
if %errorlevel% equ 0 (
    echo CUDA compiler (nvcc) is working correctly.
    nvcc --version | find "release 11.8"
) else (
    echo WARNING: CUDA compiler test failed.
    echo This might be normal if PATH hasn't been refreshed yet.
)

echo.
echo CUDA 11.8 installation completed.
echo A system restart may be required for all changes to take effect.
echo.
