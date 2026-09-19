# 微多样性（Microdiversity）学习笔记：从零开始理解宏基因组中的群体遗传变异

> 适用对象：对生态学、进化遗传学和微多样性分析不熟悉，但已经接触宏基因组、MAG、vOTU、reads mapping 的初学者。  
> 适用场景：环境宏基因组、病毒组、MAG、vOTU、contig 层面的微多样性分析。  
> 核心问题：同一个微生物或病毒群体内部，是否存在遗传差异？这些差异能回答什么生态问题？

---

## 目录

1. 微多样性到底是什么？
2. 为什么要研究微多样性？
3. 宏多样性和微多样性的区别
4. 从 reads 到微多样性的基本逻辑
5. 常用术语解释
6. 微多样性指标总览
7. Coverage depth：覆盖深度
8. Coverage breadth：覆盖广度
9. SNV / SNP：单核苷酸变异
10. SNV density：变异密度
11. Nucleotide diversity, π：核苷酸多样性
12. Population ANI：群体平均核苷酸一致性
13. Linkage disequilibrium：连锁不平衡
14. pN/pS：非同义/同义多态比值
15. FST：群体遗传分化
16. Tajima’s D：中性检验指标
17. dN/dS、pN/pS、Ka/Ks 的区别
18. Strain、population、species、vOTU 的关系
19. 微多样性可以回答哪些生态问题？
20. 病毒微多样性分析的特殊问题
21. MAG 微多样性分析的特殊问题
22. 常用工具：inStrain、MetaPop、metaSNV、MIDAS 等
23. 推荐分析路线
24. 结果解释模板
25. 常见误区
26. 论文方法写法模板
27. 黄河/WWTP 项目的建议做法
28. 一句话总结

---

# 1. 微多样性到底是什么？

**微多样性（microdiversity）** 指的是同一个微生物或病毒群体内部的遗传差异。

这里的“同一个群体”可以是：

- 一个细菌 species；
- 一个 MAG；
- 一个病毒 vOTU；
- 一个 viral contig；
- 一个参考基因组；
- 一个基因或基因组片段。

它关注的不是“有哪些物种”，而是：

> 在同一个物种、同一个 MAG 或同一个病毒群体内部，不同个体之间是否存在碱基差异？

例如，有一个病毒 contig：

```text
Reference viral contig:
ATGCTAGCTAGCTAGC
```

样品中的 reads 回贴上去以后，你发现第 8 个位置有些 reads 是 `C`，有些 reads 是 `T`：

```text
部分 reads: ATGCTAGCTAGCTAGC
部分 reads: ATGCTAGTTAGCTAGC
                  ↑
               变异位点
```

这个位置就是一个群体内的单核苷酸变异。微多样性分析就是把这些变异系统地识别出来，然后计算指标，回答生态和进化问题。

---

# 2. 为什么要研究微多样性？

宏基因组中常规的群落分析通常告诉你：

- 哪些物种或病毒存在？
- 哪些样品的群落组成更相似？
- 哪个环境中某些类群更丰富？

但这些问题只看到“种类层面”。

微多样性进一步问：

- 同一个物种内部是否有多个不同 strain？
- 同一个病毒 vOTU 是否在不同季节发生了遗传变化？
- WWTP effluent 和 Yellow River water 中的同一群体是否是同一个来源？
- 某个群体是近期扩增，还是长期稳定存在？
- 某些基因是否受到选择压力？

举例：

两个样品中都有同一个病毒 vOTU，而且丰度差不多。

宏多样性会说：

> 这个病毒在两个样品中都存在。

微多样性会继续问：

> 两个样品里的这个病毒，是同一个遗传群体吗？还是同一个 vOTU 下面包含不同变体？

这就让你从“有没有”进入到“内部是否分化、是否替换、是否适应”的层面。

---

# 3. 宏多样性和微多样性的区别

| 层级 | 英文 | 关注对象 | 常见指标 | 典型问题 |
|---|---|---|---|---|
| 宏多样性 | Macrodiversity | 不同物种、OTU、vOTU、MAG 之间的组成差异 | Richness, Shannon, Bray-Curtis, Jaccard, NMDS, PCoA | Yellow River 和 WWTP effluent 的病毒群落组成是否不同？ |
| 微多样性 | Microdiversity | 同一个物种、MAG、vOTU、contig 内部的遗传变异 | SNV density, π, population ANI, pN/pS, FST, Tajima’s D | 同一个病毒群体在春季和夏季内部遗传结构是否不同？ |

简单理解：

```text
宏多样性：看“有哪些类群”
微多样性：看“同一个类群内部变了多少”
```

类比：

```text
宏多样性：这个城市里有哪些姓氏？
微多样性：同一个姓氏家族内部，不同个体之间有哪些 DNA 差异？
```

---

# 4. 从 reads 到微多样性的基本逻辑

微多样性分析通常不是直接从 contig 数量或 TPM 开始，而是从 reads mapping 开始。

基本流程：

```text
参考序列
MAGs / viral contigs / vOTUs / reference genomes
↓
每个样品的 reads 回贴到参考序列
↓
得到 BAM 文件
↓
统计每个位点的碱基组成
↓
识别 SNV / SNP
↓
计算 coverage、π、SNV density、ANI、FST 等指标
```

举例：

假设某个位置被 20 条 reads 覆盖：

```text
A: 14 条 reads
G: 6 条 reads
C: 0
T: 0
```

这个位置不是完全一致，而是有两种碱基状态。这个位点就可以贡献微多样性信号。

微多样性分析的本质是：

> 利用 reads 中隐藏的碱基差异，估计同一个群体内部的遗传变异程度。

---

# 5. 常用术语解释

## 5.1 Reference

**Reference** 是 reads 回贴的目标序列，可以是：

- MAG；
- viral contig；
- vOTU representative sequence；
- isolate genome；
- gene sequence。

微多样性分析的结果高度依赖 reference 的选择。

