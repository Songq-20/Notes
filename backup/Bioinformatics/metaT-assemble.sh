#!/bin/bash  
  
# 定义帮助函数  
function show_help {  
    echo "Usage: $0 [-h] -prefix <sample_prefix> -R1_PATH <R1_sequence_path> [-R2_PATH <R2_sequence_path>] -o <output_directory>"  
    echo "Options:"  
    echo "  -h            Show this help message"  
    echo "  -prefix       Prefix for the sample name"  
    echo "  -R1_PATH      Path to the read 1 (forward) fastq file"  
    echo "  -R2_PATH      Path to the read 2 (reverse) fastq file (optional)"  
    echo "  -o            Path to the directory where output files will be written"  
    exit 0  
}  
  
# 初始化变量  
SAMPLE_PREFIX=""  
R1_PATH=""  
R2_PATH=""  
OUTPUT_DIR=""  
  
# 检查参数  
while [[ $# -gt 0 ]]; do  
    case "$1" in  
        -h|--help)  
            show_help  
            exit 0  
            ;;  
        -prefix)  
            shift  
            if [[ -z "$1" ]]; then  
                echo "Error: Missing sample prefix after -prefix."  
                show_help  
                exit 1  
            fi  
            SAMPLE_PREFIX="$1"  
            shift  
            ;;  
        -R1_PATH)  
            shift  
            if [[ -z "$1" ]]; then  
                echo "Error: Missing R1 path after -R1_PATH."  
                show_help  
                exit 1  
            fi  
            R1_PATH="$1"  
            shift  
            ;;  
        -R2_PATH)  
            shift  
            R2_PATH="$1"  
            shift  
            ;;  
        -o)  
            shift  
            if [[ -z "$1" ]]; then  
                echo "Error: Missing output directory after -o."  
                show_help  
                exit 1  
            fi  
            OUTPUT_DIR="$1"  
            shift  
            ;;  
        *)  
            echo "Error: Invalid option: $1"  
            show_help  
            exit 1  
            ;;  
    esac  
done  
  
# 验证必须的参数是否已设置  
if [[ -z "$SAMPLE_PREFIX" || -z "$R1_PATH" ||-z "$R2_PATH" || -z "$OUTPUT_DIR" ]]; then  
    echo "Error: Missing required options."  
    show_help  
    exit 1  
fi  
  
# 检查输出目录是否存在，如果不存在则创建  
if [ ! -d "$OUTPUT_DIR" ]; then  
    mkdir -p "$OUTPUT_DIR"  
    if [ $? -ne 0 ]; then  
        echo "Error: Could not create output directory $OUTPUT_DIR"  
        exit 1  
    fi  
fi  
mkdir -p ${OUTPUT_DIR}/sortmeRNA/sortmeRNA_temp
source /data01nfs/user/liupf/miniconda3/bin/activate
conda activate trimmomatic
trimmomatic PE -threads 20 $R1_PATH $R2_PATH ${OUTPUT_DIR}/${SAMPLE_PREFIX}.R1.trimmed.fq.gz ${OUTPUT_DIR}/${SAMPLE_PREFIX}.R1.trimmed.U.fq.gz ${OUTPUT_DIR}/${SAMPLE_PREFIX}.R2.trimmed.fq.gz ${OUTPUT_DIR}/${SAMPLE_PREFIX}.R2.trimmed.U.fq.gz ILLUMINACLIP:/data01nfs/user/liupf/common_files/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 
conda deactivate
conda deactivate
source /data01nfs/user/liupf/miniconda3/bin/activate
conda activate sortmeRNA
sortmerna --ref /data01nfs/user/liupf/software_lpf/sortmeRNA_db/rfam-5.8s-database-id98.fasta --ref /data01nfs/user/liupf/software_lpf/sortmeRNA_db/rfam-5s-database-id98.fasta --ref /data01nfs/user/liupf/software_lpf/sortmeRNA_db/silva-arc-16s-id95.fasta --ref /data01nfs/user/liupf/software_lpf/sortmeRNA_db/silva-arc-23s-id98.fasta --ref /data01nfs/user/liupf/software_lpf/sortmeRNA_db/silva-bac-16s-id90.fasta --ref /data01nfs/user/liupf/software_lpf/sortmeRNA_db/silva-bac-23s-id98.fasta --ref /data01nfs/user/liupf/software_lpf/sortmeRNA_db/silva-euk-18s-id95.fasta --ref /data01nfs/user/liupf/software_lpf/sortmeRNA_db/silva-euk-28s-id98.fasta --fastx -a 15 -v --log --reads ${OUTPUT_DIR}/${SAMPLE_PREFIX}.R1.trimmed.fq.gz --reads ${OUTPUT_DIR}/${SAMPLE_PREFIX}.R2.trimmed.fq.gz --aligned ${OUTPUT_DIR}/sortmeRNA/${SAMPLE_PREFIX}.align --other ${OUTPUT_DIR}/sortmeRNA/${SAMPLE_PREFIX}.unalign --paired_in --out2 --workdir ${OUTPUT_DIR}/sortmeRNA/sortmeRNA_temp/${SAMPLE_PREFIX}
conda deactivate
conda deactivate
source /data01nfs/user/liupf/miniconda3/bin/activate
conda activate megahit
megahit -1 ${OUTPUT_DIR}/sortmeRNA/${SAMPLE_PREFIX}.unalign_fwd.fq.gz -2 ${OUTPUT_DIR}/sortmeRNA/${SAMPLE_PREFIX}.unalign_rev.fq.gz -t 20  --out-prefix $SAMPLE_PREFIX --out-dir $OUTPUT_DIR/$SAMPLE_PREFIX &> $OUTPUT_DIR/$SAMPLE_PREFIX.log
