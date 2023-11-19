## 汇报：

> those with no viral and no host gene called are viral; those with no viral gene and 2 or more host genes are mostly non-viral; those with no viral gene and 1 host gene are hard to tell viral from non-viral (likely mobile genetic elements), and should be discarded unless manually checked.

```Plain Text keep1: virus gene >0

keep2:virus gene==0&&host gene==0 | virsorter2 score>0.95&&hallmark gene ≥ 2

manual check : virus gene == 0&&host gene == 1 && length >10kb

discard rest

Shell cat proviruses.fna viruses.fna > virus_tmp.fasta sed -i -e 's/ .*$//g' virus_tmp.fasta sed -i -e 's/_1$//g' virus_tmp.fasta

# rerun checkv

awk "$6==0&$7>1" quality_summary.tsv|cut -f1 -d$'\t' > discard_seq.txt

# 将符合条件的contig_id选出来

# $6 virus_gene ; $7 host_gene

```

###### manully check-keep
1. 结构基因、hallmark 基因、注释缺失或假设性富集(~10% 的基因具有 non-hypothetical 注释)。
    
    超过10%基因可被注释功能/与已知基因相似
    
2. 缺乏 hallmarks，但 >=50% 已注释的基因为病毒，且其中至少一半以上的 viral bitcore >100，且 contig 的长度 < 50kb。
    
3. Provirus:整合酶 / 重组酶 / 切除酶 / 阻遏子，在一侧富集了病毒基因。
    
4. Provirus: 基因组中存在 “break”：两个基因之间的间隙gap对应于一个链开关，更高的编码密度，注释缺失，以及在一侧噬菌体基因的富集。
    
5. 仅有～1-3 个基因有注释，但至少一半命中病毒，且命中基因的 bitscore 不超过病毒 bitscore 的 150% 且 / 或病毒的 bitscore >100
    
6. LPS (脂多糖)外观区域对病毒基因的命中率也非常高looking regions if also has very strong hits to viral genes，bitscore>100。

###### manully check-discard

8. 细胞样基因是病毒基因的 3 倍，几乎所有基因都有注释，没有基因只命中病毒，也没有病毒标志基因hallmark genes。
    
2. 缺乏任何病毒 hallmark genes，且长度 >50kb。
    
3. 许多明显的细胞基因字符串，没有其他病毒标志基因。 在基准测试中遇到的例子包括 1) CRISPR Cas, 2) ABC transporters, 3) Sporulation proteins, 4) Two-component systems, 5) Secretion system。这其中一些可能是由病毒编码的，但在没有进一步证据的情况下并不表明是病毒 contig。
    
4. 多个质粒基因或转座酶，但没有明确的只命中病毒的基因。
    
5. 注释信息很少，仅有～1-3 个基因同时命中了病毒和细胞基因，但有 stronger bitscores 支持其为细胞基因。
    
6. 没有强有力的命中病毒的脂多糖样区域。富含通常与脂多糖相关的基因，如外聚酶、糖基转移酶、酰基转移酶、短链脱氢酶/还原酶、脱水酶。
    
7. 注释为 Type IV 和 / 或 Type VI 分析系统，并被非病毒基因围绕。
    
8. 注释信息很少，仅有～1-3 个基因全部命中细胞基因 (即使 bitscore <100) ，且没有命中病毒的基因。
    

## 记录：

host_gene>=1,virus=0 not virus

LPS在不同病毒，宿主中序列高度特异*

为什么重新跑checkv 问。

周六九点。