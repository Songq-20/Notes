> MinCED - find CRISPRs

```bash
./minced [options] file_in file_out 
#example
./minced ecoli.fna ecoli.crisprs
./minced -minNR 2 short_seq.fna
#对于短序列，要减少repeat的最少发现次数 -2 次
./minced ecoli.fna ecoli_out.txt ecoli_out.gff
#可选择同时输出.gff文件
```

> gff：存储序列信息的文件格式

具体有：seqid source type start end score strand phase attributes

type： mRNA,exon,cds,repeat_region..

source: 文件来源

strand:+正链

phase：步进，仅对CDS

attributes：属性，内容众多，以“ key=value”存储。