如果 reference 选得太宽泛，多个相近但不同的群体可能会被 reads 混贴到一起，导致假阳性 SNV 增多。

如果 reference 选得太严格，真实变异较大的 reads 可能贴不上去，导致微多样性被低估。

---

## 5.2 Read recruitment

**Read recruitment** 指把样品中的 reads 比对到参考序列上。

常用工具：

- Bowtie2；
- BWA-MEM / BWA-MEM2；
- Minimap2；
- BBMap。

比对完成后通常得到 BAM 文件。

---

## 5.3 BAM 文件

BAM 是二进制格式的 alignment 文件，记录每条 read 比对到了参考序列的哪里、比对质量如何、碱基是否匹配等信息。

微多样性工具通常输入：

```text
reference.fa + sample.bam
```

然后输出：

```text
coverage
SNV
π
ANI
linkage
population comparison
```

---

## 5.4 Allele

**Allele** 在这里可以简单理解为某个位点上不同的碱基状态。

例如一个位置：

```text
A: 70%
G: 30%
```

那么 A 和 G 就是这个位点的两个 allele。

---

## 5.5 Allele frequency

**Allele frequency** 是某个 allele 在该位点所有 reads 中的比例。

例如：

```text
总 reads = 20
A = 14
G = 6
```

则：

```text
A frequency = 14 / 20 = 0.70
G frequency = 6 / 20 = 0.30
```

如果一个低频 allele 只占 1% 或 2%，可能是真实低频变异，也可能是测序错误。因此很多分析会设置 minimum allele frequency 过滤。

---

## 5.6 Strain

**Strain** 可以理解为同一 species 内部遗传上有所不同的变体。

例如：

```text
E. coli strain A
E. coli strain B
```

它们都是 E. coli，但基因组不完全相同。

在宏基因组中，我们很少能直接看到完整 strain，通常只能通过 SNV、coverage、linkage 等信号推断是否存在多个 strain。

---

## 5.7 Population

**Population** 在微多样性中通常指：

> 一个样品中，能够比对到同一个 reference 的一组相近微生物或病毒个体。

比如某个 viral contig 在一个水样中被很多 reads 覆盖，那么这些 reads 代表的病毒个体可以看作该 contig 对应的 viral population。

---

## 5.8 vOTU

**vOTU = viral operational taxonomic unit**。

它是病毒组研究中常用的操作分类单元。通常根据序列相似性聚类得到。

常见 vOTU 聚类标准：

```text
≥ 95% ANI
≥ 85% alignment fraction
```

但 vOTU 不完全等于传统意义上的 species。它是一个方便分析的操作单元。

---

# 6. 微多样性指标总览

| 指标 | 中文解释 | 主要回答的问题 | 对数据质量要求 |
|---|---|---|---|
| Coverage depth | 覆盖深度 | 这个 reference 被测得够不够深？ | 基础过滤指标 |
| Coverage breadth | 覆盖广度 | reference 有多少比例被覆盖？ | 基础过滤指标 |
| SNV count | SNV 数量 | 检测到多少变异位点？ | 中等 |
| SNV density | SNV 密度 | 单位长度内变异多不多？ | 中等 |
| π | 核苷酸多样性 | 群体内部平均遗传差异有多大？ | 较高 |
| population ANI | 群体平均一致性 | 样品内或样品间群体有多相似？ | 较高 |
| pN/pS | 非同义/同义多态比 | 变异是否偏向改变蛋白？是否可能有选择？ | 高 |
| FST | 群体分化指数 | 两个群体之间是否遗传分化？ | 高 |
| Tajima’s D | 中性检验 | 是否偏离中性演化模型？ | 很高 |
| linkage | 连锁关系 | 不同 SNV 是否来自同一 strain 背景？ | 高 |

对于初学者和环境病毒数据，建议优先理解并使用：

```text
coverage depth
coverage breadth
SNV density
π
population ANI
```

谨慎使用：

```text
pN/pS
FST
Tajima’s D
linkage
```

---

# 7. Coverage depth：覆盖深度

## 7.1 含义

**Coverage depth** 指 reference 上某个位点或整个序列平均被 reads 覆盖了多少次。

例如一个 contig 长 10,000 bp，总共有 100,000 个比对上的碱基：

```text
mean coverage = 100,000 / 10,000 = 10×
```

意思是这个 contig 平均每个位点被 reads 覆盖了 10 次。

---

## 7.2 它回答什么问题？

Coverage depth 回答的是：

> 这个序列在样品中测得够不够深？

如果 depth 太低，SNV 识别不可靠。

例如某个位点只有 2 条 reads：

```text
A: 1
G: 1
```

你很难判断这是真实变异，还是测序错误或比对错误。

如果某个位点有 100 条 reads：

```text
A: 70
G: 30
```

这个变异就更可信。

---

## 7.3 常见计算方式

### 单个位点 depth

```text
某个位点覆盖该位置的 reads 数量
```

### 整个 contig 的 mean depth

```text
mean depth = 所有位点 depth 总和 / contig 长度
```

也可以近似理解为：

```text
mean depth = mapped bases / reference length
```

---

## 7.4 如何解释？

| Coverage depth | 解释 |
|---|---|
| < 1× | 基本不可靠 |
| 1–5× | 很低，只适合判断是否存在，不适合 SNV |
| 5–10× | 勉强可用，但微多样性不稳 |
| ≥ 10× | 常见最低微多样性阈值 |
| ≥ 20× | 更适合 SNV 和 π 分析 |

对于环境病毒，很多 contig 覆盖度很低，因此需要过滤。

---

## 7.5 常见阈值

病毒 contig 可考虑：

```text
mean coverage ≥ 5×   # 宽松
mean coverage ≥ 10×  # 推荐
mean coverage ≥ 20×  # 严格
```

MAG 可考虑：

```text
mean coverage ≥ 10×
```

---

# 8. Coverage breadth：覆盖广度

## 8.1 含义

**Coverage breadth** 指 reference 上有多少比例的区域被 reads 覆盖。

