@echo off
call D:\envs\atari\Scripts\activate.bat

echo 正在测试环境...
python -c "import gym; import ale_py; import torch; print('所有依赖安装成功!')"

echo 测试Atari环境...
python -c "import gym; env = gym.make('Pong-v0'); print('Atari环境可用!')"

pause