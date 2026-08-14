# 其余数据集 GRACE 单编码器复现

日期：2026-08-14

## 协议

- 数据集：Cora、CiteSeer、PubMed、Coauthor CS、Coauthor Physics。
- 每个数据集只训练 1 个 GRACE encoder，使用配置中的完整 epochs。
- 固定 encoder embedding，重复 20 次线性分类器；每次使用新的 1:1:8 分层 split/classifier seed。
- validation 选择 `C=2^-10 ... 2^9` 中 accuracy 最优的分类器，随后只在 80% test 上评估一次。
- DBLP 不在当前目标数据集表中，本轮未运行。

## 结果

| 数据集 | epochs | Accuracy（20 次分类器） | Macro-F1 |
|---|---:|---:|---:|
| Cora | 200 | **83.7662% ± 0.7661%** | 82.4456% ± 0.7569% |
| CiteSeer | 200 | **71.7832% ± 0.8200%** | 63.9207% ± 1.8349% |
| PubMed | 1500 | **85.9000% ± 0.2782%** | 85.6001% ± 0.2800% |
| Coauthor CS | 1000 | **92.8179% ± 0.2376%** | 90.6710% ± 0.3799% |
| Coauthor Physics | 1500 | **95.6284% ± 0.0909%** | 94.2082% ± 0.1413% |

该“一次 encoder、重复线性分类器”的设计与 [JGCL WWW 2022](https://par.nsf.gov/servlets/purl/10543005) 对 GRACE/GCA 的评估描述一致；本地仍使用确定性的分层 1:1:8 划分，因此不是相同随机种子的逐点复刻。

## 与此前独立 encoder 结果的变化

- Cora：此前 10 个独立 encoder 为 `82.8235% ± 0.8653%`，本次固定一个 encoder 后为 `83.7662% ± 0.7661%`。
- CiteSeer：此前为 `71.6535% ± 0.6459%`，本次为 `71.7832% ± 0.8200%`。
- Coauthor Physics 使用 `batch_size=1024` 的流式分块反向传播，1500 epochs 未发生 OOM。

## 结果目录

- `results/cora_single_encoder_20clf_1_1_8/`
- `results/citeseer_single_encoder_20clf_1_1_8/`
- `results/pubmed_single_encoder_20clf_1_1_8/`
- `results/coauthor_cs_single_encoder_20clf_1_1_8/`
- `results/coauthor_physics_single_encoder_20clf_1_1_8/`

每个目录包含一个 `encoder.json`、20 个 `classifier_*.json` 和一个 `aggregate.json`。