例如一个 contig 长 10,000 bp，其中 8,000 bp 至少有一条 read 覆盖：

```text
coverage breadth = 8,000 / 10,000 = 80%
```

---

## 8.2 它回答什么问题？

Coverage breadth 回答的是：

> 这个 reference 是整体被覆盖，还是只有一小段被覆盖？

这非常重要。

假设一个 10 kb contig，只有其中 500 bp 被高深度覆盖：

```text
500 bp 区域 depth = 100×
其余 9,500 bp depth = 0×
```

mean coverage 可能看起来不算极低，但其实只有局部区域被测到。这种情况不能代表整个 contig 的微多样性。

---

## 8.3 常见计算方式

```text
coverage breadth = 被覆盖位点数 / reference 总长度
```

通常“被覆盖”定义为：

```text
该位点 depth ≥ 1
```

也有工具使用更严格阈值，比如 depth ≥ 5。

---

## 8.4 如何解释？

| Coverage breadth | 解释 |
|---|---|
| < 30% | 很不可靠，可能只是局部匹配 |
| 30–50% | 较弱证据 |
| 50–70% | 勉强可用 |
| ≥ 70% | 常用阈值 |
| ≥ 80% | 更稳 |
| ≥ 90% | 很好 |

---

## 8.5 推荐阈值

对于病毒 vOTU / contig：

```text
coverage breadth ≥ 70%
```

更严格：

```text
coverage breadth ≥ 80%
```

对于 MAG：

```text
breadth ≥ 70%
```

---

# 9. SNV / SNP：单核苷酸变异

## 9.1 SNV 是什么？

**SNV = single nucleotide variant**，单核苷酸变异。

它指某个位点上，样品 reads 中出现了不同于 reference 或不同于主等位基因的碱基。

例如 reference 是：

```text
A
```

reads 中看到：

```text
A: 80%
G: 20%
```

那么 G 可以看作该位点的一个 SNV。

---

## 9.2 SNP 是什么？

**SNP = single nucleotide polymorphism**，单核苷酸多态性。

SNP 通常强调这个变异在群体中达到一定频率，并且是比较稳定的多态。

在宏基因组中，我们很多时候无法证明它是稳定多态，因此常用 SNV 更稳。

---

## 9.3 SNV 和 SNP 的区别

| 名称 | 更适合的语境 | 含义 |
|---|---|---|
| SNV | 宏基因组、测序变异检测 | 观察到的单碱基变异 |
| SNP | 群体遗传学、稳定多态 | 群体中较稳定存在的单碱基多态 |

论文中如果不确定，建议写：

```text
single-nucleotide variants (SNVs)
```

---

## 9.4 SNV 识别的基本逻辑

对每个位点统计 A/T/C/G 数量：

```text
位置 100:
A = 90
G = 10
C = 0
T = 0
```

如果：

- 覆盖度足够；
- 次要 allele 频率超过阈值；
- 比对质量足够；
- 碱基质量足够；

则这个位点可以被认为是 SNV 位点。

---

## 9.5 常见过滤条件

```text
minimum depth
minimum allele frequency
minimum base quality
minimum mapping quality
minimum read ANI
```

例如：

```text
位点 depth ≥ 10
minor allele frequency ≥ 0.05
mapping quality ≥ 2 或 ≥ 10
read ANI ≥ 95%
```

---

# 10. SNV density：变异密度

## 10.1 含义

**SNV density** 指单位长度内的 SNV 数量。

常见单位：

```text
SNVs per kb
SNVs per Mb
SNVs per site
```

---

## 10.2 计算方法

如果一个 contig 长 10 kb，检测到 20 个 SNV：

```text
SNV density = 20 / 10 kb = 2 SNVs/kb
```

如果用 per bp：

```text
SNV density = 20 / 10,000 = 0.002 SNVs/site
```

---

## 10.3 它回答什么问题？

SNV density 回答：

> 这个群体单位长度内有多少变异位点？

它可以粗略衡量群体内部遗传变异丰富程度。

---

## 10.4 如何解释？

高 SNV density 可能说明：

- 群体内部遗传多样性高；
- 多个 strain 共存；
- 来自多个来源的相近群体混合；
- reference 把相近但不同的群体合并了；
- mapping 太宽松导致假 SNV 增多。

低 SNV density 可能说明：

- 群体较单一；
- 近期扩增；
- 强选择导致单一型占优；
- coverage 太低导致 SNV 检测不足；
- 过滤过严。

---

## 10.5 注意事项

SNV density 不能单独解释，必须结合：

```text
coverage depth
coverage breadth
contig length
mapping 参数
π
```

例如，低 coverage 的 contig 检测到很少 SNV，不一定代表它真的多样性低，可能只是测序深度不够。

---

# 11. Nucleotide diversity, π：核苷酸多样性

## 11.1 含义

**π（pi, nucleotide diversity）** 是微多样性中最核心的指标之一。

它表示：

> 从同一个群体中随机抽取两条序列，它们在同一位点不同的概率。

简单说：

```text
π 越高：群体内部遗传差异越大
π 越低：群体内部遗传差异越小
```

---

## 11.2 直观例子

某个位点所有 reads 都是 A：

```text
A: 100%
G: 0%
C: 0%
T: 0%
```

随机抽两条 reads，它们肯定一样。这个位点对 π 的贡献是 0。

另一个位点：

```text
A: 50%
G: 50%
C: 0%
T: 0%
```

随机抽两条 reads，有较大概率不同。这个位点对 π 的贡献较高。

---

## 11.3 单个位点 π 的计算思想

如果一个位点有不同 allele，频率分别是：

```text
pA, pT, pC, pG
```

那么这个位点的多样性可以近似理解为：

```text
π_site = 1 - (pA² + pT² + pC² + pG²)
```

意思是：

```text
1 - 随机抽两条序列相同的概率
= 随机抽两条序列不同的概率
```

例子：

```text
A: 0.7
G: 0.3
```

则：

