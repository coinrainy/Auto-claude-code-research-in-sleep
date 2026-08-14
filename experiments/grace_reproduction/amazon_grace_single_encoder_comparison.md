# Amazon GRACE 单编码器、多线性分类器复现

日期：2026-08-14

## 协议

- 每个数据集只训练 1 个 GRACE encoder，训练 2,000 epochs。
- 固定该 encoder 输出的 embedding，不重新训练 encoder。
- 线性评估重复 20 次；每次使用新的 1:1:8 分层 split seed 和 classifier seed。
- 在每次 train/validation split 上选择 `C`，然后只在对应的 80% test 上评估一次。
- encoder seed 为配置中的 `39788`；classifier split 从 `49788` 开始，classifier seed 从 `59788` 开始。

该模式对应论文中“一次 encoder、重复线性分类器”的设置。论文只明确比例和重复方式，未提供与本地完全相同的随机种子，因此仍是协议级复现。

## 结果

| 数据集 | Accuracy（20 次分类器） | Macro-F1 |
|---|---:|---:|
| Amazon Computers | **87.7755% ± 0.3760%** | 85.5414% ± 0.6976% |
| Amazon Photo | **91.9698% ± 0.3606%** | 90.1827% ± 0.5316% |

## 论文对照

| 来源 | Amazon Computers | Amazon Photo |
|---|---:|---:|
| JGCL（WWW 2022） | 87.13 ± 0.17 | 92.22 ± 0.91 |
| UGCL（IJCAI 2025） | 86.8 ± 0.32 | 91.8 ± 0.15 |
| SP-GCL（TMLR 稿件） | 86.35 ± 0.44 | 92.15 ± 0.25 |
| 本地 GRACE：1 encoder + 20 classifiers | **87.7755 ± 0.3760** | **91.9698 ± 0.3606** |

来源：

- [JGCL WWW 2022 PDF](https://par.nsf.gov/servlets/purl/10543005)：明确使用 GCA 的 10%/10%/80% 划分，并说明 GRACE/GCA 使用一次 encoder、重复线性分类器。
- [UGCL IJCAI 2025 PDF](https://ijcai-preprints.s3.us-west-1.amazonaws.com/2025/4910.pdf)：明确采用 10%/10%/80% 划分并报告 GRACE baseline。
- [SP-GCL TMLR PDF](https://openreview.net/notes/edits/attachment?id=EUzwo2MxkR&name=pdf)：明确采用 10%/10%/80% 划分并报告 GRACE baseline。

## 结论

- **Amazon Computers：达到并超过上述论文中的 GRACE 点估计。** 本地结果比 JGCL、UGCL、SP-GCL 分别高 0.6455、0.9755、1.4255 个百分点。
- **Amazon Photo：明显优于之前 10 个独立 encoder 的均值。** 新均值从 91.4052% 提升到 91.9698%，标准差从 2.0406% 降到 0.3606%；与 JGCL 和 SP-GCL 分别相差 -0.2502 和 -0.1802 个百分点，但高于 UGCL 的 91.8%。
- 因此，在“一次 encoder、重复线性分类器”的论文匹配协议下，Computers 可以复现，Photo 已基本接近论文 GRACE 数值，且不再出现之前 85.3758% 的极端低值。

结果文件：

- `results/amazon_computers_single_encoder_20clf_1_1_8/encoder.json`
- `results/amazon_computers_single_encoder_20clf_1_1_8/aggregate.json`
- `results/amazon_photo_single_encoder_20clf_1_1_8/encoder.json`
- `results/amazon_photo_single_encoder_20clf_1_1_8/aggregate.json`
