bwa mem -t1 /analyses/micgwas/ml/datasets/c_difficile/ref/AM180355.1.fasta CZWK01.fasta.gz | samtools sort -T CZWK01 -O bam - > CZWK01.sorted.bam
            
samtools index CZWK01.sorted.bam 
            
samtools view sample.sorted.bam | head -n 5
            
IGV
            