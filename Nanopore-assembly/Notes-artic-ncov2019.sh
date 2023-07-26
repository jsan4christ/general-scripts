https://artic.network/ncov-2019/ncov2019-it-setup.html   //Set up
https://artic.network/ncov-2019/ncov2019-bioinformatics-sop.html  //How to run

# To activate this environment, use
#
#     $ conda activate artic-ncov2019
#
# To deactivate an active environment, use
#
#     $ conda deactivate


artic minion --normalise 200 --threads 4 --scheme-directory /usr/local/biotools/artic-ncov2019/primer_schemes --read-file barcode01-K011681_01.fastq --fast5-directory path_to_fast5 --sequencing-summary path_to_sequencing_summary.txt nCoV-2019/V3 samplename

artic minion --normalise 200 --threads 4 --scheme-directory /usr/local/biotools/artic-ncov2019/primer_schemes --read-file barcode02-K011682_01.fastq --fast5-directory fast5 --sequencing-summary sequencing_summary_FAP53626_23bdd32d.txt nCoV-2019/V3 barcode01-K011681


Running: nanopolish index -s sequencing_summary_FAP53626_23bdd32d.txt -d fast5 barcode01-K011681_01.fastq

Running: minimap2 -a -x map-ont -t 4 /usr/local/biotools/artic-ncov2019/primer_schemes/nCoV-2019/V3/nCoV-2019.reference.fasta barcode01-K011681_01.fastq | samtools view -bS -F 4 - | samtools sort -o barcode01-K011681.sorted.bam -

Running: samtools index barcode01-K011681.sorted.bam

Running: align_trim --normalise 200 /usr/local/biotools/artic-ncov2019/primer_schemes/nCoV-2019/V3/nCoV-2019.scheme.bed --start --remove-incorrect-pairs --report barcode01-K011681.alignreport.txt < barcode01-K011681.sorted.bam 2> barcode01-K011681.alignreport.er | samtools sort -T barcode01-K011681 - -o barcode01-K011681.trimmed.rg.sorted.bam
Running: align_trim --normalise 200 /usr/local/biotools/artic-ncov2019/primer_schemes/nCoV-2019/V3/nCoV-2019.scheme.bed --remove-incorrect-pairs --report barcode01-K011681.alignreport.txt < barcode01-K011681.sorted.bam 2> barcode01-K011681.alignreport.er | samtools sort -T barcode01-K011681 - -o barcode01-K011681.primertrimmed.rg.sorted.bam

Running: samtools index barcode01-K011681.trimmed.rg.sorted.bam
Running: samtools index barcode01-K011681.primertrimmed.rg.sorted.bam
Running: nanopolish variants --min-flanking-sequence 10 -x 1000000 --progress -t 4 --reads barcode01-K011681_01.fastq -o barcode01-K011681.nCoV-2019_2.vcf -b barcode01-K011681.trimmed.rg.sorted.bam -g /usr/local/biotools/artic-ncov2019/primer_schemes/nCoV-2019/V3/nCoV-2019.reference.fasta -w "MN908947.3:1-29904" --ploidy 1 -m 0.15 --read-group nCoV-2019_2 

Running: nanopolish variants --min-flanking-sequence 10 -x 1000000 --progress -t 4 --reads barcode01-K011681_01.fastq -o barcode01-K011681.nCoV-2019_1.vcf -b barcode01-K011681.trimmed.rg.sorted.bam -g /usr/local/biotools/artic-ncov2019/primer_schemes/nCoV-2019/V3/nCoV-2019.reference.fasta -w "MN908947.3:1-29904" --ploidy 1 -m 0.15 --read-group nCoV-2019_1 

Running: artic_vcf_merge barcode01-K011681 /usr/local/biotools/artic-ncov2019/primer_schemes/nCoV-2019/V3/nCoV-2019.scheme.bed 2> barcode01-K011681.primersitereport.txt nCoV-2019_2:barcode01-K011681.nCoV-2019_2.vcf nCoV-2019_1:barcode01-K011681.nCoV-2019_1.vcf

Running: artic_vcf_filter --nanopolish barcode01-K011681.merged.vcf barcode01-K011681.pass.vcf barcode01-K011681.fail.vcf