```text
π_site = 1 - (0.7² + 0.3²)
       = 1 - (0.49 + 0.09)
       = 0.42
```

这个 0.42 是该位点的差异概率。

实际工具会使用更严格的修正和过滤，但基本思想就是这样。

---

## 11.4 整个 contig 或 genome 的 π

整个 reference 的 π 通常是所有可比较位点的平均值：

```text
π_reference = 所有有效位点 π_site 的平均值
```

也可以理解为：

> 在这个 contig 或 genome 上，随机抽两条序列，平均每个位点不同的概率。

---

## 11.5 它回答什么问题？

π 回答：

> 这个群体内部的平均遗传多样性有多高？

可用于比较：

- RW vs WW 中同一 vOTU 的多样性；
- 春夏秋冬中同一病毒群体的多样性；
- 携带 ARG/VF 的 MAG 是否比普通 MAG 多样性更高；
- 高风险 viral contigs 是否有更高的群体内变异。

---

## 11.6 如何解释高 π？

高 π 可能表示：

1. 多个 strain 共存；
2. 群体长期存在并积累变异；
3. 多来源输入导致混合；
4. 环境选择允许多个变体共存；
5. reference 把多个相近但不同的群体合并了；
6. mapping 太宽松。

所以高 π 不能直接等于“进化快”。

更稳的表述：

```text
higher nucleotide diversity suggests greater within-population genetic variation
```

不要轻易写：

```text
higher π indicates faster evolution
```

---

## 11.7 如何解释低 π？

低 π 可能表示：

1. 群体比较单一；
2. 近期扩增，某个变体占优势；
3. 强选择清除了其他变体；
4. coverage 太低，检测不到低频变异；
5. 过滤条件太严格。

所以低 π 也不一定代表真的没有变异。

---

## 11.8 π 和 SNV density 的区别

| 指标 | 看什么 | 特点 |
|---|---|---|
| SNV density | 有多少变异位点 | 更像“变异位点数量” |
| π | 变异位点上的 allele 频率差异 | 更像“平均序列差异概率” |

例子：

两个 contig 都有 10 个 SNV：

- Contig A：每个 SNV 都是 50%/50%；
- Contig B：每个 SNV 都是 99%/1%。

它们 SNV 数量一样，但 π 不一样。Contig A 的 π 更高，因为群体内部差异更明显。

---

# 12. Population ANI：群体平均核苷酸一致性

## 12.1 含义

**ANI = average nucleotide identity**，平均核苷酸一致性。

在微多样性中，population ANI 可以理解为：

> 一个样品中的 reads 所代表的群体，与 reference 或与另一个样品中的群体之间有多相似。

---

## 12.2 它和 π 的关系

简单理解：

```text
π 高 → 群体内部差异大 → population ANI 可能较低
π 低 → 群体内部差异小 → population ANI 可能较高
```

但二者不是完全相同的指标。

π 更关注群体内部随机两条序列的差异概率。

ANI 更关注平均序列相似度。

---

## 12.3 它回答什么问题？

Population ANI 回答：

- 同一个 reference 在不同样品中是否代表相似群体？
- 两个样品中的同一 vOTU 是否接近同一个 population？
- 是否存在 population replacement？

例如：

```text
Spring sample: vOTU_001 population ANI = 99.9%
Summer sample: vOTU_001 population ANI = 97.5%
```

这可能提示同一个 vOTU 在不同季节中对应的群体有遗传差异。

---

## 12.4 如何解释？

| Population ANI | 可能解释 |
|---|---|
| 很高 | 群体高度相似，可能同源或差异较小 |
| 较低 | 群体有明显遗传差异，可能存在 strain 替换或多来源输入 |

注意：ANI 的具体阈值要结合工具、reference 类型和数据质量，不要机械套用。

---

# 13. Linkage disequilibrium：连锁不平衡

## 13.1 含义

**Linkage disequilibrium（LD）** 指不同变异位点之间是否倾向于一起出现。

简单说：

> 如果一个 read 上出现了 A 位点的某个变异，它是否也更可能出现 B 位点的另一个变异？

---

## 13.2 直观例子

有两个 SNV 位点：

```text
位点 1: A/G
位点 2: C/T
```

如果样品中总是出现：

```text
A-C
G-T
```

而很少出现：

```text
A-T
G-C
```

说明这两个位点之间存在连锁关系，可能来自两个不同 strain。

---

## 13.3 它回答什么问题？

LD 可以帮助判断：

- SNV 是否来自不同 strain；
- 群体中是否有重组；
- 群体结构是否复杂；
- 多个位点是否共同遗传。

---

## 13.4 为什么初学者不建议优先做？

因为 LD 分析要求：

- reads 足够长；
- coverage 足够高；
- SNV 数量足够；
- 变异位点能被同一条 read 或 read pair 覆盖；
- mapping 准确。

对于短 contig、低覆盖环境病毒，LD 往往不稳定。

---

# 14. pN/pS：非同义/同义多态比值

## 14.1 基础概念：同义和非同义突变

基因编码蛋白时，三个碱基组成一个密码子。

例如：

```text
GAA → Glutamic acid
GAG → Glutamic acid
```

虽然 DNA 碱基变了，但编码的氨基酸没变，这叫 **同义突变（synonymous mutation）**。

另一种情况：

```text
GAA → Glutamic acid
GCA → Alanine
```

碱基变化导致氨基酸也变了，这叫 **非同义突变（nonsynonymous mutation）**。

---

## 14.2 pN 和 pS 是什么？

```text
pN = nonsynonymous polymorphism
pS = synonymous polymorphism
```

pN/pS 表示：

> 群体内部非同义多态和同义多态的比例。

---

## 14.3 它回答什么问题？

pN/pS 尝试回答：

> 群体内部的变异是否更倾向于改变蛋白序列？是否可能受到选择压力？

解释逻辑：

| pN/pS | 常见解释 |
|---|---|
| < 1 | 非同义变异较少，可能存在纯化选择 |
| ≈ 1 | 接近中性 |
| > 1 | 非同义变异较多，可能存在正选择或适应性变化 |

