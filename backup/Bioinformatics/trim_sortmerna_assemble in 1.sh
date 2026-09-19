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
trimmomatic PE -threads 4  /data02nfs/Project/rawdata4/黄河水体宏转录组/XQ-20230705-00069/2306PC32/2306PC32.R1.fq.gz /data02nfs/Project/rawdata4/黄河水体宏转录组/XQ-20230705-00069/2306PC32/2306PC32.R2.fq.gz /datanode03/zhujy/trim_out/2306PC32R1.trimmed.fq.gz /datanode03/zhujy/trim_out/2306PC32R1.trimmed.U.fq.gz /datanode03/zhujy/trim_out/2306PC32R2.trimmed.fq.gz /datanode03/zhujy/trim_out/2306PC32R2.trimmed.U.fq.gz ILLUMINACLIP:/data01nfs/user/liupf/common_files/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 
conda deactivate
source activate /data01nfs/user/liupf/miniconda3/envs/sortmeRNA
sortmerna --ref /data01nfs/user/liupf/software_lpf/sortmeRNA_db/rfam-5.8s-database-id98.fasta --ref /data01nfs/user/liupf/software_lpf/sortmeRNA_db/rfam-5s-database-id98.fasta --ref /data01nfs/user/liupf/software_lpf/sortmeRNA_db/silva-arc-16s-id95.fasta --ref /data01nfs/user/liupf/software_lpf/sortmeRNA_db/silva-arc-23s-id98.fasta --ref /data01nfs/user/liupf/software_lpf/sortmeRNA_db/silva-bac-16s-id90.fasta --ref /data01nfs/user/liupf/software_lpf/sortmeRNA_db/silva-bac-23s-id98.fasta --ref /data01nfs/user/liupf/software_lpf/sortmeRNA_db/silva-euk-18s-id95.fasta --ref /data01nfs/user/liupf/software_lpf/sortmeRNA_db/silva-euk-28s-id98.fasta --fastx -a 15 -v --log --reads /datanode03/zhujy/trim_out/2306PC32R1.trimmed.fq.gz --reads /datanode03/zhujy/trim_out/2306PC32R2.trimmed.fq.gz --aligned /datanode03/zhujy/sortmerna_out/2306PC32.align --other /datanode03/zhujy/sortmerna_out/2306PC32.unalign --paired_in --out2 --workdir /datanode03/zhujy/sortmerna_temp/2306PC32
conda deactivate
source /data01nfs/user/liupf/miniconda3/bin/activate
conda activate megahit
megahit -1 /datanode03/zhujy/sortmerna_out/2306PC32.unalign_fwd.fq.gz -2 /datanode03/zhujy/sortmerna_out/2306PC32.unalign_rev.fq.gz -t 60 --out-prefix 2306PC32_megahit --out-dir /datanode03/zhujy/megahit_out/2306PC32 &> /datanode03/zhujy/megahit_out/megahit_log/2306PC32.log
