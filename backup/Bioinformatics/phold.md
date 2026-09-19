# Phold
> https://github.com/gbouras13/phold
## Installation
> without GPU
```shell
mamba create -n pholdENV -c conda-forge -c bioconda phold 
```

### Test file
```shell
wget https://raw.githubusercontent.com/gbouras13/phold/main/tests/test_data/NC_043029.gbk

wget https://raw.githubusercontent.com/gbouras13/phold/main/tests/test_data/NC_043029_phold_output.gbk

# output.gbk for plot
```
## Usage

### fasta -> gbk
```shell
source /datanode03/wenr/miniforge3/bin/activate
conda activate pharokkaENV
pharokka.py -i file.fasta -d /datanode03/wenr/pharokka_db -o output_dir -t 8 --fast
conda deactivate

### gbk file in output_file
```
### Quick Start
```shell
phold run -i file.gbk  -o output_dir -t 20 --cpu
```
### 2 Steps run
```shell
# Step 1 

phold predict -i tests/test_data/NC_043029.gbk -o test_predictions 

## May be faster if GPU is available

# Step 2 

phold compare -i tests/test_data/NC_043029.gbk --predictions_dir test_predictions -o test_output_phold -t 8 
```
## Output
The primary outputs are:  
* `phold_3di.fasta` containing the 3Di sequences for each CDS
* `phold_per_cds_predictions.tsv` containing detailed annotation information on every CDS
* `phold_all_cds_functions.tsv` containing counts per contig of CDS in each PHROGs category, VFDB, CARD, ACRDB and Defensefinder databases (similar to the pharokka_cds_functions.tsv from Pharokka)
* `phold.gbk`, which contains a GenBank format file including these annotations, and keeps any other genomic features (tRNA, CRISPR repeats, tmRNAs) included from the pharokka Genbank input file if provided

## Plotting
`phold plot` will allow you to create Circos plots with `pyCirclize` for all your phage(s). For example:
```shell
phold plot -i tests/test_data/NC_043029_phold_output.gbk  -o NC_043029_phold_plots -t '${Stenotrophomonas}$ Phage SMA6'  

### -t == Title of figure
```
