@echo off
echo ========================================
echo    Quick Atari RL Training Test
echo ========================================
echo.

cd /d %~dp0\..

echo Activating Atari environment...
call conda activate atari
if %errorlevel% neq 0 (
    echo ERROR: Failed to activate Atari environment!
    echo Please run setup_gpu_env.bat first.
    pause
    exit /b 1
)

echo.
echo Testing basic imports...
python -c "
import torch
import gym
import cv2
print('All imports successful!')
print('PyTorch CUDA available:', torch.cuda.is_available())
"

if %errorlevel% neq 0 (
    echo ERROR: Import test failed!
    pause
    exit /b 1
)

echo.
echo Testing environment creation...
python -c "
import gym
env = gym.make('PongNoFrameskip-v4')
print('Environment created successfully')
print('Action space:', env.action_space)
print('Observation space:', env.observation_space)
env.close()
"

if %errorlevel% neq 0 (
    echo WARNING: Environment creation failed. This may be due to missing ROMs.
    echo You can try importing ROMs manually: python -m atari_py.import_roms ROMS
)

echo.
echo Testing model loading...
if exist "pong_dqn.pth" (
    python -c "
import torch
from dqn import DQN, PongWrapper
import gym

# Create environment to get action dimensions
env = gym.make('PongNoFrameskip-v4')
wrapped_env = PongWrapper(env)
action_dim = len(wrapped_env.valid_actions)
env.close()

# Load model
model = DQN(action_dim)
model.load_state_dict(torch.load('pong_dqn.pth', map_location='cpu'))
model.eval()
print('Model loaded successfully!')
print('Model parameters:', sum(p.numel() for p in model.parameters()))
    "

    if %errorlevel% neq 0 (
        echo ERROR: Model loading test failed!
        pause
        exit /b 1
    )
) else (
    echo WARNING: pong_dqn.pth not found. Skipping model loading test.
)

echo.
echo ========================================
echo Test completed successfully!
echo ========================================
echo.
echo Your Atari RL environment is working correctly.
echo You can now run the full training with: python dqn.py
echo.
pause
