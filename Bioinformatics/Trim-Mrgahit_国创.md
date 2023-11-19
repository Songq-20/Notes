## 样品信息进度统计
【腾讯文档】黄河数据汇总
https://docs.qq.com/sheet/DUnNRRkRZZ3puc01B?tab=yj6u99

---
---
# 宏病毒组
## 611PES1
231106 add by sq
### trim
``` 
#!/bin/bash
#SBATCH -J trim
#SBATCH -p cn-long
#SBATCH -N 1
#SBATCH -c 30
#SBATCH -o /data01nfs/user/songq/log/trim.out
#SBATCH -e /data01nfs/user/songq/log/trim.err
#SBATCH --no-requeue
#SBATCH -A cnl
source /data01nfs/user/songq/.bash_profile
source activate /data01nfs/user/liupf/miniconda3/envs/trimmomatic/
trimmomatic PE -threads 4 /data02nfs/Project/rawdata4/黄河污水宏病毒组/XQ-20230912-00010/611PES1/611PES1.R1.fq.gz /data02nfs/Project/rawdata4/黄河污水宏病毒组/XQ-20230912-00010/611PES1/611PES1.R2.fq.gz /datanode03/songq/Trimmed_out/611PES1/611PES1.R1_trimmed.fq.gz /datanode03/songq/Trimmed_out/611PES1/611PES1.R1_trimmed_U.fq.gz /datanode03/songq/Trimmed_out/611PES1/611PES1.R2_trimmed.fq.gz /datanode03/songq/Trimmed_out/611PES1/611PES1.R2_trimmed_U.fq.gz ILLUMINACLIP:/data01nfs/user/liupf/common_files/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
```
### assemble
``` 
#!/bin/bash
#SBATCH -J megahit
#SBATCH -p cn-long
#SBATCH -N 1
#SBATCH -c 60
#SBATCH -o /data01nfs/user/songq/log/megahit.out
#SBATCH -e /data01nfs/user/songq/log/megahit.err
#SBATCH --no-requeue
#SBATCH -A cnl
source /data01nfs/user/liupf/miniconda3/bin/activate
conda activate megahit
megahit -1 /datanode03/songq/Trimmed_out/611PES1/611PES1.R1_trimmed.fq.gz -2 /datanode03/songq/Trimmed_out/611PES1/611PES1.R2_trimmed.fq.gz -t 60 --out-prefix 611PES1_megahit --out-dir /datanode03/songq/Megahit_out/611PES1 &> /datanode03/songq/Megahit_out/megahit_log/611PES1_megahit.log
```
---
## 611PES2
### trim_assemble
```
#!/bin/bash
#SBATCH -J trim_megahit
#SBATCH -p cn-long
#SBATCH -N 1
#SBATCH -c 60
#SBATCH -o /data01nfs/user/qinfsh/log/trim_megahit.out
#SBATCH -e /data01nfs/user/qinfsh/log/trim_megahit.err
#SBATCH --no-requeue
#SBATCH -A cnl
source /data01nfs/user/qinfsh/.bash_profile
source activate /data01nfs/user/liupf/miniconda3/envs/trimmomatic/
trimmomatic PE -threads 4 /data02nfs/Project/rawdata4/黄河污水宏病毒组/XQ-20230912-00010/611PES2/611PES2.R1.fq.gz /data02nfs/Project/rawdata4/黄河污水宏病毒组/XQ-20230912-00010/611PES2/611PES2.R2.fq.gz /datanode03/songq/Trimmed_out/611PES2/611PES2.R1_trimmed.fq.gz /datanode03/songq/Trimmed_out/611PES2/611PES2.R1_trimmed_U.fq.gz /datanode03/songq/Trimmed_out/611PES2/611PES2.R2_trimmed.fq.gz /datanode03/songq/Trimmed_out/611PES2/611PES2.R2_trimmed_U.fq.gz ILLUMINACLIP:/data01nfs/user/liupf/common_files/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 
conda deactivate
source /data01nfs/user/liupf/miniconda3/bin/activate
conda activate megahit
megahit -1 /datanode03/songq/Trimmed_out/611PES2/611PES2.R1_trimmed.fq.gz -2 /datanode03/songq/Trimmed_out/611PES2/611PES2.R2_trimmed.fq.gz -t 60 --out-prefix 611PES2_megahit --out-dir /datanode03/songq/Megahit_out/611PES2 &> /datanode03/songq/Megahit_out/megahit_log/611PES2_megahit.log
```
---
## 714PES4
### trim_assemble
```
#!/bin/bash
#SBATCH -J trim_megahit
#SBATCH -p cn-long
#SBATCH -N 1
#SBATCH -c 60
#SBATCH -o /data01nfs/user/songq/log/trim_megahit.out
#SBATCH -e /data01nfs/user/songq/log/trim_megahit.err
#SBATCH --no-requeue
#SBATCH -A cnl
export PATH=$PATH:/data01nfs/user/liupf/miniconda3/bin
source /data01nfs/user/songq/.bash_profile
source activate /data01nfs/user/liupf/miniconda3/envs/trimmomatic/
trimmomatic PE -threads 4 /data02nfs/Project/rawdata4/黄河污水宏病毒组/XQ-20230912-00010/714PES4/714PES4.R1.fq.gz /data02nfs/Project/rawdata4/黄河污水宏病毒组/XQ-20230912-00010/714PES4/714PES4.R2.fq.gz /datanode03/songq/Trimmed_out/714PES4/714PES4.R1_trimmed.fq.gz /datanode03/songq/Trimmed_out/714PES4/714PES4.R1_trimmed_U.fq.gz /datanode03/songq/Trimmed_out/714PES4/714PES4.R2_trimmed.fq.gz /datanode03/songq/Trimmed_out/714PES4/714PES4.R2_trimmed_U.fq.gz ILLUMINACLIP:/data01nfs/user/liupf/common_files/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
conda deactivate
source /data01nfs/user/liupf/miniconda3/bin/activate
conda activate megahit
megahit -1 /datanode03/songq/Trimmed_out/714PES4/714PES4.R1_trimmed.fq.gz -2 /datanode03/songq/Trimmed_out/714PES4/714PES4.R2_trimmed.fq.gz -t 60 --out-prefix 714PES4_megahit --out-dir /datanode03/songq/Megahit_out/714PES4 &> /datanode03/songq/Megahit_out/megahit_log/714PES4_megahit.log
```
---
## 715PES5
### trim
```
#!/bin/bash
#SBATCH -J trim
#SBATCH -p cn-long
#SBATCH -N 1
#SBATCH -c 60
#SBATCH -o /data01nfs/user/songq/log/trim.out
#SBATCH -e /data01nfs/user/songq/log/trim.err
#SBATCH --no-requeue
#SBATCH -A cnl
export PATH=$PATH:/data01nfs/user/liupf/miniconda3/bin
source /data01nfs/user/songq/.bash_profile
source activate /data01nfs/user/liupf/miniconda3/envs/trimmomatic/
trimmomatic PE -threads 4 /data02nfs/Project/rawdata4/黄河污水宏病毒组/XQ-20230912-00011/715PES5/715PES5.R1.fq.gz /data02nfs/Project/rawdata4/黄河污水宏病毒组/XQ-20230912-00011/715PES5/715PES5.R2.fq.gz /datanode03/songq/Trimmed_out/715PES5/715PES5.R1_trimmed.fq.gz /datanode03/songq/Trimmed_out/715PES5/715PES5.R1_trimmed_U.fq.gz /datanode03/songq/Trimmed_out/715PES5/715PES5.R2_trimmed.fq.gz /datanode03/songq/Trimmed_out/715PES5/715PES5.R2_trimmed_U.fq.gz ILLUMINACLIP:/data01nfs/user/liupf/common_files/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
```
### assemble
```
#!/bin/bash
#SBATCH -J megahit
#SBATCH -p cn-long
#SBATCH -N 1
#SBATCH -c 60
#SBATCH -o /data01nfs/user/songq/log/megahit.out
#SBATCH -e /data01nfs/user/songq/log/megahit.err
#SBATCH --no-requeue
#SBATCH -A cnl

source /data01nfs/user/liupf/miniconda3/bin/activate
conda activate megahit
megahit -1 /datanode03/songq/Trimmed_out/715PES5/715PES5.R1_trimmed.fq.gz -2 /datanode03/songq/Trimmed_out/715PES5/715PES5.R2_trimmed.fq.gz -t 60 --out-prefix 715PES5_megahit --out-dir /datanode03/songq/Megahit_out/715PES5 &> /datanode03/songq/Megahit_out/megahit_log/715PES5_megahit.log
```
---
## 715PES6
### trim
```
#!/bin/bash
#SBATCH -J trim
#SBATCH -p cn-long
#SBATCH -N 1
#SBATCH -c 60
#SBATCH -o /data01nfs/user/songq/log/trim.out
#SBATCH -e /data01nfs/user/songq/log/trim.err
#SBATCH --no-requeue
#SBATCH -A cnl
export PATH=$PATH:/data01nfs/user/liupf/miniconda3/bin
source /data01nfs/user/songq/.bash_profile
source activate /data01nfs/user/liupf/miniconda3/envs/trimmomatic/
trimmomatic PE -threads 4 /data02nfs/Project/rawdata4/黄河污水宏病毒组/XQ-20230912-00011/715PES6/715PES6.R1.fq.gz /data02nfs/Project/rawdata4/黄河污水宏病毒组/XQ-20230912-00011/715PES6/715PES6.R2.fq.gz /datanode03/songq/Trimmed_out/715PES6/715PES6.R1_trimmed.fq.gz /datanode03/songq/Trimmed_out/715PES6/715PES6.R1_trimmed_U.fq.gz /datanode03/songq/Trimmed_out/715PES6/715PES6.R2_trimmed.fq.gz /datanode03/songq/Trimmed_out/715PES6/715PES6.R2_trimmed_U.fq.gz ILLUMINACLIP:/data01nfs/user/liupf/common_files/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
```
### assemble
```
#!/bin/bash
#SBATCH -J megahit
#SBATCH -p cn-long
#SBATCH -N 1
#SBATCH -c 60
#SBATCH -o /data01nfs/user/songq/log/megahit.out
#SBATCH -e /data01nfs/user/songq/log/megahit.err
#SBATCH --no-requeue
#SBATCH -A cnl
source /data01nfs/user/liupf/miniconda3/bin/activate
conda activate megahit
megahit -1 /datanode03/songq/Trimmed_out/715PES6/715PES6.R1_trimmed.fq.gz -2 /datanode03/songq/Trimmed_out/715PES6/715PES6.R2_trimmed.fq.gz -t 60 --out-prefix 715PES6_megahit --out-dir /datanode03/songq/Megahit_out/715PES6 &> /datanode03/songq/Megahit_out/megahit_log/715PES6_megahit.log
```
---
---
# 宏转录组
## 611PC31
### trim
```
#!/bin/bash
#SBATCH -J trim
#SBATCH -p cn-long
#SBATCH -N 1
#SBATCH -c 60
#SBATCH -o /data01nfs/user/songq/log/trim.out
#SBATCH -e /data01nfs/user/songq/log/trim.err
#SBATCH --no-requeue
#SBATCH -A cnl
export PATH=$PATH:/data01nfs/user/liupf/miniconda3/bin
source /data01nfs/user/songq/.bash_profile
source activate /data01nfs/user/liupf/miniconda3/envs/trimmomatic/
trimmomatic PE -threads 4 /data02nfs/Project/rawdata4/黄河污水宏转录组/XQ-20230821-00038/611PC31/611PC31.R1.fq.gz /data02nfs/Project/rawdata4/黄河污水宏转录组/XQ-20230821-00038/611PC31/611PC31.R2.fq.gz /datanode03/songq/Trimmed_out/611PC31/611PC31.R1_trimmed.fq.gz /datanode03/songq/Trimmed_out/611PC31/611PC31.R1_trimmed_U.fq.gz /datanode03/songq/Trimmed_out/611PC31/611PC31.R2_trimmed.fq.gz /datanode03/songq/Trimmed_out/611PC31/611PC31.R2_trimmed_U.fq.gz ILLUMINACLIP:/data01nfs/user/liupf/common_files/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
```
### sortmeRNA
```
#!/bin/bash
#SBATCH -J sortmerna
#SBATCH -p cn-long
#SBATCH -N 1
#SBATCH -c 60
#SBATCH -o /data01nfs/user/songq/log/sortmerna.out
#SBATCH -e /data01nfs/user/songq/log/sortmerna.err
#SBATCH --no-requeue
#SBATCH -A cnl
export PATH=$PATH:/data01nfs/user/liupf/miniconda3/bin
source /data01nfs/user/songq/.bash_profile
source activate /data01nfs/user/liupf/miniconda3/envs/sortmeRNA
sortmerna --ref /data01nfs/user/liupf/software_lpf/sortmeRNA_db/rfam-5.8s-database-id98.fasta --ref /data01nfs/user/liupf/software_lpf/sortmeRNA_db/rfam-5s-database-id98.fasta --ref /data01nfs/user/liupf/software_lpf/sortmeRNA_db/silva-arc-16s-id95.fasta --ref /data01nfs/user/liupf/software_lpf/sortmeRNA_db/silva-arc-23s-id98.fasta --ref /data01nfs/user/liupf/software_lpf/sortmeRNA_db/silva-bac-16s-id90.fasta --ref /data01nfs/user/liupf/software_lpf/sortmeRNA_db/silva-bac-23s-id98.fasta --ref /data01nfs/user/liupf/software_lpf/sortmeRNA_db/silva-euk-18s-id95.fasta --ref /data01nfs/user/liupf/software_lpf/sortmeRNA_db/silva-euk-28s-id98.fasta --fastx -a 15 -v --log --reads /datanode03/songq/Trimmed_out/611PC31/611PC31.R1_trimmed.fq.gz --reads /datanode03/songq/Trimmed_out/611PC31/611PC31.R2_trimmed.fq.gz --aligned /datanode03/songq/sortmeRNA_out/611PC31/611PC31.align --other /datanode03/songq/sortmeRNA_out/611PC31/611PC31.unalign --paired_in --out2 --workdir /datanode03/songq/sortmeRNA_temp/611PC31
```
### assemble
```
#!/bin/bash
#SBATCH -J megahit
#SBATCH -p cn-long
#SBATCH -N 1
#SBATCH -c 60
#SBATCH -o /data01nfs/user/songq/log/megahit.out
#SBATCH -e /data01nfs/user/songq/log/megahit.err
#SBATCH --no-requeue
#SBATCH -A cnl
source /data01nfs/user/liupf/miniconda3/bin/activate
conda activate megahit
megahit -1 /datanode03/songq/sortmeRNA_out/611PC31/611PC31.unalign_fwd.fq.gz -2 /datanode03/songq/sortmeRNA_out/611PC31/611PC31.unalign_rev.fq.gz -t 60 --out-prefix 611PC31_megahit --out-dir /datanode03/songq/Megahit_out/611PC31 &> /datanode03/songq/Megahit_out/megahit_log/611PC31_megahit.log
```
