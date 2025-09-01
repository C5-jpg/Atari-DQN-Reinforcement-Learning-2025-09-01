@echo off
echo 正在初始化工作区...

:: 创建工作区目录
if not exist "workspace" mkdir workspace

:: 复制示例代码到工作区
echo import gym > workspace\test_env.py
echo env = gym.make('Pong-v0') >> workspace\test_env.py
>>> env.reset()
>>> for _ in range(1000):
>>>     env.render()
>>>     action = env.action_space.sample() # take a random action
>>>     obs, reward, done, info = env.step(action)
>>>     if done:
>>>         obs = env.reset()
>>> env.close()

echo 工作区已初始化！
echo 示例代码已保存到 workspace\test_env.py
pause