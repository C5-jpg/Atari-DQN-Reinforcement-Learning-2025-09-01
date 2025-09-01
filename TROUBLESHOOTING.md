# 故障排除指南

## PyTorch包下载问题解决方案

### 问题描述
运行 `download_gpu_packages.bat` 时出现以下错误：
```
ERROR: When restricting platform and interpreter constraints using --python-version, --platform, --abi, or --implementation, either --no-deps must be set, or --only-binary=:all: must be set and --no-binary must not be set (or must be set to :none:).
```

### 解决方案

#### 方法1：使用修复后的脚本（推荐）
我已经修复了 `download_gpu_packages.bat` 脚本，添加了 `--only-binary=:all:` 参数：
```batch
pip download torch==2.5.1+cu118 torchvision==0.20.1+cu118 torchaudio==2.5.1+cu118 --only-binary=:all: --platform win_amd64 --python-version 39 -d .
```

#### 方法2：使用备用脚本
如果修复后的脚本仍有问题，使用 `download_gpu_packages_alternative.bat`：
```batch
pip download torch==2.5.1+cu118 torchvision==0.20.1+cu118 torchaudio==2.5.1+cu118 --no-deps -d .
```

#### 方法3：手动下载PyTorch
如果上述方法都不工作，可以手动下载PyTorch wheel文件：
1. 访问 https://download.pytorch.org/whl/torch_stable.html
2. 下载以下文件：
   - `torch-2.5.1+cu118-cp39-cp39-win_amd64.whl`
   - `torchvision-0.20.1+cu118-cp39-cp39-win_amd64.whl`
   - `torchaudio-2.5.1+cu118-cp39-cp39-win_amd64.whl`
3. 将文件放入 `packages/` 目录

### 验证下载
下载完成后，检查 `packages/` 目录应包含以下文件：
```
torch-2.5.1+cu118-cp39-cp39-win_amd64.whl
torchvision-0.20.1+cu118-cp39-cp39-win_amd64.whl
torchaudio-2.5.1+cu118-cp39-cp39-win_amd64.whl
gym-0.15.7.tar.gz
atari_py-0.2.9-cp39-cp39-win_amd64.whl
opencv_python-4.10.0.82-cp39-cp39-win_amd64.whl
numpy-2.3.2-cp311-cp311-win_amd64.whl
matplotlib-...
pillow-...
setuptools-...
wheel-...
pip-...
```

## 其他常见问题

### 1. CUDA安装失败
**现象**: CUDA安装过程中出现权限错误
**解决方案**:
1. 以管理员身份运行命令提示符
2. 确保NVIDIA驱动已正确安装
3. 检查是否有其他CUDA版本冲突

### 2. cuDNN安装失败
**现象**: cuDNN文件无法正确复制
**解决方案**:
1. 手动解压cuDNN文件到临时目录
2. 以管理员身份复制文件到CUDA目录
3. 验证文件路径正确性

### 3. Conda环境创建失败
**现象**: `conda create` 命令失败
**解决方案**:
1. 检查Miniconda是否正确安装
2. 刷新环境变量：`call scripts\refreshenv.cmd`
3. 重新安装Miniconda

### 4. Python包安装失败
**现象**: pip install 过程中出现依赖冲突
**解决方案**:
1. 使用 `--no-deps` 参数安装
2. 手动解决依赖关系
3. 检查Python版本兼容性

### 5. GPU检测失败
**现象**: PyTorch无法检测到CUDA
**解决方案**:
1. 验证CUDA安装：`nvcc --version`
2. 检查cuDNN文件位置
3. 重新安装PyTorch GPU版本

## 离线部署完整流程

### 准备阶段（有网络环境）

#### 步骤1：下载系统级软件
```batch
# 1. 下载Python 3.9.13
# URL: https://www.python.org/ftp/python/3.9.13/python-3.9.13-amd64.exe
# 保存为: python-3.9.13-amd64.exe

# 2. 下载Miniconda3
# URL: https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe
# 保存为: Miniconda3-latest-Windows-x86_64.exe

# 3. 下载CUDA 11.8
# URL: https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda_11.8.0_522.06_windows.exe
# 保存到: cuda/cuda_11.8.0_522.06_windows.exe

# 4. 下载cuDNN 8.9.7
# URL: https://developer.download.nvidia.com/compute/cudnn/secure/8.9.7/11.8_20240213/cudnn-8.9.7-windows-x86_64_v8.9.7.29.zip
# 保存到: cuda/cudnn-8.9.7-windows-x86_64_v8.9.7.29.zip
```

#### 步骤2：下载Python包
```batch
# 方法1：使用修复后的脚本（推荐）
download_gpu_packages.bat

# 方法2：使用备用脚本
download_gpu_packages_alternative.bat

# 方法3：手动下载（如果脚本失败）
# 访问PyPI下载所需包
```

#### 步骤3：组织文件结构
```
U盘根目录/
├── install_gpu.bat                    ✅ 一键安装脚本
├── download_gpu_packages.bat          ✅ 包下载脚本
├── python-3.9.13-amd64.exe           ⏳ 已下载
├── Miniconda3-latest-Windows-x86_64.exe  ⏳ 已下载
├── cuda/                              ✅ 目录
│   ├── cuda_11.8.0_522.06_windows.exe    ⏳ 已下载
│   └── cudnn-8.9.7-windows-x86_64_v8.9.7.29.zip  ⏳ 已下载
├── packages/                          ⏳ 脚本运行后生成
├── scripts/                           ✅ 所有脚本
├── dqn.py                            ✅ 项目文件
├── pong_dqn.pth                      ✅ 模型文件
├── shadow_leaderboard.py             ✅ 对比工具
├── ROMS/                             ✅ ROM文件
├── OFFLINE_INSTALL_README.md         ✅ 安装指南
├── PROJECT_LOG.md                    ✅ 项目日志
└── TROUBLESHOOTING.md               ✅ 本文档
```

### 部署阶段（离线环境）

#### 步骤1：验证文件完整性
```batch
# 检查所有必需文件是否存在
dir /b *.bat *.exe cuda\* packages\*
```

#### 步骤2：运行安装
```batch
# 以管理员身份运行
install_gpu.bat
```

#### 步骤3：验证安装
```batch
# 运行验证脚本
scripts\verify_gpu.bat
```

#### 步骤4：测试功能
```batch
# 激活环境
conda activate atari

# 测试基本功能
python -c "import torch; print('CUDA available:', torch.cuda.is_available())"

# 测试训练
python dqn.py
```

## 性能优化建议

### GPU内存优化
1. 适当调整batch_size（32-128）
2. 使用gradient accumulation
3. 定期清理GPU缓存

### 训练稳定性
1. 使用gradient clipping
2. 实现early stopping
3. 保存最佳模型检查点

### 监控和调试
1. 使用 `nvidia-smi` 监控GPU使用率
2. 查看任务管理器中的内存使用情况
3. 定期检查训练日志

## 联系支持

如果遇到无法解决的问题，请：
1. 记录完整的错误信息
2. 说明执行的步骤
3. 提供系统配置信息
4. 联系技术支持团队

---

**最后更新**: 2025年9月1日
**版本**: 1.0
