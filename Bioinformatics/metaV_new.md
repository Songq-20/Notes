

### Trim

```bash
#!/bin/bash
#SBATCH -J trim
#SBATCH -p cn-long
#SBATCH -N 1
#SBATCH -c 60
#SBATCH -o /data01nfs/user/songq/log/trim.out
#SBATCH -e /data01nfs/user/songq/log/trim.err
#SBATCH --no-requeue
#SBATCH -A cnl
#SBATCH --mail-type=FAIL,END,BEGIN
#SBATCH --mail-user=2261518989@qq.com
R1=/R1_dir
R2=/R2_dir
R1_T=/output_R1_trimmed.fq.gz
R1_T_U=/output_R1_trimmed_U.fq.gz
R2_T=/output_R2_trimmed.fq.gz
R2_T_U=/output_R2_trimmed_U.fq.gz

conda activate /datanode03/songq/mambaforge/envs/trimmomatic
trimmomatic PE -threads 4  $R1 $R2 $R1_T $R1_T_U $R2_T $R2_T_U ILLUMINACLIP:/datanode03/liupf/common_files/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
```

---

### Assemble
>7h+, out-dir中的最子端文件夹不能存在，megahit会自己创建。储存空间不足会报错 Exit Code:01
```bash
#SBATCH

conda activate megahit
megahit -1 input_R1.trimmed.fq.gz -2 input_R2.trimmed.fq.gz -t 60 --out-prefix prefix --out-dir dir &> name.log
```


### rename 
```shell
#SBATCH
source activate /data01nfs/user/liupf/miniconda3/envs/seqkit
while read id
do
seqkit replace -p "\s.+" ${id}.fa > ${id}_1.fa
#去掉空格后的东西
seqkit replace -p ^ -r <prefix_> ${id}_1.fa > ${id}_rename.fa
#加入样品id
done<id.list
conda deactivate
```  

---
### >5k
```bash
#SBATCH 
source activate /datanode03/zhangxf/programs/mambaforge/envs/seqkit
while read id
do seqkit seq -m 5000 -j 8 <${id}_Raw_megahit_out> > ${id}_5k_contig.fa
done<id.list
```
`5k files cat > all_in_one_rename.fa`
<br>

### 病毒基因组注释 
```bash
######VirSorter2######
#SBATCH
source /data01nfs/user/huangxy/programs/anaconda3/bin/activate
conda activate vs2
virsorter run -w <output >-i <input> --min-length 5000 --include-groups dsDNAphage,ssDNA,RNA,lavidaviridae,NCLDV -j 20 all

######VirFinder######
#########cancel
#SBATCH
source /data01nfs/user/liupf/miniconda3/bin/activative
conda activate virfinder
R
library("VirFinder")
predResult <- VF.pred("inputfile")
predResult[order(predResult$pvalue),]
predResult$qvalue <- VF.qvalue(predResult$pvalue)
predResult_sorter<-predResult[order(predResult$qvalue),]
write.table(predResult_sorter, file="output-prefix_virfinder.txt", quote=F, sep="\\t")

######geNomad######
#SBATCH
conda activate genomad
genomad end-to-end --min-score 0.7 --cleanup <input> <output> /datanode03/huangxy/database/genomad_db

######VIBRANT######
source /data01nfs/user/huangxy/programs/anaconda3/bin/activate
conda activate vibrant
VIBRANT_run.py -i input.fasta -t 10 -folder output_folder
conda deactivate

######DeepVirFinder######
#SBATCH
source /datanode03/huangxy/programs/anaconda3/bin/activate
conda activate deepvirfinder
python /datanode03/huangxy/programs/DeepVirFinder/dvf.py -i input_dir -o output_dir -l 1000 -c 10
conda deactivate
```
  
---
### Score Filt
**VirSorter2**  
max_score >=0.9 == 1; 0.5-0.9 == 0.5; <0.5 == 0  
**geNomad**  
score >=0.8 == 1; 0.7-0.8 == 0.5; <0.7 == 0    
**DeepVirFinder**  
p-value<0.05 && score >= 0.9 == 1 ; 0.7-0.9 == 0.5 ; <0.7 == 0  
**VIBRANT**  
all == 1
  
*Filter*  
sum( All_Four_Score ) >=1 ==> vContigs