Running: bgzip -f barcode01-K011681.pass.vcf

Running: tabix -p vcf barcode01-K011681.pass.vcf.gz

Running: artic_make_depth_mask --store-rg-depths /usr/local/biotools/artic-ncov2019/primer_schemes/nCoV-2019/V3/nCoV-2019.reference.fasta barcode01-K011681.primertrimmed.rg.sorted.bam barcode01-K011681.coverage_mask.txt

Running: artic_mask /usr/local/biotools/artic-ncov2019/primer_schemes/nCoV-2019/V3/nCoV-2019.reference.fasta barcode01-K011681.coverage_mask.txt barcode01-K011681.fail.vcf barcode01-K011681.preconsensus.fasta

Running: bcftools consensus -f barcode01-K011681.preconsensus.fasta barcode01-K011681.pass.vcf.gz -m barcode01-K011681.coverage_mask.txt -o barcode01-K011681.consensus.fasta


Running: artic_fasta_header barcode01-K011681.consensus.fasta "barcode01-K011681/ARTIC/nanopolish"

Running: cat barcode01-K011681.consensus.fasta /usr/local/biotools/artic-ncov2019/primer_schemes/nCoV-2019/V3/nCoV-2019.reference.fasta > barcode01-K011681.muscle.in.fasta

Running: muscle -in barcode01-K011681.muscle.in.fasta -out barcode01-K011681.muscle.out.fasta


>P76_1
AGGGCAAACTGGAAAGATTGCT
>P76_2
GGGCAAACTGGAAAGATTGCTGA

1.3 Problem Statement

Countries with tropical climate in recent years have suffered several introductions of arboviruses transmitted by mosquitoes, making it essential to monitor the transmission of viral genotypes associated with the appearance and increase of severe disease cases.


1.4 Research Questions

1. Is it possible to understand the migratory dispersion of arboviruses using bioinformatics tools?
2. How have been climatic factors contributed to the increase in infections caused by arboviruses?
3. How can genomic surveillance contribute to fighting infections caused by arboviruses?

### Run parallel
parallel 'artic minion --normalise 200 --threads 4 --scheme-directory /usr/local/biotools/artic-ncov2019/primer_schemes --read-file {}_01.fastq --fast5-directory fast5 --sequencing-summary sequencing_summary_FAP53626_23bdd32d.txt nCoV-2019/V3 {}' ::: $(ls *_01.fastq | cut -d "_" -f 1)


## Using medaka to skip nanopolish

medaka tools list_models

artic minion --medaka --medaka-model r941_min_high_g360 --normalise 200 --threads 4 --scheme-directory /usr/local/biotools/artic-ncov2019/primer_schemes --read-file barcode03-K011683_01.fastq.gz  nCoV-2019/V3 barcode03-K011683


parallel 'artic minion --medaka --medaka-model r941_min_high_g360 --normalise 200 --threads 4 --scheme-directory /usr/local/biotools/artic-ncov2019/primer_schemes --read-file {}_01.fastq nCoV-2019/V3  {}' ::: $(ls *_01.fastq | cut -d "_" -f 1)


###Trim/primer check:
##barcode69-K011749-NC_045512.2_1-consensus_alignment_sorted.bam


conda activate artic-ncov2019  ## Run once
align_trim --normalise 200 /usr/local/biotools/artic-ncov2019/primer_schemes/nCoV-2019/V3/nCoV-2019.scheme.bed --start --remove-incorrect-pairs --report barcode69-K011749.alignreport.txt < barcode69-K011749-NC_045512.2_1-consensus_alignment_sorted.bam 2> barcode69-K011749.alignreport.er | samtools sort -T barcode69-K011749 - -o barcode69-K011749.trimmed.rg_gd.sorted.bam
align_trim --normalise 200 /usr/local/biotools/artic-ncov2019/primer_schemes/nCoV-2019/V3/nCoV-2019.scheme.bed --remove-incorrect-pairs --report barcode69-K011749.alignreport.txt < barcode69-K011749-NC_045512.2_1-consensus_alignment_sorted.bam 2> barcode69-K011749.alignreport.er | samtools sort -T barcode69-K011749 - -o barcode69-K011749.primertrimmed.rg_gd.sorted.bam


### gridion

