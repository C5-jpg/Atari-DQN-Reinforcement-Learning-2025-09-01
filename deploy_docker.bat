@echo off
echo 正在部署Docker环境...

:: 检查Docker是否已安装
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo 正在安装Docker Desktop...
    start /wait DockerDesktopInstaller.exe --quiet --accept-license
    echo 请重启计算机后再次运行此脚本
    pause
    exit
)

:: 加载Docker镜像
echo 正在加载Docker镜像...
docker load -i atari-env.tar

:: 创建运行脚本
echo @echo off > run_container.bat
echo docker run -it --name atari-container -v "%cd%\workspace:/app/workspace" atari-env >> run_container.bat

:: 创建Jupyter运行脚本
echo @echo off > run_jupyter.bat
echo docker run -d -p 8888:8888 --name atari-jupyter -v "%cd%\workspace:/app/workspace" atari-env jupyter lab --ip=0.0.0.0 --allow-root --no-browser >> run_jupyter.bat
echo echo Jupyter已启动，访问 http://localhost:8888 >> run_jupyter.bat
echo echo 获取token命令: docker logs atari-jupyter >> run_jupyter.bat

echo Docker环境部署完成！
echo 运行 run_container.bat 启动交互式容器
echo 运行 run_jupyter.bat 启动Jupyter Lab
pause