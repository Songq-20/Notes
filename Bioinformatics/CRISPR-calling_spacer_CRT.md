# CRISPR-calling_spacer_CRT  
## virus host prodiction by direct blastn

> target, vOTUs seqs, query, CRISPR spacer from MAGs or genomes, CRT prediction

#####glacier MAGs

```
#part I 1086 global glaicer genomes, 20220603 newest update, Drep99 glacier MAGs
cd /home/PTPE2/User/liupf/Projects_liupf/glacier_virome/MAGs_99_20220602

#part II,

#part III,

```

#extract CRISPR spacer #other spacer detection tools

```Plain Text # minced /home/PTPE2/Software/minced/minced -minNR 4 -maxRL 55 -maxSL 70 -spacers [genome.fasta] [outputfile.txt] [output.gff]

#test /home/PTPE2/Software/minced/minced -minNR 4 -maxRL 55 -maxSL 70 -spacers DRR331386_ma_bin.12.fa DRR331386_ma_bin.12.txt

> #####part I, cd /home/PTPE2/User/liupf/Projects_liupf/glacier_virome/MAGs_99_20220602
> 

for file in *.fa do /home/PTPE2/Software/minced/minced -minNR 4 -maxRL 55 -maxSL 70 -spacers "${file}" "${file%.*}".txt done

#delete empty files find . -type f -empty -print -delete

#fixed header of CRISPR file and merge # DRR331391_me_bin.9_spacers.fa + >DRR331391_k141_218009_length_8040_cov_79.2735_CRISPR_1_spacer_3 ==> >DRR331391_me_bin.9_C1_s3

for file in *_spacers.fa do echo ${file} sed -i -e "s/>.*\(_CRISPR.*_spacer_.*$)/>“${file%.*}"\1/g" "${file}” sed -i -e “s/CRISPR_/CR/g” “${file}" sed -i -e "s/spacer_/sp/g" "${file}” done

#109 genomes with spacers cat *_spacers.fa > MAGs1086_w_spacer109MAGs.fasta #1774

#>>>>>>>>>>>>>>>>>>>>>>>>> #>>>>>>>>>>>>>>>>>>>>>>>>> ##part II, 1364 MAGs of the NBT paper (1020 TP Drep99 + nonTP344 MAGs) cd ~/User/liupf/Projects_liupf/glacier_virome/mapping_to_MAGS1020

for file in *.fa do /home/PTPE2/Software/minced/minced -minNR 4 -maxRL 55 -maxSL 70 -spacers "${file}" "${file%.*}".txt done

#delete empty files find . -type f -empty -print -delete

for file in *_spacers.fa do echo ${file} sed -i -e "s/>.*\(_CRISPR.*_spacer_.*$)/>“${file%.*}"\1/g" "${file}” sed -i -e “s/CRISPR_/CR/g” “${file}" sed -i -e "s/spacer_/sp/g" "${file}” done

ls *spacers.fa|wc -l #173 MAGs with spacers cat* _spacers.fa > MAGs1364_w_spacer173MAGs.fasta grep -c ‘>’ MAGs1364_w_spacer173MAGs.fasta #4595 spacers

```

##blastn to vOTUs all vOTUs

