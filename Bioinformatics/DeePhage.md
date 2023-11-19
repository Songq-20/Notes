## **Describe**

A tool for identifying temperate phage-derived and virulent phage-derived sequence in metavirome data using deep learning.

> 根据噬菌体和宿主菌的关系，可将噬菌体分为两类：一类噬菌体在宿主菌细胞内迅速增殖，产生许多子代噬菌体，并最终使宿主菌细胞破裂，这类噬菌体被称为烈性噬菌体（ virulent phage）；另一类噬菌体感染宿主菌后不立即增殖，而是将其核酸整合（Integration）到宿主菌染色体中，随宿主核酸的复制而复制，并随细胞的分裂而传代，这类噬菌体被称作温和噬菌体（temperate phage）或溶原性噬菌体（lysogenic phage）。

---

## Usage

1. **Run by executable file**

```
./DeePhage <input_file.fasta> <output_file.csv>

```

1. **Run by MATLAB script**

```
DeePhage('input_file.fasta','output_file.csv')

```

1. **Run DeePhage with specified cutoff**

- **Default** :

score<0.5 → temperate phage-derived fragment

score>0.5 → virulent phage-derived fragment

- **If has a cutoff**:

score between (0.5-cutoff , 0.5+cutoff) → "uncertain"

score < 0.5-cutoff → temperate phage-derived fragment

score > 0.5+cutoff → virulent phage-derived fragment

```
./DeePhage example.fna result.csv 0.7

# Why 0.7?

```

```
DeePhage('example.fna','result.csv','0.7')

# ...

```

---

## Output

The output of DeePhage consists of four columns:

|Header|Length|lifestyle*score|possible*lifestyle|
|---|---|---|---|

**Note**: If you want to run multiple tasks at the same time (either on physical host or virtual machine), please copy DeePhage package into different folders and run different tasks under different folders. Do not run different tasks under the same folder. 

More details in [https://github.com/shufangwu/DeePhage](https://github.com/shufangwu/DeePhage)