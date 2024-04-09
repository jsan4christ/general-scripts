diamond blastx -d /analyses/software/dbs/diamond/nr -q RES014_S3_L001_R1_001.fastq.gz  -o matches.m8 -t /analyses/tmp/ ##temp directory

## https://bioinformatics.stackexchange.com/questions/3931/remove-delete-sequences-by-id-from-multifasta
## To delete sequences by id If you want to learn how to do things with command-line tools, you can linearize the FASTA with awk, pipe to grep to filter for items of interest named in patterns.txt, then pipe to tr to delinearize:
$ awk '{ if ((NR>1)&&($0~/^>/)) { printf("\n%s", $0); } else if (NR==1) { printf("%s", $0); } else { printf("\t%s", $0); } }' in.fa | grep -Ff patterns.txt - | tr "\t" "\n" > out.fa


## drop all the 
sed -i 's/"//g' PRJEB2090_sub_accn_fq.txt

## Download files from SRA using link to file
parallel 'wget {}' ::: $(cat PRJEB2090_sub_accn_fq.txt)

## paste files and seperate content with empty line
ls -1 *_consensus.fasta | wc -l
find ./*_consensus.fasta | uniq | xargs -I{} sh -c "cat {}; echo ''" > run40_assemblies.fasta
less run40_assemblies.fasta | grep "^>" | wc -l



awk -F_ '/^>/{print $1;next}{print}' < run43_assemblies.fasta > run43_assemblies_renamed.fasta

## find files not in the list but are present in the folder
ls -1 *.gz | grep -vf okay_fqs.txt > bad_fqs.txt

## filter sequences
seqkit grep -r -f nonHumanSeqIdsGisaid.txt sequences_2020-11-30_07-36.fasta > animalSequences.fasta

du -sh /usr/local/biotools ##disk usage by biotools, the -s is important to get the summary of the whole folder otherwise, will give each file/sub-folder separately.

df -h / ## for drive status

/Applications/biotools/virulign S.xml basMinkSequences.fasta --exportKind GlobalAlignment  --exportAlphabet Nucleotides --exportReferenceSequence yes  > basMinkSequencesSpike.fasta 2> err_log.txt

## rename folder to lower case
rename -f 'y/A-Z/a-z/' Scripts
rename 'y/A-Z/a-z/' * #for all files and folders

## rename files
To rename multiple files:

rename s/0000/000/ F0000* (On Ubuntu, OSX (Homebrew package rename, MacPorts package p5-file-rename), or other systems with perl rename (prename))
rename .fna A.fna *.fna  (on systems with rename from util-linux-ng, such as RHEL)
rename -- -SE_001 -01_SE *.gz #the -- indicates the end of arguements. 

#Replace spaces in file names with _
find . -name "* *" -type f | rename 's/ /_/g'

## Shuffle rows of file
#P. aeruginosa
head -1 metadata/amikacin_metadata_amikacin.tsv > metadata/amikacin_head.txt
tail -467 metadata/amikacin_metadata_amikacin.tsv > metadata/amikacin_body.txt
shuf -n 467 < metadata/amikacin_body.txt > metadata/amikacin_body_shuff.txt
cat metadata/amikacin_head.txt metadata/amikacin_body_shuff.txt > metadata/amikacin_metadata_amikacin.tsv

head -1 metadata/amikacin_metadata_amikacin.tsv > metadata/amikacin_head.txt
tail -470 metadata/amikacin_metadata_amikacin.tsv > metadata/amikacin_body.txt
shuf -n 470 < metadata/amikacin_body.txt > metadata/amikacin_body_shuff.txt
cat metadata/amikacin_head.txt metadata/amikacin_body_shuff.txt > metadata/amikacin_metadata_amikacin.tsv


#P. deficile
Azith
head -1 metadata/azithromycin_metadata_azithromycin.tsv > metadata/azithromycin_head.txt
tail -456 metadata/azithromycin_metadata_azithromycin.tsv > metadata/azithromycin_body.txt
shuf -n 456 < metadata/azithromycin_body.txt > metadata/azithromycin_body_shuff.txt
cat metadata/azithromycin_head.txt metadata/azithromycin_body_shuff.txt > metadata/azithromycin_metadata_azithromycin.tsv


xargs -a fileNames.txt -I filename find /dir -name filename

MRC server:
export PATH=/analyses/software/miniconda3b/bin:$PATH

# Ensure java home is correct on my Mac
export JAVA_HOME=/Library/Java/Home 

export JAVA_HOME=$(/usr/libexec/java_home) ## works

#Docker
https://cloudaffaire.com/faq/docker-qemu-x86_64-could-not-open-lib64-ld-linux-x86-64-so-2-no-such-file-or-directory/
https://stackoverflow.com/questions/35594987/how-to-force-docker-for-a-clean-build-of-an-image
docker image ls #list images, -a to list all
docker ps -a # list containers
docker rmi c424f699a8f1  --force #delete by image id
https://docs.docker.com/engine/reference/commandline/stop/
FROM --platform=linux/amd64 alpine:latest
docker build -t vocpl . --no-cache
docker run --platform linux/amd64  vocpl
docker run --platform linux/x86_64 vocpl  ##using this

ln -s /path/to/original /path/to/link
ln -s /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin/Contents/Home/ /usr/local/oraclejava 

export PATH=/Users/sanem/miniconda2/bin:$PATH
export PATH=/Users/sanem/miniconda3/bin:$PATH

conda activate nextstrain
#error: -bash: [: /Library/Internet: binary operator expected
#export java

#install to conda environment from base

## Change tree ids
awk 'NR==FNR{a[$1]=$2;next}{ for (i in a) gsub(i ":",a[i] ":")}1' CH1_newIds.txt CH1_purged_final_BeastSet_mafft.aln_strict_constant_est.tree > CH1_purged_final_BeastSet_mafft.aln_strict_constant_est_shortIds.tree
awk 'NR==FNR{a[$1]=$2;next}{ for (i in a) gsub(i ":",a[i] ":")}1' CH3_newIds.txt CH3_purged_final_BeastSet_mafft.aln_strict_constant_est.tree > CH3_purged_final_BeastSet_mafft.aln_strict_constant_est_shortIds.tree


## Change fasta sequence names (comma seperated file with old and new names)
for i in `cat name_replace_v2.txt`;  do  on=$(echo $i | cut -d "," -f1);  nn=$(echo $i | cut -d "," -f2);  sed -i '' "s#$on#$nn#g" run51_52_sanger_53_54_v1.fasta;  done

ls -1 *.lf_filt.vcf >  vcfList.txt
python /analyses/werner/apps/snpdistance/scripts/snpdistance.py -v $(cat vcfList.txt | paste -sd ","  -) -o l1_norm.txt

##Filter VCFs
parallel 'python VCF_Filter_v3.py -vi ../{}.lf.vcf -vo {}.lf_filt.vcf -mmc 5 -mmfs 0.02 -mmf 0.05 -mff 0.95' ::: $(ls ../*.lf.vcf | xargs -n1 basename| cut -d "." -f1)


parallel './makeconsensus-illumina2.sh {}-Sequences_ref.fasta {}-Sequences_sequence-alignment.bam {}' ::: $(ls -1 *.bam | xargs -n 1 basename| cut -d "-" -f1)


./makeconsensus-nanopore2.sh 4732_brcd09_31098-Sequences_ref.fasta 4732_brcd09_31098-Sequences_sequence-alignment.bam 4732



./makeconsensus-nanopore2.sh 4732_brcd09_31098-Sequences_ref.fasta 4732_brcd09_31098-Sequences_sequence-alignment.bam 4732_brcd09_31098

##Find files by id and copy to location
for id in `cat nature_sra_ids_short.txt`; do 
find . -name "*${id}*.gz" -type f -exec cp {} ./nature_sra/ \;
done

for id in `cat upasana_ids.txt`; do find ../../ -name "*${id}*.gz" -type f -exec cp {} upasna/ \; ; done

for id in `cat upasana/seq_ids.txt`;    do find GD/outputs/ -name "${id}-bam.zip" -type f -exec cp {} upasana/ \; ; done



##Rename samples from comma separated source/destination ids
for i in `cat sample_ids.txt`;  do  on=$(echo $i | cut -d "," -f1);  nn=$(echo $i | cut -d "," -f2);  mv "${on}.fastq.gz" "${nn}.fastq.gz";  done
for i in `cat old_new_seq_names.txt`;  do  on=$(echo $i | cut -d "," -f1);  nn=$(echo $i | cut -d "," -f2);  mv ${on} ${nn};  done


## paste comma separated lines
paste -d, file1 file2
pr -mtJS',' file1 file2
awk -v OFS=, 'FNR==NR{a[++i]=$0; next} {print a[FNR], $0}' file1 file2



for i in `cat fqNames.txt`;  do  nn=$(echo $i | cut -d "_" -f2);  mv "${i}" "${nn}";  done

## SRA upload:
okay you have to run this: 

/home/houriiyah/.aspera/connect/bin/ascp -i /analyses2/houriiyah/nCoV_genomes/aspera_3Feb.openssh -QT -l 100m -k1 -v -d /analyses2/houriiyah/nCoV_genomes/SRA_501YV2_submission1/ subasp@upload.ncbi.nlm.nih.gov:uploads/houriiyah.tegally_gmail.com_bTBGQX9v
/home/houriiyah/.aspera/connect/bin/ascp -i /analyses2/houriiyah/nCoV_genomes/aspera_3Feb.openssh -QT -l 100m -k1 -v -d /analyses2/houriiyah/nCoV_genomes/SRA_501YV2_submission1/ subasp@upload.ncbi.nlm.nih.gov:uploads/houriiyah.tegally_gmail.com_bTBGQX9v


but you have to replace this one with your own: /home/houriiyah/.aspera/connect/bin/ascp

go to: cd /usr/local/biotools/ and run:  ./ibm-aspera-connect-3.11.1.58-linux-g2.12-64.sh to get your own ascp executable


/home/sanjames/.aspera/connect/bin/ascp -i /analyses2/houriiyah/nCoV_genomes/aspera_3Feb.openssh -QT -l100m -k1 -d /analyses2/houriiyah/nCoV_genomes/SRA_501YV2_submission1/ subasp@upload.ncbi.nlm.nih.gov:uploads/houriiyah.tegally_gmail.com_bTBGQX9v

/home/sanjames/.aspera/connect/bin/ascp -i /analyses2/houriiyah/nCoV_genomes/aspera_3Feb.openssh -vwf -P33001 subasp@upload.ncbi.nlm.nih.gov:uploads/houriiyah.tegally_gmail.com_bTBGQX9v


##Worked:
sudo /home/houriiyah/.aspera/connect/bin/ascp -i /analyses2/houriiyah/nCoV_genomes/aspera_3Feb.openssh -QT -l 100m -k1 -v -d /analyses2/houriiyah/nCoV_genomes/SRA_501YV2_submission1/ subasp@upload.ncbi.nlm.nih.gov:uploads/houriiyah.tegally_gmail.com_bTBGQX9v
sudo /home/houriiyah/.aspera/connect/bin/ascp -i /analyses2/houriiyah/nCoV_genomes/aspera_3Feb.openssh -QT -l 100m -k1 -v -d /analyses2/houriiyah/nCoV_genomes/RUN61/ subasp@upload.ncbi.nlm.nih.gov:uploads/houriiyah.tegally_gmail.com_bTBGQX9v

ascp -P33001 -QT -l500m --file-manifest=text -k 0 -o Overwrite=always --host={domain} --user={username} --mode=send {Source File Path} {destination Folder}
/home/sanjames/.aspera/connect/bin/ascp -P33001 -v -L ./ -QT -l500m --file-manifest=text -k 0 -o Overwrite=always --host=upload.ncbi.nlm.nih.gov --user=subasp --mode=send /analyses2/houriiyah/nCoV_genomes/aspera_3Feb.openssh uploads/houriiyah.tegally_gmail.com_bTBGQX9v


## Local
ascp -i /analyses2/houriiyah/nCoV_genomes/aspera_3Feb.openssh -QT -l100m -k1 -v -L ./ -d . subasp@upload.ncbi.nlm.nih.gov:uploads/houriiyah.tegally_gmail.com_bTBGQX9v

ascp -i /home/sanjames/aspera_SJ.openssh -QT -l100m -k1 -d . subasp@upload.ncbi.nlm.nih.gov:uploads/sanemmanueljames_gmail.com_BhT4EXjx


## ls run60/ | awk -F_ '/^K/{print $1;next}{print}' | grep -v "SampleSheet" | xargs -d '\n' echo -p
## ls run60/ | awk -F_ '/^K/{print $1;next}{print}' | grep -v "SampleSheet" | xargs -d '\n' mkdir -p

source watcher-env/bin/activate

python /analyses2/houriiyah/nCoV_genomes/GD/watcher/watcher.py config.tulio.prod.yaml 

ls run60/ | awk -F_ '/^K/{print $1;next}{print}' | grep -v "SampleSheet" > run60_sample_ids.txt

-l 5000: split file into files of 5,000 lines each.
-d: numerical suffix. This will make the suffix go from 00 to 99 by default instead of aa to zz.
--additional-suffix: lets you specify the suffix, here the extension
$FileName: name of the file to be split.
file: prefix to add to the resulting files.

split -l 40 -d --additional-suffix=.txt SampleSheetIDs.txt ${runId}_sample_ids_batch

for batch_file in maryam_sample_ids_batch*.txt; do
	for sample in `cat ${batch_file}`; do
		/analyses2/houriiyah/nCoV_genomes/GD_batch_start.sh $sample "Run5_17122020";
	done
	sleep 10m
done


for sample in `cat temp_r60.txt`; do
	/analyses2/houriiyah/nCoV_genomes/GD_batch_start.sh $sample "run60";
done

for batch_file in maryam_sample_ids_batch*.txt; do
for sample in `cat $batch_file`; do /analyses2/houriiyah/nCoV_genomes/GD_batch_start_ont.sh $sample "Run5_17122020"; done
sleep 10m
done

./download_output_batch.sh <path to file containing list of job IDs> <output directory>

/analyses2/houriiyah/nCoV_genomes/GD/outputs/download_output_batch.sh /analyses2/houriiyah/nCoV_genomes/maryam_run5/fq_ids.txt /analyses2/houriiyah/nCoV_genomes/maryam_run5/GD_out

source /analyses2/houriiyah/nCoV_genomes/GD/watcher-env/bin/activate

/analyses/software/miniconda3/bin/python /analyses2/houriiyah/nCoV_genomes/GD/watcher/watcher.py /analyses2/houriiyah/nCoV_genomes/GD/config.tulio.prod.yaml

run_gd_watcher.sh

sed -n '1,/rsync_exclude/d;/\[/,$d;/^$/d;p' config.file

## Get ids from samplesheet
## https://stackoverflow.com/questions/21347695/how-to-read-config-files-with-section-in-bash-shell
sed -n '1,/Data/d;/\[/,$d;/^$/d;p' SampleSheet.csv | awk -F "," 'NR>1 { print $1}' > SampleSheetIDs.txt

 /usr/local/biotools/krisp_ncov_assembly/bin/gd_batch_submit.sh -r "run60" -t "PE" -s 45 -i "2m"
 
 ## Install package version in environment
 sudo $(which mamba) install --name nextstrain augur=12.0.0
 
 ### Multiple sequence alignment with augur and mafft (more details in  ~/temp/Bioinformatics/MSA/partition_align_msa.txt)
 
 parallel 'augur align --sequences bins/{1}.fasta --reference-sequence {2} --output alignments/{1}_aln.fasta --remove-reference --fill-gaps' ::: $(ls bins/| cut -d "." -f1) ::: "KPCOVID_ref.fasta"
 
 nextclade -i run71_consensus_v2_final_n4.fasta -r /Users/sanem/temp/Collaborations/covid/ref/reference.txt -c nextclade_run71_consensus_v2_final_n4.csv
 nextclade -i 2documentsfromRun71-18Feb2021.fasta -c nextclade_2documentsfromRun71-18Feb2021.csv
 
  split fasta:
 python ..//Users/sanem/temp/Collaborations/covid/wave2_data/split_multi_fasta.py/split_multi_fasta.py -m run73_consensus_v1.fasta
 

 awk -F '>' '/^>/ {F=sprintf("%s.fasta", $2); print > F;next;} {print F; close(F)}' < run73_consensus_v1.fasta
 
 parallel 'aga --global {2} {1}.fasta {1}_aln.fasta' ::: $(ls K00*.fasta | cut -d "." -f1)  ::: "/Users/sanem/temp/Collaborations/covid/ref/NC_045512.2.gb"
 
 ##--nt-weight 1 --aa-weight 1 --nt-gap-open-cost -10 --nt-gap-extension-cost -1 --aa-gap-open-cost -6 --aa-gap-extension-cost -2 --aa-frame-shift-cost -100 --aa-misalignment-cost -20


## Recombinants:
sudo /home/houriiyah/.aspera/connect/bin/ascp -i /analyses2/houriiyah/nCoV_genomes/aspera_3Feb.openssh -QT -l 100m -k1 -v -d/analyses2/houriiyah/nCoV_genomes/recombinants/recombinants_SRA/ subasp@upload.ncbi.nlm.nih.gov:uploads/houriiyah.tegally_gmail.com_bTBGQX9v

  /usr/local/biotools/SRA/aspera_connect/.aspera/connect/bin/ascp -i /usr/local/biotools/SRA/aspera_connect/aspera.openssh -QT -l 100m -k1 -v -d /analyses2/houriiyah/nCoV_genomes/RUN61/ subasp@upload.ncbi.nlm.nih.gov:uploads/krispilluminabasespace_gmail.com_zYSMLYcy
  
  

## move files to new folder
for f in `cat SampleIDs.txt`; do mv ${f}*gz temp/; done

## Change fasta sequence names based on fasta file name - works locally
for i in `ls *NC_045512.2_1-alignment-nt.fasta`;  do  on=$(echo $i | cut -d "," -f1);  nn=$(echo $i | cut -d "_" -f1);  sed -i '' "s#SCV2#$nn#g" $on;  done

sudo chmod -R 777 GD

## shell java garbage collection
parallel 'jcmd {} GC.run' ::: $(pgrep java)


## gd batch upload
/usr/local/biotools/krisp_ncov_assembly/bin/gd_batch_submit.sh -r "RUN82" -t "PE" -s 20 -i "20m"
/usr/local/biotools/krisp_ncov_assembly/bin/gd_batch_submit.sh -r "RUN02" -t "ONT" -s 10 -i "15m"
/usr/local/biotools/krisp_ncov_assembly/bin/gd_batch_submit.sh -r "RUN04" -t "SE" -s 20 -i "20m"
/usr/local/biotools/krisp_ncov_assembly/bin/gd_batch_submit.sh -r "RUN88" -t "PE" -s 20 -i "20m"

## gd submit one
/usr/local/biotools/krisp_ncov_assembly/bin/gd_submit.sh  SCV2-GS-9509 "."  "PE"

## repeat many i.e  -p Y
/usr/local/biotools/krisp_ncov_assembly/bin/gd_batch_submit.sh -r "RUN84" -f "repeat" -t "ONT" -s 20 -i "15m" -p Y
/usr/local/biotools/krisp_ncov_assembly/bin/gd_batch_submit.sh -r "RUN87" -f "repeat" -t "PE" -s 10 -i "1m" -p Y

##repeat one
/usr/local/biotools/krisp_ncov_assembly/bin/gd_submit_repeat.sh SCV2-GS-9509 "."
/usr/local/biotools/krisp_ncov_assembly/bin/gd_submit_repeat.sh bc1_001 "." "PE"
/usr/local/biotools/krisp_ncov_assembly/bin/gd_submit_repeat.sh bc1_001 "." "SE"


## GD download
 mkdir ../../UCT/run17 && /usr/local/biotools/krisp_ncov_assembly/bin/download_output_batch.sh ../../UCT/run17/job_ids.txt carolyn/run17
 

 
 /usr/local/biotools/krisp_ncov_assembly/bin/process-nt.sh
 
 /analyses2/houriiyah/nCoV_genomes/GD/outputs/carolyn/run17
 
 scp -r /analyses2/houriiyah/nCoV_genomes/GD/outputs/carolyn/run17/*NC_045512.2_1-alignment-nt.fasta .
 sed -i '' "s/\./N/g" run17_consensus.fasta 
 sed -i  '' "s/-//g" > run_consensus17_v1.fasta
 
 #split a fasta file into 6 new files of relatively even size (https://pypi.org/project/pyfasta/#command-line-interface)
 pyfasta split -n 6 original.fasta
 
 /usr/local/biotools/krisp_ncov_assembly/bin/gd_batch_submit.sh -r "RUN121" -t "ONT" -s 10 -i "15m"
 
 #kill all processes owned by sanjames.
 killall --user sanjames     
         

for i in `cat SampleIDs.txt`;  do  on=$(echo $i | cut -d "," -f1); nn=$(echo $i | cut -d "," -f2);  rename "${on}" "${nn}" ${on}*;  done

## change pairend fastq ids
for i in `cat SampleIDs.txt`;  do  on=$(echo $i | cut -d "," -f1); nn=$(echo $i | cut -d "," -f2);   
 for sample in `ls ${on}*`; do
	rename "${on}" "${nn}" ${sample};
 done
done                                 


/usr/local/biotools/krisp_ncov_assembly/bin/gd_batch_submit.sh -r "RUN120" -t "PE" -s 20 -i "20m"
/usr/local/biotools/krisp_ncov_assembly/bin/gd_submit_repeat.sh K014462-comb "." "PE"


gd_batch_submit.sh -r "RUN161" -t "PE" -s 20 -i "20m"
download_output_batch.sh job_ids.txt .

diff  mapped_ids.sort.txt all_ids.sort.txt | grep '^>' | cut -c 3-   ###get difference in the two lists
seqkit grep -r -f un_mapped_ids.txt run_consensus_v3.1.fasta > un_mapped.fasta

ps auxwww | grep watcher
ps auxwww | grep gdp #use this


!L0v3L!nux

#Check for mutation in global seqs
https://nextstrain.org/ncov/global?c=gt-nuc_28275

## Drop 12 characters from the end
rename -n 's/(.*).{12}/$1/' *

=ROUND(((29903-K2)/29903)*100;0)
=ROUND(((29903-G2)/29903)*100;0)
=ROUND(((AL2-AK2)/29903)*100;0)

/analyses2/houriiyah/nCoV_genomes/GD/outputs/run60_test/nt-alignment-process-test/process-nt.sh
### User accounts:
sudo useradd -m -d "/data1/users/home/anmol" anmol

sudo usermod -aG wheel anmol


#remove special characters from file name
rename -n 's/[^a-zA-Z0-9_-]//' *.fastq

grep ">" run123_consensus_final.fasta | sed  "s#>##g" > run123_ids.txt
for i in `cat run123_ids.txt`;  do   nn=$(echo $i | cut -d "/" -f2);  sed -i '' "s#${i}#${nn}#g" run123_consensus_final.fasta;  done
cat run120_consensus_final.fasta <(echo) run122_consensus_final.fasta <(echo) run123_consensus_final.fasta  > all_3_runs.fasta   # paste file content with new line


sudo chmod -R 777 /analyses2/houriiyah/nCoV_genomes/GD

rm -Rf /analyses2/houriiyah/nCoV_genomes/GD/watcher2/rejected/illumina-paired/*
rm -Rf /analyses2/houriiyah/nCoV_genomes/GD/watcher2/rejected/illumina-single/*
rm -Rf /analyses2/houriiyah/nCoV_genomes/GD/watcher2/processed/illumina-paired/*
rm -Rf /analyses2/houriiyah/nCoV_genomes/GD/watcher2/processed/illumina-single/*
rm -Rf /analyses2/houriiyah/nCoV_genomes/GD/watcher2/new/illumina-paired/*
rm -Rf /analyses2/houriiyah/nCoV_genomes/GD/watcher2/new/illumina-single/*
rm -Rf /analyses2/houriiyah/nCoV_genomes/GD/watcher2/new/ont/*
rm -Rf /analyses2/houriiyah/nCoV_genomes/GD/watcher2/processed/ont/*
rm -Rf /analyses2/houriiyah/nCoV_genomes/GD/watcher2/rejected/ont/*

#watcher 3
rm -Rf /analyses2/houriiyah/nCoV_genomes/GD/watcher3/rejected/illumina-paired/*
rm -Rf /analyses2/houriiyah/nCoV_genomes/GD/watcher3/rejected/illumina-single/*
rm -Rf /analyses2/houriiyah/nCoV_genomes/GD/watcher3/processed/illumina-paired/*
rm -Rf /analyses2/houriiyah/nCoV_genomes/GD/watcher3/processed/illumina-single/*
rm -Rf /analyses2/houriiyah/nCoV_genomes/GD/watcher3/new/illumina-paired/*
rm -Rf /analyses2/houriiyah/nCoV_genomes/GD/watcher3/new/illumina-single/*
rm -Rf /analyses2/houriiyah/nCoV_genomes/GD/watcher3/new/ont/*
rm -Rf /analyses2/houriiyah/nCoV_genomes/GD/watcher3/processed/ont/*
rm -Rf /analyses2/houriiyah/nCoV_genomes/GD/watcher3/rejected/ont/*
rm -Rf /analyses2/houriiyah/nCoV_genomes/GD/watcher3/processed/*

ps auxwww | grep gdp

screen -r 93539

./gdp.py -c config/config.yaml watch .

tail -f /analyses2/houriiyah/nCoV_genomes/GD/watcher2/screenlog.0



for i in `cat runs131_134_seqIds.txt`;  do   on=$(echo $i | cut -d "," -f1); nn=$(echo $i | cut -d "," -f2);  sed -i '' "s#${on}#${nn}#g" runs131_134_gisaid.fasta;  done
for i in `cat africa_seq_names.txt`;  do   on=$(echo $i | cut -d "," -f1); nn=$(echo $i | cut -d "," -f2); sed -i ''  "s#${on}#${nn}#g" data/nextstrain_africa_sequences.fasta;  done



for id in `cat seq_ids.txt`; do 
find ../../GD/outputs/run232/ -name "*${id}*.bam" -type f -exec cp {} ./ \;
done

for id in `cat sample_ids.txt`; do find ../../GD/outputs/run236_gridion/ -name "*${id}*-bam.zip" -type f -exec cp {} ./nanopore \;; done

https://rdrr.io/cran/phylotools/man/rename.fasta.html

seqkit replace --quiet -p '^(\d+)_(\w+)' -r '{kv}${2}'  -k africa_seq_names2.txt data/nextstrain_africa_sequences.fasta

for id in `cat find.txt`; do 
find ../../GD -name "${id}*fastq.gz" -type f -exec cp {} ./ \;
done

##Cat multiple files separated by new line
for f in *.txt; do (cat "${f}"; echo) >> finalfile.txt; done


for i in `cat gisaid_ids.txt`;  do on=$(echo $i | cut -d "," -f1);  nn=$(echo $i | cut -d "," -f2);  sed -i '' "s#${on}#${nn}#g" run155_161_gisaid_consensus_n121.fasta;  done


##Transfer to screen: https://www.linkedin.com/pulse/move-running-process-screen-bruce-werdschinski/
ctrl+Z
bg
disown %1
screen
[Ubuntu: echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope]
reptyr $(pgrep treetime)

for id in `cat ahri_seq_ids.txt`; do 
find ../../GD -name "*${id}*-NC_045512.2_1-consensus_alignment_sorted.bam" -type f -exec cp {} ./ \;
done

for id in `cat all_PID27_fastq_ids.txt`; do 
find ../../ -name "*${id}*.fastq.gz" -type f -exec cp {} ./ \;
done

grep -lir 'K008288' . | xargs cp -t sanger_sequenced



## in R
sapply(str_split(rownames(virusname), "/", n = 3, simplify = FALSE), `[`, 2) #stringr
eduan.tree.tip.date = gsub("/", "", strapplyc(eduan.tree.tip.label, "\\/\\d+-\\d+-\\d+", simplify = TRUE)) #gsubfn - extract date from string.

gd_batch_submit.sh -r "RUN180" -t "PE" -s 20 -i "20m"
gd_batch_submit.sh -r "CAF304" -t "SE" -s 20 -i "20m"

for i in `cat gisaid_ids.txt`;  do on=$(echo $i | cut -d "," -f1);  nn=$(echo $i | cut -d "," -f2);  sed -i '' "s#${on}#${nn}#g" CAF_run296_299_304_consensus_gisaid_n261.fasta;  done


rename -- -NC _NC *-NC_045512.2_1-alignment-contigs.fasta
process-nt-dash.sh

for i  in `ls *.gz`; do id=$(echo $i | cut -d "_" -f 3); mv $i "${id}_SE.fastq.gz"  ; done
for i  in `ls *.gz`; do id=$(echo $i | cut -d "_" -f 3); mv $i ${id}  ; done

https://www.baeldung.com/linux/xz-compression #refer for multiple files
xz -dv data.csv.xz  #decompress
xz -v1 data.csv # compress

To enter ^M, type CTRL-V, then CTRL-M. That is, hold down the CTRL key then press V and M in succession.
sed -e  "s/^M/\n/g" SA_BIG_cluster.txt > SA_BIG_cluster_clean.txt 

https://www.ilovepdf.com/  #compress pdf

https://serverfault.com/questions/448647/symbolic-link-and-filezilla-over-sftp
sudo mount --bind /data1/sftp/files /var/sftp/files/


for i in `cat run224_seqIds.txt`;  do on=$(echo $i | cut -d "," -f1);  nn=$(echo $i | cut -d "," -f2);  sed -i '' "s#${on}#${nn}#g" run_consensus_v3.fasta; done

## remove part of seqNames
sed -i '' "s/_ONT//g" run366_barc_3008_n52.fasta #mac
sed -i "s/_ONT//g" run366_barc_3008_n52.fasta #linux

 /analyses2/houriiyah/nCoV_genomes/GD/watcher2 
 $ ./gdp.py -c config/config.yaml download-analysis 4097d576-2f2f-4ab6-8d64-d80966bef9d6 -d downloads/test/
 $ gdp_download_batch.sh downloads/test/test.txt downloads/test
 
 $ ./gdp.py -c config/config.yaml watch
 
 
 $ ./gdp.py -c config/config.yaml upload-files list.txt -d downloads/test/
 
  opts.files_list, Path(opts.dest), Action[config.get('action', 'Context')], file_regex, action)
 
 ./gdp.py -c config/config.yaml watch .
 
 gdp_submit.sh  K025576-2 "."  "PE"
 
 gdp_batch_submit.sh -r "RUN23X" -t "PE" -s 20 -i "15m"
 
 gdp_batch_submit.sh -r "RUN365" -t "ONT" -s 15 -i "10m"
 
 gdp_batch_submit.sh -r "RUN214" -t "PE" -s 3 -i "1s"
 gdp_batch_submit.sh -r "RUN346" -t "PE" -s 10 -i "10s"
 
 /mnt/isilon/abbott
 
 ## watcher4
cd /analyses2/houriiyah/nCoV_genomes/GD/watcher4 &&  source watcher-env/bin/activate

python gdp.py -c config/config.yaml --threads 1 --upload-only upload-files  /analyses2/houriiyah/nCoV_genomes/minion_96_protocol/run425/temp/*.fastq.gz 
python gdp.py -c config/config.yaml --threads 1 --upload-only upload-files  /analyses2/houriiyah/nCoV_genomes/CERI/abbott_meta_b03_110123/temp/*.fastq.gz 
python gdp.py -c config/config.yaml --upload-only upload-files  /analyses2/houriiyah/nCoV_genomes/minion_96_protocol/run485/temp/*.fastq.gz
python gdp.py -c ./config/config_bact.yaml upload-files --threads 1 --upload-only  /analyses2/data/Cholera/temp/*.fastq.gz

python gdp.py -c config/config.yaml --threads 4 --upload-only upload-files  /analyses2/houriiyah/Influenza/KRISP_Influenza_14122023/temp/*.fastq.gz



cp /mnt/isilon/abbott/abbott_meta_b04_170123/K052005*.gz ../../CERI/abbott_meta_b05_190123/

 #Strip special characters from file name
 rename $'\r' '' * #https://unix.stackexchange.com/questions/60779/how-do-i-remove-carriage-returns-from-directory-names

/usr/bin/rename -- _S -R_S *.gz

### Run results:
../GD/watcher2/new/illumina-paired/AMPNC203/AMPNC203-NC_045512.2-0-0-alignment-nt.fasta and AMPNC203-bam.zip

for id in `cat run206_sample_ids.txt`; do 
find ../GD/watcher2/new/illumina-paired/${id} -name "${id}*-NC_045512.2-0-0-alignment-nt.fasta" -type f -exec cp {} ../GD/outputs/run206 \;
find ../GD/watcher2/new/illumina-paired/${id} -name "${id}*-bam.zip" -type f -exec cp {} ../GD/outputs/run206 \;
done
 
for id in `cat run206_sample_ids.txt`; do 
rm -Rf ../GD/watcher2/new/illumina-paired/${id} ../GD/watcher2/rejected/ ../GD/watcher2/processed/illumina-paired/${id};
done

for id in `cat run206_sample_ids.txt`; do 
rm -Rf ../GD/watcher2/new/illumina-paired/${id}
done


/watcher2/new/illumina-paired/AMPNC203/AMPNC203-NC_045512.2-0-0-consensus-nt.fasta

../GD/watcher2/new/illumina-paired/K025616/

mkdir -p ../GD/outputs/run206

scorpio haplotype -n 'Omicron (B.1.1.529-like)' -i ~/temp/Collaborations/covid/ref/NC_045512.2.fasta --output-counts --append-genotypes

tail -f /analyses2/houriiyah/nCoV_genomes/GD/watcher2/screenlog.0


https://codon2nucleotide.theo.io/

#There are 64 different trinucleotide codons: 61 specify amino acids and 3 are stop codons (i.e., UAA, UAG and UGA)

for i in `cat BarcodeMappings.txt`;  do  on=$(echo $i | cut -d "," -f1); nn=$(echo $i | cut -d "," -f2);  mv "${on}_ONT.fastq.gz" "${nn}_ONT.fastq.gz";  done

for i in `cat BarcodeMappings.txt`;  do  on=$(echo $i | cut -d "," -f1); nn=$(echo $i | cut -d "," -f2);  rename -- "${on}" "${nn}" *.*;  done

nextalign run --input-ref <INPUT_REF> --output-all <OUTPUT_ALL> --input-gene-map <INPUT_GENE_MAP> --genes <GENES>... --output-dir <OUTPUT_DIR> --include-reference --output-fasta <OUTPUT_FASTA> --output-basename <OUTPUT_BASENAME> <INPUT_FASTAS>...



nextalign run -r ~/temp/Collaborations/covid/ref/NC_045512.2.fasta run_161_reactions_all.fasta \
 --output-all na_output  \
 --input-gene-map ~/temp/Collaborations/covid/ref/genemap.gff \
 --genes S \
 --include-reference \
 --output-fasta nextaligned_run161_reactions_all.fasta \
 --output-basename nextalign
 

augur tree --alignment C.36_seqs.gene.S.fasta --output C.36_seqs.gene.S_augur.tree --nthreads 1 --tree-builder-args="-m GTR -b 100"


# Remove identical sequences
seqkit rmdup --by-seq --ignore-case background_sequences.fasta -o background_sequences_uniq.fasta --dup-seqs-file background_sequences_dup.fasta --dup-num-file background_sequences_dup.text
seqkit rmdup --ignore-case all.seqs.fasta -o all.seqs_uniq.fasta --dup-seqs-file all.seqs_dups.fasta --dup-num-file all.seqs_dups.txt

hyphy gard --alignment recombination_seqs_uniq.fasta --model GTR


https://www.medrxiv.org/content/10.1101/2021.08.21.21262393v2

for i in `cat SampleIDs.txt`;  do  on=$(echo $i | cut -d "," -f1); nn=$(echo $i | cut -d "," -f2);  mv "${on}.fastq.gz" "${nn}_ONT.fastq.gz";  done
for i in `cat SampleIDs.txt`;  do  on=$(echo $i | cut -d "," -f1); nn=$(echo $i | cut -d "," -f2);  mv "${on}.fastq.gz" "${nn}.fastq.gz";  done


/Applications/biotools/CodonCounter/bam_nuc_codon_count.py --help
/Applications/biotools/CodonCounter/bam_nuc_codon_count.py -bam  K032424-NC_045512.2_1-consensus_alignment_sorted_iq.bam -ref ~/temp/Collaborations/covid/ref/NC_045512.2.fasta -gff ~/temp/Collaborations/covid/ref/genemap_anmol.gff -coor_range 21563-25384

/Applications/biotools/CodonCounter/bam_nuc_codon_count.py -bam ../N47297_sorted.bam.gz -ref ~/temp/Collaborations/covid/ref/NC_045512.2.fasta -gff ~/temp/Collaborations/covid/ref/genemap_anmol.gff -coor_range 21563-25384
/Applications/biotools/CodonCounter_v1.0/CodonCounterx.py -bam fixed -ref ~/temp/Collaborations/covid/ref/NC_045512.2.fasta -gff ~/temp/Collaborations/covid/ref/genemap_anmol.gff -coor_range 21563-25384

/Applications/biotools/CodonCounter_v1.0/CodonCounterx.py --output_type both -bam N46611_fixed.bam -ref ~/temp/Collaborations/covid/ref/NC_045512.2.fasta -gff ~/temp/Collaborations/covid/ref/genemap_anmol.gff -coor_range 21563-25384 -o  N46611-2_ccOut.csv

parallel '/Applications/biotools/CodonCounter_v1.0/CodonCounterx.py --output_type codon -bam {}_fixed_sorted.bam -ref ~/temp/Collaborations/covid/ref/NC_045512.2.fasta -gff ~/temp/Collaborations/covid/ref/genemap_anmol.gff -coor_range 21563-25384 -o  {}_codonFreqsOut.csv' ::: $(ls *_fixed_sorted.bam | cut -d "_" -f1)
parallel '/Applications/biotools/CodonCounter_v1.0/CodonCounterx.py --output_type codon -bam {}_fixed_sorted.bam -ref ~/temp/Collaborations/covid/ref/NC_045512.2.fasta -gff ~/temp/Collaborations/covid/ref/genemap_anmol.gff -coor_range 266-13468 -o  {}_ORF1a_codonFreqsOut.csv' ::: $(ls *_fixed_sorted.bam | cut -d "_" -f1)
parallel '/Applications/biotools/CodonCounter_v1.0/CodonCounterx.py --output_type nuc -bam {}_fixed_sorted.bam -ref ~/temp/Collaborations/covid/ref/NC_045512.2.fasta -gff ~/temp/Collaborations/covid/ref/genemap_anmol.gff -coor_range 266-13468 -o  {}_ORF1a_nucFreqsOut.csv' ::: $(ls *_fixed_sorted.bam | cut -d "_" -f1)

parallel -j 25 '/Applications/biotools/CodonCounter_v1.0/CodonCounterx.py --output_type nuc -bam {1}_fixed_sorted.bam -ref ~/temp/Collaborations/covid/ref/NC_045512.2.fasta -gff {2} -coor_range 266-13468 -o  {1}_ORF1a_nucFreqsOut.csv' ::: $(ls *_fixed_sorted.bam | cut -d "_" -f1) ::: ~/temp/Collaborations/covid/ref/genemap_anmol.gff


#https://mgymrek.github.io/pybamview/usage.html
pybamview --bam N47297-2_fixed_sorted.bam --ref ~/temp/Collaborations/covid/ref/NC_045512.2.fasta

~/temp/Collaborations/covid/ref/NC_045512.2.fasta ~/temp/Collaborations/covid/ref/sars-cov-2.fasta

##Re-map ont
samtools fastq K045314-consensus_alignment_sorted.bam > K045314_ONT.fastq
minimap2 -a -x map-ont -t 4  /Users/sanem/temp/Collaborations/covid/ref/NC_045512.2.fasta K045314_ONT.fastq | samtools view -bS -F 4 - | samtools sort -o K045314_ONT.bam - 

export ccPath=/Applications/biotools/CodonCounter
$ccPath/bam_nuc_codon_count.py -bam  K043938-consensus_alignment_sorted.bam -ref ~/temp/Collaborations/covid/ref/NC_045512.2.fasta -gff ~/temp/Collaborations/covid/ref/genemap_anmol.gff -coor_range 21563-25384

NextClade
https://docs.nextstrain.org/projects/nextclade/en/stable/user/nextclade-cli.html
/analyses2/data/nextclade/data/sars-cov-2 #dataset on the server
nextclade \
   --in-order \
   --input-fasta omicron.sequences.fasta \
   --input-dataset /Applications/data/sars-cov-2 \
   --output-tsv output/nextclade.tsv \
   --output-tree output/nextclade.auspice.json \
   --output-dir output/ \
   --output-basename nextclade
   

https://www.metagenomics.wiki/tools/samtools/number-of-reads-in-bam-file
# get the total number of reads of a BAM file (may include unmapped and duplicated multi-aligned reads)

samtools view -c SAMPLE.bam

# counting only mapped (primary aligned) reads

samtools view -c -F 260 SAMPLE.bam

### GISAID - Houriiyah Script
1. Replace the input files - metadata and good IDs. Examples given. 

2. When you get the output GISAID file, open it and clean up the columns - there will be some empty ones. And add the name of your fasta file. Add the nextclade to an additional tab

3. The script also produces the file for renaming the sequences (rename.txt) - just open it and remove the first line, it adds a zero on the first line. If you do not have the code for renaming the sequences, here it is. 

for i in `cat rename.txt`;  do  on=$(echo $i | cut -d "," -f1);  nn=$(echo $i | cut -d "," -f2);  sed -i '' "s#$on#$nn#g" run_consensus_NHLS_vFinal.fasta;  done
for i in `cat rename.txt`;  do  on=$(echo $i | cut -d "," -f1);  nn=$(echo $i | cut -d "," -f2);  sed -i '' "s#$on#$nn#g" run427_428_consensus_gisaid_n57.fasta;  done


FastTree -gtr -nt -boot 100 ethiopia_nextalign.aligned.fasta > eth_no_tree1.nwk

python -m venv venv --prompt="client-old" ##client-old as the name of the virtual environment

su - bryant #The (-) switch has the same effect as logging into a system directly with that user account. In essence, you become that user.



for i in `cat rename.txt`;  do  on=$(echo $i | cut -d "," -f1);  nn=$(echo $i | cut -d "," -f2);  sed -i '' "s#$on#$nn#g" new_tree_renamed.nwk;  done


https://docs.nextstrain.org/projects/nextclade/en/stable/user/datasets.html ##get datasets
https://github.com/nextstrain/nextclade/blob/master/docs/dev/developer-guide.md  ## Install from source and run
curl -fsSL "https://github.com/nextstrain/nextclade/releases/latest/download/nextclade-Linux-x86_64" -o "nextclade" && chmod +x nextclade

NEXTCLADE_VERSION=2.0.0-alpha.5 sudo curl -fsSL "https://github.com/nextstrain/nextclade/releases/download/nextclade-${NEXTCLADE_VERSION}/nextclade-Linux-x86_64" -o "nextclade" && sudo chmod +x nextclade

https://github.com/nextstrain/nextclade/releases/download/2.0.0-alpha.5/nextalign-x86_64-unknown-linux-gnu

sudo curl -fsSL "https://github.com/nextstrain/nextclade/releases/download/2.0.0-alpha.5/nextalign-x86_64-unknown-linux-gnu" -o "nextclade" && sudo chmod +x nextclade


/usr/local/biotools/nextclade-2.0.0-alpha.5/target/release/nextclade run \
  --input-fasta=gisaid_pox_2022_06_07_12.fasta \
  --input-dataset=data/monkeypox/ \
  --output-fasta='out/nextclade.aligned.fasta' \
  --output-tsv='out/nextclade.tsv' \
  --output-tree='out/nextclade.tree.json' \
  --in-order \
  --seed-spacing 1000 \
  --max-indel 10000
  
  
  /usr/local/biotools/nextclade-2.0.0-alpha.5/target/release/nextalign run \
  --input-fasta=gisaid_pox_2022_06_07_12.fasta \
  --input-ref=data/monkeypox/reference.fasta \
  --input-gene-map=data/monkeypox/genemap.gff \
  --output-fasta='out/nextclade.aligned.fasta' \
  --in-order \
  --seed-spacing 1000 \
  --max-indel 10000
  
  
  ## Nextclade Sanem Mac:
  /Applications/biotools/nextclade dataset get --name 'sars-cov-2' --output-dir '/Applications/data/sars-cov-2'

/Applications/biotools/nextclade run \
   --input-dataset /Applications/data/sars-cov-2 \
   --output-tsv=output/nextclade.tsv \
   /Applications/data/sars-cov-2/sequences.fasta #change to your dataset

  
  ### Dashboard related commands:
  ## GIT: https://www.theserverside.com/blog/Coffee-Talk-Java-News-Stories-and-Opinions/git-push-new-branch-remote-github-gitlab-upstream-example#:~:text=Push%20a%20new%20Git%20branch%20to%20a%20remote%20repo&text=Perform%20a%20git%20push%20with,branch%20to%20the%20remote%20repo
  
  ## Directory: /Applications/streamlit/live/SARS-Cov-2-Africa-dashboard
  git checkout dev or git switch -c dev ## where dev is the development branch
  git status
  git add -A
  git commit -m "format variant table - space sublineages"
  git push --set-upstream origin dev ### only first time
  git push origin ##subsequently
  
  https://github.com/microsoft/timelinestoryteller
  Prof. Emmanuel James San
  https://vercel.com/new/templates
  
  https://stackoverflow.com/questions/11774262/how-to-extract-the-fill-colours-from-a-ggplot-object
  
  /data/software/GlobalProtect_UI_rpm-5.1.1.0-17.rpm
  /data/software/GlobalProtect_UI_deb-5.1.1.0-17.deb
  
  #Rename / modify tree nodes
  for i in `cat rename.txt`;  do  on=$(echo $i | cut -d "," -f1);  nn=$(echo $i | cut -d "," -f2);  sed -i '' "s#$on#$nn#g" new_tree_renamed.nwk;  done
  
 ## Color conversion
  https://www.farb-tabelle.de/en/rgb2hex.htm?q=coral4  
  
./sc2rf.py K045228.sequences.nextaligned.fasta -b 1-10 --show-private-mutations --clades BA.1 B.1.672 --enable-deletions -n 40


https://nextstrain.org/fetch/genome.ucsc.edu/trash/ct/subtreeAuspice1_genome_23d50_c128a0.json?branchLabel=aa%20mutations&c=gt-nuc_4690&label=nuc%20mutations:A28330G

# Notepad++ remove blanklines - find and replace: [\n\r]+$


coverage = ((alignment_end - alignment_start) - total_missing - total_non_acgtns) / ref_len;

## Ethiopia
treetime --aln nextalign.aligned.fasta --tree nextalign.aligned.fasta.treefile --dates metadata.tsv --clock-rate 0.0008 --reroot oldest --clock-std-dev 0.0004 > log.txt

sudo -H -u sanjames bash -c '/analyses/software/miniconda3b/bin/conda init bash' 

3Du@n@123

treetime --aln nextalign.aligned.fasta --tree reference_tree.nwk --dates selected_metadata.tsv --clock-rate 0.0008 --clock-std-dev 0.0004 --reroot oldest --confidence > log.txt

ba4and5_output_baseline_0.0005_seed1234	4204
ba4and5_output_baseline_0.0005_seed2007	7266
ba4and5_output_baseline_0.0005_seed3219	10317
ba4and5_output_baseline_0.0005_seed4321	13362
ba4and5_output_baseline_0.0005_seed5432 16411
ba4and5_output_baseline_0.0005_seed6543	19489
ba4and5_output_baseline_0.0005_seed7654 23116
ba4and5_output_baseline_0.0005_seed8765 26211
ba4and5_output_baseline_0.0005_seed9876 29239

#https://stackoverflow.com/questions/7106012/download-a-single-folder-or-directory-from-a-github-repo
svn export https://github.com/TheEconomist/covid-19-excess-deaths-tracker.git/trunk/output-data/excess-deaths

xz -d metadata_tsv_2022_10_20.tar.xz #

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/Users/sanem/miniconda3/lib


## Gisaid metadata:
~/temp/Collaborations/covid/GISAID/global_metadata/metadata_2022-02-07_19-17.tsv.gz

for id in `cat seqs.txt`; do 
find /analyses2/houriiyah/nCoV_genomes/ -name ${id}*.gz -type f -exec cp {} ./ \;
done

bam2bed < foo.bam \
    | cut -f 12 \
    | awk '{print length($0)}' \
    > mapped_read_lengths.txt
    
## generate paper.pdf  
    docker run --platform linux/amd64 --rm \
    --volume $PWD/manuscript:/data \
    --user $(id -u):$(id -g) \
    --env JOURNAL=joss \
    openjournals/inara

ssh -o PubkeyAuthentication=no -o PreferredAuthentications=password   sanjames@mrcad.mrc.ac.za@krisp.mrc.ac.za
scp  -o PubkeyAuthentication=no -o PreferredAuthentications=password  SAxbb15_new_strains.fasta sanjames@mrcad.mrc.ac.za@krisp.mrc.ac.za:/analyses2/eduan/XBB.1.5_2023-02-01/


https://stackoverflow.com/questions/26319567/use-grepl-to-search-either-of-multiple-substrings-in-a-text
You could paste the genres together with an "or" | separator and run that through grepl as a single regular expression.
x <- c("Action", "Adventure", "Animation")
my_text <- c("This one has Animation.", "This has none.", "Here is Adventure.")
grepl(paste(x, collapse = "|"), my_text)
# [1]  TRUE FALSE  TRUE

https://www.biostars.org/p/93494/
prefetch-orig.2.11.0 $(<ref_ids.txt)
fastq-dump-orig.2.11.0 --split-3 --gzip $(<ref_ids.txt)


KRISP Gridion # https://askubuntu.com/questions/178909/not-enough-space-in-var-cache-apt-archives 
sudo mv -i /var/cache/apt /data/TEMP/
sudo ln -s /data/TEMP/apt /var/cache/apt

# Run the upgrade and install. After you are done you can switch back to normal with:

sudo apt-get clean
sudo unlink /var/cache/apt
sudo cp -r /data/TEMP/apt /var/cache

/usr/local/biotools/beast2/bin/beast

## show line 
less -NS file.txt #show line number.

## https://serverfault.com/questions/127904/newline-separated-xargs
## Install via ports
brew install findutils

grep ">" selected_uniq_seqs_g_augur_aln_cluster.fasta173 | shuf |  head -n 150 | sed "s/>//" | gxargs -d '\n' -I {} seqkit grep -np {} selected_uniq_seqs_g_augur_aln_cluster.fasta173 > down_sampled_0.9/selected_uniq_seqs_g_augur_aln_cluster.fasta173


# https://stackoverflow.com/questions/69413931/how-do-i-find-all-sequence-lengths-in-a-fasta-dataset-without-using-the-biopytho
# find all Sequence Lengths in a multi-FASTA file
# Need the emboss package (install via conda): mamba install emboss

infoseq -auto -only -name -length -noheading file.fasta

## vi find and replace all. https://linuxize.com/post/vim-find-replace/
:%s/:/_/
:%s/:/_/g [all]

## jphmm:
/Users/sanem/temp/CERI/TechnicalWorkingGroup/Recombination/jphmm/jpHMM/example/LDA

/Users/sanem/temp/CERI/TechnicalWorkingGroup/Recombination/jphmm/jpHMM/src

cp jpHMM /usr/local/bin/

/Users/sanem/jpHMM/src/jpHMM -i AL.fas -s Query.fas -v HIV -j 1e-06 -a nucleic_Alphas_estimated_HIV.txt -b transition_priors.txt -e EP.txt -t TP.txt -c cons.txt

# usage: jpHMM
# 	[ -s  file containing the query sequence(s) ] 
# 	[ -v  type of the given sequences (HIV or HCV)]
# 
# 	optional arguments:
# 
# 	[ -a  (opt.) file containing the priors for the estimation of the emission probabilities (include path to file here or with -P)] 
# 	[ -b  (opt.) file containing the priors for the estimation of the transition probabilities] 
# 	[ -i  (opt.) file containing the given multiple sequence alignment  (include path to file here or with -I)] 
# 	[ -j  (opt.) probability of a jump from one subtype to any other subtype (default: HIV: 1e-9, HBV: 1e-7) ]
# 	[ -B  (opt.) beam-width for the beam algorithm    (default: 1e-20) ]
# 	[ -P  (opt.) input directory for emission priors (default: ./priors/, if not -a chosen) ]
# 	[ -I  (opt.) input directory for alignment file (default: ./input/, if not -i chosen) ]
# 	[ -o  (opt.) output directory for result files  (default: ./output/) ]
# 	[ -Q  (opt.) algorithm to speed up Viterbi algorithm (beam_search or blat) (default: beam_search) ]
# 	[ -C  (opt.) circular genome type: if chosen: circular genomes    (default: non-circular genomes) ]
# 	[ -J  (opt.) kind of jumps in HMM (quadratic (from each ST to each ST) or linear (via a mute jump state)) (default: quadratic) ]
# 
# 	for usage of model probabilities that have been determined externally:
# 
# 	[ -e  (opt.) file containing the (external) emission probabilities ]
# 	[ -t  (opt.) file containing the (external) transition probabilities ]
# 	[ -c  (opt.) file containing the (external) consensus columns ]
	
	
	jpHMM -s cluster85.fasta -v HIV  -a /Users/sanem/temp/CERI/TechnicalWorkingGroup/Recombination/jphmm/jpHMM/priors/emissionPriors_HIV.txt
	
	mv jpHMM ~/
	
	cd ~/temp/CERI/TechnicalWorkingGroup/Recombination/Tutorial/17/
    
    Failure of the transition priors input file.
    libc++abi: terminating with uncaught exception of type Error

    jpHMM -s cluster85.fasta -v HIV -a ~/jpHMM/priors/emissionPriors_HIV.txt
	
	## SCP multiple files
	
	ls -1 *-ONT_ONT | cut -d "-" -f 1 |  uniq | grep K04 > seq_ids.txt
	scp sanjames@mrcad.mrc.ac.za@krisp.mrc.ac.za:/analyses2/data/Pangea_SJ/aga_hiv/aln/clusters/cluster85/\{cluster85.fasta2,cluster85.fasta11,cluster85.fasta14} .
	

#sed - modify begining of a line.
#https://linuxconfig.org/add-character-to-the-beginning-of-each-line-using-sed

## https://stackoverflow.com/questions/67744604/what-does-pipe-greater-than-mean-in-r
##    |> is the base R "pipe" operator. It was new in version 4.1.0.

pip install . --force-reinstall


http://lonelyjoeparker.com/wp/?page_id=274#beast-note

perl -pi.bak -e 's/[\n\r\R]+//gms' ~/temp/Collaborations/HIV/Marcel/beast_xlms/SC_CC/trees/bb-format/prot_seq_Cameroun_CRF02_AG_reduit+Gabon+EquatorialGuinea_finalV5_wDates_SC_CC_200ML_bb.trees
sed -i '' "s/\[[^]]*\]//g"  ~/temp/Collaborations/HIV/Marcel/beast_xlms/SC_CC/trees/bb-format/prot_seq_Cameroun_CRF02_AG_reduit+Gabon+EquatorialGuinea_finalV5_wDates_SC_CC_200ML_bb.trees
perl -pi.bak -e 's/\;/\;\n/g' ~/temp/Collaborations/HIV/Marcel/beast_xlms/SC_CC/trees/bb-format/prot_seq_Cameroun_CRF02_AG_reduit+Gabon+EquatorialGuinea_finalV5_wDates_SC_CC_200ML_bb.trees
perl -pi.bak -e 's/=\ /=\ \[\&\R\]/gms' ~/temp/Collaborations/HIV/Marcel/beast_xlms/SC_CC/trees/bb-format/prot_seq_Cameroun_CRF02_AG_reduit+Gabon+EquatorialGuinea_finalV5_wDates_SC_CC_200ML_bb.trees

java -jar ~/temp/Collaborations/HIV/Marcel/BaTS_beta/BaTS_beta.jar single ~/temp/Collaborations/HIV/Marcel/beast_xlms/SC_CC/trees/bb-format/prot_seq_Cameroun_CRF02_AG_reduit+Gabon+EquatorialGuinea_finalV5_wDates_SC_CC_200ML_bb.trees 1000 3


/analyses2/data/SJ/BackUp/Mac/sanem/temp/Courses and Trainings
ufsngsworkshop2023@gmail.com


ls -1 *.bam | rev | cut -c5- | rev


virulign /Applications/biotools/virulign/references/HIV/HIV-HXB2-gag.xml  --exportAlphabet AminoAcids  cluster85wRefs_uniq_aln.fasta13.rdp5.gag_rrr.fas > cluster85wRefs_uniq_aln.fasta13.rdp5.gag_aa_rrr.fas 2> cluster85wRefs_uniq_aln.fasta13.rdp5.gag_aa_rrr.fas.err

virulign /Applications/biotools/virulign/references/HIV/HIV-HXB2-gag.xml cluster85wRefs_uniq_aln.fasta13.rdp5.gag_rrr.fas --exportKind GlobalAlignment  --exportAlphabet AminoAcids   > cluster85wRefs_uniq_aln.fasta13.rdp5.gag_aa_rrr.fas 2> cluster85wRefs_uniq_aln.fasta13.rdp5.gag_aa_rrr.fas.err

Nucleotides

sed '/^>/! s/\^//g' <seq2.fa >seq3.fa

# This triggers the substitution command s/\^//g (which I believe you tried to use but got the order of the slashes slightly wrong) on any line that does not start with a > character. The substitution removes any ^ character on the line by repeatedly replacing it with nothing until no such character is left.
# The ^ needs to be escaped since it otherwise would act as an anchor, anchoring the regular expression to the start of the line.

#remove-line-breaks-in-a-fasta-file
seqkit seq -w 0 input.fasta > output.fasta # works for multifaster


seqtk seq -l 0 test_unwrap_in.fa > test_unwrap_out.fa # works for one sequence

##### Seq alignment trimming
##### http://trimal.cgenomics.org/getting_started_with_trimal_v1.2
##### https://web.natur.cuni.cz/~vlada/moltax/part2.html
trimal -in cluster85_13_aln_rrr_nc.rdp5.fas -out cluster85_13_aln_rrr_nc.rdp5.trimal.fas -htmlout cluster85_13_aln_rrr_nc.rdp5.fas.trimal.html -gt 0.8 -st 0.001 -cons 60
trimal -in INFILE -out OUTFILE -fasta -automated1
trimal -in INFILE -out OUTFILE -fasta -gt 0.7
trimal -in INFILE -out OUTFILE -fasta -gappyout
Automated1 is a heuristic method, -gt removes sites with >30% gaps, -gappyout automatically computes a trimming score based on gap distribution.

column -s, -t < data/metadata.tsv  | less -#2 -N -S

column -s, -t < data/metadata.tsv  | less -#2 -N -S

https://stackoverflow.com/questions/714421/what-is-an-easy-way-to-do-a-sorted-diff-between-two-files
diff <(sort text2) <(sort text1)

https://www.bioinformatics.org/sms/iupac.html

# hyphy remove-duplicates.bf --msa example.fas [--tree example.nwk] --output uniques.fas ENV="DATA_FILE_PRINT_FORMAT=9"
# hyphy /Applications/biotools/hyphy-analyses/remove-duplicates/remove-duplicates.bf --msa cluster85_5_env_nr_pruned_sel_flat.fas --tree cluster85wRefs_uniq_aln_nr_pruned6_flat_sel.fasta5.rdp5.rrs.fas.fast.tree --output cluster85_5_env_nr_pruned_sel_flat_uniq.fas ENV="DATA_FILE_PRINT_FORMAT=9" # tree option not recorgnized
hyphy /Applications/biotools/hyphy-analyses/remove-duplicates/remove-duplicates.bf --msa cluster85_5_env_nr_pruned_sel_flat.fas --output cluster85_5_env_nr_pruned_sel_flat_uniq.fas ENV="DATA_FILE_PRINT_FORMAT=9"

# https://unix.stackexchange.com/questions/60577/concatenate-multiple-files-with-same-header
head -1 K059437_HCV001_ONT_strain-table.csv > all.txt
awk 'FNR>1{print}' *strain-table.csv >> all.txt

NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN


 File "/Users/sanemj/miniconda3/lib/python3.11/site-packages/pandas/io/excel/_base.py", line 1157, in __new__
    raise ValueError(f"No engine for filetype: '{ext}'") from err
ValueError: No engine for filetype: 'xls'

Solution:


bedtools bamtofastq -i K059357_COVID477-bam_spike.bam -fq K059357_COVID477-bam_spike_R1.fastq -fq2 K059357_COVID477-bam_spike_R2.fastq


seqpanther codoncounter -bam bams -rid NC_045512.2 -ref /Users/sanemj/Temp/Bioinformatics/covid/ref/NC_045512.2.fasta -gff /Users/sanemj/Temp/Bioinformatics/covid/ref/genemap_anmol.gff -coor_range 21563-25384

ls -1d */ #list only directories


