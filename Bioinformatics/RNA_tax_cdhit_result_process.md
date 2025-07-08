## 运行要求
1. 数据库序列文件的序列id前加上数据库名称，如`RVMT_ND_522014_1`
2. 数据库分类文件对应id列也加上对应数据库名称
3. 数据库分类文件对齐，竖向合并在一起，保留必须列。
## 处理原始输出 "name.clstr"
```shell
python /datanode03/songq/script/process_cdhit.py your_file.clstr > your_file_fix.tsv

#删掉 >Cluster0 之类的标题
#删掉 序号、长度、星号、百分比、...
#对于 Luca 序列，比对“ORF”前的字符串（”Luca_Supergroup006--NEW-hepe-virga_microbial_mat“），去重
```
## 处理 Luca 序列
```shell
./datanode03/songq/script/process_luca.sh your_file_fix.tsv > your_file_fix_uniq_luca.tsv

#处理 Luca 序列，比对 ”Luca_Supergroup006“部分，去重
```
## 分类整合
```shell
awk '
# 读取第二个文件的A列到字典
NR == FNR { 
    key = $1;   # 假设A列是第一列
    dict[key] = $0;  # 存储整行
    next
} 
# 处理第一个文件（单列表格）
{
    if ($0 == "") {  # 保留空行
        print "";
        next;
    }
    # 查找匹配
    if ($1 in dict) {
        print dict[$1];
    } else {
        print $1;  # 不匹配时只输出原内容
    }
}
' tax_db.tsv your_file_fix_uniq_luca.tsv  > tax_result.tsv

#将分类合并到序列上
```
## 分类赋值给自己的序列
```shell
python cdhit-classifier_1.1.py tax_result.tsv

#加表头 ID	Phylum	Class	Order	Family	Genus	Source
#对于每个簇，把出现次数最多的Family的完整序列和Source赋值给自己的序列。
#会生成两个文件，一个保存有分类结果，一个存有未被分类的序列
```
>Note：上述脚本依赖关键词检索，如”RVMT TO Luca PC3“，可以个性化替换为自己的关键词。
