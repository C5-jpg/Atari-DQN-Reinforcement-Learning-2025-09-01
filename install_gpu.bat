@echo off
echo ========================================
echo    Atari RL GPU Environment Setup
echo ========================================
echo This script will install Python, Miniconda, CUDA, cuDNN, and all dependencies
echo.

cd /d %~dp0

echo Checking system requirements...
echo.

REM Check if running as administrator
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Running as administrator - OK
) else (
    echo WARNING: Not running as administrator. Some installations may fail.
    echo Please consider running as administrator for best results.
    echo.
)

echo Checking GPU compatibility...
nvidia-smi >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: NVIDIA GPU not detected or drivers not installed!
    echo Please install NVIDIA drivers first from:
    echo https://www.nvidia.com/Download/index.aspx
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b 1
)

echo GPU detected successfully.
nvidia-smi | find "Driver Version"
echo.

echo Step 1: Installing Python 3.9...
if not exist "python-3.9.13-amd64.exe" (
    echo ERROR: python-3.9.13-amd64.exe not found in current directory!
    echo Please ensure all required files are present.
    pause
    exit /b 1
)

echo Installing Python 3.9.13 (this may take a few minutes)...
python-3.9.13-amd64.exe /quiet InstallAllUsers=1 PrependPath=1 Include_test=0
if %errorlevel% neq 0 (
    echo ERROR: Python installation failed!
    pause
    exit /b 1
)
echo Python installation completed.
echo.

echo Step 2: Installing Miniconda...
if not exist "Miniconda3-latest-Windows-x86_64.exe" (
    echo ERROR: Miniconda3-latest-Windows-x86_64.exe not found!
    pause
    exit /b 1
)

echo Installing Miniconda (this may take a few minutes)...
Miniconda3-latest-Windows-x86_64.exe /InstallationType=AllUsers /AddToPath=1 /RegisterPython=1 /S
if %errorlevel% neq 0 (
    echo ERROR: Miniconda installation failed!
    pause
    exit /b 1
)
echo Miniconda installation completed.
echo.

echo Step 3: Installing CUDA 11.8...
call scripts\install_cuda.bat
if %errorlevel% neq 0 (
    echo ERROR: CUDA installation failed!
    pause
    exit /b 1
)
echo.

echo Step 4: Installing cuDNN...
call scripts\install_cudnn.bat
if %errorlevel% neq 0 (
    echo ERROR: cuDNN installation failed!
    pause
    exit /b 1
)
echo.

echo Step 5: Setting up Conda environment with GPU support...
call scripts\setup_gpu_env.bat
if %errorlevel% neq 0 (
    echo ERROR: Environment setup failed!
    pause
    exit /b 1
)
echo.

echo ========================================
echo Installation completed successfully!
echo ========================================
echo.
echo Next steps:
echo 1. Close this command prompt
echo 2. Open a new command prompt as administrator
echo 3. Run: conda activate atari
echo 4. Run: python -c "import torch; print('GPU available:', torch.cuda.is_available())"
echo 5. Copy your project files and start training!
echo.
echo For verification, run: scripts\verify_gpu.bat
echo.
pause
