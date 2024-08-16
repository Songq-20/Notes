```
第一步：
source /data01nfs/apps/anaconda3/bin/activate
source activate /datanode03/huangxy/programs/anaconda3/envs/gtdbtk/
export GTDBTK_DATA_PATH=/data01nfs/user/huangxy/database/gtdbtk-2.1.0/db

第二步：
gtdbtk de_novo_wf --genome_dir /datanode03/wenr/database/Metagenome/drep10/nondereplicated_genomes_clean/ --bacteria --outgroup_taxon p__Patescibacteria --out_dir /datanode03/wenr/database/Metagenome/drep10/DD_MAGs_GTDB-tk_results --cpus 6 --force --extension fasta

第三步：
gtdbtk de_novo_wf --genome_dir /datanode03/wenr/database/Metagenome/drep10/nondereplicated_genomes_clean/ --archaea --outgroup_taxon p__Altiarchaeota --out_dir /datanode03/wenr/database/Metagenome/drep10/DD_MAGs_GTDB-tk_results --cpus 6 --force --extension fasta

第四步：
source /data01nfs/apps/anaconda3/bin/activate
source activate /datanode03/zhangxf/programs/mambaforge/envs/iphop_env

第五步：
iphop add_to_db --fna_dir /datanode03/wenr/database/Metagenome/drep10/nondereplicated_genomes_clean/ --gtdb_dir /datanode03/wenr/database/Metagenome/drep10/DD_MAGs_GTDB-tk_results --out_dir /datanode03/wenr/database/Metagenome/drep10/Iphop_db530 --db_dir /datanode03/zhangxf/iphop_db/Aug_2023_pub_rw/Aug_2023_pub_rw --num_threads 6

第六步：
iphop predict --f /datanode03/wenr/database/Metagenome/drep10/8penguin_10megahit_clusters_2637.fasta --db_dir /datanode03/wenr/database/Metagenome/drep10/Iphop_db530 --out_dir /datanode03/wenr/database/Metagenome/drep10/iphop_DD_results530/ --num_threads 6
```+