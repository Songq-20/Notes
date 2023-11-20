# merge-all-vc-calling-results
## filtering and merge all results from virsorter2, vibrant, DeepVirFinder, virFinder,

# pipeline

```Plain Text 
#1, get a list sequence names of all genomes from virsorte2, vibrant, DeepVirFinder, virFinder,

#2, seqkit get all possible sequences

#move to checkV quality checking 
```

# TP-CAS

```
/mnt/nfs/liupf/glacier_virome/virus_contigs_calling_out

#1, virsorter2
cp -r glacier_metaV14.out /mnt/nfs/liupf/glacier_virome/virus_contigs_calling_out
cp -r glacier_metaG10.out /mnt/nfs/liupf/glacier_virome/virus_contigs_calling_out

#keep only this file
ls | grep -v final-viral-score.tsv| xargs rm -r

#2 virfinder
cp glacier_10k_virfinder.txt /mnt/nfs/liupf/glacier_virome/virus_contigs_calling_out
cp glacier_metaV14_10k_virfinder.txt /mnt/nfs/liupf/glacier_virome/virus_contigs_calling_out
cp virfinder-metaG10.txt  /mnt/nfs/liupf/glacier_virome/virus_contigs_calling_out

#3 vibrant
cp glacier_10k.phages_combined.txt /mnt/nfs/liupf/glacier_virome/virus_contigs_calling_out
cp glacier_metaV14.phages_combined.txt /mnt/nfs/liupf/glacier_virome/virus_contigs_calling_out
cp glacier_metaG10.phages_combined.txt  /mnt/nfs/liupf/glacier_virome/virus_contigs_calling_out

```

# all data on LZU904

```
mv glacier_10k_Dvf_gt10000bp_dvfpred_full.txt ../virus_contigs_calling_out/
mv glacier_metaG10.fasta_gt10000bp_dvfpred.txt ../virus_contigs_calling_out/
mv glacier_metaV14.fasta_gt10000bp_dvfpred.txt ../virus_contigs_calling_out/

# /home/liupf/Projects/glacier_virome/virus_contigs_calling_out
cat *final* > VS2_viral_score.tsv
cat *phages_combined.txt >VIBRANT_phage_out.txt
cat *virfinder* >Virfinder_total_out.txt
cat *dvfpred* >Deepvifinder_total_out.txt

#vs2
cat VS2_viral_score.tsv |grep -v 'seqname' >  VS2_viral_score_seqname.tsv
sed -i -e 's/||.*$//g' VS2_viral_score_seqname.tsv
16539 VS2_viral_score_seqname.tsv

#virfinder, filter with score 0.7, pvalue 0.05
awk '$4>=0.7&&$5<0.05' Virfinder_total_out.txt > Virfinder_total_out_s7p5.txt
#7765 Virfinder_total_out_s7p5.txt

#virfinder, filter with score 0.9, pvalue 0.05
awk '$4>=0.9&&$5<0.05' Virfinder_total_out.txt > Virfinder_total_out_s9p5.txt
#1901 Virfinder_total_out_s9p5.txt
cat Virfinder_total_out_s9p5.txt |cut -d$'\t' -f2 >Virfinder_total_out_s9p5_seqname.txt

#between 0.9-0.7
awk '$4>=0.7&&$4<0.9' Virfinder_total_out_s7p5.txt > Virfinder_total_out_s7s9.txt
#5864 Virfinder_total_out_s7s9.txt

cat Virfinder_total_out_s7s9.txt |cut -d$'\t' -f2 > Virfinder_total_out_s7s9_seqname.txt

#score 0.7 p0.05 + virsorter2
#comm -12 <(sort Virfinder_total_out_s7s9_seqname.txt) <(sort VS2_viral_score_seqname.tsv) > Virfinder_s7s9_VS2_seqname.txt
#1670
#comm逐行比较已排序的两个文件-输出三列

#Deepvifinder, filter with score 0.9, pvalue 0.05
awk '$3>=0.9&&$4<0.05' Deepvifinder_total_out.txt> Deepvifinder_total_out_s9p5.txt
#5373 Deepvifinder_total_out_s9p5.txt
cat Deepvifinder_total_out_s9p5.txt |cut -d$'\t' -f1 >Deepvifinder_total_out_s9p5_seqname.txt

##vibrant
sed -i -e 's/_fragment.*$//g' VIBRANT_phage_out.txt
#9667

cat VS2_viral_score_seqname.tsv Deepvifinder_total_out_s9p5_seqname.txt Virfinder_total_out_s9p5_seqname.txt VIBRANT_phage_out.txt |sort|uniq> glacier_virome_all_4pipelin_uniq.txt

#21918 glacier_virome_all_4pipelin_uniq.txt

#in total 21918 putative virus sequences from 4 pipeline
$cat glacier_10k.fasta  glacier_metaG10.fasta glacier_metaV14.fasta > ./virus_contigs_calling_out/glacier_total_tmp.fasta
#422377

#glacier_10k.fasta:386063
#glacier_metaG10.fasta:24850
#glacier_metaV14.fasta:11464
#GLY-PB-SR.fasta:7400

conda activate seqkit
seqkit grep -n -f glacier_virome_all_4pipelin_uniq.txt glacier_total_tmp.fasta -o glacier_total_virus_Can.fasta

$seqkit stats glacier_total_virus_Can.fasta
file                           format  type  num_seqs      sum_len  min_len   avg_len  max_len
glacier_total_virus_Can.fasta  FASTA   DNA     21,282  509,465,880   10,000  23,938.8  836,185

```

