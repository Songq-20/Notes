# quality filtering and CheckV  
## checkV quality checking and life strategies of virus

#CheckV.md

```
# https://bitbucket.org/berkeleylab/checkv/src/master/

cd /home/liupf/Projects/glacier_virome/virus_contigs_calling_out

screen -r checkV-glacier-all

checkv end_to_end glacier_total_virus_Can.fasta checkv_output_directory -t 30 -d /home/ptpe/biodatabase/checkv_db/checkv-db-v1.0

#21282

#the output of checkV will cut some viurs contigs into sevearl part if this is the case
#appended _1 or _2 to fragment
#this will not show in the quality summary file

cat proviruses.fna viruses.fna > virus_tmp.fasta

sed -i -e 's/ .*$//g' virus_tmp.fasta
sed -i -e 's/_1$//g' virus_tmp.fasta

#删除 .* and _1 # $指结尾

#we rerun the checkV
#rerun checkV？
checkv end_to_end virus_tmp.fasta checkv_output_directory -t 30 -d /home/ptpe/biodatabase/checkv_db/checkv-db-v1.0

#discarded list
#among them, xxx are with 0 virus genes and with >=1 host genes,
##these need to be discardeded number
#virus gene==0 and host gene>=1
awk '$6==0&$7>0' quality_summary.tsv |wc -l
#7795

awk '$6==0&$7>0' quality_summary.tsv | cut -f1 -d$'\t' > glacier_total_virus_discarded_seq.txt
#上面这部分是筛选出来要被丢弃的序列

#kept
seqkit grep -n -v -f glacier_total_virus_discarded_seq.txt  ../virus_tmp.fasta -o glacier_total_virus_final1.fasta

# grap -v:显示后面跟着的内容的互补内容

#
/home/liupf/Projects/glacier_virome/virus_contigs_calling_out/checkv_output_directory/checkv_output_directory/glacier_total_virus_final1.fasta
```

# 

```
cd /home/liupf/Projects/glacier_virome/GLY-PB-SR_virus_merge

screen -S checkV-GLY-PB-SR
conda activate checkv07
checkv end_to_end GLY-PB-SR_Can.fasta  GLY-PB-SR_Can_checkv_output_directory -t 15 -d /home/ptpe/biodatabase/checkv_db/checkv-db-v1.0

cat proviruses.fna viruses.fna >virus_tmp.fasta

sed -i -e 's/ .*$//g' virus_tmp.fasta
sed -i -e 's/_1$//g' virus_tmp.fasta

#rerun
screen -r checkV-GLY-PB-SR
/home/liupf/Projects/glacier_virome/GLY-PB-SR_virus_merge/GLY-PB-SR_Can_checkv_output_directory

checkv end_to_end virus_tmp.fasta  checkv_output_directory -t 15 -d /home/ptpe/biodatabase/checkv_db/checkv-db-v1.0

awk '$6==0&$7>0' quality_summary.tsv | cut -f1 -d$'\t' > discarded_seq.txt

#92

#kept
seqkit grep -n -v -f discarded_seq.txt  ../virus_tmp.fasta -o glacier_total_virus_final2.fasta
#
/home/liupf/Projects/glacier_virome/GLY-PB-SR_virus_merge/GLY-PB-SR_Can_checkv_output_directory/checkv_output_directory/glacier_total_virus_final2.fasta

```

# MV-populations.fa

```
#CheckV v0.8.1: contamination
screen -r MV-populations-checkv
conda activate checkv07
checkv end_to_end MV-populations.fa checkv_output_directory -t 14 -d /home/ptpe/biodatabase/checkv_db/checkv-db-v1.0

cd /home/liupf/Projects/glacier_virome/Mv-population_checkv_output_directory

cat proviruses.fna viruses.fna > virus_tmp.fasta

sed -i -e 's/ .*$//g' virus_tmp.fasta
sed -i -e 's/_1$//g' virus_tmp.fasta
checkv end_to_end virus_tmp.fasta  checkv_output_directory -t 15 -d /home/ptpe/biodatabase/checkv_db/checkv-db-v1.0

awk '$6==0&$7>0' quality_summary.tsv | cut -f1 -d$'\t' > discarded_seq.txt

#666

#kept

seqkit grep -n -v -f discarded_seq.txt  ../virus_tmp.fasta -o glacier_total_virus_final3.fasta

/home/liupf/Projects/glacier_virome/Mv-population_checkv_output_directory/checkv_output_directory/glacier_total_virus_final3.fasta

```

##move to vOTUs clustering

########testing

