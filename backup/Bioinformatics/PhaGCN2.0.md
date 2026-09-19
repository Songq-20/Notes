# PhaGCN 2.0
## Installation
```
git clone https://github.com/KennthShang/PhaGCN2.0.git

cd PhaGCN2.0
mamba env create -f environment.yaml -n phagcn2

cd database
tar -zxvf ALL_protein.tar.gz
cd ..
```

## Usage

Before you use it each time, you need to run is
```
conda activate phagcn2
export MKL_SERVICE_FORCE_INTEL=1
```
Running
```
python run_Speed_up.py --contigs contigs.fa --len 8000
```
`--len`:The default length is 8000bp. The shortest length supported is 1700bp.  
## Notice

If you want to use PhaGCN, you need to take care of three things:

1. Make sure all your contigs are virus contigs. You can sperate bacteria contigs by using VirSorter or DeepVirFinder
2. The script will pass contigs with non-ACGT characters, which means those non-ACGT contigs will be remained unpredict.
3. If the program output an error (which is caused by your machine): Error: mkl-service + Intel(R) MKL: MKL_THREADING_LAYER=INTEL is incompatible with libgomp.so.1 library. You can type in the command export MKL_SERVICE_FORCE_INTEL=1 before runing run_Speed_up.py
4. If you want train your own virus classification database,Hardware requirements can be considerable(exceeding 48 GB,and at least one GPU), depending mainly on the size and complexity of the dataset. (Relationship between memory requirements and sequences analyzed forthcoming)