#!/usr/bin/env bash

## Use presto to process from fastq

#PATH=/Applications/biotools/presto-0.7.2/bin:$PATH

# igblast - https://ncbi.github.io/igblast/cook/examples.html
# igblast from python - https://github.com/xinyu-dev/igblast/blob/master/Using%20IgBlast.ipynb

# Presto workflow -  https://presto.readthedocs.io/en/stable/workflows/Greiff2014_Workflow.html

# 10x https://bitbucket.org/kleinstein/immcantation/src/master/training/#markdown-header-lineage-tree-reconstruction

## Partis and cloanalyst will associate a probability to the call. igblast will not (imgt / Air)

AssemblePairs.py align -1 75501_R2.fastq -2 75501_R1.fastq --coord illumina --rc tail --outname 75501 --log AP.log
FilterSeq.py quality -s 75501_assemble-pass.fastq -q 20 --outname 75501 --log FS.log
MaskPrimers.py score -s 75501_quality-pass.fastq -p ../../../../../../Greiff2014/Greiff2014_VPrimers.fasta     --start 4 --mode mask --pf VPRIMER --outname 75501-FWD --log MPV.log

MaskPrimers.py score -s 75501-FWD_primers-pass.fastq -p ../../../../../../Greiff2014/Greiff2014_CPrimers.fasta --start 4 --mode cut --revpr --pf CPRIMER --outname 75501-REV --log MPC.log

#CollapseSeq.py -s 75501-REV_primers-pass.fastq -n 20 --inner --uf CPRIMER --cf VPRIMER --act set --outname 75501 #did not produce anything

CollapseSeq.py -s 75501-FWD_primers-pass.fastq -n 20 --inner --uf CPRIMER --cf VPRIMER --act set --outname 75501

SplitSeq.py group -s 75501_collapse-unique.fastq -f DUPCOUNT --num 2 --outname 75501
ParseHeaders.py table -s 75501_atleast-2.fastq -f ID DUPCOUNT CPRIMER VPRIMER
ParseLog.py -l AP.log -f ID LENGTH OVERLAP ERROR PVALUE
ParseLog.py -l FS.log -f ID QUALITY
ParseLog.py -l MPV.log MPC.log -f ID PRIMER ERROR



### Nextseq heavy

seqkit stats *.fastq.gz  -T # https://bioinf.shenwei.me/seqkit/usage/

SplitSeq.py count -s file.fastq -n 500000 --fasta

SplitSeq.py samplepair -1 75501_R1.fastq -2 75501_R2.fastq --outname 75501 -n 500000  --coord illumina --outdir subsample/

AssemblePairs.py align -1 subsample/75501-2_sample1-n500000.fastq -2 subsample/75501-1_sample1-n500000.fastq --coord illumina --rc tail --outname 75501 --outdir align --log AP.log

FilterSeq.py quality -s align/75501_assemble-pass.fastq -q 20 --outname 75501 --log FS.log
MaskPrimers.py score -s 75501_quality-pass.fastq -p Greiff2014_VPrimers.fasta \
    --start 4 --mode mask --pf VPRIMER --outname 75501-FWD --log MPV.log
MaskPrimers.py score -s 75501-FWD_primers-pass.fastq -p Greiff2014_CPrimers.fasta \
    --start 4 --mode cut --revpr --pf CPRIMER --outname 75501-REV --log MPC.log
CollapseSeq.py -s 75501-REV_primers-pass.fastq -n 20 --inner --uf CPRIMER \
    --cf VPRIMER --act set --outname 75501
SplitSeq.py group -s 75501_collapse-unique.fastq -f DUPCOUNT --num 2 --outname 75501
ParseHeaders.py table -s 75501_atleast-2.fastq -f ID DUPCOUNT CPRIMER VPRIMER
ParseLog.py -l AP.log -f ID LENGTH OVERLAP ERROR PVALUE
ParseLog.py -l FS.log -f ID QUALITY
ParseLog.py -l MPV.log MPC.log -f ID PRIMER ERROR

# https://changeo.readthedocs.io/en/stable/examples/igblast.html
# https://presto.readthedocs.io/en/stable/examples/filter.html

#Follow up step: https://changeo.readthedocs.io/en/stable/examples/igblast.html

# setup environment variables

## Original files: /datacommons/dhvi/BCR_RepSeq_Data/Mouse_Studies/Takara/DH270/NextSeq/heavy/V2/group1_reorg/75501

srun -p dhvi --mem=128G --exclude=dcc-dhvi-12 --pty bash -i

