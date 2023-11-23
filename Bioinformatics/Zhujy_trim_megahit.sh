#!/bin/bash
#SBATCH -J trim
#SBATCH -p cn-long
#SBATCH -N 1
#SBATCH -c 60
#SBATCH -o /data01nfs/user/zhujy/log/trim.out
#SBATCH -e /data01nfs/user/zhujy/log/trim.err
#SBATCH --no-requeue
#SBATCH -A cnl
source /data01nfs/user/zhujy/.bash_profile
source activate /data01nfs/user/liupf/miniconda3/envs/trimmomatic/
trimmomatic PE -threads 4  /data02nfs/Project/rawdata4/黄河水体宏病tt毒组/XQ-20230724-00125/2304PES3/2304PES3.R1.fq.gz /data02nfs/Project/rawdata4/黄河水体宏病毒组/XQ-20230724-00125/2304PES3/2304PES3.R2.fq.gz /datanode03/zhujy/trim_out/2304PES3R1.trimmed.fq.gz /datanode03/zhujy/trim_out/2304PES3R1.trimmed.U.fq.gz /datanode03/zhujy/trim_out/2304PES3R2.trimmed.fq.gz /datanode03/zhujy/trim_out/2304PES3R2.trimmed.U.fq.gz ILLUMINACLIP:/data01nfs/user/liupf/common_files/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 

#!/bin/bash
#SBATCH -J megahit
#SBATCH -p cn-long
#SBATCH -N 1
#SBATCH -c 60
#SBATCH -o /datanode03/zhujy/log/megahit4.out
#SBATCH -e /datanode03/zhujy/log/megahit4.err
#SBATCH --no-requeue
#SBATCH -A cnl
source /data01nfs/user/liupf/miniconda3/bin/activate
conda activate megahit
megahit -1 /datanode03/zhujy/trim_out/2304PES3R1.trimmed.fq.gz -2 /datanode03/zhujy/trim_out/2304PES3R2.trimmed.fq.gz -t 60  --out-prefix 2304PES3  --out-dir /datanode03/zhujy/megahit_out/2304PES3  &> /datanode03/zhujy/megahit_out/megahit_log/2304PES3.log
