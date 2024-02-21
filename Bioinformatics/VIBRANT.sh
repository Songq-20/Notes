#!/bin/bash
#SBATCH -J VIBRANT
#SBATCH -p cn-long
#SBATCH -N 1
#SBATCH -c 60
#SBATCH -o /data01nfs/user/songq/log/VIBRANT.out
#SBATCH -e /data01nfs/user/songq/log/VIBRANT.err
#SBATCH --no-requeue
#SBATCH -A cnl

source /data01nfs/user/huangxy/programs/anaconda3/bin/activate
VIBRANT_run.py -i /datanode03/songq/5k_contigs/611RW_MV_MGHT_5K.fa -t 10 -folder /datanode03/songq/vibrant/611RW