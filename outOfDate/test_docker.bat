@echo off
echo 正在测试Docker环境...

:: 运行测试容器
docker run --rm atari-env python -c "import gym; import ale_py; import torch; print('所有依赖安装成功!')"

:: 测试Atari环境
docker run --rm atari-env python -c "import gym; env = gym.make('Pong-v0'); print('Atari环境可用!')"

echo 测试完成！
pause