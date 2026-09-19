# 在学校集群运行 AlphaFold3
> 详细说明网站：  
> [bkunyun](https://www.bkunyun.com/helpce/docs/2029/AlphaFold3/)  
> [GitHub](https://github.com/google-deepmind/alphafold/tree/main)  

### 命令行
```shell
cd /data/groups/lzu_public/home/liupf/af3_demo
export AF_BASE=/data/groups/lzu_public/home/liupf/af3_demo
export XLA_FLAGS="--xla_gpu_enable_triton_gemm=false"
/opt/app/singularity/3.11.5/bin/singularity exec \
--nv \
--bind $AF_BASE:/root/af3_demo \
--bind $AF_BASE/af_input:/root/af_input \
--bind /opt/app/nvidia/550.54.14:/usr/local/nvidia \
--bind $AF_BASE/af_output:/root/af_output \
--bind /opt/app/alphafold3/models:/root/models \
--bind /opt/app/alphafold3/public_databases:/root/public_databases \
/opt/app/sif/alphafold3.sif \
python /root/af3_demo/run_alphafold.py \
--json_path=/root/af_input/input.json \
--model_dir=/root/models \
--db_dir=/root/public_databases \
--output_dir=/root/af_output \
--flash_attention_implementation=xla
```

1. 将输入文件编写成 `JSON` 格式，放到 `af3_demo/af_input` 中
2. 运行上述命令
3. 输出文件在 `af3_demo/af_output`

### 输入文件

> AlphaFold3 支持 DNA 、RNA 、蛋白质序列输入

#### 示例文件
蛋白序列
```json
{
  "name": "2PV7",
  "sequences": [
    {
      "protein": {
        "id": ["A", "B"],
        "sequence": "GMRESYANENQFGFKTINSDIHKIVIVGGYGKLGGLFARYLRASGYPISILDREDWAVAESILANADVVIVSVPINLTLETIERLKPYLTENMLLADLTSVKREPLAKMLEVHTGAVLGLHPMFGADIASMAKQVVVRCDGRFPERYEWLLEQIQIWGAKIYQTNATEHDHNMTYIQALRHFSTFANGLHLSKQPINLANLLALSSPIYRLELAMIGRLFAQDAELYADIIMDKSENLAVIETLKQTYDEALTFFENNDRQGFIDAFHKVRDWFGDYSEQFLKESRQLLQQANDLKQG"
      }
    }
  ],
  "modelSeeds": [1],
  "dialect": "alphafold3",
  "version": 1
}
```
RNA序列
```json

{
  "name": "rnatest",
  "sequences": [
    {
      "rna": {
        "id": "A",
        "sequence": "ACCTTCTTT"
      }
    }
  ],
  "modelSeeds": [1],
  "dialect": "alphafold3",
  "version": 1
}
```
DNA序列
```json
{
  "name": "dnatest",
  "sequences": [
    {
      "dna": {
        "id": "A",
        "sequence": "ACCUUCUUU"
      }
    }
  ],
  "modelSeeds": [1],
  "dialect": "alphafold3",
  "version": 1
}
```
> ***注意*** 单个序列长度最大为5120bp  

**modelSeeds**  
示例值： [1, 2]  
含义： 指定随机种子，以便模型生成多个预测结果。  
用途： 提供多个随机种子值时，模型将基于这些种子生成多个可能的结构，以增加结果的可靠性或多样性。

**dialect**  
示例值： "alphafold3"  
含义： 指定输入文件的格式或方言。  
用途： 确保模型理解并正确解析输入文件。在这个例子中，使用了alphafold3格式。

**version**  
示例值：1  
含义：表示输入文件的版本号，可以是1或2，1 是初始 AlphaFold 3 输入格式，2 是通过 unpairedMsaPath 字段 和 pairedMsaPath 字段自定义指定外部的 MSA 文件，还有mmcifPath 字段来指定外部自定义模板文件路径。


