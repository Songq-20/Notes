# 使用 Salmon 计算 TPM 值

1. build ref
```shell
#!/bin/bash
#SBATCH -J salmon
#SBATCH -p cn-long2
#SBATCH -N 1
#SBATCH -c 30
#SBATCH -o /datanode03/zhujy/log/salmon.out
#SBATCH -e /datanode03/zhujy/log/salmon.err
#SBATCH --no-requeue
#SBATCH -A cnl2
#SBATCH --mail-type=FAIL,END,BEGIN
#SBATCH --mail-user=2261518989@qq.com

source /data01nfs/apps/anaconda3/bin/activate
conda activate salmon-1.9.0
salmon index -t vOTU.fa -i salmon_index_output_dir -k 31 -p 30

# -p Threads Number
```  
2. mapping  
```
source /data01nfs/apps/anaconda3/bin/activate
conda activate salmon-1.9.0

while read id
do
mkdir salmon_mapping/${id}
R1=/datanode03/zhujy/zhujy_datanode03/trim_out/${id}*R1*trimmed.fq.gz
R2=/datanode03/zhujy/zhujy_datanode03/trim_out/${id}*R2*trimmed.fq.gz
salmon quant --validateMappings -i salmon_index -l A -p 30 --meta -1 $R1 -2 $R2 -o salmon_mapping/${id}
done < id.list
```