### R merge
```R
setwd("C:/Users/wudn2/OneDrive/桌面/2402")
dvf <- read.csv(file="dvf.csv",header=T)
vs2 <- read.csv(file="vs2.csv",header=T)
gnmd <- read.csv(file="gnmd.csv",header=T)
vbrt <- read.csv(file="vbrt.csv",header=T)

merge1 <- merge(vs2,vbrt,by.x="raw.id",by.y="raw.id",all.x=T,all.y=T)
merge2 <- merge(merge1,gnmd,by.x="raw.id",by.y="raw.id",all.x=T,all.y=T)
merge3 <- merge(merge2,dvf,by.x="raw.id",by.y="raw.id",all.x=T,all.y=T)

write.table(merge3,file="mergeall.txt",sep="\t",quote=F,col.names = T,row.names = F)
```
### CheckV
```bash
#### seqkit ####
#SBATCH
source activate /data01nfs/user/liupf/miniconda3/envs/seqkit
seqkit grep -f score>1_id.txt all_in_one_rename.fa -o outputfile

#### checkv ####
#!/bin/bash
#SBATCH -J checkv
#SBATCH -p cn-long
#SBATCH -N 1
#SBATCH -c 60
#SBATCH -o /datanode03/songq/log/checkv.out
#SBATCH -e /datanode03/songq/log/checkv.err
#SBATCH --no-requeue
#SBATCH -A cnl
#SBATCH --mail-type=FAIL,END,BEGIN
#SBATCH --mail-user=your-email-address
source /datanode03/huangxy/programs/anaconda3/bin/activate
conda activate checkm

checkv end_to_end input output -t 30 -d /data01nfs/user/huangxy/database/checkv-db-v1.5

conda deactivate
```
### reCheckV
```Shell
#!/bin/bash
#SBATCH -J checkv
#SBATCH -p cn-long
#SBATCH -N 1
#SBATCH -c 60
#SBATCH -o /data01nfs/user/songq/log/checkv.out
#SBATCH -e /data01nfs/user/songq/log/checkv.err
#SBATCH --no-requeue
#SBATCH -A cnl
cd /datanode03/songq/recheckv_in
cat /datanode03/songq/checkv_out/proviruses.fna /datanode03/songq/checkv_out/viruses.fna > virus_tmp.fasta
sed -i -e 's/ .*$//g' virus_tmp.fasta
sed -i -e 's/_1$//g' virus_tmp.fasta 


source /data01nfs/user/huangxy/programs/anaconda3/bin/activate
conda activate /data01nfs/user/huangxy/programs/anaconda3/envs/checkm

checkv end_to_end virus_tmp.fasta /datanode03/songq/recheckv_out -t 30 -d /data01nfs/user/huangxy/database/checkv-db-v1.5

conda deactivate
```
---
### Filter  
reCheckV virus_gene >= 1

### vOTU Clustering
Rapid genome clustering based on pairwise ANI

First, create a blast+ database:  
```Shell
cat *.fa > blastdb.fa

source /data01nfs/apps/anaconda3/bin/activate
conda activate blast-2.5
makeblastdb -in blastdb.fa -dbtype nucl -out blastdb_0306/blastdb
conda activate
```

Next, use megablast from blast+ package to perform all-vs-all blastn of sequences:  
```Shell
blastn -query blastdb.fa -db blastdb_0306/blastdb -outfmt '6 std qlen slen' -max_target_seqs 10000 -out <my_blast.tsv> -num_threads 32
```

Next, calculate pairwise ANI by combining local alignments between sequence pairs:  
```Shell
python3 anicalc.py -i <my_blast.tsv> -o <my_ani.tsv>
```

