@echo off
echo ========================================
echo    GPU Atari RL Packages Downloader (Alternative)
echo ========================================
echo This script downloads packages without platform constraints
echo.

mkdir packages 2>nul
cd packages

echo Downloading PyTorch GPU packages...
pip download torch==2.5.1+cu118 torchvision==0.20.1+cu118 torchaudio==2.5.1+cu118 --no-deps -d .

echo Downloading core packages...
pip download gym==0.15.7 atari-py opencv-python==4.10.0.82 --no-deps -d .

echo Downloading dependencies separately...
pip download numpy scipy matplotlib pillow setuptools wheel pip --no-deps -d .

echo.
echo ========================================
echo Alternative download completed!
echo ========================================
echo.
echo This method downloads packages without platform constraints.
echo Some packages might need to be compiled on target machines.
echo.
echo IMPORTANT: Please also download these files manually:
echo.
echo 1. Python 3.9.13:
echo    https://www.python.org/ftp/python/3.9.13/python-3.9.13-amd64.exe
echo    Save as: python-3.9.13-amd64.exe (in root directory)
echo.
echo 2. Miniconda3:
echo    https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe
echo    Save as: Miniconda3-latest-Windows-x86_64.exe (in root directory)
echo.
echo 3. CUDA 11.8:
echo    https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda_11.8.0_522.06_windows.exe
echo    Save in: cuda/cuda_11.8.0_522.06_windows.exe
echo.
echo 4. cuDNN 8.9.7:
echo    https://developer.download.nvidia.com/compute/cudnn/secure/8.9.7/11.8_20240213/cudnn-8.9.7-windows-x86_64_v8.9.7.29.zip
echo    Save in: cuda/cudnn-8.9.7-windows-x86_64_v8.9.7.29.zip
echo.
pause
