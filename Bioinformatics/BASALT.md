# BASALT
>更新：  
>1. CheckM2 数据库路径更新



---
 

### 准备工作
使用之前需将 `BASALT.zip` 文件解压到 `~/.cache` 下
```shell
cd ~
cp /datanode03/songq/applications/BASALT.zip ~/.cache
cd ~/.cache
unzip BASALT.zip
```  
  

### 运行
```shell
source /datanode03/songq/mambaforge/bin/activate
conda activate BASALT
export CHECKM2DB="/datanode03/huangxy/database/checkm_data/CheckM2_database/uniref100.KO.1.dmnd"
# use CheckM2

# Sort read sequences(srs)
BASALT -a assemble.fa -s R1.fq.gz,R2.fq.gz -t 20 -m 200 -qc checkm2

# srs + Long read sequences
BASALT -a assemble.fa -s R1.fq.gz,R2.fq.gz -l lrs1.fq -t 20 -m 200 -qc checkm2

# hifi
BASALT -a assemble.fa -s R1.fq.gz,R2.fq.gz -l lrs1.fq -hf hifi1.fq -t 20 -m 200 -qc checkm2
# Note: only PacBio-HiFi data is supported in v1.0.1 for long-read only assemblies
```
```shell
BASALT -a as1.fa,as2.fa,as3.fa -s srs1_r1.fq,srs1_r2.fq/srs2_r1.fq,srs2_r2.fq -t 20 -m 200 -qc checkm2
```
### 可选参数
`--autopara`	:	Autobinning parameters. 
* `–-autopara more-sensitive` Choose recommended binners with full parameters: Maxbin2 [0.3, 0.5, 0.7, 0.9], MetaBAT2 [200, 300, 400, 500], CONCOCT [2-3 flexible parameters based on result of MetaBAT2], and Semibin2 [100]
* `–-autopara sensitive` Partial binners with partial parameters: MetaBAT2 [200, 300, 400, 500], CONCOCT [1-2 flexible parameters based on result of MetaBAT2], and Semibin2 [100]
* `–-autopara quick` Limited binners: MetaBAT2 [200, 300, 400, 500] and Semibin2 [100]
(default: more-sensitive)  

`--min-cpn`	Minimum completeness cutoff, e.g., --min-cpn 30 (default: 35)  

`--max-ctn` Maximum contamination cutoff, e.g., --max-ctn 25 (default: 20)  

更多参数见说明文档
### 注意
* 使用 BASALT 之前需要将 `BASALT.zip` 解压到 `~/.cache` ，否则即使成功激活环境也会报错
* BASALT 无需指定输出文件夹，会将文件输出至当前工作目录  
* 当前版本（v1.0.1）需要将 BASALT 输入文件放在工作目录下，不然会无法读取文件 
> 建议将输入文件复制到 BASALT 工作目录，且在此目录运行 BASALT  

GitHub：https://github.com/EMBL-PKU/BASALT