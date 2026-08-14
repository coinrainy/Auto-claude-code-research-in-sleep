# Amazon GRACE 1:1:8 复现与论文对照

日期：2026-08-14

## 本地复现协议

- 上游 GRACE：`CRIPAC-DIG/GRACE`，commit `b3b5ac3fcbaabbb50e8bd69a075b46cd82a50378`。
- 数据：PyG 版本 Amazon Computers（13,752 节点）和 Amazon Photo（7,650 节点）。
- 预训练：全图无监督 GRACE，使用 GCA 参数包中的 2,000 epochs 配置。
- 评估：每个类别分别按 train/validation/test = 1:1:8 划分；验证集选择线性分类器 C；测试集只评估一次。
- 独立运行：每个数据集 10 次；训练、划分、分类器分别使用递增种子。
- 本地划分是确定性的分层 1:1:8。论文通常只明确 10%/10%/80% 比例，因此下面是协议级对照，不是相同随机划分的逐点复刻。

## 逐次结果

| 数据集 | 10 次 accuracy（%） | 均值 ± 总体标准差（%） | macro-F1（%） |
|---|---|---:|---:|
| Amazon Computers | 88.3818, 86.9091, 87.2909, 87.0455, 87.8727, 87.0818, 86.2727, 86.4455, 87.3182, 87.4000 | **87.2018 ± 0.5885** | 84.6964 ± 0.9639 |
| Amazon Photo | 92.2712, 85.3758, 91.5523, 91.9935, 92.2222, 92.0425, 91.6013, 91.7647, 92.6471, 92.5817 | **91.4052 ± 2.0406** | 89.5109 ± 2.7789 |

## 采用 1:1:8 的论文对照

| 来源 | Amazon Computers accuracy（%） | Amazon Photo accuracy（%） |
|---|---:|---:|
| JGCL（WWW 2022） | 87.13 ± 0.17 | 92.22 ± 0.91 |
| UGCL（IJCAI 2025） | 86.8 ± 0.32 | 91.8 ± 0.15 |
| SP-GCL（TMLR 稿件） | 86.35 ± 0.44 | 92.15 ± 0.25 |
| 本地 GRACE（10 次） | **87.2018 ± 0.5885** | **91.4052 ± 2.0406** |

来源：

- [JGCL WWW 2022 PDF](https://par.nsf.gov/servlets/purl/10543005)：明确采用 GCA 的 10%/10%/80% 划分，并报告 GRACE 为 87.13/92.22。
- [UGCL IJCAI 2025 PDF](https://ijcai-preprints.s3.us-west-1.amazonaws.com/2025/4910.pdf)：明确采用 10%/10%/80% 划分，并报告 GRACE 为 86.8/91.8。
- [SP-GCL TMLR PDF](https://openreview.net/notes/edits/attachment?id=EUzwo2MxkR&name=pdf)：明确采用 10%/10%/80% 划分、10 次平均，并报告 GRACE 为 86.35/92.15。

## 结论

1. **Amazon Computers：可以达到论文 GRACE 的点估计水平。** 本地均值比 JGCL 的 87.13% 高 0.0718 个百分点，比 UGCL 和 SP-GCL 的 GRACE 报告值分别高 0.4018 和 0.8518 个百分点；但本地标准差明显更大（0.5885%）。
2. **Amazon Photo：单次可以达到论文数值，但 10 次均值没有稳定达到。** 本地均值比 JGCL、SP-GCL、UGCL 分别低 0.8148、0.7448、0.3948 个百分点；第 2 次只有 85.3758%，导致总体标准差达到 2.0406%。
3. 因此，当前 GRACE baseline 在 Computers 上基本复现成功；Photo 上存在明显 seed 敏感性，不能用最好的一次 92.6471% 代替 10 次平均结果。

结果文件：

- `results/amazon_computers_1_1_8_10run/aggregate.json`
- `results/amazon_photo_1_1_8_10run/aggregate.json`
