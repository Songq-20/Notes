
#!/bin/bash
#SBATCH -J matabat2
#SBATCH -p cn-long
#SBATCH -N 1
#SBATCH -c 60
#SBATCH -o /data01nfs/user/qinfsh/songq/log/metabat2.out
#SBATCH -e /data01nfs/user/qinfsh/songq/log/matabat2.err
#SBATCH --no-requeue
#SBATCH -A cnl
#SBATCH --mail-type=FAIL,END,BEGIN
#SBATCH --mail-user=2261518989@qq.com
source /data01nfs/user/liupf/miniconda3/bin/activate
conda activate metabat2
metabat2 -m 1500 -t 15 -i /datanode03/songq/5k_contigs/611RW_MV_MGHT_5K.fa -a songq/metabat2/611RW_depth.txt -o songq/metabat2/611RW.metabat2 

