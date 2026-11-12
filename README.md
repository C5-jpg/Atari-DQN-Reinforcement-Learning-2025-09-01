# Atari Pong DQN：训练、微调与评估记录

从像素输入学习 `PongNoFrameskip-v4` 的强化学习实验项目。主要实现包括卷积 DQN、经验回放、目标网络、已有权重微调，以及基于 ALE 状态快照的单分评估。仓库同时保留早期多智能体实验和部署材料。

**English summary.** This repository contains a pixel-based DQN implementation for Atari Pong, checkpoint fine-tuning, and a snapshot-based point evaluation tool. Historical logs include both positive and negative evaluation returns. They do not establish a multi-seed benchmark or a general improvement from fine-tuning. The active implementation uses the legacy Gym API; archived multi-agent experiments are separate from the main DQN pipeline.

## 研究问题与范围

本项目围绕三个可检查的问题组织代码和记录：

1. 如何把 Pong 图像预处理、Q 网络、经验回放和目标网络连接为完整训练循环？
2. 继续训练已有策略时，训练回报和独立评估回报是否一致，是否会出现性能退化？
3. 完整游戏回合的平均回报，与从相同模拟器状态出发的单分测试，分别衡量什么？

| 内容 | 当前入口与边界 |
|---|---|
| 单智能体 DQN | [dqn.py](dqn.py)：`train()`、`finetune()`、`evaluate()` |
| 已有模型 | [pong_dqn.pth](pong_dqn.pth) 与 [epoch 1 微调权重](finetune_ckpts/pong_dqn_ft_epoch1.pth)；权重与历史 CSV 行没有完整的唯一对应记录 |
| 单分测试 | [shadow_leaderboard.py](shadow_leaderboard.py)：共享状态快照或无快照时的种子回退评估 |
| 早期实验 | [outOfDate/](outOfDate/)：独立的历史代码，不是主入口中可切换的算法选项 |
| 环境与部署 | 保留旧 Gym 和 Windows 离线安装材料；全新机器安装、Docker 构建仍有下文所列限制 |

主入口的更新目标为 `r + (1 - done) * gamma * max Q_target(s', a')`，使用普通 DQN 网络。它没有 Double DQN 的动作选择/价值估计分离，也没有 Dueling 网络头；历史目录中的实验不能作为主入口已支持这些算法的证明。

## 已保存结果

### 微调 CSV

以下逐行摘录 [finetune_ckpts/finetune_metrics.csv](finetune_ckpts/finetune_metrics.csv)，保留原文件顺序及失败结果：

| CSV 数据行 | epoch | 累计训练步数 | 最近至多 100 个已完成训练回合的平均回报 | 评估平均回报 |
|---:|---:|---:|---:|---:|
| 1 | 1 | 20,000 | 15.6250 | +21.0 |
| 2 | 2 | 40,000 | 18.0000 | +21.0 |
| 3 | 3 | 60,000 | 18.5385 | **−21.0** |
| 4 | 4 | 80,000 | 18.6471 | +21.0 |
| 5 | 5 | 100,000 | 18.9767 | +21.0 |
| 6 | 1 | 20,000 | −18.8667 | +20.0 |

第 3 行显示：训练回报仍为正时，评估回报出现明显退化。后续行恢复到 +21，但现有记录不足以确定退化原因。

最后一行的 epoch 和累计步数重新从 1 / 20,000 开始。CSV 没有 run ID、时间戳、配置快照、权重哈希或逐回合评估记录；因此不能把全部六行视为同一次连续运行，也不能从这些记录计算可信的多次运行均值或泛化胜率。当前源码默认仅微调 1 个 epoch，其 epsilon 配置也不能直接解释前五行的历史值。

`evaluate()` 使用贪心策略完成整个 episode，返回平均回报和平均长度；当前微调配置每次评估 5 个 episode。历史 CSV 未记录每行实际使用的评估回合数，不能仅凭当前默认值补全历史实验协议。CSV 中的步数和长度按 `PongWrapper.step()` 调用计数，每次调用最多执行 4 次底层环境步，不能直接当作原始 Atari 帧数。

### Shadow Match CSV

[shadow_leaderboard.csv](shadow_leaderboard.csv) 保存的是**单分测试**：策略从一个起始状态运行，直到获得非零奖励、游戏结束或达到步数上限。

| CSV 数据行 | 模型标签 | 得分 / 失分 / 平分 | 测试分数 | 平均步数/分 |
|---:|---|---|---:|---:|
| 1 | `baseline` | 100 / 0 / 0 | 100 | 89.0 |
| 2 | `baseline` | 50 / 0 / 0 | 50 | 89.0 |
| 3 | `ftbad_ep1` | 50 / 0 / 0 | 50 | 270.0 |

这些数字不是完整游戏胜率。不同记录的测试分数不同，CSV 也没有保存快照集合、配置和权重哈希，不能据此认定各行来自同一次可比实验。脚本支持在一次调用内让多个模型使用同一批快照；状态集合本身不持久化，跨调用比较需要另行保留完整实验记录。

