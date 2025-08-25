> **Trim reads before running Kraken2**

## Kraken2 Tax
```shell
#!/bin/bash
#SBATCH -J k2
#SBATCH -p cn-long2
#SBATCH -N 1
#SBATCH -c 30
#SBATCH -o /datanode03/songq/log/k2.out
#SBATCH -e /datanode03/songq/log/k2.err
#SBATCH --no-requeue
#SBATCH -A cnl2
#SBATCH --mail-type=FAIL,END,BEGIN
#SBATCH --mail-user=2261518989@qq.com

source /datanode02/zhangzh/.apps/kraken2.sh
DBDIR="/datanode02/zhangzh/database/kraken2_database"
DIR="/datanode03/songq/songq_datanode03/Trimmed_out/"
while read id
do
kraken2 --db $DBDIR --paired  ${DIR}${id}*R1*trimmed.fq.gz ${DIR}${id}*R1*trimmed.fq.gz --report ${id}.report  --report-minimizer-data --output ${id}.out
done < MGid.txt
```
## Get Proka_seq
```shell
##get proka_seq id
while read id 
do
awk '$3+0 != 0 {print $3+0}' ${id}.out | sort -nu > ${id}.taxid
taxonkit lineage ${id}.taxid > ${id}.taxo
awk '$3 ~ /Eukaryota/ {print $1}' ${id}.taxo > ${id}.Eukid
awk 'NR==FNR{a[$1];next}$3 in a{print $2}'  ${id}.Eukid ${id}.out > ${id}.Eukseq
awk 'NR==FNR{a[$1];next}!($3 in a){print $2}'  ${id}.Eukid ${id}.out  > ${id}.prokaseq
done < metaGid.txt.u
##seqkit get proka_seq
conda activate seqkit 
while read id
do
seqkit grep -f ${id}.prokaseq ../Trimmed_out/${id}*R1*trimmed.fq.gz -o ${id}.R1_proka_1.fq.gz
seqkit grep -f ${id}.prokaseq ../Trimmed_out/${id}*R2*trimmed.fq.gz -o ${id}.R2_proka_@.fq.gz
done < metaGid.txt.u
```
## Braken 
... To do ...

## ARGs_OAP
> Custom Database
```
#!/bin/bash
#SBATCH -J vfdb-test
#SBATCH -p cn-long2
#SBATCH -N 1
#SBATCH -c 10
#SBATCH -o /datanode03/liupf/logs/vfdb-test.out
#SBATCH -e /datanode03/liupf/logs/vfdb-test.err
#SBATCH --no-requeue
#SBATCH -A cnl2
#SBATCH --mail-type=FAIL,END,BEGIN
#SBATCH --mail-user=2261518989@qq.com
source /datanode02/wuzz/miniconda3/bin/activate 
conda activate args_oap

args_oap stage_one -i input_dir -o output_dir -t 10 --database /datanode03/songq/database/VFDB/vfdb/VFDB_setB_nt.fas1;
args_oap stage_two -i output_dir -t 10 --database /datanode03/songq/database/VFDB/vfdb/VFDB_setB_nt.fas1 --structure1 /datanode03/songq/database/VFDB/VFDB_structure.txt

### 注意：将 “AAA_” 改为“=-”
```

