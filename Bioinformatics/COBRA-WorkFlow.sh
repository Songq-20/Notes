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
source /data01nfs/user/liupf/miniconda3/bin/activate

# Step1 Bowtie2 to get *.sam #
conda activate bowtie2
bowtie2-build Megahit_out/{Sample-id}/{Sample-id}_megahit.contigs.fa mapping/{Sample-id}-contig-bowtie2index
bowtie2 -x mapping/{Sample-id}-contig-bowtie2index -1 Trimmed_out/{Sample-id}/{Sample-id}.R1_trimmed.fq.gz -2 Trimmed_out/{Sample-id}/{Sample-id}.R2_trimmed.fq.gz -S mapping/{Sample-id}.sam --threads 60 --sensitive --no-unal
conda deactivate

# Step2 Samtools to get filtered & sorted *bam #
conda activate samtools
samtools view -@ 60 -bS mapping/{Sample-id}.sam > mapping/{Sample-id}.bam
samtools view -h -@ 60 -q 30 -F 0x08 -b -f 0x2 mapping/{Sample-id}.bam > mapping/{Sample-id}-filtered.bam
samtools sort -@ 60 mapping/{Sample-id}-filtered.bam -o mapping/{Sample-id}-cobra-fs.bam
conda deactivate

# Step3 MetaBAT2 & coverage.transfer.py to get coverage.txt #
conda activate metabat2
jgi_summarize_bam_contig_depths --outputDepth cobra-temp/{Sample-id}-coverage.txt mapping/{Sample-id}-MV-cobra-fs.bam
conda deactivate
python ~/coverage.transfer.py -i cobra-temp/{Sample-id}-coverage.txt -o coverage/{Sample-id}_coverage.txt
conda deactivate

# Step4 running COBRA #
# -q: checkv_input(vs2+genomad) : -m: *sam from bowtie2 #
source activate cobra
cobra-meta -f Megahit_out/{Sample-id}/{Sample-id}_megahit.contigs.fa -q checkv_in/{Sample-id}.fa -o COBRA/611_RW_MV_COBRA -c coverage/{Sample-id}_coverage.txt -m mapping/{Sample-id}-MV.sam -a megahit -mink 21 -maxk 141 
conda deactivate