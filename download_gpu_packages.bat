@echo off
echo ========================================
echo    GPU Atari RL Packages Downloader
echo ========================================
echo This script will download all necessary packages for offline GPU installation
echo.

mkdir packages 2>nul
cd packages

echo Downloading PyTorch GPU packages...
pip download torch==2.5.1+cu118 torchvision==0.20.1+cu118 torchaudio==2.5.1+cu118 --only-binary=:all: --platform win_amd64 --python-version 39 -d .

echo Downloading core packages...
pip download gym==0.15.7 atari-py opencv-python==4.10.0.82 --only-binary=:all: -d .

echo Downloading dependencies...
pip download numpy matplotlib pillow setuptools wheel pip --only-binary=:all: -d .

echo.
echo ========================================
echo Download completed successfully!
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
echo After downloading all files, run install_gpu.bat on target machines.
echo.
pause
