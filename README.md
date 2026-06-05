<div align="center">

# 🎮 Atari DQN 强化学习 — Pong 智能体训练与多智能体对抗

**Deep Q-Network · Double DQN · Dueling DQN · Self-Play · Shadow Match**

[![Python](https://img.shields.io/badge/Python-3.9-blue.svg)](https://www.python.org/)
[![PyTorch](https://img.shields.io/badge/PyTorch-2.5.1-EE4C2C.svg)](https://pytorch.org/)
[![CUDA](https://img.shields.io/badge/CUDA-11.8-76B900.svg)](https://developer.nvidia.com/cuda-toolkit)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED.svg)](https://www.docker.com/)
[![Gym](https://img.shields.io/badge/OpenAI%20Gym-0.15.7-008001.svg)](https://github.com/openai/gym)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**从像素输入学习 Atari Pong，达到完美表现 (+21.0 评估回报)**

[项目特性](#-项目特性) · [算法架构](#-算法架构) · [训练结果](#-训练结果) · [快速开始](#-快速开始) · [Shadow Match](#-shadow-match-排行榜)

</div>

---

## 📋 项目概述

本项目实现了一套完整的 **Atari Pong 强化学习系统**，涵盖从单智能体 DQN 训练到多智能体自博弈对抗的渐进式学习框架。专为上海交通大学分布式课堂环境设计，支持 **20+ 台 Windows 工作站的离线 USB 部署**。

### 🎯 核心特性

- 🧠 **三种 DQN 变体**: 经典 DQN、Double DQN、Dueling DQN
- 🏓 **Atari Pong 完美通关**: 评估回报达到 +21.0（满分）
- 🤖 **自博弈训练**: 参数共享 + 水平翻转对称性
- 🏆 **Shadow Match 排行榜**: 公平的多模型对比评估系统
- 📦 **离线 GPU 部署**: CUDA 11.8 + cuDNN，USB 一键安装
- 🎬 **训练视频录制**: 自动录制游戏过程 MP4
- 🐳 **Docker 支持**: 容器化训练环境
- 🕹️ **2,147 款 Atari ROM**: 完整 Atari 2600 游戏库

---

## 🧠 算法架构

### 渐进式学习框架

```
┌─────────────────────────────────────────────────────────────┐
│                    渐进式强化学习路径                          │
│                                                              │
│  Level 1          Level 2          Level 3          Level 4  │
│  ┌─────────┐     ┌─────────┐     ┌─────────┐     ┌────────┐│
│  │ 表格RL   │ ──▶ │ 单智能体 │ ──▶ │ 自博弈   │ ──▶ │ 多智能体││
│  │CliffWalk│     │  DQN    │     │Self-Play│     │Dueling ││
│  │         │     │         │     │         │     │  DQN   ││
│  │·价值迭代 │     │·经验回放 │     │·参数共享 │     │·快照池  ││
│  │·策略迭代 │     │·目标网络 │     │·水平翻转 │     │·多对手  ││
│  └─────────┘     └─────────┘     └─────────┘     └────────┘│
└─────────────────────────────────────────────────────────────┘
```

### DQN 网络架构 (Nature 2015)

```
输入: 4 × 84 × 84 灰度帧堆叠
         │
         ▼
┌─────────────────────────┐
│ Conv2d: 4 → 32          │  8×8, stride 4
│ ReLU                    │
├─────────────────────────┤
│ Conv2d: 32 → 64         │  4×4, stride 2
│ ReLU                    │
├─────────────────────────┤
│ Conv2d: 64 → 64         │  3×3, stride 1
│ ReLU                    │
├─────────────────────────┤
│ Flatten: 3136           │
│ Linear: 3136 → 512      │
│ ReLU                    │
├─────────────────────────┤
│ Linear: 512 → 3         │  [NOOP, UP, DOWN]
└─────────────────────────┘
```

### Dueling DQN 架构 (多智能体)

```
                     ┌──────────┐
                     │  共享卷积  │
                     │  特征提取  │
                     └─────┬────┘
                           │
                 ┌─────────┴─────────┐
                 ▼                   ▼
          ┌─────────────┐    ┌─────────────┐
          │  Value 流 V(s)│    │Advantage 流  │
          │  状态价值函数 │    │  A(s,a)      │
          └──────┬──────┘    └──────┬──────┘
                 │                   │
                 └─────────┬─────────┘
                           ▼
                 Q(s,a) = V(s) + A(s,a) - mean(A)
```

### 状态预处理流水线

```
原始帧 (210×160 RGB)
    │
    ▼ 裁剪 (行 34-194)
    ▼ 灰度转换
    ▼ 缩放至 84×84
    ▼ 归一化 [0, 1]
    ▼ 帧堆叠 × 4
    │
输出: 4×84×84 张量
```

---

## 📊 训练结果

### 单智能体 Pong 训练

| 指标 | 基线模型 | 微调模型 |
|:---:|:---:|:---:|
| 评估平均回报 | **+21.0** | **+21.0** |
| 胜率 | 100% | 100% |
| Shadow Match 得分 | 100/100 | 50/50 |
| 平均步数/得分 | 89 步 | 270 步 |

### 微调训练曲线

| Epoch | 平均奖励 | 评估回报 |
|:---:|:---:|:---:|
| 1 | 15.6 | +21.0 |
| 2 | 18.0 | +21.0 |
| 3 | 18.5 | +21.0 |
| 4 | 18.8 | +21.0 |
| 5 | 19.0 | +21.0 |

> 🎯 **基线模型和微调模型均在 Pong 上达到完美表现 (21:0)**

### 训练视频

项目包含训练过程中录制的游戏视频：

<table>
<tr>
<td align="center"><b>训练早期 (Episode 0)</b></td>
<td align="center"><b>训练后期 (Episode 1)</b></td>
</tr>
<tr>
<td>

```
┌──────────────────┐
│  ╔══════════════╗ │
│  ║  PONG        ║ │
│  ║              ║ │
│  ║  ●           ║ │
│  ║     ║    ║   ║ │
│  ║  CPU    AI   ║ │
│  ║  0      0    ║ │
│  ╚══════════════╝ │
└──────────────────┘
```

</td>
<td>

```
┌──────────────────┐
│  ╔══════════════╗ │
│  ║  PONG        ║ │
│  ║        ●     ║ │
│  ║  ║         ║ ║ │
│  ║  CPU     AI  ║ │
│  ║  0      21   ║ │
│  ╚══════════════╝ │
└──────────────────┘
```

</td>
</tr>
</table>

---

## 📁 项目结构

```
Atari-DQN-Reinforcement-Learning/
│
├── 🧠 核心代码
│   ├── dqn.py                           # DQN 训练/微调/评估 (459行)
│   │   ├── ReplayMemory                 # 经验回放缓冲区 (100k)
│   │   ├── DQN (nn.Module)              # Nature DQN 网络架构
│   │   ├── PongWrapper (gym.Wrapper)    # Pong 状态预处理
│   │   ├── train()                      # 主训练循环
│   │   ├── finetune()                   # 微调流水线
│   │   └── evaluate()                   # 贪心评估
│   │
│   └── shadow_leaderboard.py            # Shadow Match 排行榜 (294行)
│       ├── DQNPolicy                    # 推理封装器
│       ├── StateBank                    # ALE 状态快照收集
│       └── ShadowArena                  # 公平多模型对比
│
├── 🏋️ 预训练模型
│   ├── pong_dqn.pth                     # 基线模型 (~6.4 MB)
│   └── finetune_ckpts/
│       ├── pong_dqn_ft_epoch1.pth       # 微调检查点
│       └── finetune_metrics.csv         # 微调指标
│
├── 🕹️ Atari ROM 库
│   └── ROMS/                            # 2,147 款 Atari 2600 ROM
│
├── 🧪 实验性代码 (outOfDate/)
│   ├── CliffWalk.py                     # 悬崖行走 (价值/策略迭代)
│   ├── battle_ground.py                 # 自博弈渲染器 (PettingZoo)
│   ├── dqn_aside.py                     # 自博弈 DQN (Double DQN)
│   └── dqn_against.py                   # 多智能体 DQN (Dueling DQN)
│
├── 🐳 部署与环境
│   ├── Dockerfile                       # Docker 容器定义
│   ├── deploy_docker.bat                # Docker 部署脚本
│   ├── install_gpu.bat                  # 一键离线 GPU 环境安装
│   ├── download_gpu_packages.bat        # 离线包下载
│   ├── packages/                        # 离线 Python wheels
│   └── scripts/
│       ├── install_cuda.bat             # CUDA 11.8 安装
│       ├── install_cudnn.bat            # cuDNN 8.9.7 安装
│       ├── setup_gpu_env.bat            # Conda 环境配置
│       ├── verify_gpu.bat               # 环境验证
│       └── test_training.bat            # 训练冒烟测试
│
├── 🎬 训练视频
│   └── video/
│       ├── openaigym.video.0.76812.video000000.mp4
│       └── openaigym.video.0.76812.video000001.mp4
│
└── 📄 文档
    ├── PROJECT_LOG.md                   # 项目开发日志
    ├── OFFLINE_INSTALL_README.md        # 离线安装指南
    └── TROUBLESHOOTING.md               # 故障排除指南
```

---

## 🚀 快速开始

### 环境要求

| 组件 | 版本 |
|:---:|:---:|
| Python | 3.9.13 |
| PyTorch | 2.5.1 + CUDA 11.8 |
| CUDA Toolkit | 11.8.0 |
| cuDNN | 8.9.7 |
| OpenAI Gym | 0.15.7 |
| ale_py | 0.11.2 |
| OpenCV | 4.10.0.82 |

### 安装

#### 方式一：在线安装

```bash
# 创建 Conda 环境
conda create -n atari python=3.9 -y
conda activate atari

# 安装 PyTorch (CUDA 11.8)
pip install torch==2.5.1 torchvision==0.20.1 --index-url https://download.pytorch.org/whl/cu118

# 安装依赖
pip install gym==0.15.7 ale_py==0.11.2 opencv-python==4.10.0.82 atari-py

# 导入 Atari ROM
python -m atari_py.import_roms ROMS/
```

#### 方式二：离线安装 (Windows 课堂环境)

```bash
# 步骤 1: 在联网机器下载包
download_gpu_packages.bat

# 步骤 2: 拷贝到 U 盘，在目标机器执行
install_gpu.bat          # 30-45 分钟全自动安装

# 步骤 3: 验证环境
scripts\verify_gpu.bat
```

#### 方式三：Docker

```bash
docker build -t atari-dqn .
deploy_docker.bat
```

### 训练

```bash
# 单智能体 Pong 训练
python dqn.py

# Shadow Match 排行榜
python shadow_leaderboard.py \
  --env PongNoFrameskip-v4 \
  --bank-size 100 \
  --csv ./shadow_leaderboard.csv \
  --model baseline=./pong_dqn.pth \
  --model ft_ep1=./finetune_ckpts/pong_dqn_ft_epoch1.pth
```

### 使用预训练模型

```python
import torch
from dqn import DQN, make_env_oldgym

# 加载预训练模型
model = DQN(4, 3)  # 4帧堆叠, 3个动作
model.load_state_dict(torch.load('pong_dqn.pth'))
model.eval()

# 评估
env = make_env_oldgym('PongNoFrameskip-v4', seed=0)
# ... 运行评估循环
```

---

## 🏆 Shadow Match 排行榜

Shadow Match 是一种**公平的多模型对比方法**，通过在完全相同的 ALE 游戏状态下评估不同模型的表现：

```
┌─────────────────────────────────────────┐
│           Shadow Match 工作流程           │
│                                          │
│  1. StateBank 收集 N 个游戏状态快照       │
│     (从 ALE 模拟器中克隆完整状态)         │
│                                          │
│  2. 每个模型在相同的状态集合上运行         │
│     Model A ──▶ State #1 → #2 → ... → #N│
│     Model B ──▶ State #1 → #2 → ... → #N│
│     Model C ──▶ State #1 → #2 → ... → #N│
│                                          │
│  3. 统计每个模型的 胜/负/平/净得分         │
│                                          │
│  4. 输出 CSV 排行榜                       │
└─────────────────────────────────────────┘
```

---

## 🔬 超参数配置

### 基础训练

| 参数 | 值 |
|:---:|:---:|
| Batch Size | 64 |
| Learning Rate | 1e-4 |
| Gamma (折扣因子) | 0.99 |
| 回放缓冲区大小 | 100,000 |
| 目标网络同步频率 | 每 5 个 episode |
| Epsilon 衰减 | 1.0 → 0.01 (1000 episodes) |
| 最大训练 Episodes | 1000 |

### 微调训练

| 参数 | 值 |
|:---:|:---:|
| Learning Rate | 5e-5 (降低) |
| Steps/Epoch | 20,000 |
| Epsilon 衰减步数 | 50,000 |
| 目标网络同步频率 | 每 1,000 步 |
| 评估 Episodes | 5/epoch |

### 自博弈训练

| 参数 | 值 |
|:---:|:---:|
| Batch Size | 128 |
| Learning Rate | 1e-4 / 2.5e-4 |
| 回放缓冲区大小 | 200k / 500k |
| 总训练步数 | 500k - 1M |
| 目标网络同步频率 | 每 10k 步 |
| 优化器 | RMSprop (alpha=0.95) |

---

## 🛠️ 技术栈

<div align="center">

| 类别 | 技术 |
|:---:|:---:|
| 深度学习 | ![PyTorch](https://img.shields.io/badge/PyTorch-2.5.1-EE4C2C) |
| 强化学习环境 | OpenAI Gym 0.15.7 + ALE + PettingZoo |
| GPU 加速 | CUDA 11.8 + cuDNN 8.9.7 |
| 视觉处理 | OpenCV 4.10 |
| 容器化 | Docker (Miniconda3 base) |
| 可视化 | TensorBoard + Gym Monitor |
| 部署 | 离线 Conda + CUDA/cuDNN 自动安装 |

</div>

---

## 📖 算法参考文献

- **DQN**: Mnih et al. "Human-level control through deep reinforcement learning." *Nature* 518, 529–533 (2015)
- **Double DQN**: van Hasselt et al. "Deep Reinforcement Learning with Double Q-learning." *AAAI* (2016)
- **Dueling DQN**: Wang et al. "Dueling Network Architectures for Deep Reinforcement Learning." *ICML* (2016)
- **Self-Play**: Silver et al. "Mastering the game of Go with deep neural networks and tree search." *Nature* 529, 484–489 (2016)

---

<div align="center">

**⭐ 如果这个项目对您有帮助，请给个 Star 支持一下！**

</div>
