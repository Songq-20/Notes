## database path
### RdRp aa
1. Luca : /datanode02/zhangzh/database/Lucaport/Luca_all_dom.faa
2. RVMT : /datanode02/zhangzh/database/RVMT_RdRP/RVMT_final_complete_contig_emboss_win_rdrp.faa
3. TO : /datanode02/zhangzh/database/TaraOcean/RdRp_footprints_Tara_Genbank_Wolf2020_centroids_50_percent_near_complete.faa

### Contigs nt
1. Luca : /datanode03/songq/database/lucaprot_contig/LucaProt_SuperGroup_contig.fna
2. RVMT : /datanode02/zhangzh/database/RVMT_contig/RiboV1.6_Contigs.fasta
3. TO : /datanode02/zhangzh/database/TaraOcean/44779_RdRP_contigs.fna

### Others
1. NR.dmnd : /datanode02/zhangzh/database/NCBI_database/NR_202307.dmnd
2. hmm profile : /datanode03/songq/RdRp/all_RdRp.hmm
---
### Trim

```shell
#!/bin/bash
#SBATCH -J trim
#SBATCH -p cn-long
#SBATCH -N 1
#SBATCH -c 60
#SBATCH -o /data01nfs/user/songq/log/trim.out
#SBATCH -e /data01nfs/user/songq/log/trim.err
#SBATCH --no-requeue
#SBATCH -A cnl

trimmomatic PE -threads 4  input.R1.fq.gz  input.R2.fq.gz  output_R1_trimmed.fq.gz  output_R1_trimmed_U.fq.gz  output_R2_trimmed.fq.gz  output_R2_trimmed_U.fq.gz ILLUMINACLIP:/data01nfs/user/liupf/common_files/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
```

### SortmeRNA

```shell
#SBATCH
conda activate sortmerna
sortmerna --ref /data01nfs/user/liupf/software_lpf/sortmeRNA_db/rfam-5.8s-database-id98.fasta --ref /data01nfs/user/liupf/software_lpf/sortmeRNA_db/rfam-5s-database-id98.fasta --ref /data01nfs/user/liupf/software_lpf/sortmeRNA_db/silva-arc-16s-id95.fasta --ref /data01nfs/user/liupf/software_lpf/sortmeRNA_db/silva-arc-23s-id98.fasta --ref /data01nfs/user/liupf/software_lpf/sortmeRNA_db/silva-bac-16s-id90.fasta --ref /data01nfs/user/liupf/software_lpf/sortmeRNA_db/silva-bac-23s-id98.fasta --ref /data01nfs/user/liupf/software_lpf/sortmeRNA_db/silva-euk-18s-id95.fasta --ref /data01nfs/user/liupf/software_lpf/sortmeRNA_db/silva-euk-28s-id98.fasta --fastx -a 15 -v --log --reads "${id}"_R1_trimmed.fq.gz  --reads "${id}"_R2_trimmed.fq.gz --aligned /datanode03/zhangxf/sortmeAJ/"${id}".align --other /datanode03/zhangxf/sortmeAJ/"${id}".unalign --paired_in --out2 --workdir /datanode03/zhangxf/tmp/"${id}"
```


### Assemble