guppy_barcoder --require_barcodes_both_ends -i FASTQ_21H  -s run97_artic_barcodes_21h --arrangements_files "barcode_arrs_nb96.cfg"



### run 97

guppy_barcoder --require_barcodes_both_ends -i FASTQ_21H  -s tst  --barcode_kits "EXP-NBD196"

parallel 'artic guppyplex --min-length 400 --max-length 700 --directory RUN97-ARTIC-BARCODES-21H/barcode{} --prefix run97' ::: $(seq -w 96)


parallel 'artic minion --normalise 200 --threads 4 --scheme-directory /usr/local/biotools/artic-ncov2019/primer_schemes --read-file ../run97_single_barcodes/run97_barcode{}.fastq --fast5-directory ../fast5 --sequencing-summary ../sequencing_summary_FAP53626_23bdd32d.txt nCoV-2019/V3  run97_barcode{}' ::: $(seq -w 96)

artic minion --depth 20 --normalise 200 --threads 4 --scheme-directory /usr/local/biotools/artic-ncov2019/primer_schemes --read-file ../run97_single_barcodes/run97_barcode29.fastq --fast5-directory ../fast5 --sequencing-summary ../sequencing_summary_FAP53626_23bdd32d.txt nCoV-2019/V3  run97_barcode29_20


### Coverage masking
artic_make_depth_mask --store-rg-depths /usr/local/biotools/artic-ncov2019/primer_schemes/nCoV-2019/V3/nCoV-2019.reference.fasta --depth 20 run97_barcode29_d70.primertrimmed.rg.sorted.bam run97_barcode29_d70.coverage_mask.txt


guppy_barcoder --require_barcodes_both_ends -i fast5  -s tst  --barcode_kits "EXP-NBD196"

####  run 98

guppy_basecaller -i fast5  -s run98_basecalls/ -c  dna_r9.4.1_450bps_fast.cfg  --device cuda:all:100%

guppy_barcoder --require_barcodes_both_ends -i run98_basecalls  -s run98_barcodes  --barcode_kits "EXP-NBD196"

mkdir -p run98_barcodes_single && cd run98_barcodes_single 

parallel 'artic guppyplex --min-length 200 --max-length 700 --directory ../barcodes/barcode{} --prefix run108' ::: $(seq -w 95)


### add sample id to barcode
xxx

eef3f3

#### run 90
for i in `cat SampleIDs.txt`;  do  on=$(echo $i | cut -d "," -f1);  nn=$(echo $i | cut -d "," -f2);  mv "run90_${on}.fastq" "${nn}.fastq";  done

parallel 'artic minion --normalise 0 --threads 4 --scheme-directory /usr/local/biotools/artic-ncov2019/primer_schemes --read-file ../run97_single_barcodes/run97_barcode{}.fastq --fast5-directory ../fast5 --sequencing-summary ../sequencing_summary_FAP53626_23bdd32d.txt nCoV-2019/V3  run97_barcode{}' ::: $(seq -w 96)


for i in `cat seqNames.txt`;  do  on=$(echo $i | cut -d "," -f1);  nn=$(echo $i | cut -d "," -f2);  sed -i '' "s#$on#$nn#g" run_consensus_v1.fasta;  done
#### run 101

####Run 108
/analyses2/houriiyah/nCoV_genomes/minion_96_protocol_trial/barcodes-single-files-run108-21h/

guppy_basecaller -i fast5  -s run108_barcodes/ -c  dna_r9.4.1_450bps_fast.cfg  --device cuda:all:100%

guppy_barcoder --require_barcodes_both_ends -i run108_barcodes  -s barcodes  --barcode_kits "EXP-NBD196"

mkdir -p run108_barcodes_single && cd run108_barcodes_single 

parallel 'artic guppyplex --min-length 200 --max-length 700 --directory barcodes/barcode{} --prefix run108' ::: $(seq -w 96)

cd ..

mkdir variant_calls && cd variant_calls

parallel 'artic minion --normalise 0 --threads 4 --scheme-directory /usr/local/biotools/artic-ncov2019/primer_schemes --read-file ../barcodes-single/run108_barcode{}.fastq --fast5-directory ../fast5 --sequencing-summary ../sequencing_summary_FAP53344_917b9069.txt nCoV-2019/V3  run97_barcode{}' ::: $(seq -w 96)


