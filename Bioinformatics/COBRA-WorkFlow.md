```Shell
#!/bin/bash
#SBATCH -J cobra
#SBATCH -p cn-long
#SBATCH -N 1
#SBATCH -c 60
#SBATCH -o /data01nfs/user/songq/log/cobra.out
#SBATCH -e /data01nfs/user/songq/log/cobra.err
#SBATCH --no-requeue
#SBATCH -A cnl

cd /datanode03/songq

# Step1 获取 query id #

source activate /datanode03/zhangxf/programs/mambaforge/envs/seqkit
seqkit seq megahit.contigs.fa -n -i > query_id.txt
conda deactivate
#用什么标准去筛选 query id 需要商定

# Step2 Bowtie2 获取 sam 文件 #

source /data01nfs/user/liupf/miniconda3/bin/activate
conda activate bowtie2
bowtie2-build megahit.contigs.fa id_bowtie2index
bowtie2 -x id_bowtie2index -1 id.R1_trimmed.fq.gz -2 id.R2_trimmed.fq.gz -S id.sam --threads 60 --sensitive --no-unal
conda deactivate

# Step3 Samtools 获取排序后的 bam 文件 #
source /data01nfs/user/liupf/miniconda3/bin/activate
conda activate samtools
samtools view -@ 60 -bS id.sam > id.bam
samtools view -h -@ 60 -q 30 -F 0x08 -b -f 0x2 idbam > id-filtered.bam
samtools sort -@ 60 id-filtered.bam -o id-cobra-fs.bam
conda deactivate

# Step4 MetaBAT2 & coverage.transfer.py 获取 coverage.txt #
conda activate /data01nfs/apps/anaconda3/envs/metabat2-2.15
jgi_summarize_bam_contig_depths --outputDepth id-coverage_raw.txt id-cobra-fs.bam
conda deactivate
python3 ~/coverage.transfer.py -i id-coverage_raw.txt -o id_coverage.txt
conda deactivate

# Step5  COBRA #
# -q: checkv_input(vs2+genomad) : -m: bam from samtools #
source activate cobra
cobra-meta -f megahit.contigs.fa -q checkv_in/{Sample-id}.fa -o Output_dir -c id_coverage.txt -m id-cobra-fs.bam -a megahit -mink 21 -maxk 141 
conda deactivate
```