---

## 14.4 为什么要谨慎？

pN/pS 的解释非常容易过度。

它依赖：

- ORF 预测准确；
- 基因方向正确；
- 密码子识别正确；
- coverage 足够；
- SNV 过滤合理；
- 样品内不是多个远缘 strain 混贴；
- 参考序列不偏。

对于病毒短 contig 尤其要谨慎。

---

## 14.5 适合什么时候做？

比较适合：

- 长 contig；
- 高覆盖；
- ORF 明确；
- 功能基因可信；
- 样品数足够；
- 有明确生态问题。

不适合：

- 低覆盖病毒；
- 很短的 contig；
- ORF 注释不可靠；
- 只是为了增加一个指标。

---

# 15. FST：群体遗传分化

## 15.1 含义

**FST** 是衡量两个或多个群体之间遗传分化程度的指标。

它回答：

> 不同样品组中的同一个群体，等位基因频率是否明显不同？

例如同一个位点：

```text
Spring:
A = 90%
G = 10%

Summer:
A = 20%
G = 80%
```

这个位点在春季和夏季的 allele frequency 差异很大，说明两个季节的群体可能发生了分化。

---

## 15.2 如何解释？

| FST | 可能含义 |
|---|---|
| 接近 0 | 群体之间遗传结构相似 |
| 较高 | 群体之间存在遗传分化 |
| 很高 | 可能有明显的 population separation 或 strain replacement |

---

## 15.3 它回答什么生态问题？

FST 可以用于：

- RW 和 WW 中同一个 MAG 是否存在遗传分化？
- 上游和下游的同一病毒群体是否来自不同来源？
- 春季和夏季是否发生 population shift？
- 污水厂出水是否向河流输入了不同遗传背景的微生物/病毒？

---

## 15.4 为什么环境宏基因组里要谨慎？

FST 需要：

- 每组样品数足够；
- 每个样品 coverage 足够；
- 同一 reference 在多个样品中都稳定检出；
- SNV 频率估计可靠；
- 不被低覆盖和 mapping bias 影响。

对于样品少、病毒低丰度、contig 短的数据，FST 很容易不稳。

---

# 16. Tajima’s D：中性检验指标

## 16.1 含义

**Tajima’s D** 是群体遗传学中用于判断序列变异是否偏离中性演化模型的指标。

它比较两种多样性估计：

1. 基于平均两两差异的 π；
2. 基于 segregating sites 数量的 θ。

如果二者差异很大，就说明群体可能偏离简单的中性模型。

---

## 16.2 如何解释？

| Tajima’s D | 常见解释 |
|---|---|
| < 0 | 低频突变较多，可能是群体扩张或纯化选择 |
| ≈ 0 | 接近中性模型 |
| > 0 | 中频突变较多，可能是平衡选择或群体瓶颈 |

---

## 16.3 初学者怎么理解？

可以用一个简单直觉：

- 如果一个群体刚刚快速扩增，会产生很多低频突变，Tajima’s D 可能偏负；
- 如果一个群体经历瓶颈或多个不同 strain 混合，中频变异可能较多，Tajima’s D 可能偏正。

---

## 16.4 为什么不建议作为环境病毒主结论？

因为 Tajima’s D 对数据要求非常高：

- 序列长度要足够；
- 变异位点要足够；
- 群体边界要清晰；
- 样品不能是复杂混合群体；
- coverage 要均匀；
- 不能有严重 mapping bias；
- 病毒重组会干扰解释。

环境病毒 contig 往往短、覆盖低、来源复杂，因此 Tajima’s D 容易“算出来但解释不稳”。

---

# 17. dN/dS、pN/pS、Ka/Ks 的区别

这些指标名字很像，但适用场景不同。

| 指标 | 主要对象 | 含义 | 常见用途 |
|---|---|---|---|
| dN/dS | 不同序列之间的固定差异 | 非同义替换率 / 同义替换率 | 比较物种或基因长期演化 |
| pN/pS | 同一群体内部的多态 | 非同义多态 / 同义多态 | 群体内选择压力 |
| Ka/Ks | 与 dN/dS 类似 | 非同义替换率 / 同义替换率 | 分子进化分析 |

简单理解：

```text
dN/dS 或 Ka/Ks：更偏长期进化、序列之间固定差异
pN/pS：更偏群体内部尚未固定的变异
```

在宏基因组 microdiversity 中，通常更常见的是 pN/pS。

---

# 18. Strain、population、species、vOTU 的关系

## 18.1 细菌中

大致层级：

```text
Genus
↓
Species
↓
Strain
↓
Individual cells / genomes
```

例如：

```text
Escherichia
↓
Escherichia coli
↓
E. coli strain K-12 / O157:H7
```

在宏基因组中，MAG 通常代表一个种群水平的基因组，但不一定等于单一 strain。

---

## 18.2 病毒中

病毒分类更复杂，环境病毒尤其难。

常用分析层级：

```text
Family / genus / species-like group
↓
vOTU
↓
viral population
↓
sequence variants
```

vOTU 是操作单元，不完全等于正式 species。

---

## 18.3 为什么这对微多样性重要？

因为你计算的是“某个 reference 内部”的变异。

如果 reference 对应的是单一 strain，π 可能低。

如果 reference 实际代表多个相近 strain 的混合，π 可能高。

所以解释微多样性时，要说：

```text
within-population genetic variation
vOTU-level microdiversity
MAG-level microdiversity
```

避免过度说成：

```text
species evolution
pathogen evolution
```

---

# 19. 微多样性可以回答哪些生态问题？

## 19.1 群体是否稳定存在？

如果一个 vOTU 在多个季节中都存在，而且 population ANI 很高、π 稳定，可能说明它在环境中持续存在。

如果同一个 vOTU 丰度存在，但不同季节 population ANI 下降或 SNV 频率变化大，可能说明发生了 population turnover。

---

## 19.2 是否存在多来源输入？