## Repair linux
xfs_repair -v -L /dev/sdb or dm-0


fastq-dump --gzip --skip-technical --readids --read-filter pass --dumpbase --split-3 --clip --outdir path/to/reads/ SRR_ID
fastq-dump --gzip --skip-technical --readids --dumpbase --split-3 --clip --outdir sra SRR2126754

fastq-dump --gzip --skip-technical --readids --dumpbase --split-3 --clip --outdir sra {}

http://www.ncbi.nlm.nih.gov/nucest?term=KP840625:KP840656[accn]  ##batch retrieve in range

https://stackoverflow.com/questions/44759180/filter-by-multiple-patterns-with-filter-and-str-detect
search_vec <- c('a','f','o')
df %>% 
    filter(str_detect(lttrs, pattern = paste(search_vec, collapse = '|')))
    
awk’{ if(NR%4==2)printsubstr($0,1,20); }’input.fastq|sort|uniq-c |awk’{ print$1 }’>counts.txt

# https://apple.stackexchange.com/questions/446859/when-pasting-in-terminal-app-00-is-pasted-at-the-start-and-01-at-the-end
printf '\e[?2004l'

https://www.biostars.org/p/9537536/
seqkit rename test.fq
rename.sh in=<file> in2=<file2> out=<outfile> out2=<outfile2> addpairnum=t  ## bbmap
https://github.com/shenwei356/seqkit/issues/94

https://github.com/shenwei356/seqkit/issues/94
seqkit locate -f <(seqkit rename pattern.fasta | seqkit seq -i ) <(printf '>Aseq\nATTAT\n') -i \
    | csvtk pretty -t

https://hpc.nih.gov/apps/seqkit.html
duplicate       duplicate sequences N times

 cat tests/hairpin.fa | seqkit head -n 1 \
    | seqkit duplicate -n 2 | seqkit rename