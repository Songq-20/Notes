## checkv作用

CheckV 通过将序列与完整病毒基因组的大型数据库进行比较来估计完整性，其中包括从公开可用的宏基因组、宏转录组和宏病毒组的系统搜索中确定的 76,262 个。

## CheckV使用

### 一步法

```bash

checkv end_to_end input_file.fna **output_file -t 16
```

### 分步法

```
checkv contamination input*file.fna output*directory -t 16
checkv completeness input*file.fna output*directory -t 16
checkv complete*genomes input*file.fna output*directory
checkv quality*summary input*file.fna output*directory
```