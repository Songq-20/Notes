# BAPHLIP
> github : https://github.com/adamhockenberry/bacphlip
## Command
```
#!/bin/bash
#SBATCH -J bacphlip
#SBATCH -p cn-short
#SBATCH -N 1
#SBATCH -c 10
#SBATCH -o /datanode03/songq/log/bacphlip.out
#SBATCH -e /datanode03/songq/log/bacphlip.err
#SBATCH --no-requeue
#SBATCH -A cns
#SBATCH --mail-type=FAIL,END,BEGIN
#SBATCH --mail-user=2261518989@qq.com
#conda activate bacphlip
conda activate /data01nfs/apps/anaconda3/envs/bacphlip-0.9.6/
bacphlip -i test.fa --multi_fasta --local_hmmsearch /datanode03/zhangxf/programs/mambaforge/envs/hmmer/bin/hmmsearch
```