```bash
#SBATCH

conda activate megahit
megahit -1 id.unalign_fwd.fq.gz -2 id.unalign_rev.fq.gz -t 60 --out-prefix id_megahit --out-dir <output_dir> &> <log.file.name>
```
---
### Rename
```
...
```
### >750bp
```
...
```
### get ORFs
```shell
source /apps/source/prodigal-2.6.3.sh
prodigal -p meta -q -m -i 750.fa -d ORF_nt.fna -a ORF_aa.faa -o ORF.gff
```
### RdRp seq Predict
```shell
#### hmmsearch ####

export TMPDIR=/datanode03/songq/tmp

source /datanode03/zhangxf/programs/mambaforge/bin/activate
conda activate hmmer
while read id
do
hmmsearch --cpu 60 -E 1 --tblout ./hmmsearch/${id}.txt /datanode03/songq/RdRp/all_RdRp.hmm ./protein/${id}.faa
done < id.list

#### LucaProt ####
### 在学校集群跑 ###
#!/bin/bash
#SBATCH --job-name=LucaProt1
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=20
#SBATCH --partition=gpu1
#SBATCH --gres=gpu:1 -n 10
#SBATCH -o log/luca.out
#SBATCH -e log/luca.err

conda activate lucaprot
while read id
do
cd ../LucaProt/src/
export CUDA_VISIBLE_DEVICES="0,1,2,3"
python predict_many_samples.py \
        --fasta_file /data/groups/lzu_public/home/liupf/songq/lucaprot/protein/${id}.faa  \
        --save_file /data/groups/lzu_public/home/liupf/songq/lucaprot/csv/${id}.csv \
        --emb_dir /data/groups/lzu_public/home/liupf/songq/lucaprot/emb/${id}   \
        --truncation_seq_length 4096  \
        --dataset_name rdrp_40_extend  \
        --dataset_type protein     \
        --task_type binary_class     \
        --model_type sefn     \
        --time_str 20230201140320   \
        --step 100000  \
        --threshold 0.5 \
        --print_per_number 10 \
        --gpu_id 0
cd /data/groups/lzu_public/home/liupf/songq
rm -r lucaprot/emb/${id} 
done < id.list
```
取 hmm 所有输出的 seq，LucaProt 输出中 prob 为 1 的部分，提取序列，进入 `palm_annot`
```shell
#### Palm_annot ####
source /datanode02/zhangzh/.apps/palmid.sh
export PATH="/datanode02/zhangzh/minisoft/palm_annot/bin:$PATH"
export PATH="/datanode02/zhangzh/minisoft/palm_annot/py:$PATH"
/datanode02/zhangzh/minisoft/palm_annot/py/palm_annot.py --input pre_palm.faa --seqtype aa --rdrp pre_palm_out.faa --fev pre_palm_out.fev --tmpdir ./tmpdir --threads 30 

#fev2tsv.py
source  /datanode02/zhangzh/.apps/palmid.sh
/datanode02/zhangzh/minisoft/palm_annot/py/fev2tsv.py --input pre_palm_out.fev --output pre_palm_out.tsv
```
`Palm_annot` 输出中取 `pre_palm_out.tsv` 内 `score` 列有值的，进入下一步质检
```shell
#### quality check ###
### mapping with metagenome reads ###
## 必须使用 Bowtie2 ##

# Bowtie2 #
source /data01nfs/apps/anaconda3/bin/activate
conda activate bowtie2
bowtie2-build ../rdrp_orf_nt.fna index/rdrp_orf_nt

dir=/datanode03/songq/songq_datanode03/Trimmed_out
while read id
do
bowtie2 -x index/rdrp_orf_nt -1 ${dir}/${id}.R1_trimmed.fq.gz -2 ${dir}/${id}.R2_trimmed.fq.gz -S "${id}.sam" --threads 30 --sensitive --no-unal
done < MGid.txt

# sam2bam #
source /datanode03/zhangxf/programs/mambaforge/bin/activate
conda activate samtools
for samfile in *.sam
do
    
    sample=$(basename "$samfile" .sam)
    
    echo "Processing $sample..."
    
    # 主命令：samtools view + sort
    samtools view -@ 30 -q 30 -F 0x08 -b -f 0x2 "$samfile" | samtools sort -@ 30 -o "${sample}.bam"
done

# coverm #
export TMPDIR=~/tmp
source /datanode03/zhangxf/mambaforge/bin/activate
conda activate coverm_0.6.1

coverm contig  --bam-files *.bam  -t 30  --methods covered_fraction -o rdrp_contig_2_metag_coverage.tsv
coverm contig  --bam-files *.bam  -t 30  --methods trimmed_mean  -o rdrp_contig_2_metag_mean.tsv
```
`coverm` 输出中没有在任何样品中 mapping 到的序列就是 RdRp

