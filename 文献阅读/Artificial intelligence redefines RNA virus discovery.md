# Artificial intelligence redefines RNA virus discovery
>LucaPort 检测RdRp  
---  
RdRp : a canonical component of RNA Virus ( RNA dependent RNA polymerase )
## Result
1. LucaProt可以检测到更多的潜在RNA序列，且有更高的准确性和特异性。
基于深度学习开发的“ClstrSearch”，先聚类，再BLAST or HMM 比对，相比之前的直接BLAST or HMM，这种降低了病毒识别的错误率。  
“LucaProt” was able to identify 98.2% ~ 99.9% of RdRPs discovered in ocean, soil, and more diverse ecosystems.
识别的“超类”和门并不与并不与传统的病毒分类相同（别的方法也可能不相同）。  

2. 两种方法鉴定：1.与细胞蛋白缺乏同源性。 2. 存在关键 RdRP motifs
找到了23种没有同源 RdRP 的病毒类。为了证明计算是正确，且检查是否以DNA病毒形式存在（怕漏掉DNA？）的：他们提DNA,RNA，测序，分析。
结果只有RNA测序映射到病毒相关RdRP contigs。 DNA+RNA -> DNA病毒、逆转录酶、细胞组织。
又用了更敏感的方法 RT-PCR （ ？）检测，在提取的DNA中没有检测到 RdRP 序列（排除了RNA序列被逆转录的可能？）  
*这里不太懂*  
最后发现他们与 RT, EU RdRP, EU DdRP 也不同，与已知 Virus RdRP聚类成功且更大。