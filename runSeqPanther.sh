
# Bam, Ref and gff should have the same ref as specified by rid.

# Ref bases should be in uppercase. Lower case will result in the error: Error: mpileup requires the --fasta-ref option by default; use --no-reference to run without a fasta reference.
# In the BBEdit text editor, you can use the option: Text->Change Case->All upper case

# Special characters such as the pipe `|` in ref id should be escaped

conda create -n sp
source activate sp

pip install git+https://github.com/codemeleon/seqPanther.git


seqpanther  codoncounter -bam Ko48924_K03455_HIVHXB2CG.bam -rid K03455\|HIVHXB2CG -ref K03455.fasta -gff K03455_modified.gff -e 0


seqpanther  codoncounter -bam Ko48924_K03455_HIVHXB2CG.bam -rid K03455\|HIVHXB2CG -ref K03455.fasta -gff K03455_modified.gff -e 0


### Covid Refs:
/Users/sanem/temp/Collaborations/covid/ref/NC_045512.2.fasta #Ref
/Users/sanem/temp/Collaborations/covid/ref/NC_045512.2.gff   #Genemap

### Moyo / Wonder analysis:
ref_id=NC_045512.2
ref=/Users/sanem/temp/Collaborations/covid/ref/NC_045512.2.fasta
genemap=/Users/sanem/temp/Collaborations/covid/ref/NC_045512.2.gff



samtools view -h BAMs_Final/Day08_Mid_pt214cB25-NC_045512.2-4-0-region.bam | head -n 8

# Split and rebam: Day 08:

bamtools split -in Day08_Mid_pt214cB25-NC_045512.2-4-0-region.bam -reference

mv Day08_Mid_pt214cB25-NC_045512.2-4-0-region.REF_NC_045512.2_1_consensus.bam Day08.bam

samtools fastq Day08.bam > Day08_ONT.fastq
minimap2 -a -x map-ont -t 4  ${ref} Day08_ONT.fastq | samtools view -bS -F 4 - | samtools sort -o Day08_ONT.bam - 
lofreq indelqual --dindel -f ${ref}  -o Day08_ONT_sorted_iq.bam Day08_ONT.bam
seqpanther  codoncounter -bam Day08_ONT_sorted_iq.bam -rid ${ref_id} -ref ${ref} -gff ${genemap} -e 0
seqpanther  codoncounter -bam Day28_merged-NC_045512.2-0-0-region.bam -rid ${ref_id} -ref ${ref} -gff ${genemap} -e 0

column -s, -t < codon_output.csv| less -#2 -N -S

/Users/sanem/miniconda3/envs/sp/bin/pip uninstall seqpanther


samtools fastq Day28_merged-NC_045512.2-0-0-region.bam > Day21_ONT.fastq
minimap2 -a -x map-ont -t 4  ${ref} Day21_ONT.fastq | samtools view -bS -F 4 - | samtools sort -o Day21_ONT.bam - 
seqpanther  codoncounter -bam Day21_ONT.bam -rid ${ref_id} -ref ${ref} -gff ${genemap} -e 0


### Rebam Steps:
parallel 'bamtools split -in {}_consensus_alignment_sorted.bam -reference' ::: $(ls -1 *_consensus_alignment_sorted.bam |  cut -d "_" -f1)

### Illumina PE
samtools fastq ../FAR40572-barcode61-96480c7f_consensus_alignment_sorted.REF_NC_045512.2_1_consensus.bam -0 FAR40572-barcode61-96480c7f.R0.fq.gz -1 FAR40572-barcode61-96480c7f.R1.fq.gz -2 FAR40572-barcode61-96480c7f.R2.fq.gz
parallel 'samtools fastq {}-consensus_alignment_sorted.REF_NC_045512.2_1_consensus.bam -0 {}.R0.fq.gz -1 {}.R1.fq.gz -2 {}.R2.fq.gz' ::: $(ls -1 *-consensus_alignment_sorted.REF_NC_045512.2_1_consensus.bam |  cut -d "-" -f1)

repair.sh in=FAR40572-barcode61-96480c7f.R1.fq.gz in2=FAR40572-barcode61-96480c7f.R2.fq.gz out=FAR40572-barcode61-96480c7f_R1.rep.fastq.gz out2=FAR40572-barcode61-96480c7f_R2.rep.fastq.gz
parallel 'repair.sh in={}.R1.fq.gz in2={}.R2.fq.gz out={}_R1.rep.fastq.gz out2={}_R2.rep.fastq.gz' ::: $(ls -1 *.R0.fq.gz |  cut -d "." -f1)

bwa mem -t 4 -R '@RG\tID:foo\tSM:bar' /Users/sanem/temp/Collaborations/covid/ref/NC_045512.2.fasta FAR40572-barcode61-96480c7f_R{1 2}.rep.fastq.gz | samtools sort -@ 4 -o FAR40572-barcode61-96480c7f.bwa.sorted.bam
bwa mem -t 4 -R '@RG\tID:foo\tSM:bar' /Users/sanem/temp/Collaborations/covid/ref/NC_045512.2.fasta K040177_R{1 2}.rep.fastq.gz | samtools sort -@ 4 -o K040177.bwa.sorted.bam
parallel 'bwa mem -t 4 -R "@RG\tID:foo\tSM:bar" {2} {1}_R{1 2}.rep.fastq.gz | samtools sort -@ 4 -o {1}.bwa.sorted.bam' ::: $(ls -1 *_R1.rep.fastq.gz | cut -d "_" -f1) ::: "/Users/sanem/temp/Collaborations/covid/ref/NC_045512.2.fasta"



### ONT

parallel 'samtools fastq {}-consensus_alignment_sorted.REF_NC_045512.2_1_consensus.bam > {}_ONT.fastq' ::: $(ls *-consensus_alignment_sorted.REF_NC_045512.2_1_consensus.bam | xargs -n 1 basename | cut -d "-" -f1)
parallel 'samtools fastq {}.bam > {}_ONT.fastq' ::: $(ls *.bam | xargs -n 1 basename | cut -d "." -f1)


parallel 'minimap2 -a -x map-ont -t 4  /Users/sanem/temp/Collaborations/covid/ref/NC_045512.2.fasta {}_ONT.fastq | samtools view -bS -F 4 - | samtools sort -o {}_ONT.bam - ' :::  $(ls *_ONT.fastq | xargs -n 1 basename | cut -d "_" -f1)

parallel 'minimap2 -a -x map-ont -t 4  {2} {1}_ONT.fastq | samtools view -bS -F 4 - | samtools sort -o {}_ONT.bam - ' :::  $(ls *_ONT.fastq | xargs -n 1 basename | cut -d "_" -f1) ::: "/Users/sanem/temp/Collaborations/covid/ref/NC_045512.2.fasta"

parallel 'lofreq indelqual --dindel -f {2}  -o {1}_sorted_iq.bam {1}_ONT.bam' ::: $(ls *_ONT.bam | cut -d "_" -f1)  ::: "/Users/sanem/temp/Collaborations/covid/ref/NC_045512.2.fasta"

parallel 'lofreq call --call-indels --use-orphan -B --no-default-filter -f {2} -o {1}.lf.vcf {1}_sorted_iq.bam  --force-overwrite' ::: $(ls *_iq.bam | cut -d "_" -f1)  ::: "/Users/sanem/temp/Collaborations/covid/ref/NC_045512.2.fasta"