Finally, perform UCLUST-like clustering using the MIUVIG recommended-parameters (95% ANI + 85% AF):  
```Shell
python3 aniclust.py --fna blastdb.fa --ani <my_ani.tsv> --out <my_clusters.tsv> --min_ani 95 --min_tcov 85 --min_qcov 0
```
### 得到 vOTU FASTA:去冗余后的病毒序列文件
```Shell
source activate /datanode03/zhangxf/programs/mambaforge/envs/seqkit
awk '{print $1}' my_clusters.tsv > my_cluster.list
seqkit grep -n -f my_cluster.list blastdb.fa -o vOTU.fa
conda deactivate
```
### ViralreCall 巨病毒注释
```shell
source /data01nfs/user/huangxy/programs/anaconda3/bin/activate
conda activate vibrant
cd /data01nfs/user/liupf/software_lpf/viralrecall
# 必须在这个目录下提交任务
mkdir input_folder viralrecall-out 
cp dir/input.fa songq
nohup python ./viralrecall.py -i input_folder -p viralrecall-out -t 6 -b &

##退出登录前可以通过jobs查看
#但是退出后，可以通过top -u liupf查看，退出该命令control + C 退出top页面
#输出主要看：.summary.tsv和.full_annot.tsv
#.full_annot.tsv主要看vog和pfam这两列，vog是一个专门的病毒数据库，这一列会给出病毒蛋白编号，pfam是解释这是什么蛋白
#.summary.tsv主要看marker基因，根据阈值是0.9 or 0.95来判断是巨病毒，也能通过巨病毒的marker基因来判断
```

### 分类注释
```shell
### vContact2 ###
source /datanode03/zhangxf/programs/mambaforge/bin/activate
conda activate vContact2
/datanode03/zhangxf/programs/mambaforge/envs/vContact2/MAVERICLab-vcontact2-aaa065683c99/bin/vcontact2_gene2genome -p vOTU.faa -o /datanode03/songq/vOTU-vcontact2.csv -s Prodigal-FAA

/datanode03/zhangxf/programs/mambaforge/envs/vContact2/MAVERICLab-vcontact2-aaa065683c99/bin/vcontact2 --raw-proteins vOTU.faa --rel-mode Diamond --proteins-fp vOTU-vcontact2.csv --db 'ProkaryoticViralRefSeq201-Merged' --pcs-mode MCL --vcs-mode ClusterONE --c1-bin /datanode03/zhangxf/programs/mambaforge/envs/vContact2/MAVERICLab-vcontact2-aaa065683c99/bin/cluster_one-1.0.jar --output-dir /datanode03/songq/vc2  -t 36

### PhaGCN 2.0 ###
export MKL_SERVICE_FORCE_INTEL=1
python run_Speed_up.py --contigs vContigs.fa --len 5000

### geNomad ###
conda activate genomad
genomad end-to-end --min-score 0.7 --cleanup <input> <output> /datanode03/huangxy/database/genomad_db

### VPF-Class ###
nohup /home/dell/huangxingyu/vpf-class-x86_64-linux@dd88a543f28eb339cf0dcb89f34479c84b3a8056  --data-index /home/dell/software/vpf-tools/vpf-class-data/index.yaml  -i your_input_file -o your_out_put_dir &

#按照 vContant2 > geNomad > PhaGCN2.0 > VPF-Class 的优先级判定分类情况

```
### DRAM-V
```shell
#### Pre-DRAM
source activate /datanode03/huangxy/programs/anaconda3/envs/vs2
virsorter run --seqname-suffix-off --provirus-off  --keep-original-seq --viral-gene-enrich-off -w virsorter_prepare -i vOTU.fna --prep-for-dramv --min-length 0 --min-score 0  -j 16 all 

#### DRAM-v

conda activate /datanode03/zhangxf/anaconda3/envs/DRAM
DRAM-v.py annotate -i virsorter_prepare/for-dramv/final-viral-combined-for-dramv.fa -v /datanode03/songq/virsorter_prepare/for-dramv/viral-affi-contigs-for-dramv.tab -o /datanode03/songq/dramv/dramv_result --threads 36
DRAM-v.py annotate -i vOTU.fna -o dramv/DRAMwithoutvs --threads 36

DRAM-v.py distill -i /datanode03/songq/dramv/dramv_result/annotations.tsv -o dramv-distill
DRAM-v.py distill -i /datanode03/songq/dramv/DRAMwithoutvs/annotations.tsv -o votu-distill
```

### iPhop 宿主预测
```shell

source activate /data01nfs/apps/anaconda3/envs/iphop-1.3.1
iphop predict --fa_file vOTU.fna --db_dir iphop_db/Aug_2023_pub_rw --out_dir iphop_out

# 注意数据库版本号和软件版本号对应
# 很慢，可以切割序列文件并行运行
# 可以自定义数据库
```


