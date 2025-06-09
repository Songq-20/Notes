#SBATCH
source /datanode02/yut/Software/Miniconda3/bin/activate
dRep dereplicate out_dir -sa 0.95 -p 30 -comp 50 -con 10  -g bins_dir/*.fa --genomeInfo checkm_out.csv

# -sa 0.95 / 0.97
# checkm_out.csv 要处理，第一行为 `genome,completeness,contamination` , 全小写。第一列bins name后面跟文件后缀.fa
