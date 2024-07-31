```
#!/bin/bash
#SBATCH -J checkm
#SBATCH -p cn-long
#SBATCH -N 1
#SBATCH -c 50
#SBATCH -o /data01nfs/user/songq/log/checkm.out
#SBATCH -e /data01nfs/user/songq/log/checkm.err
#SBATCH --no-requeue
#SBATCH -A cnl
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=2261518989@qq.com
source /data01nfs/user/huangxy/programs/anaconda3/bin/activate
conda activate checkm
mkdir checkM
checkm coverage \
    -x fasta \
    -m 20 \
    -t 20 \
    bins \
    checkM/coverage.out \
    bam_file/611RW.contig.sorted.bam

```