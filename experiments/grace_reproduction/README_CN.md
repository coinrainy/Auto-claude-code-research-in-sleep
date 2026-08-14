# GRACE 复现：Cora / CiteSeer

本目录记录官方 GRACE 在当前环境中的可复现实验。上游代码来自
`https://github.com/CRIPAC-DIG/GRACE.git`，固定 commit 为
`b3b5ac3fcbaabbb50e8bd69a075b46cd82a50378`。

## 协议

- 只跑 Cora 和 CiteSeer；沿用上游 `config.yaml` 的模型、增强、优化器和 200 epochs。
- 保留官方 GRACE 的双视图 edge/feature dropout、GCN encoder、projection head 和全量 InfoNCE。
- 每个类别独立打乱后取 `round(10%)` 到 train，再取同样数量到 validation，剩余节点为 test；实际大小为 Cora `272/272/2164`、CiteSeer `333/333/2661`。
- embedding 只做 L2 normalization；用 train 拟合 `OneVsRest(LogisticRegression(solver=liblinear))`，在 validation 上从 `C=2^-10 ... 2^9` 选择 accuracy 最优者，随后只在 80% test 上评估一次，不使用 test 选择超参数。
- 每个数据集独立运行 10 次。第 `i` 次（从 0 开始）的训练、划分、分类器种子分别为 `config.seed+i`、`config.seed+10000+i`、`config.seed+20000+i`。
- 汇总报告 accuracy、micro-F1、macro-F1 的均值和总体标准差，百分比保留到 4 位小数。
- 论文匹配模式使用 `--single_encoder --classifier_runs 20`：只训练一个 encoder，固定 embedding，随后用 20 组独立 split/classifier seed 重复线性评估。

## GCA 数据集配置补全

`GRACE/config.yaml` 已补齐 Amazon/Coauthor 四个数据集，参数取自 GCA 官方
[`param/`](https://github.com/CRIPAC-DIG/GCA/tree/main/param) 的 uniform-drop
配置：`Amazon Computers`、`Amazon Photo`、`Coauthor CS`、`Coauthor Physics`。
同时支持 GCA 风格别名 `Amazon-Computers`、`Amazon-Photo`、`Coauthor-CS` 和
`Coauthor-Phy`。GCA 参数文件没有 dataset-specific seed，因此新增配置记录
GCA runner 默认 seed `39788`；`Coauthor Physics` 使用 `batch_size=1024`
以匹配官方大图 loss 路径，其余数据集使用全量 InfoNCE。

## 已完成结果

Amazon Computers 和 Amazon Photo 的 1:1:8、10 次独立 encoder 复现及论文对照见
[amazon_grace_comparison.md](amazon_grace_comparison.md)；单 encoder、20 次线性分类器的结果见
[amazon_grace_single_encoder_comparison.md](amazon_grace_single_encoder_comparison.md)。
其余五个目标数据集的同协议结果见
[grace_single_encoder_remaining_comparison.md](grace_single_encoder_remaining_comparison.md)。

| 数据集 | test accuracy | test micro-F1 | test macro-F1 |
|---|---:|---:|---:|
| Cora | 82.8235% ± 0.8653% | 82.8235% ± 0.8653% | 81.3026% ± 0.9512% |
| CiteSeer | 71.6535% ± 0.6459% | 71.6535% ± 0.6459% | 63.7752% ± 1.9799% |

各实验的 run/classifier 收据（含 seed、split 尺寸、split SHA-256、validation 选出的 C、loss history 和测试指标）位于 `results/`。`aggregate.json` 是汇总入口。

## 重跑

先将官方仓库拉到当前工作区的兄弟目录，并应用本目录保存的兼容补丁：

```bash
git clone --depth=1 https://github.com/CRIPAC-DIG/GRACE.git ../GRACE
git -C ../GRACE apply experiments/grace_reproduction/upstream_grace_1_1_8.patch
```

然后执行：

```bash
./experiments/grace_reproduction/run_10.sh
```

可通过 `GRACE_ROOT`、`DATA_ROOT`、`PYTHON_BIN` 和 `RESULT_ROOT` 覆盖默认路径；脚本带 `--resume`，中断后可继续已有 run。补齐后的数据集可直接单独运行，例如：

```bash
../.venv-g02/bin/python ../GRACE/train.py \
  --dataset Amazon-Computers \
  --config ../GRACE/config.yaml \
  --data_root /root/autodl-tmp/G-02-baseline-data/pyg \
  --runs 10
```

论文匹配的单 encoder 模式示例：

```bash
../.venv-g02/bin/python ../GRACE/train.py \
  --dataset Amazon-Computers \
  --config ../GRACE/config.yaml \
  --data_root /root/autodl-tmp/G-02-baseline-data/pyg \
  --single_encoder \
  --classifier_runs 20
```

## 环境和数据

本次运行使用 Python 3.10.8、Torch 2.13.0+cu126、PyG 2.8.0.post1、scikit-learn 1.7.2、NumPy 2.2.6 和 RTX 4090。数据缓存使用 PyG Planetoid 格式；数据不复制进仓库。
