# 处理 hmmsearch 的输出  
>  包括去掉 #注释行，去掉 seq_id 数字后缀，相同序列筛选得分最高者，筛选E-Value<=0.00001

```shell
for file in hmmsearch
do
  #移除注释行
  grep -v '^#' "$file" > "${file%.*}_fix.txt"

  #添加第一列目标名称，使用制表符分隔
  awk -F ' ' '{print $1 "\t" $0}' "${file%.*}_fix.txt" > "${file%.*}_fix2.txt"

  #规范化：移除目标名称中的下划线和数字
  sed -i -e 's/\(.*\)_[0-9]*\t/\1\t/g' "${file%.*}_fix2.txt"

  #规范化：将所有多余空格转换为单个制表符
  sed -i -e 's/ \+/ /g' "${file%.*}_fix2.txt"
  sed -i -e 's/ /\t/g' "${file%.*}_fix2.txt"

  #获取每个目标名称的最高分数记录
  awk '!seen[$1]++' "${file%.*}_fix2.txt" > "${file%.*}_top.txt"

  #重新筛选 e value <= 10-5（软件会有漏网之鱼）
  awk -F'\t' '$6 <= 0.00001' hydro.hmm_top.txt > hydro.hmm_top2.txt
  #删除临时文件
  rm "${file%.*}_fix.txt" "${file%.*}_fix2.txt"
done
```