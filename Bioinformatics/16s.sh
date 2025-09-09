./usearch -fastq_mergepairs *.R1.fq -reverse *.R2.fq -relabel @ -fastqout merged_f.fastq

head -12 merged_f.fastq
cat merged_f.fastq | head |grep --color='auto' 'GTGCCA.*CGGTAA' -E
cat merged_f.fastq | head |grep --color='auto' 'AAACTT.*TGACGG' -E

source /data01nfs/apps/anaconda3/bin/activate
conda env list
conda activate seqkit-2.2.0
seqkit stats merged_f.fastq

./usearch -fastx_truncate merged_f.fastq -stripleft 19 -stripright 20 -fastqout stripped.fq

./usearch -fastq_filter stripped.fq  -fastq_maxee 1.0 -fastaout filtered.fa

seqkit stats stripped.fq
seqkit stats filtered.fa

source /data01nfs/apps/anaconda3/bin/activate
conda activate mothur
mothur
summary.seqs(fasta=filtered.fa,processors=4) 
quit()

source /data01nfs/apps/anaconda3/bin/activate
conda activate seqkit-2.2.0
cat filtered.fa | seqkit seq -m 369 -M 383 > filtered_length.fa
seqkit stats filtered_length.fa

source /data01nfs/apps/anaconda3/bin/activate
conda env list
conda activate mothur
mothur
summary.seqs(fasta=filtered_length.fa,processors=4)    
quit()

./usearch -fastx_uniques filtered_length.fa -sizeout -fastaout uniques.fa
./usearch -unoise3 uniques.fa -zotus zotus.fa
./usearch -otutab merged_f.fastq -otus zotus.fa -otutabout zotutab_raw.txt

source /data01nfs/apps/anaconda3/bin/activate
conda env list
conda activate mothur
mothur
classify.seqs(fasta= zotus.fa, template=/datanode03/wenr/database/sliva/silva.nr_v138.align, taxonomy=/datanode03/wenr/database/sliva/silva.nr_v138.tax, cutoff=80, processors=10)
quit()



