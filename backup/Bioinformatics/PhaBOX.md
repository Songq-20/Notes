# PhaBOX
> https://github.com/KennthShang/PhaBOX  
结合了噬菌体识别、分类、生活史预测、宿主预测在内的四个插件，四种功能。提供一步式运行方法

## Usage
### One Step
```shell
conda activate /datanode03/wenr/miniforge3/envs/phabox

python /datanode03/wenr/PhaBOX/main.py --contigs tinput.fa --threads 20 --len 5000 --rootpth root_output_dir --out out/ --dbdir /datanode03/wenr/PhaBOX/database --parampth /datanode03/wenr/PhaBOX/parameters/ --scriptpth /datanode03/wenr/PhaBOX/scripts/
```
`--rootpth`：总的输出文件夹，所有的输出文件都在这里。  
`--out`：我们需要阅读的输出。默认在`--rootpth`下。  
`--contigs`：输入的文件序列id需要以字母开头。

### Sub script
> 以 `PhaMer_single.py`为例
```
python /datanode03/wenr/PhaBOX/PhaMer_single.py --contigs tinput.fa --threads 20 --len 5000 --rootpth root_output_dir --out out/ --dbdir /datanode03/wenr/PhaBOX/database --parampth /datanode03/wenr/PhaBOX/parameters/ --scriptpth /datanode03/wenr/PhaBOX/scripts/
```
子命令包括：  
* phamer_prediction.csv：噬菌体识别结果
* phagcn_prediction.csv：分类结果
* cherry_prediction.csv：宿主预测结果
* phatyp_prediction.csv：生活方式预测结果