###
for i in `cat SampleIDs.txt`; do on=$(echo $i | cut -d "," -f1);  nn=$(echo $i | cut -d "," -f2);  mv "run97_${on}.muscle.out.fasta" "run108_${nn}.muscle.out.fasta";  done

## ubuntu
rename s/run108_b/b/ *.fasta

##mac
for i in `cat SampleIDs.txt`;  do  on=$(echo $i | cut -d "," -f1);  nn=$(echo $i | cut -d "," -f2);  sed -i '' "s#$on#$nn#g" run_consensus_v1.fasta;  done ##Only works on my mac, not in centos

### works in centos - to rename samples
for i in `cat SampleIDs.txt`;  do  on=$(echo $i | cut -d "," -f1);  nn=$(echo $i | cut -d "," -f2);  mv "run90_${on}.fastq" "${nn}.fastq";  done



https://github.com/nf-core/nanoseq
Alignment (GraphMap2 or minimap2)
Both aligners are capable of performing unspliced and spliced alignment. Sensible defaults will be applied automatically based on a combination of the input data and user-specified parameters
Each sample can be mapped to its own reference genome if multiplexed in this way
Convert SAM to co-ordinate sorted BAM and obtain mapping metrics (SAMtools)

####CoronaHiT
## Basecalling was performed using Guppy v.4.2.2 (Oxford Nanopore Technologies) in high accuracy mode (model dna_r9.4.1_450bps_hac)
## ‘require_barcodes_both_ends’ and a score of 60 at both ends to produce 95 FASTQ files (94 SARS-CoV-2 samples and 1 negative control) 

### RUN 111

guppy_basecaller -i fast5  -s basecalls/ -c  dna_r9.4.1_450bps_fast.cfg  --device cuda:all:100%

guppy_barcoder --require_barcodes_both_ends -i basecalls  -s barcodes  --barcode_kits "EXP-NBD196"

mkdir -p barcodes_single && cd barcodes_single 

parallel 'artic guppyplex --min-length 200 --max-length 700 --directory ../barcodes/barcode{} --prefix run111' ::: $(seq -w 96)

for i in `cat ../SampleIDS.txt`;  do  on=$(echo $i | cut -d "," -f1);  nn=$(echo $i | cut -d "," -f2);  mv "run111_${on}.fastq" "${nn}.fastq";  done

cd ..



mkdir variant_calls && cd variant_calls

