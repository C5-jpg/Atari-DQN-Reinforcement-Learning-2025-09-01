@echo off
echo ========================================
echo Installing cuDNN 8.9.7
echo ========================================
echo.

cd /d %~dp0\..

if not exist "cuda\cudnn-8.9.7-windows-x86_64_v8.9.7.29.zip" (
    echo ERROR: cuDNN archive not found at cuda\cudnn-8.9.7-windows-x86_64_v8.9.7.29.zip
    echo Please ensure the cuDNN archive is present.
    pause
    exit /b 1
)

echo Extracting cuDNN archive...
echo This may take a few minutes...
echo.

REM Create temporary directory for extraction
if not exist "C:\temp" mkdir C:\temp
if exist "C:\temp\cudnn" rmdir /s /q C:\temp\cudnn

REM Extract using PowerShell (more reliable than 7zip)
powershell -command "Expand-Archive -Path 'cuda\cudnn-8.9.7-windows-x86_64_v8.9.7.29.zip' -DestinationPath 'C:\temp\cudnn' -Force"

if %errorlevel% neq 0 (
    echo ERROR: Failed to extract cuDNN archive.
    pause
    exit /b 1
)

echo cuDNN extracted successfully.
echo.

REM Check if CUDA is installed
if not exist "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v11.8" (
    echo ERROR: CUDA 11.8 not found at expected location.
    echo Please ensure CUDA is installed first.
    pause
    exit /b 1
)

echo Copying cuDNN files to CUDA directory...

REM Copy bin files
echo Copying bin files...
xcopy "C:\temp\cudnn\cuda\bin\*.*" "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v11.8\bin\" /Y /I /E
if %errorlevel% neq 0 (
    echo WARNING: Failed to copy bin files.
)

REM Copy include files
echo Copying include files...
xcopy "C:\temp\cudnn\cuda\include\*.*" "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v11.8\include\" /Y /I /E
if %errorlevel% neq 0 (
    echo WARNING: Failed to copy include files.
)

REM Copy lib files
echo Copying lib files...
xcopy "C:\temp\cudnn\cuda\lib\x64\*.*" "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v11.8\lib\x64\" /Y /I /E
if %errorlevel% neq 0 (
    echo WARNING: Failed to copy lib files.
)

echo.
echo Cleaning up temporary files...
rd /s /q C:\temp\cudnn

echo.
echo cuDNN installation completed successfully!

REM Verify cuDNN installation
echo Verifying cuDNN installation...
if exist "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v11.8\bin\cudnn64_8.dll" (
    echo cuDNN library found at expected location.
) else (
    echo WARNING: cuDNN library not found at expected location.
    echo Please check if installation completed properly.
)

echo.
echo cuDNN 8.9.7 installation completed.
echo.
