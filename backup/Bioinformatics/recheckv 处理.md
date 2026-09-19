```Shell
cat proviruses.fna viruses.fna > virus_tmp.fasta

sed -i -e 's/ .*$//g' virus_tmp.fasta
sed -i -e 's/_1$//g' virus_tmp.fasta 

mv virus_tmp.fasta /data01nfs/user/liupf/oil_field_10kDNAvirus/recheckv_out/



#in screen
conda activate /data01nfs/user/huangxy/programs/anaconda3/envs/checkm

#in checkm

checkv end_to_end virus_tmp.fasta /data01nfs/user/liupf/oil_field_10kDNAvirus/recheckv_out/prefix_final -t 16 -d /data01nfs/user/huangxy/database/checkv_data/checkv-db-v1.4

------ /*20221031 done*/ ------

#in ../recheckv_out/prefix_final
awk '$6==0&$7>0' quality_summary.tsv | cut -f1 -d$'\t' > prefix_discarded.txt

conda activate seqkit

#in seqkit
seqkit grep -n -v -f prefix_discarded.txt  ../virus_tmp.fasta -o prefix_tirmmed.fasta
```

```Shell
blastn -query ../recheckv_out/B121_final/B121_trimmed.fasta -db 10k_blastdb -outfmt '6 std qlen slen' -max_target_seqs 10000 -out ../blast_out/B121_blast.tsv -num_threads 10
```

```Shell
source /data01nfs/user/huangxy/programs/anaconda3/bin/activate`