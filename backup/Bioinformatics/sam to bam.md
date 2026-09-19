```
#!/bin/bash
#SBATCH -J samtools
#SBATCH -p cn-long
#SBATCH -N 1
#SBATCH -c 50
#SBATCH -o /data01nfs/user/songq/log/samtools.out
#SBATCH -e /data01nfs/user/songq/log/samtools.err
#SBATCH --no-requeue
#SBATCH -A cnl
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=2261518989@qq.com
source /data01nfs/user/liupf/miniconda3/bin/activate
conda activate samtools
mkdir bam_file
while read id
do
samtools view -bS --threads 20 sam_file/${id}HH_vOTU.sam > bam_file/${id}.contig.bam
samtools sort bam_file/${id}.contig.bam -o bam_file/${id}.contig.sorted.bam --threads 20
samtools index bam_file/${id}.contig.sorted.bam
done<id.list
```
