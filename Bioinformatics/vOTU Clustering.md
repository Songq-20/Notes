# Supporting code
Rapid genome clustering based on pairwise ANI

First, create a blast+ database:  
```Shell
makeblastdb -in <my_seqs.fna> -dbtype nucl -out <my_db> 
```

Next, use megablast from blast+ package to perform all-vs-all blastn of sequences:  
```Shell
blastn -query <my_seqs.fna> -db <my_db> -outfmt '6 std qlen slen' -max_target_seqs 10000 -o <my_blast.tsv> -num_threads 32
```

Next, calculate pairwise ANI by combining local alignments between sequence pairs:  
```Shell
anicalc.py -i <my_blast.tsv> -o <my_ani.tsv>
```

Finally, perform UCLUST-like clustering using the MIUVIG recommended-parameters (95% ANI + 85% AF):  
```Shell
aniclust.py --fna <my_seqs.fna> --ani <my_ani.tsv> --out <my_clusters.tsv> --min_ani 95 --min_tcov 85 --min_qcov 0
```