# all data on LZU904; adding

```
cd /home/liupf/Projects/glacier_virome/GLY-PB-SR_virus_merge

#vs2
(base) [ptpe@localhost VIBRANT_phages_GLY-PB-SR]$ cp final-viral-score.tsv ../GLY-PB-SR_virus_merge/
cat final-viral-score.tsv  |grep -v 'seqname' >  GLY-PB-SR-VS2_viral_score_seqname.tsv
sed -i -e 's/||.*$//g' GLY-PB-SR-VS2_viral_score_seqname.tsv
#219

#vibrant
(base) [ptpe@localhost VIBRANT_phages_GLY-PB-SR]$ cp GLY-PB-SR.phages_combined.txt ../../GLY-PB-SR_virus_merge/
sed -i -e 's/_fragment.*$//g' GLY-PB-SR.phages_combined.txt
#115

#virfinder, filter with score 0.9, pvalue 0.05
mv virfinder-GLY-PB-SR.txt ./GLY-PB-SR_virus_merge
awk '$4>=0.9&&$5<0.05' virfinder-GLY-PB-SR.txt > virfinder-GLY-PB-SR_s9p5.txt
#36 Virfinder_total_out_s9p5.txt
cat virfinder-GLY-PB-SR_s9p5.txt |cut -d$'\t' -f2 >virfinder-GLY-PB-SR_s9p5_seqname.txt

#Deepvifinder, filter with score 0.9, pvalue 0.05
mv GLY-PB-SR.fasta_gt10000bp_dvfpred.txt ../GLY-PB-SR_virus_merge/
awk '$3>=0.9&&$4<0.05' GLY-PB-SR.fasta_gt10000bp_dvfpred.txt > GLY-PB-SR.fasta_gt10000bp_s9p5.txt
#85
cat GLY-PB-SR.fasta_gt10000bp_s9p5.txt |cut -d$'\t' -f1 >GLY-PB-SR.fasta_gt10000bp_s9p5_seqname.txt

cat GLY-PB-SR-VS2_viral_score_seqname.tsv GLY-PB-SR.phages_combined.txt virfinder-GLY-PB-SR_s9p5_seqname.txt GLY-PB-SR.fasta_gt10000bp_s9p5_seqname.txt |sort|uniq> GLY-PB-SR_all_4pipelin_uniq.txt
#258 GLY-PB-SR_all_4pipelin_uniq.txt

#in total 258 putative virus sequences from 4 pipeline

seqkit grep -n -f GLY-PB-SR_all_4pipelin_uniq.txt ../GLY-PB-SR.fasta -o GLY-PB-SR_Can.fasta

$seqkit stats GLY-PB-SR_Can.fasta
file                 format  type  num_seqs    sum_len  min_len   avg_len  max_len
GLY-PB-SR_Can.fasta  FASTA   DNA        258  6,594,006   10,001  25,558.2  409,823
```

# add MV-population.fa

```Plain Text #see checkV

```

# filtering out sequences with

> 将几个软件的结果整合
>