parallel 'artic minion --normalise 0 --threads 12 --scheme-directory /usr/local/biotools/artic-ncov2019/primer_schemes --read-file ../barcodes_single/{}.fastq --fast5-directory ../fast5 --sequencing-summary ../sequencing_summary_FAP53225_09545d24.txt nCoV-2019/V3 {}' ::: $(ls -1 ../barcodes_single/*.fastq | xargs -n 1 basename | cut -d "." -f1)

## Transfer variant calls and fastqs to the server.
../process_nt
grep ">" run_consensus_v1.fasta 
### RUN 113

 617533546
guppy_basecaller -i fast5  -s basecalls/ -c  dna_r9.4.1_450bps_fast.cfg  --device cuda:all:100%

guppy_barcoder --require_barcodes_both_ends -i basecalls  -s barcodes  --barcode_kits "EXP-NBD196"

mkdir -p barcodes_single && cd barcodes_single 

parallel 'artic guppyplex --min-length 200 --max-length 700 --directory ../barcodes/barcode{}' ::: $(seq -w 95)

for i in `cat ../SampleIDS.txt`;  do  on=$(echo $i | cut -d "," -f1);  nn=$(echo $i | cut -d "," -f2);  mv "run113_${on}.fastq" "${nn}.fastq";  done

cd ..

mkdir variant_calls && cd variant_calls

parallel 'artic minion --normalise 0 --threads 12 --scheme-directory /usr/local/biotools/artic-ncov2019/primer_schemes --read-file ../barcodes_single/{}.fastq --fast5-directory ../fast5 --sequencing-summary ../sequencing_summary_FAP53564_23158a77.txt nCoV-2019/V3 {}' ::: $(ls -1 ../barcodes_single/*.fastq | xargs -n 1 basename | cut -d "." -f1)

#### RUN115

guppy_basecaller -i fast5  -s basecalls/ -c  dna_r9.4.1_450bps_fast.cfg  --device cuda:all:100%

guppy_barcoder --require_barcodes_both_ends -i basecalls  -s barcodes  --barcode_kits "EXP-NBD196"

mkdir -p barcodes_single && cd barcodes_single 

parallel 'artic guppyplex --min-length 200 --max-length 700 --directory ../barcodes/barcode{}' ::: $(seq -w 95)


for i in `cat ../SampleIDS.txt`;  do  on=$(echo $i | cut -d "," -f1);  nn=$(echo $i | cut -d "," -f2);  mv "${on}" "${nn}";  done

cd ..

mkdir variant_calls && cd variant_calls

parallel 'artic minion --normalise 0 --threads 12 --scheme-directory /usr/local/biotools/artic-ncov2019/primer_schemes --read-file ../barcodes_single/{}.fastq --fast5-directory ../fast5 --sequencing-summary ../sequencing_summary_FAH78884_b8b725bd.txt nCoV-2019/V3 {}' ::: $(ls -1 ../barcodes_single/*.fastq | xargs -n 1 basename | cut -d "." -f1)

####### RUN 116

less ../../../RUN_116_20210429/no_sample/20210429_0837_X1_FAH78754_c881827f/sequencing_summary_FAH78754_fa995200.txt | wc -l ## 3779505

tail -n 3779504 ../../../RUN_116_20210429/no_sample/20210429_0837_X1_FAH78754_c881827f/sequencing_summary_FAH78754_fa995200.txt >  sequencing_summary_FAH78754_fa995200_part1.txt

cat sequencing_summary_FAP83203_1c42530b.txt sequencing_summary_FAH78754_fa995200_part1.txt > sequencing_summary_combined.txt


cp -R fast5 fast5_combined

cp -n ../../../RUN_116_20210429/no_sample/20210429_0837_X1_FAH78754_c881827f/fast5/* fast5_combined/

guppy_basecaller -i fast5_combined  -s basecalls/ -c  dna_r9.4.1_450bps_fast.cfg  --device cuda:all:100%

guppy_barcoder --require_barcodes_both_ends -i basecalls  -s barcodes  --barcode_kits "EXP-NBD196"

mkdir -p barcodes_single && cd barcodes_single 

parallel 'artic guppyplex --min-length 200 --max-length 700 --directory ../barcodes/barcode{}' ::: $(seq -w 95)

## Create a SampleIDs.txt file with revised name and put in the barcodes single directory before running the code below

for i in `cat SampleIDS.txt`;  do  on=$(echo $i | cut -d "," -f1);  nn=$(echo $i | cut -d "," -f2);  mv "${on}" "${nn}";  done
for i in `cat SampleIDs.txt`;  do  on=$(echo $i | cut -d "," -f1);  nn=$(echo $i | cut -d "," -f2);  mv "${on}.fastq.gz" "${nn}.fastq.gz";  done


cd ..

mkdir variant_calls && cd variant_calls

parallel 'artic minion --normalise 0 --threads 12 --scheme-directory /usr/local/biotools/artic-ncov2019/primer_schemes --read-file ../barcodes_single/{}.fastq --fast5-directory ../fast5 --sequencing-summary ../sequencing_summary_combined.txt nCoV-2019/V3 {}' ::: $(ls -1 ../barcodes_single/*.fastq | xargs -n 1 basename | cut -d "." -f1)
parallel 'artic minion --normalise 0 --threads 12 --scheme-directory /usr/local/biotools/artic-ncov2019/primer_schemes --read-file ../barcodes_single/{}.fastq --fast5-directory ../fast5 --sequencing-summary ../sequencing_summary_combined.txt nCoV-2019/V3 {}' ::: $(ls -1 ../barcodes_single/*.fastq | xargs -n 1 basename | cut -d "." -f1)


## run 121

guppy_basecaller -i fast5  -s basecalls/ -c  dna_r9.4.1_450bps_fast.cfg  --device cuda:all:100%

guppy_barcoder --require_barcodes_both_ends -i basecalls  -s barcodes  --barcode_kits "EXP-NBD196"

mkdir -p barcodes_single && cd barcodes_single 

## /home/grid/miniconda3/envs/artic-ncov2019/bin/

parallel 'artic guppyplex --min-length 200 --max-length 700 --directory ../barcodes/barcode{}' ::: $(seq -w 96)

less sequencing_summary_FAP70166_e3c0098c.txt | wc -l ## 1816136
tail -n 1816135 sequencing_summary_FAP70166_e3c0098c.txt >  sequencing_summary_FAP70166_e3c0098c_NoHead.txt.txt
cat sequencing_summary_FAP84176_96dfa7a3.txt sequencing_summary_FAP70166_e3c0098c_NoHead.txt.txt > sequencing_summary_combined.txt


##RUN 123
guppy_basecaller -i fast5  -s basecalls/ -c  dna_r9.4.1_450bps_fast.cfg  --device cuda:all:100%

guppy_barcoder --require_barcodes_both_ends -i basecalls  -s barcodes  --barcode_kits "EXP-NBD196"
guppy_barcoder -i basecalls  -s barcodes  --barcode_kits "EXP-NBD196"

mkdir -p barcodes_single && cd barcodes_single 

parallel 'artic guppyplex --min-length 400 --max-length 1200 --directory ../barcodes/barcode{}' ::: $(seq -w 96)


install Ubuntu 20 LTS, python3 gcc 

for i in `cat SampleIDs.txt`;  do  on=$(echo $i | cut -d "," -f1);  nn=$(echo $i | cut -d "," -f2);  mv "None_${on}.fastq" "${nn}.fastq";  done

parallel 'artic minion --normalise 0 --threads 12 --scheme-directory /usr/local/biotools/artic-ncov2019/primer_schemes --read-file ../barcodes_single/{}.fastq.gz --fast5-directory ../fast5 --sequencing-summary ../sequencing_summary_FAO88899_060ec31e.txt nCoV-2019/V3 {}' ::: $(ls -1 ../barcodes_single/*.fastq.gz | xargs -n 1 basename | cut -d "." -f1)
sampling methods, data collection, analyses, interpretation and reporting technical assistance to NPHIs and other relevant institutions for strengthening the use of pathogen genomics for routine infectious disease surveillance
/data/run_147/no_sample/20210701_1309_X1_FAO88899_da500e69

## Epi2me
/Applications/biotools/epi2me-cli/epi2me-cli --list


parallel 'artic minion --normalise 0 --threads 12 --scheme-directory /usr/local/biotools/artic-ncov2019/primer_schemes --read-file ../barcodes_single/{}.fastq.gz --fast5-directory ../fast5 --sequencing-summary ../sequencing_summary_FAO80363_93055d4c.txt nCoV-2019/V3 {}' ::: $(ls -1 ../barcodes_single/*.fastq.gz | xargs -n 1 basename | cut -d "." -f1)



Software requirements:

Conda (both miniconda and anacond are fine)
Miniconda is sufficient: https://docs.conda.io/en/latest/miniconda.html
Artic pipeline
The artic protocol is freely available on online nCoV-2019 novel coronavirus bioinformatics protocol.
Text editor
You also need to keep a text document to help you modify commands e.g. bbedit for mac, notepad++ for Windows and gedit for Linux.
GNU parallels
Also freely available at https://www.gnu.org/software/parallel/ or via conda https://anaconda.org/conda-forge/parallel



parallel 'artic guppyplex --min-length 200 --max-length 1200 --directory ../fastq_pass/barcode{}' ::: $(seq -w 96)
parallel 'artic minion --medaka --medaka-model r941_min_high_g360 --normalise 0 --threads 4 --scheme-directory /usr/local/biotools/artic-ncov2019/primer_schemes --read-file ../barcodes_single/{}.fastq.gz nCoV-2019/V3  {}' ::: $(ls ../barcodes_single/*.fastq.gz | xargs -n 1 basename | cut -d "." -f 1)


# guppy_basecaller --print_workflows
## Flow cell product code  - FLO-MIN106
## Product kit - SQK-RBK110-96

# guppy_barcoder --print_kits


dna_r9.4.1_450bps_hac 
https://denbi-nanopore-training-course.readthedocs.io/en/latest/basecalling/basecalling.html

---
### Prepare
#a)
mkdir -p barcodes_single 
mkdir -p variant_calls
mkdir -p consensussa

#b)
parallels 'guppy_basecaller -i fast5_pass/barcode{}  -s basecalls/barcode{} -c  dna_r9.4.1_450bps_fast.cfg  --device cuda:all:100%' $(seq -w 96)


guppy_barcoder --require_barcodes_both_ends -i basecalls  -s barcodes  --barcode_kits "EXP-NBD196"

#c)
cd barcodes_single && artic guppyplex --min-length 200 --max-length 700 --directory ../barcodes/barcode01 && nn=$(grep barcode01 SampleIDs.txt | cut -d "," -f2); && mv "${on}".fastq.gz "${nn}".fastq.gz; && artic minion --normalise 0 --threads 12 --scheme-directory /usr/local/biotools/artic-ncov2019/primer_schemes --read-file barcodes_single/{}.fastq.gz --fast5-directory fast5 --sequencing-summary sequencing_summary_combined.txt nCoV-2019/V3 {}


FLO-MIN106     SQK-RBK110-96     included  dna_r9.4.1_450bps_hac          2021-05-17_dna_r9.4.1_minion_384_d37a2ab9

parallels 'guppy_basecaller -i fast5_pass/barcode{}  -s basecalls/barcode{} -c  dna_r9.4.1_450bps_fast.cfg  --device cuda:all:100%' $(seq -w 94)

guppy_barcoder  --require_barcodes_both_ends --input_path basecalls/pass/ --save_path barcodes2 --config configuration.cfg --barcode_kits "EXP-MRT001"


## Not working in v.6: guppy_barcoder  --input_path basecalls/pass/ --save_path barcodes --config configuration.cfg --barcode_kits "EXP-MRT001"

### Combine fastqs for barcodes
guppy_basecaller -i fast5  -s basecalls/ -c  dna_r9.4.1_450bps_fast.cfg  --device cuda:all:100%
guppy_basecaller --compress_fastq -i  fast5 -s basecall --cpu_threads_per_caller 8 --num_callers 1 -c dna_r9.4.1_450bps_hac.cfg --device cuda:all:100%


guppy_barcoder  --input_path basecalls/pass/ --save_path barcodes --config configuration.cfg --barcode_kits "SQK-RBK110-96" ## native barcoding (SQK-LSK109 with EXP-NBD104 and EXP-NBD114)

mkdir barcodes_single && cd barcodes

list=$(ls -l | grep ^d | awk '$9 ~/^barcode/ {print $9}')

for i in $list; do cat $i"/"*".fastq" > "../barcodes_single/"$i".fastq"; done

cd ../barcodes_single

gzip *.fastq

ls

less SampleIDs_1.txt |  grep "\S" > SampleIDs.txt 

for i in `cat SampleIDs.txt`;  do  on=$(echo $i | cut -d "," -f1);  nn=$(echo $i | cut -d "," -f2);  mv "${on}.fastq.gz" "${nn}.fastq.gz";  done



scp -r *.gz sanjames@krisp.mrc.ac.za:/analyses2/houriiyah/nCoV_genomes/minion_96_protocol/run242


scp -r *.gz sanjames@krisp.mrc.ac.za:/analyses2/houriiyah/nCoV_genomes/minion_96_protocol/run236/bc3_4.xx

scp -r *.gz sanjames@krisp.mrc.ac.za:/analyses2/houriiyah/nCoV_genomes/minion_96_protocol/run235/


parallel 'artic guppyplex --min-length 200 --max-length 1200 --directory ../barcodes/barcode{}' ::: $(seq -w 96)

for i in `cat SampleIDs.txt`;  do  on=$(echo $i | cut -d "," -f1);  nn=$(echo $i | cut -d "," -f2);  mv "${on}.fastq.gz" "${nn}.fastq.gz";  done


artic minion --normalise 0 --threads 12 --scheme-directory /usr/local/biotools/artic-ncov2019/primer_schemes --read-file K032888.fastq.gz --fast5-directory ../fast5 --sequencing-summary ../sequencing_summary_FAQ30748_b35c7e83.txt nCoV-2019/V3 K032888


globalprotect launch-ui