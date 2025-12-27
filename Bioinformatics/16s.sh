./usearch -fastq_mergepairs *.R1.fq -reverse *.R2.fq -relabel @ -fastqout merged_f.fastq

head -12 merged_f.fastq
cat merged_f.fastq | head |grep --color='auto' 'GTGCCA.*CGGTAA' -E
cat merged_f.fastq | head |grep --color='auto' 'AAACTT.*TGACGG' -E

source /data01nfs/apps/anaconda3/bin/activate
conda env list
conda activate seqkit-2.2.0
seqkit stats merged_f.fastq

./usearch -fastx_truncate merged_f.fastq -stripleft 19 -stripright 20 -fastqout stripped.fq

./usearch -fastq_filter stripped.fq -fastq_maxee 1.0 -fastaout filtered.fa

seqkit stats stripped.fq
seqkit stats filtered.fa

source /data01nfs/apps/anaconda3/bin/activate
conda activate mothur
mothur
summary.seqs(fasta=filtered.fa,processors=4) 
quit()
                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1       33      33      0       3       1
2.5%-tile:      1       368     368     0       4       90142
25%-tile:       1       370     370     0       4       901413
Median:         1       372     372     0       4       1802826
75%-tile:       1       374     374     0       5       2704239
97.5%-tile:     1       375     375     0       6       3515510
Maximum:        1       431     431     1       66      3605651
Mean:   1       372     372     0       4
# of Seqs:      3605651
source /data01nfs/apps/anaconda3/bin/activate
conda activate seqkit-2.2.0
cat filtered.fa | seqkit seq -m 366 -M 375 > filtered_length.fa
seqkit stats filtered_length.fa

source /data01nfs/apps/anaconda3/bin/activate
conda env list
conda activate mothur
mothur
summary.seqs(fasta=filtered_length.fa,processors=4)    
quit()

./usearch -fastx_uniques filtered_length.fa -sizeout -fastaout uniques.fa
./usearch -unoise3 uniques.fa -zotus zotus.fa


source /data01nfs/apps/anaconda3/bin/activate
conda env list
conda activate mothur
mothur <<EOF
classify.seqs(fasta= zotus.fa, template=/datanode03/wenr/database/sliva/silva.nr_v138.align, taxonomy=/datanode03/wenr/database/sliva/silva.nr_v138.tax, cutoff=80, processors=10)
quit()
EOF
./usearch -otutab merged_f.fastq -otus zotus_filt.fa -otutabout zotutab_raw.txt

