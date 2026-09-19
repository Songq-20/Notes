## 筛选 >750bp

```shell
seqkit seq -m 750 -j 8 metaT.fa > metaT_750.fa
```
## 翻译蛋白
```shell
prodigal -i metaT_750.fa -a metaT.faa -p meta
```
## Lucaprot
```shell
#! /bin/bash
#SBATCH --job-name=LucaProt
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=20
#SBATCH --partition=gpu1
#SBATCH --gres=gpu:1 -n 10
#SBATCH -o log/luca.out
#SBATCH -e log/luca.err

conda activate lucaprot
cd /data/groups/lzu_public/home/liupf/LucaProt/src/
export CUDA_VISIBLE_DEVICES="0,1,2,3"
python predict_many_samples.py \
        --fasta_file path_to_metaT.faa  \
        --save_file output_path_to_.csv \
        --emb_dir emb_dir   \
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
```
LucaProt 输出有 `.csv` 文件和一些在 `emb` 文件夹内的 `.pt` 文件, `.pt`文件占用很大，不知道要不要删除。