IGBLASTDIR=/hpc/home/jes183/ncbi-igblast-1.22.0
GERMLINE_DB=imgt_igblast_db/human
BLASTDB=/hpc/home/jes183/imgt_igblast_db/human
export IGDATA=/hpc/home/jes183/ncbi-igblast-1.22.0


WORKDIR=Takara_DH270_NextSeq_75501
FILE=75501.filtered.q30p95.polyG.trimmed.RC.UMI.consensus.trimmed.uniq
#FILE=75501.filtered.q30p95.polyG.trimmed.RC.UMI.consensus.trimmed.uniq.wo_gaps.all.heavy


igblastn -germline_db_V "${GERMLINE_DB}/human_V" -germline_db_J "${GERMLINE_DB}/human_J" -germline_db_D "${GERMLINE_DB}/human_D" -organism human -query "${WORKDIR}/${FILE}.fasta" -auxiliary_data "{$IGBLASTDIR}/optional_file/human_gl.aux" -show_translation -outfmt 7 -num_threads 4 -num_alignments_V 5 -out "${FILE}_tab.igblast"

### igblast for change0
igblastn \
    -germline_db_V "${GERMLINE_DB}/human_V" \
    -germline_db_D "${GERMLINE_DB}/human_D" \
    -germline_db_J "${GERMLINE_DB}/human_J" \
    -auxiliary_data "${IGBLASTDIR}/optional_file/human_gl.aux" \
    -domain_system imgt -ig_seqtype Ig -organism human \
    -outfmt '7 std qseq sseq btop' \
    -c_region_db "${GERMLINE_DB}/ncbi_human_c_genes" \
    -num_threads 64 \
    -query "${WORKDIR}/${FILE}.fasta" \
    -out CH235/"${FILE}_tab.igblast.fmt7"

## https://github.com/phac-nml/neptune/issues/5 igblast has trouble processing gaps

ls /hpc/home/jes183/miniconda3/lib/python3.11/site-packages/crowelab_pyir/data/germlines
                        packages/crowelab_pyir/data/germlines

### try via pyir to improve ig blast performance
pyir -t fasta --sequence_type nucl -m 64 --outfmt tsv \
	--igdata /hpc/home/jes183/ncbi-igblast-1.22.0 \
	-r Ig -s human \
	--aux  "${IGBLASTDIR}/optional_file/human_gl.aux" \
	--germlineV "${GERMLINE_DB}/human_V" \
    --germlineD "${GERMLINE_DB}/human_D" \
    --germlineJ "${GERMLINE_DB}/human_J" \
	--print_args \
	#--additional_field=c_region_db,"${GERMLINE_DB}/ncbi_human_c_genes",outfmt,'7 std qseq sseq btop' \
	"${WORKDIR}/${FILE}.fasta"
	
# https://docs.airr-community.org/en/v1.2.1/datarep/rearrangements.html

### Partition into clones for diversity analysis
srun -p dhvi --mem=16G --exclude=dcc-dhvi-12 --pty bash -i

CLOANALYST_PATH=/datacommons/dhvi/cloanalyst-linux-mpi
mono $CLOANALYST_PATH/CloanalystPackage/Cloanalyst.dll fast_partition 75506.RecombinationSummaries.RF.txt


### run igblast on subsample:
seqkit stats 75501.filtered.q30p95.polyG.trimmed.RC.UMI.consensus.trimmed.uniq.wo_gaps.all.heavy.fasta

cat 75501.filtered.q30p95.polyG.trimmed.RC.UMI.consensus.trimmed.uniq.wo_gaps.all.heavy.fasta | seqkit sample -p 0.1 \
-o 75501.filtered.q30p95.polyG.trimmed.RC.UMI.consensus.trimmed.uniq.wo_gaps.all.heavy_0.1.fasta

WORKDIR=Takara_DH270_NextSeq_75501/sample
FILE=75501.filtered.q30p95.polyG.trimmed.RC.UMI.consensus.trimmed.uniq.wo_gaps.all.heavy

igblastn -germline_db_V "${GERMLINE_DB}/human_V" \
    -germline_db_D "${GERMLINE_DB}/human_D" \
    -germline_db_J "${GERMLINE_DB}/human_J" \
    -auxiliary_data "${IGBLASTDIR}/optional_file/human_gl.aux" \
    -domain_system imgt -ig_seqtype Ig -organism human \
    -outfmt '7 std qseq sseq btop' \
    -c_region_db "${GERMLINE_DB}/ncbi_human_c_genes" \
    -num_threads 64 \
    -query "${WORKDIR}/${FILE}.fasta" \
    -out Takara_DH270_NextSeq_75501/sample/"${FILE}_tab.igblast_tumx_IS.fmt7"
    
    