```Plain Text cd /home/PTPE2/User/liupf/Projects_liupf/glacier_virome/global_glacier_virome vOTUs

#make blastdb # source /home/PTPE2/Software/miniconda3/bin/activate

conda activate blast212 makeblastdb -in glacier_April1_final5k_vOTUs.fna -dbtype nucl -out glacier_April1_final5k_vOTUs -parse_seqids

#blastn #part I blastn -task megablast -query /home/PTPE2/User/liupf/Projects_liupf/glacier_virome/MAGs_99_20220602/MAGs1086_w_spacer109MAGs.fasta -db glacier_April1_final5k_vOTUs -evalue 1e-5 -num_threads 20 -out MAGs1086_w_spacer109MAGs_vOTUs10840.txt -outfmt “6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qlen slen”

#blastn #part II blastn -task megablast -query /home/PTPE2/User/liupf/Projects_liupf/glacier_virome/mapping_to_MAGS1020/MAGs1364_w_spacer173MAGs.fasta -db glacier_April1_final5k_vOTUs -evalue 1e-5 -num_threads 20 -out MAGs1364_w_spacer173MAGs_vOTUs10840.txt -outfmt “6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qlen slen”

### 

makeblastdb -in glacier_April1_final5k.fna -dbtype nucl -out glacier_April1_final5k -parse_seqids

#blast to all conitgs, glacier_April1_final5k.fna; with DC snow samples #part I blastn -task megablast -query /home/PTPE2/User/liupf/Projects_liupf/glacier_virome/MAGs_99_20220602/MAGs1086_w_spacer109MAGs.fasta -db glacier_April1_final5k -evalue 1e-5 -num_threads 20 -out MAGs1086_w_spacer109MAGs_vCongtigs.txt -outfmt “6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qlen slen”

#blastn #part II blastn -task megablast -query /home/PTPE2/User/liupf/Projects_liupf/glacier_virome/mapping_to_MAGS1020/MAGs1364_w_spacer173MAGs.fasta -db glacier_April1_final5k -evalue 1e-5 -num_threads 20 -out MAGs1364_w_spacer173MAGs_vContigs.txt -outfmt “6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qlen slen”

```

###part III #3241

```Plain Text cd ~/User/liupf/Projects_liupf/glacier_virome/MAG3241_TPG

for file in *.fa do /home/PTPE2/Software/minced/minced -minNR 4 -maxRL 55 -maxSL 70 -spacers "${file}" "${file%.*}".txt done

#delete empty files find . -type f -empty -print -delete

for file in *_spacers.fa do echo ${file} sed -i -e "s/>.*\(_CRISPR.*_spacer_.*$)/>“${file%.*}"\1/g" "${file}” sed -i -e “s/CRISPR_/CR/g” “${file}" sed -i -e "s/spacer_/sp/g" "${file}” done

ls *spacers.fa|wc -l #530 MAGs with spacers cat* _spacers.fa > MAGs3241_w_spacer530MAGs.fasta grep -c ‘>’ MAGs3241_w_spacer530MAGs.fasta #11282

cd /home/PTPE2/User/liupf/Projects_liupf/glacier_virome/global_glacier_virome

blastn -task megablast -query /home/PTPE2/User/liupf/Projects_liupf/glacier_virome/MAG3241_TPG/MAGs3241_w_spacer530MAGs.fasta -db glacier_April1_final5k -evalue 1e-5 -num_threads 6 -out MAGs3241_w_spacer530MAGs_vCongtigs.txt -outfmt “6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qlen slen”
 ```

##part IV, cyanobacteria, 52  


# 

```  
cd /home/PTPE2/User/liupf/Projects_liupf/glacier_virome/GlacierCyano_MAG_Microbome2022

for file in *mag.fa do /home/PTPE2/Software/minced/minced -minNR 4 -maxRL 55 -maxSL 70 -spacers "${file}" "${file%.*}".txt done

#delete empty files find . -type f -empty -print -delete

for file in *_spacers.fa do echo ${file} sed -i -e "s/>.*\(_CRISPR.*_spacer_.*$)/>“${file%.*}"\1/g" "${file}” sed -i -e “s/CRISPR_/CR/g” “${file}" sed -i -e "s/spacer_/sp/g" "${file}” done

ls *spacers.fa|wc -l #13 MAGs with spacers cat* _spacers.fa > MAGs52_w_spacer13MAGs.fasta grep -c ‘>’ MAGs52_w_spacer13MAGs.fasta # spacers #94

blastn -task megablast -query /home/PTPE2/User/liupf/Projects_liupf/glacier_virome/GlacierCyano_MAG_Microbome2022/MAGs52_w_spacer13MAGs.fasta -db glacier_April1_final5k -evalue 1e-5 -num_threads 6 -out MAGs52_w_spacer13MAGs_vCongtigs.txt -outfmt “6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qlen slen”
 ```