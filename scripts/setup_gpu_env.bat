@echo off
echo ========================================
echo Setting up Atari RL GPU Environment
echo ========================================
echo.

cd /d %~dp0\..

REM Refresh environment variables
echo Refreshing environment variables...
call scripts\refreshenv.cmd

REM Check if conda is available
conda --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Conda is not available. Please ensure Miniconda was installed correctly.
    pause
    exit /b 1
)

echo Creating Atari conda environment...
conda create -n atari python=3.9 -y
if %errorlevel% neq 0 (
    echo ERROR: Failed to create conda environment.
    pause
    exit /b 1
)

echo Activating environment and installing packages...
call conda activate atari

REM Set CUDA environment variables
echo Setting CUDA environment variables...
set CUDA_HOME=C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v11.8
set PATH=%CUDA_HOME%\bin;%PATH%
set CUDA_PATH=%CUDA_HOME%

REM Install PyTorch GPU packages
echo Installing PyTorch GPU packages...
pip install --no-index --find-links=packages torch==2.5.1+cu118
if %errorlevel% neq 0 (
    echo ERROR: Failed to install PyTorch.
    pause
    exit /b 1
)

pip install --no-index --find-links=packages torchvision==0.20.1+cu118
if %errorlevel% neq 0 (
    echo ERROR: Failed to install TorchVision.
    pause
    exit /b 1
)

pip install --no-index --find-links=packages torchaudio==2.5.1+cu118
if %errorlevel% neq 0 (
    echo ERROR: Failed to install TorchAudio.
    pause
    exit /b 1
)

REM Install other packages
echo Installing core packages...
pip install --no-index --find-links=packages gym==0.15.7
if %errorlevel% neq 0 (
    echo ERROR: Failed to install Gym.
    pause
    exit /b 1
)

pip install --no-index --find-links=packages atari-py
if %errorlevel% neq 0 (
    echo ERROR: Failed to install Atari-py.
    pause
    exit /b 1
)

pip install --no-index --find-links=packages opencv-python==4.10.0.82
if %errorlevel% neq 0 (
    echo ERROR: Failed to install OpenCV.
    pause
    exit /b 1
)

REM Install dependencies
echo Installing dependencies...
pip install --no-index --find-links=packages numpy matplotlib pillow
if %errorlevel% neq 0 (
    echo ERROR: Failed to install dependencies.
    pause
    exit /b 1
)

REM Import Atari ROMs
echo Importing Atari ROMs...
if exist "ROMS" (
    python -m atari_py.import_roms ROMS
    if %errorlevel% neq 0 (
        echo WARNING: Failed to import ROMs. You may need to do this manually later.
    ) else (
        echo ROMs imported successfully.
    )
) else (
    echo WARNING: ROMS directory not found. Please ensure ROM files are present.
)

REM Copy project files
echo Copying project files...
if not exist "%USERPROFILE%\atari_project" mkdir "%USERPROFILE%\atari_project"

xcopy "dqn.py" "%USERPROFILE%\atari_project\" /Y
xcopy "pong_dqn.pth" "%USERPROFILE%\atari_project\" /Y
xcopy "shadow_leaderboard.py" "%USERPROFILE%\atari_project\" /Y
xcopy "README.md" "%USERPROFILE%\atari_project\" /Y

if exist "finetune_ckpts" (
    xcopy "finetune_ckpts" "%USERPROFILE%\atari_project\finetune_ckpts\" /E /I /H /Y
)

if exist "ROMS" (
    xcopy "ROMS" "%USERPROFILE%\atari_project\ROMS\" /E /I /H /Y
)

echo.
echo ========================================
echo Environment setup completed successfully!
echo ========================================
echo.
echo Your Atari RL environment is ready!
echo.
echo To use the environment:
echo 1. Open a new command prompt
echo 2. Run: conda activate atari
echo 3. Navigate to: %USERPROFILE%\atari_project
echo 4. Run your training: python dqn.py
echo.
echo For verification, run: scripts\verify_gpu.bat
echo.
