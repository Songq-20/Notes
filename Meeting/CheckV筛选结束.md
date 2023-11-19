## 汇报：

31个数据集rerun checkv结束，得到的去污染序列存放在

```Shell
/data01nfs/user/liupf/oil_field_10kDNAvirus/recheckv_out/prefix_final/prefix_trimmed.fasta
```

下一步vOTUS Clustering

> Supporting code 
> Rapid genome clustering based on pairwise ANI 
> First, create a blast+ database: 
> `makeblastdb -in <my_seqs.fna> -dbtype nucl -out <my_db>` 
> Next, use megablast from blast+ package to perform all-vs-all blastn of sequences:
> `blastn -query <my_seqs.fna> -db <my_db> -outfmt '6 std qlen slen' -max_target_seqs 10000 -o <my_blast.tsv> -num_threads 10` 
> Next, calculate pairwise ANI by combining local alignments between sequence pairs: anicalc.py -i blast.tsv> -o ani.tsv> Finally, perform UCLUST-like clustering using the MIUVIG recommended-parameters (95% ANI + 85% AF): `aniclust.py --fna <my_seqs.fna> --ani <my_ani.tsv> --out <my_clusters.tsv> --min_ani 95 --min_tcov 85 --min_qcov 0` How it works

### 一些问题：

1. 数据库序列从哪儿来？就用那31个数据集吗？
对 
2. tcov 是什么？统计学上的内容吗？ 
目标序列的比例。
3. AF是什么？
两个序列相似片段占总片段的比率---防止只因为小片段序列相似就把两个长基因组分在一起
