@echo off
echo ========================================
echo    Atari RL GPU Environment Verification
echo ========================================
echo.

cd /d %~dp0\..

echo Checking system information...
echo.

REM Check Windows version
echo Windows Version:
ver
echo.

REM Check GPU information
echo GPU Information:
nvidia-smi
if %errorlevel% neq 0 (
    echo ERROR: NVIDIA GPU not detected or drivers not installed!
    echo Please install NVIDIA drivers first.
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b 1
)
echo.

REM Check CUDA installation
echo CUDA Information:
nvcc --version 2>nul
if %errorlevel% neq 0 (
    echo WARNING: CUDA compiler not found.
    echo This may be normal if CUDA PATH is not set.
) else (
    echo CUDA compiler found.
)
echo.

REM Check cuDNN
echo cuDNN Information:
if exist "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v11.8\bin\cudnn64_8.dll" (
    echo cuDNN library found.
) else (
    echo WARNING: cuDNN library not found.
)
echo.

REM Check Conda
echo Conda Information:
conda --version 2>nul
if %errorlevel% neq 0 (
    echo ERROR: Conda not found!
    echo Please ensure Miniconda was installed correctly.
    pause
    exit /b 1
) else (
    echo Conda found.
)
echo.

REM Check Python
echo Python Information:
python --version 2>nul
if %errorlevel% neq 0 (
    echo ERROR: Python not found!
    pause
    exit /b 1
) else (
    echo Python found.
)
echo.

REM Test Atari environment
echo Testing Atari RL Environment...
echo Activating conda environment...
call conda activate atari
if %errorlevel% neq 0 (
    echo ERROR: Failed to activate 'atari' conda environment!
    echo Please ensure the environment was created correctly.
    pause
    exit /b 1
)

echo.
echo Testing PyTorch GPU...
python -c "
import torch
print('PyTorch version:', torch.__version__)
print('CUDA available:', torch.cuda.is_available())
if torch.cuda.is_available():
    print('GPU count:', torch.cuda.device_count())
    print('Current GPU:', torch.cuda.get_device_name(0))
    print('CUDA version:', torch.version.cuda)
else:
    print('WARNING: CUDA not available in PyTorch!')
" 2>nul

if %errorlevel% neq 0 (
    echo ERROR: PyTorch GPU test failed!
    pause
    exit /b 1
)

echo.
echo Testing Gym and Atari...
python -c "
try:
    import gym
    print('Gym imported successfully')
    env = gym.make('PongNoFrameskip-v4')
    print('Atari Pong environment created successfully')
    env.close()
    print('Environment test passed')
except Exception as e:
    print('ERROR in Gym/Atari test:', str(e))
" 2>nul

if %errorlevel% neq 0 (
    echo WARNING: Gym/Atari test failed. This may be due to missing ROMs.
    echo You can try importing ROMs manually later.
)

echo.
echo Testing OpenCV...
python -c "
try:
    import cv2
    print('OpenCV version:', cv2.__version__)
    print('OpenCV test passed')
except Exception as e:
    print('ERROR in OpenCV test:', str(e))
" 2>nul

if %errorlevel% neq 0 (
    echo ERROR: OpenCV test failed!
    pause
    exit /b 1
)

echo.
echo Testing GPU computation...
python -c "
import torch
import torch.nn as nn

if torch.cuda.is_available():
    print('Testing GPU computation...')
    model = nn.Linear(100, 10).cuda()
    input_tensor = torch.randn(32, 100).cuda()
    output = model(input_tensor)
    print('GPU computation test passed!')
else:
    print('WARNING: CUDA not available, skipping GPU computation test')
" 2>nul

if %errorlevel% neq 0 (
    echo WARNING: GPU computation test failed.
)

echo.
echo ========================================
echo Verification completed!
echo ========================================
echo.
echo If you see any ERROR messages above, please check the installation.
echo If you see WARNING messages, some features may not work but basic functionality should be available.
echo.
echo Your Atari RL GPU environment is ready to use!
echo.
echo To start training:
echo 1. Open command prompt
echo 2. Run: conda activate atari
echo 3. Navigate to your project: cd %USERPROFILE%\atari_project
echo 4. Run: python dqn.py
echo.
pause
