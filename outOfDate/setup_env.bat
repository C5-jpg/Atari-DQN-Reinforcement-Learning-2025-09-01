@echo off
echo 正在设置强化学习环境...

:: 创建目标目录
if not exist "D:\envs\atari" mkdir "D:\envs\atari"

:: 解压环境包
echo 正在解压环境包...
cd /d D:\envs\atari
tar -xzf "D:\Docker-Atari-Offline\atari_env.tar.gz"

:: 复制ROM文件
echo 正在复制ROM文件...
xcopy "D:\Docker-Atari-Offline\ROMS" "D:\envs\atari\Lib\site-packages\ale_py\roms\" /E /I /Y

:: 创建激活脚本
echo @echo off > D:\envs\atari\activate_atari.bat
echo D:\envs\atari\Scripts\activate.bat >> D:\envs\atari\activate_atari.bat

echo 环境设置完成！
echo 运行 D:\envs\atari\activate_atari.bat 激活环境
pause