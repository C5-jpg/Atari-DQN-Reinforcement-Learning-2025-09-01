# 强化学习Docker环境离线部署指南

## 系统要求
- Windows 10/11 (64位)
- 至少10GB可用磁盘空间
- 8GB以上内存
- 支持虚拟化的CPU

## 部署步骤

### 1. 安装Docker Desktop
   - 双击运行 `DockerDesktopInstaller.exe`
   - 安装完成后重启计算机

### 2. 部署Docker环境
   - 运行 `deploy_docker.bat`
   - 等待镜像加载完成

### 3. 初始化工作区
   - 运行 `init_workspace.bat` 创建工作区目录

### 4. 测试环境
   - 运行 `test_docker.bat` 验证环境

## 使用方法

### 交互式使用
1. 运行 `run_container.bat` 启动交互式容器
2. 在容器中，环境已自动激活
3. 使用 `python` 运行代码

### Jupyter Lab使用
1. 运行 `run_jupyter.bat` 启动Jupyter Lab
2. 在浏览器中访问 `http://localhost:8888`
3. 获取token：运行 `docker logs atari-jupyter`
4. 使用token登录Jupyter Lab

### 工作区说明
- 所有代码应放在 `workspace` 目录中
- 该目录会自动挂载到容器中的 `/app/workspace`
- 容器重启后工作区内容会保留

## 常用命令

### 查看运行中的容器
```bash
docker ps