高 π、高 SNV density 可能说明多个来源的相近群体混合。

例如 WWTP effluent 中某些病毒或 MAG 的 π 较高，可能是污水中多宿主、多来源输入导致的混合群体。

但这种解释必须谨慎，需要结合：

- 样点背景；
- coverage；
- source tracking；
- taxonomy；
- abundance。

---

## 19.3 是否存在 strain replacement？

如果同一个 MAG 或 vOTU 在两个季节都存在，但等位基因频率显著不同，可能是 strain replacement。

表现可能包括：

- population ANI 下降；
- FST 升高；
- 多个 SNV 位点频率整体改变；
- linkage pattern 改变。

---

## 19.4 是否存在环境选择？

如果某些环境条件下特定群体的 π、pN/pS 或 allele frequency 系统变化，可能提示环境选择。

例如：

- 高温季节特定病毒群体 SNV 增加；
- 污水厂出水中 ARG-carrying MAG 的 pN/pS 改变；
- 高营养盐样品中某些细菌 population ANI 降低。

但“选择”是强解释，需要谨慎，最好有统计支持和生物学机制。

---

## 19.5 是否和风险相关？

对于潜在病原相关病毒或携带 ARG/VF 的 MAG，可以问：

- 风险相关群体是否有更高微多样性？
- 高风险类群是否在特定季节出现 population turnover？
- WWTP effluent 是否输入了遗传上不同的风险群体？

但不能仅凭微多样性证明致病能力。

---

# 20. 病毒微多样性分析的特殊问题

## 20.1 病毒 contig 通常短

病毒 contig 短会导致：

- 可分析位点少；
- π 估计不稳定；
- pN/pS 不可靠；
- Tajima’s D 不适合。

建议过滤：

```text
contig length ≥ 5 kb
或 contig length ≥ 10 kb
```

---

## 20.2 病毒丰度低

环境病毒，尤其潜在风险病毒，常常 coverage 很低。

低 coverage 会导致：

- SNV 检测不足；
- 低频变异丢失；
- 测序错误被误判；
- 不同样品之间不可比。

建议：

```text
mean coverage ≥ 10×
coverage breadth ≥ 70%
```

---

## 20.3 病毒参考库不完整

很多环境病毒没有接近参考基因组。

这会影响：

- taxonomy；
- ORF 注释；
- pN/pS；
- 宿主推断；
- 病原风险解释。

所以对于病毒，推荐表述：

```text
viral contigs related to potentially pathogenic reference viruses
```

而不是：

```text
pathogenic viruses
```

---

## 20.4 RNA 病毒和 DNA 病毒不一样

如果是 RNA virome 或 metatranscriptome，reads 反映的可能是转录活性或 RNA abundance。

如果是 DNA virome / metagenome，reads 主要反映 DNA abundance。

因此：

- DNA mapping 的 TPM 更适合叫 relative abundance；
- RNA mapping 的 TPM 可以更接近 activity / expression / transcriptional signal；
- 具体写法要根据数据类型决定。

---

# 21. MAG 微多样性分析的特殊问题

## 21.1 MAG 较长，适合做更多指标

MAG 通常比 viral contig 长得多，因此：

- 可分析位点多；
- π 更稳定；
- pN/pS 更可行；
- FST 更可行；
- strain-level analysis 更有意义。

---

## 21.2 MAG 不是完整单菌株

MAG 是从宏基因组中 binning 得到的基因组草图，可能包含：

- 缺失区域；
- contamination；
- strain heterogeneity；
- assembly bias。

因此做 MAG 微多样性前建议过滤：

```text
completeness ≥ 50%
contamination ≤ 10%
```

更严格：

```text
completeness ≥ 70% 或 90%
contamination ≤ 5%
```

---

## 21.3 携带 ARG/VF 的 MAG 可以单独分析

你的项目里可以问：

- 携带 ARG 的 MAG 是否 microdiversity 更高？
- 携带 VF 的 MAG 是否在 WWTP effluent 中有更复杂 strain structure？
- 同一个 risk MAG 是否在 RW 和 WW 中存在 population differentiation？

这些问题比对低丰度病毒做复杂群体遗传指标更稳。

---

# 22. 常用工具

## 22.1 inStrain

### 定位

inStrain 是目前比较常用的 metagenomic microdiversity 工具。

它从 BAM 文件中计算：

- coverage；
- breadth；
- SNV；
- π；
- population ANI；
- linkage；
- 样品间 population comparison。

### 适合对象

```text
MAGs
isolate genomes
viral contigs
vOTUs
environmental contigs
```

### 优点

- 适合 MAG 和病毒 contig；
- 输出指标丰富；
- 文档和使用者较多；
- 适合你的黄河病毒/MAG 数据。

### 缺点

- 对 coverage 要求较高；
- 样品多时计算量大；
- 低丰度病毒保留率可能低。

---

## 22.2 MetaPop

### 定位

MetaPop 是用于 microbial and viral populations 的 macrodiversity + microdiversity pipeline。

可分析：

- nucleotide diversity；
- SNP/SNV；
- pN/pS；
- gene-level selection；
- macrodiversity。

### 优点

- 原本就面向病毒和微生物群体；
- 指标和生态演化解释直接。

### 缺点

- 维护状态不理想；
- 环境依赖老；
- 安装可能困难。

---

## 22.3 metaSNV / metaSNV2

### 定位

metaSNV 主要做 prokaryotic metagenomes 的 SNV 分析。

### 适合

- 细菌；
- 古菌；
- 有较好参考基因组的 species；
- 多样品 species-level SNV 比较。

### 不太适合

- 未知病毒 contigs；
- 短 vOTUs；
- 参考库很不完整的环境病毒。

---

## 22.4 MIDAS / MIDAS2

### 定位

MIDAS/MIDAS2 用于 species-level SNP profiling 和 gene content variation。

### 适合

- 人体肠道等参考库完善的微生物组；
- 已知 bacterial species；
- strain-level population genomics。