## 环境与 ROM

### 旧接口依赖

代码使用 `import gym`，并按旧接口解包 `step()` 的四个返回值；`PongWrapper.reset()` 返回单个状态张量。当前 Gymnasium / ALE 文档使用不同的环境注册及返回接口，不能仅替换包名就直接运行本代码。[当前 ALE 接口示例](https://ale.farama.org/getting-started/)

[scripts/setup_gpu_env.bat](scripts/setup_gpu_env.bat) 记录的历史安装目标如下，**它不是经过锁定的跨平台环境清单**：

| 组件 | 历史目标或源码需求 |
|---|---|
| Python | 3.9 |
| PyTorch | 2.5.1，Windows GPU 脚本使用 `+cu118` 构建 |
| Gym | 0.15.7，旧四返回值 API |
| Atari 后端 | `atari-py`；主代码通过旧 Gym 创建环境 |
| 图像处理 | OpenCV 4.10.0.82 |
| 数值计算 | NumPy，历史脚本没有固定版本 |

目前没有统一的依赖锁文件。`packages/` 混有 Python 3.11 的 Windows wheel，而安装脚本创建 Python 3.9 环境；仓库文件树也没有脚本所需的 PyTorch wheel。因此，现有离线包不能视为可直接安装的完整 Python 3.9 环境。`atari-py` 本身已停止维护，Windows 构建存在额外兼容限制，参见其[上游说明](https://github.com/openai/atari-py)。

下面的运行示例以**已建立可用旧 Gym / Atari 环境**为前提；本仓库尚未提供经过全新环境验证的一键安装流程。

### ROM 准备

请使用自己具有使用权限的 Pong ROM，并遵循其提供方的条款。仓库包含 `ROMS/` 目录不代表仓库作者能够对其中游戏内容授予使用或再分发许可。旧 `atari-py` 环境的导入接口为：

```bash
python -m atari_py.import_roms /path/to/authorized-roms
```

将路径替换为自己的 ROM 目录；含空格的路径使用引号。命令接口见 [atari-py ROM 导入说明](https://github.com/openai/atari-py#roms)。不要将新 ALE 环境的注册方式与本项目旧 Gym 入口混用。

## 运行

所有命令均从仓库根目录执行。先获取代码：

```bash
git clone --depth 1 https://github.com/C5-jpg/Atari-DQN-Reinforcement-Learning-2025-09-01.git
cd Atari-DQN-Reinforcement-Learning-2025-09-01
```

### 1. 检查环境和预处理

在兼容环境中执行以下命令，不进行训练：

```bash
python -c "import gym, atari_py, cv2, numpy, torch; print('gym', gym.__version__, 'numpy', numpy.__version__, 'torch', torch.__version__, 'opencv', cv2.__version__)"
python -c "from dqn import make_env_oldgym; env = make_env_oldgym('PongNoFrameskip-v4', seed=123); state = env.reset(); print(tuple(state.shape), env.action_space.n); env.close()"
```

第二条命令预期打印 `(4, 84, 84) 3`。找不到环境、缺 ROM、依赖导入错误或返回值数量不匹配，都表示尚未满足后续训练/评估条件。

### 2. 评估已有权重

在仓库根目录启动 Python，将以下代码作为一个完整代码块执行。它只加载权重并运行评估，不训练模型：

```python
import torch
from dqn import DQN, make_env_oldgym, evaluate

device = "cuda" if torch.cuda.is_available() else "cpu"
env = make_env_oldgym("PongNoFrameskip-v4", seed=123)
try:
    model = DQN(len(env.valid_actions)).to(device)
    state_dict = torch.load("pong_dqn.pth", map_location=device, weights_only=True)
    model.load_state_dict(state_dict)
    avg_return, avg_length = evaluate(env, model, n_episodes=5, device=device)
    print({"avg_return": avg_return, "avg_wrapper_steps": avg_length})
finally:
    env.close()
```

构造函数是 `DQN(action_dim)`；四帧输入已固定在网络内部。评估微调模型时，将权重路径换成 `finetune_ckpts/pong_dqn_ft_epoch1.pth`。输出是本次评估结果，不保证等于历史 CSV 中的某一行。

### 3. 微调已有模型

```bash
python dqn.py
```

这个默认入口调用 **`finetune()`**，要求根目录已有 `pong_dqn.pth`。当前默认配置为 1 个 epoch、20,000 个包装环境步、学习率 `5e-5`，结果写入 `finetune_ckpts/`。重复执行会向同一个 CSV 追加记录，并覆盖同名 epoch 权重。

为每次实验使用独立目录，可在 Python 中运行：

```python
import json
from pathlib import Path
from dqn import finetune, finetune_config

run_dir = Path("runs/finetune-001")
run_dir.mkdir(parents=True, exist_ok=False)
cfg = dict(finetune_config)
cfg["save_dir"] = str(run_dir)
(run_dir / "config.json").write_text(
    json.dumps(cfg, indent=2), encoding="utf-8"
)
finetune(cfg)
```

目录已存在时此示例会停止，以避免混入旧记录。每个 epoch 生成 `pong_dqn_ft_epochN.pth` 和一行 `finetune_metrics.csv`。配置副本保留了本次参数；严谨比较还需要记录代码提交、输入权重哈希和环境版本。

### 4. 从随机初始化训练

真实入口是导入模块后调用 `train()`：

```bash
python -c "from dqn import train; train()"
```

它读取 `dqn.py` 中的 `config`，不加载已有权重，默认训练 1,000 个 episode，结束时写入并**覆盖当前目录的 `pong_dqn.pth`**。运行前保留需要继续使用的权重。该函数没有命令行参数解析，没有独立的逐 epoch 检查点或完整实验日志，也没有在函数内设置随机种子。

训练使用浮点帧张量的经验回放，内存占用会随缓冲区增长；默认容量为 100,000。完整训练不等于环境检查，运行时间和资源需求应结合机器与配置测量。

### 5. 在同一次 Shadow Match 中比较两个模型

以下为单行命令，可用于 Bash 或 PowerShell；每次运行更换 CSV 文件名，避免混合实验：

```bash
python shadow_leaderboard.py --env PongNoFrameskip-v4 --seed 123 --bank-size 50 --fallback-points 50 --csv shadow_comparison_001.csv --model baseline=./pong_dqn.pth --model finetuned=./finetune_ckpts/pong_dqn_ft_epoch1.pth
```

脚本先收集 ALE 状态快照，再让两个模型分别评估。若后端缺少所需快照能力，会打印警告并退回到不同种子下的首分测试；两种模式的结果应分开报告。`--max-steps` 默认每分 4,000 个包装环境步；没有得失分而到达上限的记录归为平分。该工具并不是两个模型在同一场 Pong 中直接控制左右两侧的对战。

## 实现要点

- **状态**：裁剪图像的 `34:194` 行，转灰度、缩放到 `84 × 84`，归一化后堆叠 4 帧。每次动作最多重复 4 个底层环境步，期间更新帧队列。
- **动作**：网络输出 3 个 Q 值，映射到 Atari 动作编号 `[0, 2, 3]`。
- **网络**：三层卷积 `4→32→64→64`，展平后接 `3136→512→3` 全连接层。
- **优化**：Adam、Smooth L1 损失和梯度裁剪；从回放缓冲区均匀抽样。
- **目标网络**：从零训练按 episode 更新，微调按包装环境步更新；两条训练路径的参数和调度不同。

| 参数 | `train()` 默认值 | `finetune()` 默认值 |
|---|---:|---:|
| batch size | 64 | 64 |
| gamma | 0.99 | 0.99 |
| 学习率 | `1e-4` | `5e-5` |
| 回放容量 | 100,000 | 100,000 |
| 目标网络更新 | 每 5 个 episode，含 episode 0 | 每 1,000 步 |
| 探索率 | 按 episode 从 1.0 衰减至下限 0.01 | 按步从 0.99 衰减，50,000 步达到 0.01 |
| 训练规模 | 1,000 个 episode | 1 × 20,000 步 |

## 局限与历史材料

现有结果是实验记录，不是经多随机种子和统一协议验证的 Atari 基准。历史运行缺少可核对的配置与权重映射，不能据此宣称持续稳定达到 +21、微调必然提升，或某种 DQN 变体优于另一种。

以下材料保留原有工程上下文，使用前需要核对其环境假设：

| 材料 | 用途与限制 |
|---|---|
| [PROJECT_LOG.md](PROJECT_LOG.md) | 历史开发记录；其中过程性结论不替代原始结果 |
| [OFFLINE_INSTALL_README.md](OFFLINE_INSTALL_README.md)、[TROUBLESHOOTING.md](TROUBLESHOOTING.md) | Windows 环境记录；离线包的版本/平台不一致问题尚未解决 |
| [Dockerfile](Dockerfile) | 需要 `atari_env.tar.gz`，该文件未包含在当前仓库中；直接 `docker build` 会在复制该文件时失败 |
| [video/](video/) | 已保存视频，可作行为示例，不能替代定量评估 |
| [outOfDate/](outOfDate/) | 历史实验和部署文件，与主 DQN 路径分开阅读 |

## 方法来源与许可

DQN 的方法来源为 Mnih 等人的 *Human-level control through deep reinforcement learning*（Nature, 2015）；本仓库提供相关学习实现和实验记录，不将算法思想归为仓库维护者原创。具体代码演变和作者归属可查看 [提交历史](https://github.com/C5-jpg/Atari-DQN-Reinforcement-Learning-2025-09-01/commits/main/)。

当前仓库根目录没有许可证文件，因此不宣称整个项目采用 MIT 或其他统一开源许可证。代码、模型、第三方依赖和游戏 ROM 的授权应分别核对。