# convert IgBLAST output to AIRR format
 MakeDb.py igblast -i 75501.filtered.q30p95.polyG.trimmed.RC.UMI.consensus.trimmed.uniq.wo_gaps.all.heavy_0.1_tab.igblast.fmt7 \
-s sample/75501.filtered.q30p95.polyG.trimmed.RC.UMI.consensus.trimmed.uniq.wo_gaps.all.heavy_0.1.fasta  \
-r "${IMGTREFS}/IGHV.fasta" "${IMGTREFS}/fasta" "${IMGTREFS}/IGHJ.fasta" --extended

#### Process all others
WORKDIR=Takara_DH270_NextSeq_75501
FILE=75501.filtered.q30p95.polyG.trimmed.RC.UMI.consensus.trimmed.uniq.wo_gaps.all.other

igblastn -germline_db_V "${GERMLINE_DB}/human_V" \
    -germline_db_D "${GERMLINE_DB}/human_D" \
    -germline_db_J "${GERMLINE_DB}/human_J" \
    -auxiliary_data "${IGBLASTDIR}/optional_file/human_gl.aux" \
    -domain_system imgt -ig_seqtype Ig -organism human \
    -outfmt '7 std qseq sseq btop' \
    -c_region_db "${GERMLINE_DB}/ncbi_human_c_genes" \
    -num_threads 64 \
    -query "${WORKDIR}/${FILE}.fasta" \
    -out Takara_DH270_NextSeq_75501/sample/"${FILE}_tab.igblast_tumx_IS.fmt7"

# convert IgBLAST output to AIRR format
 MakeDb.py igblast -i Takara_DH270_NextSeq_75501/75501.filtered.q30p95.polyG.trimmed.RC.UMI.consensus.trimmed.uniq.wo_gaps.all.other_tab.igblast_tumx_IS.fmt7 \
-s Takara_DH270_NextSeq_75501/75501.filtered.q30p95.polyG.trimmed.RC.UMI.consensus.trimmed.uniq.wo_gaps.all.other.fasta  -r "${IMGTREFS}/IGV.fasta" "${IMGTREFS}/IGDfasta" "${IMGTREFS}/IGJ.fasta" --extended

ParseDb.py select -d Takara_DH270_NextSeq_75501/75501.filtered.q30p95.polyG.trimmed.RC.UMI.consensus.trimmed.uniq.wo_gaps.all.other_tab.igblast_tumx_IS_db-pass.tsv -f productive -u T
    
DefineClones.py -d Takara_DH270_NextSeq_75501/75501.filtered.q30p95.polyG.trimmed.RC.UMI.consensus.trimmed.uniq.wo_gaps.all.other_tab.igblast_tumx_IS_db-pass_parse-select.tsv --act set --model ham \
    --norm len --dist 0.16
    
CreateGermlines.py -d Takara_DH270_NextSeq_75501/75501.filtered.q30p95.polyG.trimmed.RC.UMI.consensus.trimmed.uniq.wo_gaps.all.other_tab.igblast_tumx_IS_db-pass_parse-select_clone-pass.tsv -g dmask --cloned \
    -r "${IMGTREFS}/IGV.fasta" "${IMGTREFS}/IGD.fasta" "${IMGTREFS}/IGJ.fasta"
    
BuildTrees.py -d Takara_DH270_NextSeq_75501/75501.filtered.q30p95.polyG.trimmed.RC.UMI.consensus.trimmed.uniq.wo_gaps.all.other_tab.igblast_tumx_IS_db-pass_parse-select_clone-pass_germ-pass.tsv --outname ex --log ex.log --collapse \
    --sample 3000 --igphyml --clean all --nproc 1