### 不适合

- 未知环境病毒；
- contig-level viral microdiversity。

---

## 22.5 StrainPhlAn

### 定位

StrainPhlAn 基于 species-specific marker genes 构建 strain-level phylogeny。

### 适合

- 已知细菌物种；
- strain tracking；
- 样品间菌株系统发育关系。

### 不适合

- 病毒 vOTU 的 π；
- 未知 contig 的微多样性。

---

## 22.6 DESMAN / ConStrains / STRONG

这些工具更偏 strain reconstruction，而不是简单 microdiversity profiling。

它们尝试：

- 重建多个 strain；
- 推断 haplotype；
- 估计 strain abundance。

适合：

- 高 coverage；
- 多样品；
- 目标 species 明确；
- 想做 strain reconstruction。

不适合：

- 低丰度病毒；
- 大规模 vOTU 筛查；
- 初学者快速获得可解释指标。

---

# 23. 推荐分析路线

对于你的 Yellow River / WWTP 项目，推荐优先使用 inStrain。

## 23.1 基本流程

```text
quality-filtered reads
↓
Bowtie2 / BWA mapping to viral contigs or MAGs
↓
SAMtools sort and index
↓
inStrain profile for each sample
↓
inStrain compare across samples
↓
extract π, SNV density, coverage, breadth, population ANI
↓
R visualization and statistics
```

---

## 23.2 示例命令

### 建库

```bash
bowtie2-build viral_contigs.fa viral_contigs
```

### reads mapping

```bash
bowtie2 -x viral_contigs \
  -1 sample.R1.fq.gz \
  -2 sample.R2.fq.gz \
  --very-sensitive \
  -p 24 | samtools sort -@ 8 -o sample.bam

samtools index sample.bam
```

### 单样品 profile

```bash
inStrain profile sample.bam viral_contigs.fa \
  -o sample_inStrain \
  -p 24 \
  --min_mapq 2 \
  --min_read_ani 0.95
```

### 多样品比较

```bash
inStrain compare \
  -i sample1_inStrain sample2_inStrain sample3_inStrain \
  -o compare_inStrain \
  -p 24
```

---

# 24. 结果解释模板

## 24.1 描述 coverage 过滤

英文：

```text
Only viral contigs with sufficient read recruitment were retained for microdiversity analysis, based on minimum thresholds for contig length, mean coverage, and coverage breadth.
```

中文：

```text
只有满足长度、平均覆盖度和覆盖广度阈值的 viral contigs 被保留用于微多样性分析。
```

---

## 24.2 描述 π

英文：

```text
Nucleotide diversity (π) was used to quantify within-population genetic variation of viral contigs across samples.
```

中文：

```text
使用 nucleotide diversity (π) 衡量不同样品中 viral contigs 的群体内遗传变异水平。
```

---

## 24.3 描述 SNV density

英文：

```text
SNV density was calculated as the number of detected single-nucleotide variants normalized by contig length.
```

中文：

```text
SNV density 通过将检测到的单核苷酸变异数量按 contig 长度标准化计算得到。
```

---

## 24.4 谨慎描述差异

英文：

```text
Higher nucleotide diversity may indicate greater within-population genetic variation, potentially reflecting strain-level heterogeneity or mixed sources.
```

中文：

```text
较高的 nucleotide diversity 可能提示更高的群体内遗传变异，可能与 strain-level heterogeneity 或多来源混合有关。
```

---

## 24.5 谨慎描述风险病毒

英文：

```text
Several viral contigs related to potentially pathogenic reference viruses showed detectable within-population nucleotide variation.
```

中文：

```text
部分与潜在病原参考病毒相关的 viral contigs 表现出可检测的群体内核苷酸变异。
```

---

# 25. 常见误区

## 25.1 高 π 不等于进化快

高 π 可能来自：

- 多 strain 共存；
- 多来源输入；
- 长期稳定存在；
- reference 过宽；
- mapping 太松。

不能直接说：

```text
higher π means faster evolution
```

---

## 25.2 低 π 不等于没有进化

低 π 可能来自：

- 单一 strain 占优；
- 近期扩增；
- 强选择；
- coverage 太低；
- 过滤太严。

---

## 25.3 低丰度病毒不适合强行做复杂指标

低 coverage 下：

- SNV 不稳定；
- π 不稳定；
- pN/pS 不可靠；
- FST 不可靠；
- Tajima’s D 更不可靠。

---

## 25.4 vOTU 不等于 species

vOTU 是操作分类单元。写作时建议说：

```text
vOTU-level population
viral population
viral contigs related to ...
```

不要轻易写：

```text
viral species evolved differently
```

---

## 25.5 不能用微多样性证明致病性

一个病毒 contig 和病原参考病毒聚类，或者具有较高 π，都不能证明它一定有感染或致病能力。

稳妥表述：

```text
related to potentially pathogenic reference viruses
```

---

# 26. 论文方法写法模板

## 26.1 简短版

```text
Microdiversity of viral populations was assessed by recruiting quality-filtered metagenomic reads to dereplicated viral contigs. Sorted BAM files were used to profile coverage depth, coverage breadth, single-nucleotide variants, and nucleotide diversity using inStrain. Only viral contigs satisfying minimum thresholds for length, mean coverage, and breadth were retained for downstream analyses.
```

---

## 26.2 完整版

```text
To evaluate population-level microdiversity, quality-filtered metagenomic reads from each sample were mapped to dereplicated viral contigs using Bowtie2. The resulting alignments were sorted and indexed with SAMtools. Single-sample profiles, including coverage depth, coverage breadth, single-nucleotide variants, and nucleotide diversity, were generated using inStrain profile. Pairwise population comparisons among samples were performed using inStrain compare. Viral contigs were retained for downstream analyses only when they met the minimum criteria for contig length, mean coverage, and coverage breadth.
```

---

## 26.3 中文理解

