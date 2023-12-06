#!/bin/bash
#SBATCH -J trim_assemble
#SBATCH -p cn-long
#SBATCH -N 1
#SBATCH -c 60
#SBATCH -o /data01nfs/user/zhujy/log/trim_assemble.out
#SBATCH -e /data01nfs/user/zhujy/log/trim_assemble.err
#SBATCH --no-requeue
#SBATCH -A cnl
source /data01nfs/user/zhujy/.bash_profile
source activate /data01nfs/user/liupf/miniconda3/envs/trimmomatic/
trimmomatic PE -threads 4  /data02nfs/Project/rawdata4/黄河水体宏基因组/XQ-20230814-00126/2304KPC3/2304KPC3.R1.fq.gz /data02nfs/Project/rawdata4/黄河水体宏基因组/XQ-20230814-00126/2304KPC3/2304KPC3.R2.fq.gz /datanode03/zhujy/trim_out/2304KPC3R1.trimmed.fq.gz /datanode03/zhujy/trim_out/2304KPC3R1.trimmed.U.fq.gz /datanode03/zhujy/trim_out/2304KPC3R2.trimmed.fq.gz /datanode03/zhujy/trim_out/2304KPC3R2.trimmed.U.fq.gz ILLUMINACLIP:/data01nfs/user/liupf/common_files/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 
conda deactivate
source /data01nfs/user/liupf/miniconda3/bin/activate
conda activate megahit
megahit -1 /datanode03/zhujy/trim_out/2304KPC3R1.trimmed.fq.gz -2 /datanode03/zhujy/trim_out/2304KPC3R2.trimmed.fq.gz -t 60  --out-prefix 2304KPC3  --out-dir /datanode03/zhujy/megahit_out/2304KPC3  &> /datanode03/zhujy/megahit_out/megahit_log/2304KPC3.log