
## 构建 Profile HMMs

1. 使用mafft对蛋白基因进行比对
```shell
mafft --auto --clustalout ../RdRp.fasta > RdRp.clustal
```
2. `.clustal` to `.sto`
```
https://sequenceconversion.bugaco.com/converter/biology/sequences/fasta_to_phylip.php
```
3. hmmbuild
```shell
hmmbuild RdRp.hmm RdRp.sto
```