```text
为了评估群体水平的微多样性，将每个样品的质控 reads 比对到去冗余 viral contigs 上，并使用 SAMtools 对比对结果进行排序和索引。随后使用 inStrain profile 计算每个样品中的覆盖深度、覆盖广度、单核苷酸变异和核苷酸多样性。使用 inStrain compare 进行样品间群体比较。只有满足 contig 长度、平均覆盖度和覆盖广度阈值的 viral contigs 被用于后续分析。
```

---

# 27. 黄河/WWTP 项目的建议做法

## 27.1 对 DNA viral contigs / vOTUs

建议先做：

```text
coverage depth
coverage breadth
π
SNV density
population ANI
```

建议暂时不把以下指标作为主结果：

```text
Tajima’s D
FST
pN/pS
strain reconstruction
```

原因：病毒 contig 短、coverage 低、风险病毒丰度低，复杂指标解释不稳。

---

## 27.2 推荐过滤阈值

相对宽松：

```text
contig length ≥ 5 kb
mean coverage ≥ 5×
coverage breadth ≥ 50%
```

推荐：

```text
contig length ≥ 5 kb
mean coverage ≥ 10×
coverage breadth ≥ 70%
```

更严格：

```text
contig length ≥ 10 kb
mean coverage ≥ 10×
coverage breadth ≥ 80%
```

---

## 27.3 可以回答的问题

### 问题 1：RW 和 WW 的病毒微多样性是否不同？

可用指标：

```text
π
SNV density
population ANI
```

解释方向：

- WWTP effluent 可能有多来源输入，导致部分 viral populations 具有较高微多样性；
- Yellow River 中某些病毒可能受季节和水文过程影响；
- 但必须结合 coverage 和 abundance 解释。

---

### 问题 2：风险相关病毒是否有特殊微多样性模式？

可对潜在风险参考病毒相关 contigs 单独提取：

```text
contig ID
family
seasonal abundance / TPM
coverage
breadth
π
SNV density
```

图形可以做：

- 热图；
- 箱线图；
- dot plot；
- tree + heatmap + π annotation。

---

### 问题 3：同一 vOTU 在不同季节是否发生 population shift？

可看：

```text
π 是否变化
SNV frequency 是否变化
population ANI 是否下降
```

谨慎表述：

```text
These patterns may suggest seasonal shifts in viral population structure.
```

不要直接说：

```text
The virus evolved seasonally.
```

---

## 27.4 对 MAGs 的分析

MAG 更适合深入做微多样性。

可以比较：

- ARG-carrying MAG vs non-ARG MAG；
- VF-carrying MAG vs non-VF MAG；
- RW MAGs vs WW MAGs；
- 不同季节 MAG population diversity。

指标：

```text
π
SNV density
population ANI
FST, if coverage and sample size are sufficient
pN/pS, if ORFs are reliable
```

---

# 28. 一句话总结

微多样性分析关注的是同一个 MAG、vOTU、contig 或 species 内部的遗传差异。它通过 reads mapping 识别 SNV，并计算 coverage、SNV density、π、population ANI 等指标，帮助回答群体内部是否存在遗传变异、不同环境中的同一群体是否分化、是否可能存在 strain 混合或 population turnover 等问题。对于环境病毒和黄河/WWTP 项目，最稳妥的起步路线是使用 inStrain 计算 coverage、breadth、π、SNV density 和 population ANI，并谨慎解释 pN/pS、FST 和 Tajima’s D 等高阶群体遗传指标。

---

# 附录 A：指标速查表

| 指标 | 中文名 | 计算思想 | 主要回答问题 | 推荐程度 |
|---|---|---|---|---|
| coverage depth | 覆盖深度 | mapped bases / reference length | 测得够不够深？ | 必须 |
| coverage breadth | 覆盖广度 | covered bases / reference length | 覆盖是否完整？ | 必须 |
| SNV count | SNV 数量 | 变异位点数 | 有多少变异位点？ | 推荐 |
| SNV density | SNV 密度 | SNV count / length | 单位长度变异多不多？ | 推荐 |
| π | 核苷酸多样性 | 随机两条序列不同的概率 | 群体内部差异多大？ | 强烈推荐 |
| population ANI | 群体平均一致性 | 平均序列相似度 | 样品间群体是否相似？ | 推荐 |
| pN/pS | 非同义/同义多态比 | 非同义多态 / 同义多态 | 是否可能存在选择？ | 谨慎 |
| FST | 群体分化 | 组间 allele frequency 差异 | RW/WW 或季节间是否分化？ | 谨慎 |
| Tajima’s D | 中性检验 | π 与 θ 的差异 | 是否偏离中性模型？ | 不建议初期使用 |
| linkage | 连锁关系 | SNV 是否共同出现 | 是否有 strain structure？ | 高阶 |

---

# 附录 B：初学者优先级

## 第一优先级：必须理解

```text
coverage depth
coverage breadth
SNV
π
SNV density
```

## 第二优先级：可以使用

```text
population ANI
between-sample comparison
strain heterogeneity
```

## 第三优先级：谨慎使用

```text
pN/pS
FST
linkage
```

## 第四优先级：暂时不要作为主线

```text
Tajima’s D
strain reconstruction
haplotype reconstruction
```

---

# 附录 C：推荐写作措辞

## 稳妥表达

```text
within-population genetic variation
population-level microdiversity
vOTU-level nucleotide diversity
viral contigs related to potentially pathogenic reference viruses
detectable nucleotide variation
seasonal shifts in population structure
```

## 不建议表达

```text
this virus is pathogenic
higher π means faster evolution
this vOTU is a species
Tajima’s D proves selection
FST proves different sources
```

---

# 附录 D：最简工作流

```text
1. 准备 reference：viral contigs / MAGs
2. 每个样品 reads mapping
3. 生成 sorted BAM
4. samtools index
5. inStrain profile
6. inStrain compare
7. 提取 coverage, breadth, π, SNV density, ANI
8. 根据 length / coverage / breadth 过滤
9. R 里做箱线图、热图、散点图
10. 谨慎解释生态意义
```