### local blast db: - old mac -2T.
cat /Applications/biotools/IMGT_V-QUEST_refs/Homo_sapiens/IG/IGHD.fasta   /Applications/biotools/IMGT_V-QUEST_refs/Macaca_mulatta/IG/IGHD.fasta /Applications/biotools/IMGT_V-QUEST_refs/Mus_musculus/IG/IGHD.fasta > IGHD.fasta 
cat /Applications/biotools/IMGT_V-QUEST_refs/Homo_sapiens/IG/IGHJ.fasta   /Applications/biotools/IMGT_V-QUEST_refs/Macaca_mulatta/IG/IGHJ.fasta /Applications/biotools/IMGT_V-QUEST_refs/Mus_musculus/IG/IGHJ.fasta > IGHJ.fasta 
cat /Applications/biotools/IMGT_V-QUEST_refs/Homo_sapiens/IG/IGHV.fasta   /Applications/biotools/IMGT_V-QUEST_refs/Macaca_mulatta/IG/IGHV.fasta /Applications/biotools/IMGT_V-QUEST_refs/Mus_musculus/IG/IGHV.fasta > IGHV.fasta 
cat /Applications/biotools/IMGT_V-QUEST_refs/Homo_sapiens/IG/IGKV.fasta   /Applications/biotools/IMGT_V-QUEST_refs/Macaca_mulatta/IG/IGKV.fasta /Applications/biotools/IMGT_V-QUEST_refs/Mus_musculus/IG/IGKV.fasta > IGKV.fasta 
cat /Applications/biotools/IMGT_V-QUEST_refs/Homo_sapiens/IG/IGLV.fasta   /Applications/biotools/IMGT_V-QUEST_refs/Macaca_mulatta/IG/IGLV.fasta /Applications/biotools/IMGT_V-QUEST_refs/Mus_musculus/IG/IGLV.fasta > IGLV.fasta 

/usr/local/ncbi/igblast/bin/igblastn


/usr/local/ncbi/igblast/bin/edit_imgt_file.pl IGHD.fasta > ig_formatted.IGHD.fasta
/usr/local/ncbi/igblast/bin/edit_imgt_file.pl IGHJ.fasta > ig_formatted.IGHJ.fasta
/usr/local/ncbi/igblast/bin/edit_imgt_file.pl IGHV.fasta > ig_formatted.IGHV.fasta
/usr/local/ncbi/igblast/bin/edit_imgt_file.pl IGKV.fasta > ig_formatted.IGKV.fasta
/usr/local/ncbi/igblast/bin/edit_imgt_file.pl IGLV.fasta > ig_formatted.IGLV.fasta
 
/usr/local/ncbi/igblast/bin/makeblastdb -parse_seqids -dbtype nucl -in  ig_formatted.IGHD.fasta
/usr/local/ncbi/igblast/bin/makeblastdb -parse_seqids -dbtype nucl -in  ig_formatted.IGHJ.fasta
/usr/local/ncbi/igblast/bin/makeblastdb -parse_seqids -dbtype nucl -in  ig_formatted.IGHV.fasta
/usr/local/ncbi/igblast/bin/makeblastdb -parse_seqids -dbtype nucl -in  ig_formatted.IGKV.fasta
/usr/local/ncbi/igblast/bin/makeblastdb -parse_seqids -dbtype nucl -in  ig_formatted.IGLV.fasta


 
 ### On the server:
 /datacommons/dhvi/10X_Genomics_data/Derek_Cain/Mouse/UCA_KI_Mouse_10X/H24511/CR6/VDJ/cellranger/H24511_VDJ/outs/
 
 AssignGenes.py igblast -s filtered_contig.fasta -b /hpc/home/jes183/ncbi-igblast-1.22.0 \
   --organism human --loci ig --format blast --outdir  --outname BCR_data_sequences
   
WORKDIR=/datacommons/dhvi/10X_Genomics_data/Derek_Cain/Mouse/UCA_KI_Mouse_10X/H24511/CR6/VDJ/cellranger/H24511_VDJ/outs
FILE=filtered_contig
OUTDIR=/datacommons/dhvi/jes183/WieheLab/temp_igblast_results/

GERMLINE_DB=~/imgt_igblast_db/human

igblastn \
    -germline_db_V "${GERMLINE_DB}/human_V" \
    -germline_db_D "${GERMLINE_DB}/human_D" \
    -germline_db_J "${GERMLINE_DB}/human_J" \
    -auxiliary_data "${IGBLASTDIR}/optional_file/human_gl.aux" \
    -domain_system imgt -ig_seqtype Ig -organism human \
    -outfmt '7 std qseq sseq btop' \
    -c_region_db "${GERMLINE_DB}/ncbi_human_c_genes" \
    -num_threads 8 \
    -query "${WORKDIR}/${FILE}.fasta" \
    -out "${OUTDIR}/${FILE}_tab.igblast.fmt7"
    
    
MakeDb.py igblast -i ${OUTDIR}/${FILE}_tab.igblast.fmt7 -s ${WORKDIR}/${FILE}.fasta \
   -r /${GERMLINE_DB} \
   --10x ${WORKDIR}/filtered_contig_annotations.csv --extended
   