```
#discarded list
#among them, xxx are with 0 virus genes and with >=1 host genes,
##these need to be discardeded number
#virus gene==0 and host gene>=1
awk '$6==0&$7>0' quality_summary.tsv |wc -l
#666
#$6-viral_genes $7-host_genes

#Not-determined 693,
#-c -count
grep -c 'Not-determined' quality_summary.tsv
693
[ptpe@localhost Mv-population_checkv_output_directory]$ awk '$7==0' quality_summary.tsv |grep -c 'Not-determined'
95
[ptpe@localhost Mv-population_checkv_output_directory]$ awk '$7>0' quality_summary.tsv |grep -c 'Not-determined'
598

#among them, 666 are with 0 virus genes and with >=1 host genes,
##these need to be discardeded number
#virus gene==0 and host gene>=1
awk '$6==0&$7>0' quality_summary.tsv |wc -l
#666

#598 Not-determined, 68 with quality levels,
[ptpe@localhost Mv-population_checkv_output_directory]$ awk '$6==0&$7>0' quality_summary.tsv |grep -c 'Not-determined'
598

# awk '$6==0&$7>0' quality_summary.tsv |grep -v 'Not-determined'
##=====> 68

#with virus gene==0 and host gene ==0, only 1 Not-determined
(checkv07) [ptpe@localhost Mv-population_checkv_output_directory]$ awk '$6==0&$7==0' quality_summary.tsv |grep -c 'Not-determined'
#94

###with virus gene>0 and host gene ==0, only 1 Not-determined
(checkv07) [ptpe@localhost Mv-population_checkv_output_directory]$ awk '$6>0&$7==0' quality_summary.tsv |grep -c 'Not-determined'
#1
#with virus gene>0 and host gene >=1, 0 Not-determined
(checkv07) [ptpe@localhost Mv-population_checkv_output_directory]$ awk '$6>0&$7>=1' quality_summary.tsv |grep -c 'Not-determined'
0

#with virus gene==0 and host gene >=1, only 1 Not-determined
(checkv07) [ptpe@localhost Mv-population_checkv_output_directory]$ awk '$6>0&$7>1' quality_summary.tsv |grep -c 'Not-determined'
#577

#with host gene==1, 693, host gene >1, 525
(checkv07) [ptpe@localhost Mv-population_checkv_output_directory]$ awk '$7>1' quality_summary.tsv |grep -c 'Not-determined'
525
(checkv07) [ptpe@localhost Mv-population_checkv_output_directory]$ awk '$7=1' quality_summary.tsv |grep -c 'Not-determined'
693
```

## checkv hmm search on viral protein

```
#PTPE2
#wkdir
/home/PTPE2/Software/biodatabase/checkv_db/checkv-db-v1.0/hmm_db/checkv_hmms
cat *.hmm > ~/User/liupf/Projects_liupf/glacier_virome/vContact2/checkV_all.hmm

cd  ~/User/liupf/Projects_liupf/glacier_virome/vContact2/

#top hits and HMM specific bitscores
hmmsearch --tblout Glacier_virome_protein_checkv.txt --cut_tc --cpu 60 checkV_all.hmm /home/PTPE2/User/liupf/Projects_liupf/glacier_virome/for-dramv/final-viral-combined-for-dramv.fa.split/All_dramv_orfs_glacier.faa &

#Error: TC bit thresholds unavailable on model Pfam-B_12
grep -c 'NAME' checkV_all.hmm
15958

for file in *hmm;
do
echo "nohup hmmsearch --tblout Glacier_virome_protein_checkv_"${file}".txt --cpu 1 /home/PTPE2/Software/biodatabase/checkv_db/checkv-db-v1.0/hmm_db/checkv_hmms/${file} /home/PTPE2/User/liupf/Projects_liupf/glacier_virome/for-dramv/final-viral-combined-for-dramv.fa.split/All_dramv_orfs_glacier.faa &"
done

#get the best hits
#awk '!x[$3]++' Glacier_virome_protein_checkv_fix.txt > Glacier_virome_protein_checkv_fix_best.txt

rm Glacier_virome_protein_checkv_fix_header.txt
nano header_hmmsearch.txt
cat header_hmmsearch.txt Glacier_virome_protein_checkv_fix.txt > Glacier_virome_protein_checkv_fix_header.txt
head Glacier_virome_protein_checkv_fix_header.txt

sed -i -e 's/ \-/  \-  /g' Glacier_virome_protein_checkv_fix_header.txt

sed -i -e 's/  \+/\t/g' Glacier_virome_protein_checkv_fix_header.txt
sed -i -e 's/ rank/\trank/g' Glacier_virome_protein_checkv_fix_header.txt

cat Glacier_virome_protein_checkv_fix_header.txt  |cut -f2 -d$'\t' |more
R
library(dplyr)

checkv<- read.delim("Glacier_virome_protein_checkv_fix_header.txt",header=T,check.names = FALSE,sep = "\t",quote="")

df <- checkv %>% group_by(target_name) %>% slice(which.max(score_all)) #  summarise(max = max(score_all))

getwd()
#[1] "/Users/pengfeiliu/A_TBP/文章-MS-TP/glacier-virome2021/virsorter2_vcontigs10kfingal"

```
