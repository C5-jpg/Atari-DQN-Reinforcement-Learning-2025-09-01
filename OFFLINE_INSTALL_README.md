# Atari RL 离线GPU环境安装指南

## 概述

本指南提供在完全离线的Windows环境下，使用U盘一键部署Atari强化学习GPU环境的完整流程。

## 系统要求

- **操作系统**: Windows 10/11 (64位)
- **内存**: 至少8GB RAM
- **存储**: 至少50GB可用磁盘空间
- **GPU**: NVIDIA GPU (支持CUDA 11.8)
- **网络**: 准备阶段需要网络，部署阶段完全离线

## 文件结构

U盘根目录应包含以下文件和文件夹：

```
U盘根目录/
├── install_gpu.bat                    # 一键安装脚本（主要执行文件）
├── download_gpu_packages.bat          # 包下载脚本（准备阶段使用）
├── python-3.9.13-amd64.exe           # Python 3.9.13安装包
├── Miniconda3-latest-Windows-x86_64.exe  # Miniconda安装包
├── cuda/
│   ├── cuda_11.8.0_522.06_windows.exe
│   └── cudnn-8.9.7-windows-x86_64_v8.9.7.29.zip
├── packages/                         # Python包离线包
│   ├── torch-2.5.1+cu118-cp39-cp39-win_amd64.whl
│   ├── torchvision-0.20.1+cu118-cp39-cp39-win_amd64.whl
│   ├── torchaudio-2.5.1+cu118-cp39-cp39-win_amd64.whl
│   ├── gym-0.15.7.tar.gz
│   ├── atari_py-0.2.9-cp39-cp39-win_amd64.whl
│   ├── opencv_python-4.10.0.82-cp39-cp39-win_amd64.whl
│   └── ... (其他依赖包)
├── scripts/                          # 安装脚本
│   ├── install_cuda.bat
│   ├── install_cudnn.bat
│   ├── setup_gpu_env.bat
│   ├── verify_gpu.bat
│   └── refreshenv.cmd
├── dqn.py                           # 您的强化学习代码
├── pong_dqn.pth                    # 预训练模型
├── shadow_leaderboard.py           # 模型对比工具
├── README.md                       # 项目说明
├── ROMS/                           # Atari ROM文件
└── finetune_ckpts/                 # 微调模型（如果有）
```

## 准备阶段（有网络环境）

### 步骤1: 下载Python包

1. 在有网络的电脑上运行 `download_gpu_packages.bat`
2. 脚本会自动下载所有必要的Python包到 `packages/` 文件夹

### 步骤2: 手动下载大文件

下载以下文件并放置在正确位置：

1. **Python 3.9.13**:
   - 下载地址: https://www.python.org/ftp/python/3.9.13/python-3.9.13-amd64.exe
   - 保存位置: U盘根目录

2. **Miniconda3**:
   - 下载地址: https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe
   - 保存位置: U盘根目录

3. **CUDA 11.8**:
   - 下载地址: https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda_11.8.0_522.06_windows.exe
   - 保存位置: `cuda/cuda_11.8.0_522.06_windows.exe`

4. **cuDNN 8.9.7**:
   - 下载地址: https://developer.download.nvidia.com/compute/cudnn/secure/8.9.7/11.8_20240213/cudnn-8.9.7-windows-x86_64_v8.9.7.29.zip
   - 保存位置: `cuda/cudnn-8.9.7-windows-x86_64_v8.9.7.29.zip`
   - **注意**: 需要NVIDIA开发者账号登录

### 步骤3: 复制项目文件

将您的Atari RL项目文件复制到U盘：
- `dqn.py`
- `pong_dqn.pth`
- `shadow_leaderboard.py`
- `ROMS/` 文件夹
- `finetune_ckpts/` 文件夹（如果有）

## 部署阶段（目标机器，完全离线）

### 前置条件

1. **确保NVIDIA驱动已安装**:
   - 在目标机器上安装最新NVIDIA驱动
   - 验证: 运行 `nvidia-smi` 应能看到GPU信息

2. **管理员权限**:
   - 以管理员身份运行命令提示符

### 安装步骤

1. **插入U盘**:
   - 将准备好的U盘插入目标机器

2. **运行一键安装**:
   - 双击 `install_gpu.bat`
   - 等待安装完成（约30-45分钟）

3. **验证安装**:
   - 运行 `scripts\verify_gpu.bat` 验证环境

4. **开始使用**:
   - 打开新的命令提示符
   - 运行: `conda activate atari`
   - 导航到项目: `cd %USERPROFILE%\atari_project`
   - 开始训练: `python dqn.py`

## 安装过程详解

### 安装顺序

1. **系统检查**: 验证GPU和管理员权限
2. **Python安装**: 安装Python 3.9.13
3. **Miniconda安装**: 安装Miniconda包管理器
4. **CUDA安装**: 安装CUDA 11.8工具包
5. **cuDNN安装**: 安装cuDNN深度学习库
6. **环境配置**: 创建Conda环境并安装所有Python包
7. **项目部署**: 复制项目文件到用户目录

### 预期安装时间

- Python: 2-3分钟
- Miniconda: 3-5分钟
- CUDA: 10-15分钟
- cuDNN: 2-3分钟
- Python包: 10-15分钟
- **总计**: 30-45分钟

## 故障排除

### 常见问题

1. **"NVIDIA GPU not detected"**
   - 解决方案: 安装NVIDIA驱动程序
   - 下载: https://www.nvidia.com/Download/index.aspx

2. **"Conda not found"**
   - 解决方案: 重新安装Miniconda或检查PATH环境变量

3. **"CUDA installation failed"**
   - 解决方案: 以管理员身份运行，或重启后重试

4. **"PyTorch GPU test failed"**
   - 解决方案: 检查CUDA版本兼容性，或重新安装PyTorch

5. **"ROM import failed"**
   - 解决方案: 手动运行 `python -m atari_py.import_roms ROMS`

### 日志查看

- 安装过程中的错误信息会显示在命令提示符中
- 使用 `scripts\verify_gpu.bat` 获取详细诊断信息

## 使用说明

### 激活环境

```batch
# 打开命令提示符
conda activate atari
```

### 运行训练

```batch
# 导航到项目目录
cd %USERPROFILE%\atari_project

# 开始训练
python dqn.py
```

### 运行模型对比

```batch
# 使用shadow leaderboard进行模型对比
python shadow_leaderboard.py --env PongNoFrameskip-v4 --bank-size 50 --csv shadow_leaderboard.csv --model baseline=pong_dqn.pth
```

## 技术规格

- **Python**: 3.9.13
- **PyTorch**: 2.5.1 + CUDA 11.8
- **CUDA**: 11.8.0
- **cuDNN**: 8.9.7
- **Gym**: 0.15.7
- **Atari-py**: 0.2.9

## 注意事项

1. **磁盘空间**: 确保至少50GB可用空间
2. **管理员权限**: 安装过程需要管理员权限
3. **网络隔离**: 目标环境必须完全离线
4. **GPU驱动**: 确保NVIDIA驱动与CUDA 11.8兼容
5. **系统重启**: 某些安装步骤可能需要重启

## 支持

如果遇到问题，请：
1. 运行 `scripts\verify_gpu.bat` 获取诊断信息
2. 检查错误消息并参考故障排除部分
3. 确保所有文件都存在且完整

---

**最后更新**: 2025年9月1日
**版本**: 1.0