---
### CD-HIT 0.9 聚类得到 vOTU
```shell
source /data01nfs/apps/anaconda3/bin/activate
conda activate /data01nfs/apps/anaconda3/envs/cd-hit-4.8.1
cd-hit -i rdrp_orf_quality_check.faa -o rdrp_orf_OTU_quality_check.faa -c  0.9  -d 0
```
**同时要得到：**
1. RdRp ORF nt 序列
2. RdRp 全长 contig nt 序列
---
### Taxonomy
#### 分类优先级
``` 
#1 RdRp AA-- RVMT-- CD-HIT0.9 -- family/genus  
#1a vContigs Nt-- RVMT-- CheckV-- family/genus
#2 RdRp AA-- RVMT-- blastp Cov75/Id90-- family/genus
#3 vContigs Nt-- RVMT-- dc-MegaBlast-- family/genus
#4 RdRp AA-- RVMT-- CD-HIT0.5 -- family
#5 RdRp AA-- TO-- CD-HIT0.9 -- family/genus
#6 RdRp AA-- TO-- blastp Cov75/Id90-- family/genus
#7 vContigs Nt-- TO -- dc-MegaBlast -- family/genus
#8 RdRp AA-- TO -- CD-HIT0.5 -- family
#9 vContigs Nt-- IMGVR -- dc-MegaBlast -- family/genus
#10 vContigs Nt-- VITAP-- High-confidence -- family
#11 RdRp AA--Luca-prot- CD-HIT0.5 -- family
#12 Others
#blastp30-with-hits
#Unclassified-blastp30
```
#### 命令
##### RdRp 层面
```shell
#### cdhit ####
cat rdrp_orf_OTU_quality_check.faa Luca.faa RVMT.faa TO.faa > WTP_Luca_RVMT_TO.faa

source /data01nfs/apps/anaconda3/bin/activate
conda activate cd-hit-4.8.1

cd-hit -i WTP_Luca_RVMT_TO.faa -o WWTP_RdRp_orf_cdhit0.9.faa -c  0.9  -d 0
cd-hit -i WTP_Luca_RVMT_TO.faa -o WWTP_RdRp_orf_cdhit0.5.faa -c  0.5  -d 0 -n 3 -T 0 -M 2048

#### blastp ####
source /data01nfs/apps/anaconda3/bin/activate
conda activate diamond-2.0.15
diamond blastp --db /datanode02/zhangzh/database/RVMT_RdRP/RVMT_DB.dmnd  --query ../../../rdrp_orf_OTU_quality_check.faa --out WTP_all_rdrp_orf_RVMT.tsv -f 6 qseqid sseqid pident length qcovhsp mismatch gapopen qstart qend sstart send evalue bitscore  --sensitive -k 1 --max-target-seqs 1   -p 10
diamond blastp --db /datanode02/zhangzh/database/TaraOcean/TaraOcean_DB.dmnd --query ../../../rdrp_orf_OTU_quality_check.faa --out WTP_all_rdrp_orf_TO.tsv -f 6 qseqid sseqid pident length qcovhsp mismatch gapopen qstart qend sstart send evalue bitscore  --sensitive -k 1 --max-target-seqs 1   -p 10
diamond blastp --db /datanode02/zhangzh/database/Lucaport/Luca_DB.dmnd --query ../../../rdrp_orf_OTU_quality_check.faa --out WTP_all_rdrp_orf_Luca.tsv -f 6 qseqid sseqid pident length qcovhsp mismatch gapopen qstart qend sstart send evalue bitscore --sensitive -k 1 --max-target-seqs 1   -p 10
diamond blastp --db /datanode02/zhangzh/database/NCBI_database/NR_202307.dmnd --query ../../../rdrp_orf_OTU_quality_check.faa --out rdrp_orf_otu_rm2303_Luca.tsv -f 6 qseqid sseqid pident length qcovhsp mismatch gapopen qstart qend sstart send evalue bitscore --sensitive -k 1 --max-target-seqs 1   -p 15
```
##### contigs 层面
```shell
#### checkv聚类 ####
cat rdrp_contig_otu_quality_check_nt.fna Luca.fna RVMT.fna TO.fna > WWTP_Luca_RVMT_TO_nt.fna

mkdir blastdb
source /data01nfs/apps/anaconda3/bin/activate
conda activate blast-2.5
makeblastdb -in WWTP_Luca_RVMT_TO_nt.fna  -dbtype nucl -out blastdb/WWTP_Luca_RVMT_TO_nt
blastn -query WWTP_Luca_RVMT_TO_nt.fna   -db blastdb/WWTP_Luca_RVMT_TO_nt -outfmt '6 std qlen slen'  -max_target_seqs 10000 -out WWTP_Luca_RVMT_TO_nt.tsv -num_threads 20

source /datanode03/huangxy/programs/anaconda3/bin/activate
python3 /datanode03/songq/songq_datanode03/anicalc.py -i HWWTP_Luca_RVMT_TO_nt.tsv  -o WWTP_Luca_RVMT_TO_contig_anicalc.tsv 
python3 /datanode03/songq/songq_datanode03/aniclust.py --fna WWTP_Luca_RVMT_TO_nt.fna --ani WWTP_Luca_RVMT_TO_contig_anicalc.tsv --out WWTP_Luca_RVMT_TO_contig_ani_clusters9080.tsv  --min_ani 90 --min_tcov 80 --min_qcov 0

#### megablast ####
source /datanode03/songq/mambaforge/bin/activate
conda activate blast-2.13
blastn -query ../../../rdrp_contig_OTU_quality_check.fna -db /datanode02/zhangzh/database/RVMT_contig/RiboV1.6_Contigs -use_index true -task megablast -outfmt '7 qseqid sseqid pident length qcovs mismatch gapopen qstart qend sstart send evalue bitscore' -max_target_seqs 1  -out rdrp_contig_after_quality_check_blastRVMT.tsv -num_threads 10
blastn -query ../../../rdrp_contig_OTU_quality_check.fna -db /datanode02/zhangzh/database/TaraOcean/Tara_RdRP_contigs  -use_index true -task megablast -outfmt '7 qseqid sseqid pident length qcovs mismatch gapopen qstart qend sstart send evalue bitscore' -max_target_seqs 1  -out rdrp_contig_after_quality_check_blastTO.tsv -num_threads 10
blastn -query ../../../rdrp_contig_OTU_quality_check.fna -db /datanode02/zhangzh/database/IMGV/IMGVR_all_nucleotides  -use_index true -task megablast -outfmt '7 qseqid sseqid pident length qcovs mismatch gapopen qstart qend sstart send evalue bitscore' -max_target_seqs 1  -out rdrp_contig_after_quality_check_blastIMGV.tsv -num_threads 10
blastn -query ../../../rdrp_contig_OTU_quality_check.fna -db /datanode02/zhangzh/database/refseq_viral230504/refseq_RNAviral -use_index true -task megablast -outfmt '7 qseqid sseqid pident length qcovs mismatch gapopen qstart qend sstart send evalue bitscore' -max_target_seqs 1  -out rdrp_contig_after_quality_check_blastrefviralRNA.tsv -num_threads 10

#### VITAP ####
source /datanode03/songq/mambaforge/bin/activate
conda activate VITAP
dir="/datanode03/songq/software/VITAP-main"
${dir}/scripts/VITAP assignment -i ../../../rdrp_contig_OTU_quality_check.fna -d ${dir}/DB_hybrid_MSL37_RefSeq209_IMGVR -o vitap-out -p 28
```