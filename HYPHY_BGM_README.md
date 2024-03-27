## BGM analysis workflow

#### Codon-align the sequences

Use `bealign` (part of Python `BioExt` package). You can install it usign `pip3 install bioext` or check [GitHub](http://github.com/veg/BioExt).

```
bealign -r CoV2-S FASTA BAM
```

Then convert BAM to a FASTA alignment 

```
bam2msa -r CoV2-S BAM MSA
```

#### Remove duplicate sequences

Use this HyPhy analysis [https://github.com/veg/hyphy-analyses/tree/master/remove-duplicates](https://github.com/veg/hyphy-analyses/tree/master/remove-duplicates) to remove all duplicate sequences from the alignment 

```
hyphy /path/to/remove-duplicates.bf ENV="DATA_FILE_PRINT_FORMAT=9" 
--msa MSA 
--output MSA-compressed
```

#### Infer tree

You can use any program (e.g. `raxml-ng`).

```
raxml-ng --msa MSA-compressed --model GTR+G
```

#### Run BGM

```
hyphy bgm --alignment MSA-compressed --tree TREE
```

Examine screen output and view the output file using [HyPhy vision](https://vision.hyphy.org/BGM)
