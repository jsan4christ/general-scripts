
augur align --sequences all_genbank_363.fasta  --output all_genbank_363_aln_augur.fasta   --nthreads 24 --method mafft --reference-sequence NC_009942.1.fasta  --remove-reference --fill-gaps --debug

hyphy FEL --alignment NS1_Protease.fas \
 --ci Yes \
--tree NS1_Protease.fas.uf.treefile \
--output NS1_Protease.fas.fel.json

for i in `cat cluster85wRefs_uniq_aln_nr_seqfile_names.txt`;
do
head_id=$(echo $i | cut -d "." -f2);
hyphy /Applications/biotools/hyphy-analyses/remove-duplicates/remove-duplicates.bf ENV="DATA_FILE_PRINT_FORMAT=9" --msa "cluster85wRefs_uniq_aln_nr.${head_id}" --output "cluster85wRefs_uniq_aln_nr_compressed.${head_id}"
done


for i in `ls *nr_compressed*`;
do
head_id=$(echo $i | cut -d "." -f2);
seqkit seq -w 0 $i > "cluster85wRefs_uniq_aln_nr_compressed_flat_sel.${head_id}"
done

for i in `ls *nr_compressed_flat_sel*`;
do
sed -i '' -e "/^>/ s/ /_/g" -e "/^>/ s/:/_/g" -e "/^>/ s/|/_/g" -e "/^>/ s/-/_/g" -e "/^>/ s/\//_/g" -e "/^>/ s/\./_/g"  -e "/^>/ s/(/_/g"  -e "/^>/ s/)/_/g" ${i}
done



###

#remove-line-breaks-in-a-fasta-file
seqkit seq -w 0 cluster85_7_env_rrs_nr.fas > cluster85_7_env_rrs_nr_sel_flat.fas

sed -i '' -e "/^>/ s/ /_/g" -e "/^>/ s/:/_/g" -e "/^>/ s/|/_/g" -e "/^>/ s/-/_/g" -e "/^>/ s/\//_/g" -e "/^>/ s/\./_/g"  -e "/^>/ s/(/_/g"  -e "/^>/ s/)/_/g" cluster85_7_env_rrs_nr_sel_flat.fas

## Manually trim alignment to known length

## get ids of gene segment alignment

grep ">" cluster85_7_env_rrs_nr_sel_flat.fas | sed "s/>//" > cluster85_7_env_rrs_nr_sel_flat.fas.seqids.txt

## get ids not in gene segment alignment but in main alignment used to construct tree.
## https://unix.stackexchange.com/questions/171968/parentheses-not-balanced-even-though-i-escaped-it  -The escaped ( has special meaning in sed: it used for back-references. To match a literal (, simply use it without the backslash: /VALUES ([0-9]/d!

sed -i '' -e "/^>/ s/ /_/g" -e "/^>/ s/:/_/g" -e "/^>/ s/|/_/g" -e "/^>/ s/-/_/g" -e "/^>/ s/\//_/g" -e "/^>/ s/\./_/g"  -e "/^>/ s/(/_/g"  -e "/^>/ s/)/_/g" cluster85wRefs_uniq_aln_rrs_nr_prune.fasta7.rdp5.fas #first rename

seqkit grep -rvf cluster85_7_env_rrs_nr_sel_flat.fas.seqids.txt cluster85wRefs_uniq_aln_rrs_nr_prune.fasta7.rdp5.fas | grep ">" | sed "s/>//" > add_to_env_aln.txt

#Now make the seqs
python ~/Downloads/Telegram\ Desktop/makeSeqs.py add_to_env_aln.txt 2571 > cluster85_7_env_rrs_nr_sel_flat_plus.fas

#Join the two files
cat cluster85_7_env_rrs_nr_sel_flat.fas cluster85_7_env_rrs_nr_sel_flat_plus.fas > cluster85_7_env_rrs_nr_sel_flat_full.fas

## Run hyphy
hyphy FEL --alignment cluster85_7_env_rrs_nr_sel_flat_full_prune.fas  --ci Yes --tree cluster85wRefs_uniq_aln_rrs_nr_prune.fasta7.rdp5.fas.uf.treefile --output cluster85_7_env_rrs_nr_sel_flat_full.fas.fel.json

hyphy bgm --type nucleotide --code universal --alignment cluster85_7_env_rrs_nr_sel_flat_full_prune.fas --output cluster85_7_env_rrs_nr_sel_flat_full.fas.bgm.json --tree cluster85wRefs_uniq_aln_rrs_nr_prune.fasta7.rdp5.fas.uf.treefile

hyphy FEL --alignment cluster85_7_env_rrs_nr_sel_flat_full_prune.fas \
--ci Yes \
--tree cluster85wRefs_uniq_aln.fasta2.rdp5.nr_rrs_pruned_sel.fas.uf.treefile \
--output cluster2-proteins/cluster2_env1-gp120_nr_rrs_pruned.fas.fel.json


## BGM - Poon

# if necessary run CleanStopCodons.bf to remove stop codons, From the command line, you can launch an interactive menu by calling
# the HyPhy executable (HYPHYMP or hyphymp if you used a package manager) and then select the options (4) Data File Tools and then (6) to run the same script.

# scripts in /Applications/biotools/comet-prot/scripts/fit_codon_model.bf

we used the following invocation in the macOS Terminal:

HYPHYMP CPU=4 BASEPATH=/usr/local/lib/hyphy/ pwd/fit_codon_model.bf

# To take advantage of a multi-core CPU, you can add the argument CPU=[number of cores] immediately after HYPHYMP. Note that not all steps in this analysis are able to utilize multiple threads.

HYPHYMP CPU=4 BASEPATH=/usr/local/share/hyphy /Applications/biotools/comet-prot/scripts/fit_codon_model.bf


fit_codon_model.bf

## remove bootstrap values from tree
sed -E 's/)[0-9.]+:/):/g' cluster85wRefs_uniq_aln_rrs_nr_prune.fasta7.rdp5.fas.uf.treefile > cluster85wRefs_uniq_aln_rrs_nr_prune.fasta7.rdp5.fas.uf.bgm.treefile

/Users/sanemj/Temp/Bioinformatics/HIV/PANGEA/cluster85/wRefs/deduped/msa/rdp5/cluster85wRefs_uniq_aln.fasta7/cluster85_7_env_rrs_nr_sel_flat_full_prune.fas
/Users/sanemj/Temp/Bioinformatics/HIV/PANGEA/cluster85/wRefs/deduped/msa/rdp5/cluster85wRefs_uniq_aln.fasta7/cluster85wRefs_uniq_aln_rrs_nr_prune.fasta7.rdp5.fas.uf.bgm.treefile

/Users/sanemj/Temp/Bioinformatics/HIV/PANGEA/cluster85/wRefs/deduped/msa/rdp5/cluster85wRefs_uniq_aln.fasta7/cluster85_7_env_rrs_nr_sel_flat_full_prune.fas.lf

HYPHYMP CPU=4 BASEPATH=/usr/local/share/hyphy /Applications/biotools/comet-prot/scripts/MapMutationsToTree.bf

/Users/sanemj/Temp/Bioinformatics/HIV/PANGEA/cluster85/wRefs/deduped/msa/rdp5/cluster85wRefs_uniq_aln.fasta7/cluster85_7_env_rrs_nr_sel_flat_full_prune.fas.mat

HYPHYMP CPU=4 BASEPATH=/usr/local/share/hyphy /Applications/biotools/comet-prot/scripts/bayesgraph.bf


######### Cluster 0
## krisp.mrc.ac.za /analyses2/data/Pangea_SJ/phylogeny/cluster85wRefs_uniq_aln.fasta5 # for running large trees and phylogeny
## scp -r sanjames@mrcad.mrc.ac.za@krisp.mrc.ac.za:/analyses2/data/Pangea_SJ/phylogeny/cluster85wRefs_uniq_aln.fasta0/*_pruned*uf .
## scp cluster85wRefs_uniq_aln_nr_pruned2.fasta5.rdp5.rrs.fas sanjames@mrcad.mrc.ac.za@krisp.mrc.ac.za:/analyses2/data/Pangea_SJ/phylogeny/cluster85wRefs_uniq_aln.fasta5/

## Refine alignment - iterative process, of prune-tree-prune until you have a final tree.
seqkit grep -rvf badSeqs.txt cluster85wRefs_uniq_aln_nr_pruned2.fasta5.rdp5.rrs.fas > cluster85wRefs_uniq_aln_nr_pruned3.fasta5.rdp5.rrs.fas

#### Cluster5 tree
## remove line breaks frome fasta file
seqkit seq -w 0 cluster85wRefs_uniq_aln_nr_pruned2.fasta5.rdp5.rrs.fas > cluster85wRefs_uniq_aln_nr_pruned2_flat_sel.fasta5.rdp5.rrs.fas

## Modify names for hyphy
sed -i '' -e "/^>/ s/ /_/g" -e "/^>/ s/:/_/g" -e "/^>/ s/|/_/g" -e "/^>/ s/-/_/g" -e "/^>/ s/\//_/g" -e "/^>/ s/\./_/g"  -e "/^>/ s/(/_/g"  -e "/^>/ s/)/_/g" cluster85wRefs_uniq_aln_nr_pruned2_flat_sel.fasta5.rdp5.rrs.fas
grep ">" cluster85wRefs_uniq_aln_nr_pruned2_flat_sel.fasta5.rdp5.rrs.fas | sed "s/>//" > cluster85wRefs_uniq_aln_nr_pruned2_flat_sel.fasta5.rdp5.rrs.fas.seqids.txt

## Infer phylogeny
FastTree -nt -gtr -gamma < cluster85wRefs_uniq_aln_nr_pruned2_flat_sel.fasta5.rdp5.rrs.fas > cluster85wRefs_uniq_aln_nr_pruned2_flat_sel.fasta5.rdp5.rrs.fas.fast.tree

## remove outliers and run again
FastTree -nt -gtr -gamma < cluster85wRefs_uniq_aln.fasta5.rdp5.nr_rrr.fas > cluster85wRefs_uniq_aln.fasta3.rdp5.nr_rrr.fast.tree

#### Env
#remove-line-breaks-in-a-fasta-file
seqkit seq -w 0 cluster85_7_env_rrs_nr.fas > cluster85_7_env_rrs_nr_sel_flat.fas

sed -i '' -e "/^>/ s/ /_/g" -e "/^>/ s/:/_/g" -e "/^>/ s/|/_/g" -e "/^>/ s/-/_/g" -e "/^>/ s/\//_/g" -e "/^>/ s/\./_/g"  -e "/^>/ s/(/_/g"  -e "/^>/ s/)/_/g" cluster85_7_env_rrs_nr_sel_flat.fas

## Manually trim alignment to known length

## get ids of gene segment alignment

grep ">" cluster85_7_env_rrs_nr_sel_flat.fas | sed "s/>//" > cluster85_7_env_rrs_nr_sel_flat.fas.seqids.txt

## get ids not in gene segment alignment but in main alignment used to construct tree.
## https://unix.stackexchange.com/questions/171968/parentheses-not-balanced-even-though-i-escaped-it  -The escaped ( has special meaning in sed: it used for back-references. To match a literal (, simply use it without the backslash: /VALUES ([0-9]/d!

sed -i '' -e "/^>/ s/ /_/g" -e "/^>/ s/:/_/g" -e "/^>/ s/|/_/g" -e "/^>/ s/-/_/g" -e "/^>/ s/\//_/g" -e "/^>/ s/\./_/g"  -e "/^>/ s/(/_/g"  -e "/^>/ s/)/_/g" cluster85wRefs_uniq_aln_rrs_nr_prune.fasta7.rdp5.fas #first rename

seqkit grep -rvf cluster85_7_env_rrs_nr_sel_flat.fas.seqids.txt cluster85wRefs_uniq_aln_rrs_nr_prune.fasta7.rdp5.fas | grep ">" | sed "s/>//" > add_to_env_aln.txt

#Now make the seqs
python ~/Downloads/Telegram\ Desktop/makeSeqs.py add_to_env_aln.txt 2571 > cluster85_7_env_rrs_nr_sel_flat_plus.fas

#Join the two files
cat cluster85_7_env_rrs_nr_sel_flat.fas cluster85_7_env_rrs_nr_sel_flat_plus.fas > cluster85_7_env_rrs_nr_sel_flat_full.fas

## Run hyphy
hyphy FEL --alignment cluster85_7_env_rrs_nr_sel_flat_full_prune.fas  --ci Yes --tree cluster85wRefs_uniq_aln_rrs_nr_prune.fasta7.rdp5.fas.uf.treefile --output cluster85_7_env_rrs_nr_sel_flat_full.fas.fel.json

hyphy bgm --type nucleotide --code universal --alignment cluster85_7_env_rrs_nr_sel_flat_full_prune.fas --output cluster85_7_env_rrs_nr_sel_flat_full.fas.bgm.json --tree cluster85wRefs_uniq_aln_rrs_nr_prune.fasta7.rdp5.fas.uf.treefile

hyphy FEL --alignment cluster85_7_env_rrs_nr_sel_flat_full_prune.fas \
--ci Yes \
--tree cluster85wRefs_uniq_aln.fasta2.rdp5.nr_rrs_pruned_sel.fas.uf.treefile \
--output cluster2-proteins/cluster2_env1-gp120_nr_rrs_pruned.fas.fel.json


##### Selection

##### Coevolution






######### Cluster 5
## krisp.mrc.ac.za /analyses2/data/Pangea_SJ/phylogeny/cluster85wRefs_uniq_aln.fasta5 # for running large trees and phylogeny
## scp -r sanjames@mrcad.mrc.ac.za@krisp.mrc.ac.za:/analyses2/data/Pangea_SJ/phylogeny/cluster85wRefs_uniq_aln.fasta5/*_pruned*uf .
## scp cluster85wRefs_uniq_aln_nr_pruned2.fasta5.rdp5.rrs.fas sanjames@mrcad.mrc.ac.za@krisp.mrc.ac.za:/analyses2/data/Pangea_SJ/phylogeny/cluster85wRefs_uniq_aln.fasta5/


## remove line breaks frome fasta file
seqkit seq -w 0 cluster85_5_aln_rrs_nr.rdp5.fas > cluster85_5_aln_rrs_nr_flat_sel.rdp5.fas

## Modify names for hyphy
sed -i '' -e "/^>/ s/ /_/g" -e "/^>/ s/:/_/g" -e "/^>/ s/|/_/g" -e "/^>/ s/-/_/g" -e "/^>/ s/\//_/g" -e "/^>/ s/\./_/g"  -e "/^>/ s/(/_/g"  -e "/^>/ s/)/_/g" cluster85_5_aln_rrs_nr_flat_sel.rdp5.fas
grep ">" cluster85_5_aln_rrs_nr_flat_sel.rdp5.fas | sed "s/>//" > cluster85_5_aln_rrs_nr_flat_sel.rdp5.fas.seqids.txt

#### Infer phylogeny - iteratively drop bad sequences. I have cummulatively put these in badSeqs.txt
FastTree -nt -gtr -gamma < cluster85_5_aln_rrs_nr_flat_sel.rdp5.fas > cluster85_5_aln_rrs_nr_flat_sel.rdp5.fas.fast.tree

## Refine alignment - iterative process, of prune-tree-prune until you have a final tree.
seqkit grep -rvf badSeqs.txt cluster85_5_aln_rrs_nr_flat_sel.rdp5.fas > cluster85_5_aln_rrs_nr_flat_sel_pruned.rdp5.fas

FastTree -nt -gtr -gamma < cluster85_5_aln_rrs_nr_flat_sel_pruned.rdp5.fas > cluster85_5_aln_rrs_nr_flat_sel_pruned.rdp5.fas.fast.tree

## -pseudo to use pseudocounts (recommended for highly gapped sequences)
##FastTree -nt -gtr -gamma < cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas > cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas.fast.tree
## final tree for selection: cluster85wRefs_uniq_aln_nr_pruned6.fasta5.rdp5.rrs.fas.fast.tree

## For ML tree with bootstrap support:
iqtree2 -s cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas -m GTR+G -pre cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas.uf


#### cluster85_5_gag
#remove-line-breaks-in-a-fasta-file
seqkit grep -rvp "ref_" cluster85_5_gag.fas > cluster85_5_gag_nr.fas

seqkit grep -rvf badSeqs.txt cluster85_5_gag_nr.fas > cluster85_5_gag_nr_pruned.fas #seqs already dropped from the tree

seqkit seq -w 0 cluster85_5_gag_nr_pruned.fas > cluster85_5_gag_nr_pruned_sel_flat.fas 

sed -i '' -e "/^>/ s/ /_/g" -e "/^>/ s/:/_/g" -e "/^>/ s/|/_/g" -e "/^>/ s/-/_/g" -e "/^>/ s/\//_/g" -e "/^>/ s/\./_/g"  -e "/^>/ s/(/_/g"  -e "/^>/ s/)/_/g" cluster85_5_gag_nr_pruned_sel_flat.fas


## Manually trim alignment to known length. I use Aliview to do this - for example trim gag to a max length of 2571. NB: prune seqs, trim length
 cluster85_5_gag_nr_trimmed_pruned_sel_flat.fas 

## get ids of gene segment alignment
grep ">" cluster85_5_gag_nr_trimmed_pruned_sel_flat.fas | sed "s/>//" | sort > cluster85_5_gag_nr_pruned_sel_flat.fas.seqids.txt

## get ids not in gene segment alignment but in main alignment used to construct tree.
## https://unix.stackexchange.com/questions/171968/parentheses-not-balanced-even-though-i-escaped-it  -The escaped ( has special meaning in sed: it used for back-references. To match a literal (, simply use it without the backslash: /VALUES ([0-9]/d!

seqkit grep -rvf cluster85_5_gag_nr_pruned_sel_flat.fas.seqids.txt cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas | grep ">" | sed "s/>//" > add_to_gag_aln.txt

#Now make the seqs
python ~/Downloads/Telegram\ Desktop/makeSeqs.py add_to_gag_aln.txt 2571 > cluster85_5_gag_nr_trimmed_pruned_sel_flat_plus.fas

#Join the two files
cat cluster85_5_gag_nr_trimmed_pruned_sel_flat.fas cluster85_5_gag_nr_trimmed_pruned_sel_flat_plus.fas > cluster85_5_gag_nr_trimmed_pruned_sel_flat_full.fas

## We still have some missing sequences...find and add
grep ">" cluster85_5_gag_nr_trimmed_pruned_sel_flat_full.fas | sed "s/>//" | sort > cluster85_5_gag_nr_trimmed_pruned_sel_flat_full_seqids_srt.fas.txt

grep ">" cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas | sed "s/>//" | sort > cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas.seqids_srt.txt

# diff <(sort text2) <(sort text1)
diff  cluster85_5_gag_nr_trimmed_pruned_sel_flat_full_seqids_srt.fas.txt cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas.seqids_srt.txt  | grep ">" | sed "s/>//" > add_to_gag_aln_2.txt

#Now make the seqs
python ~/Downloads/Telegram\ Desktop/makeSeqs.py add_to_gag_aln_2.txt 2571 > cluster85_5_gag_nr_trimmed_pruned_sel_flat_plus_2.fas

cat cluster85_5_gag_nr_trimmed_pruned_sel_flat_full.fas cluster85_5_gag_nr_trimmed_pruned_sel_flat_plus_2.fas > cluster85_5_gag_nr_trimmed_pruned_sel_flat_full_full.fas

## Run hyphy
hyphy FEL --alignment cluster85_5_gag_nr_trimmed_pruned_sel_flat_full_full.fas  --ci Yes --branches Internal --tree cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas.fast.tree --output cluster85_5_gag_nr_trimmed_pruned_sel_flat_full_full.fas.fel.json

hyphy meme --alignment cluster85_5_gag_nr_trimmed_pruned_sel_flat_full_full.fas --ci Yes --branches Internal --tree cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas.fast.tree --output cluster85_5_gag_nr_trimmed_pruned_sel_flat_full_full.fas.meme.json

hyphy slac --alignment cluster85_5_gag_nr_trimmed_pruned_sel_flat_full_full.fas --branches Internal --tree cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas.fast.tree --output cluster85_5_gag_nr_trimmed_pruned_sel_flat_full_full.fas.SLAC.json

hyphy bgm --type nucleotide --code universal  --alignment cluster85_5_gag_nr_trimmed_pruned_sel_flat_full_full.fas --output cluster85_5_gag_nr_trimmed_pruned_sel_flat_full_full.fas.bgm.json --tree cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas.fast.tree


#### cluster85_5_pol
#remove-line-breaks-in-a-fasta-file
seqkit grep -rvp "ref_" cluster85_5_pol.fas > cluster85_5_pol_nr.fas

seqkit grep -rvf badSeqs.txt cluster85_5_pol_nr.fas > cluster85_5_pol_nr_pruned.fas #seqs already dropped from the tree

seqkit seq -w 0 cluster85_5_pol_nr_pruned.fas > cluster85_5_pol_nr_pruned_sel_flat.fas 

sed -i '' -e "/^>/ s/ /_/g" -e "/^>/ s/:/_/g" -e "/^>/ s/|/_/g" -e "/^>/ s/-/_/g" -e "/^>/ s/\//_/g" -e "/^>/ s/\./_/g"  -e "/^>/ s/(/_/g"  -e "/^>/ s/)/_/g" cluster85_5_pol_nr_pruned_sel_flat.fas


## Manually trim alignment to known length. I use Aliview to do this - for example trim pol to a max length of 2571. NB: prune seqs, trim length
cluster85_5_pol_nr_trimmed_pruned_sel_flat.fas #2961

## get ids of gene segment alignment
grep ">" cluster85_5_pol_nr_trimmed_pruned_sel_flat.fas | sed "s/>//" | sort > cluster85_5_pol_nr_pruned_sel_flat.fas.seqids.txt

## get ids not in gene segment alignment but in main alignment used to construct tree.
## https://unix.stackexchange.com/questions/171968/parentheses-not-balanced-even-though-i-escaped-it  -The escaped ( has special meaning in sed: it used for back-references. To match a literal (, simply use it without the backslash: /VALUES ([0-9]/d!

seqkit grep -rvf cluster85_5_pol_nr_pruned_sel_flat.fas.seqids.txt cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas | grep ">" | sed "s/>//" > add_to_pol_aln.txt

#Now make the seqs
python ~/Downloads/Telegram\ Desktop/makeSeqs.py add_to_pol_aln.txt 2571 > cluster85_5_pol_nr_trimmed_pruned_sel_flat_plus.fas

#Join the two files
cat cluster85_5_pol_nr_trimmed_pruned_sel_flat.fas cluster85_5_pol_nr_trimmed_pruned_sel_flat_plus.fas > cluster85_5_pol_nr_trimmed_pruned_sel_flat_full.fas

## We still have some missing sequences...find and add
grep ">" cluster85_5_pol_nr_trimmed_pruned_sel_flat_full.fas | sed "s/>//" | sort > cluster85_5_pol_nr_trimmed_pruned_sel_flat_full_seqids_srt.fas.txt

grep ">" cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas | sed "s/>//" | sort > cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas.seqids_srt.txt

# diff <(sort text2) <(sort text1)
diff  cluster85_5_pol_nr_trimmed_pruned_sel_flat_full_seqids_srt.fas.txt cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas.seqids_srt.txt  | grep ">" | sed "s/>//" > add_to_pol_aln_2.txt

#Now make the seqs
python ~/Downloads/Telegram\ Desktop/makeSeqs.py add_to_pol_aln_2.txt 2571 > cluster85_5_pol_nr_trimmed_pruned_sel_flat_plus_2.fas

cat cluster85_5_pol_nr_trimmed_pruned_sel_flat_full.fas cluster85_5_pol_nr_trimmed_pruned_sel_flat_plus_2.fas > cluster85_5_pol_nr_trimmed_pruned_sel_flat_full_full.fas

## Run hyphy
hyphy busted --srv No --alignment cluster85_5_pol_nr_trimmed_pruned_sel_flat_full_full.fas --tree  cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas.fast.tree --starting-points 5 --output  cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas.fast.tree.BUSTED.json

hyphy FEL --alignment cluster85_5_pol_nr_trimmed_pruned_sel_flat_full_full.fas  --ci Yes --branches Internal --tree cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas.fast.tree --output cluster85_5_pol_nr_trimmed_pruned_sel_flat_full_full.fas.fel.json

hyphy meme --alignment cluster85_5_pol_nr_trimmed_pruned_sel_flat_full_full.fas --ci Yes --branches Internal --tree cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas.fast.tree --output cluster85_5_pol_nr_trimmed_pruned_sel_flat_full_full.fas.meme.json

hyphy slac --alignment cluster85_5_pol_nr_trimmed_pruned_sel_flat_full_full.fas --branches Internal --tree cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas.fast.tree --output cluster85_5_pol_nr_trimmed_pruned_sel_flat_full_full.fas.SLAC.json

hyphy bgm --type nucleotide --code universal  --alignment cluster85_5_pol_nr_trimmed_pruned_sel_flat_full_full.fas --output cluster85_5_pol_nr_trimmed_pruned_sel_flat_full_full.fas.bgm.json --tree cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas.fast.tree


#### cluster85_5_Env
#remove-line-breaks-in-a-fasta-file
seqkit grep -rvp "ref_" cluster85_5_env.fas > cluster85_5_env_nr.fas

seqkit grep -rvf badSeqs.txt cluster85_5_env_nr.fas > cluster85_5_env_nr_pruned.fas #seqs already dropped from the tree

seqkit seq -w 0 cluster85_5_env_nr_pruned.fas > cluster85_5_env_nr_pruned_sel_flat.fas 

sed -i '' -e "/^>/ s/ /_/g" -e "/^>/ s/:/_/g" -e "/^>/ s/|/_/g" -e "/^>/ s/-/_/g" -e "/^>/ s/\//_/g" -e "/^>/ s/\./_/g"  -e "/^>/ s/(/_/g"  -e "/^>/ s/)/_/g" cluster85_5_env_nr_pruned_sel_flat.fas


## Manually trim alignment to known length. I use Aliview to do this - for example trim env to a max length of 2571. NB: prune seqs, trim length
cluster85_5_env_nr_trimmed_pruned_sel_flat.fas 

## get ids of gene segment alignment
grep ">" cluster85_5_env_nr_trimmed_pruned_sel_flat.fas | sed "s/>//" | sort > cluster85_5_env_nr_pruned_sel_flat.fas.seqids.txt

## get ids not in gene segment alignment but in main alignment used to construct tree.
## https://unix.stackexchange.com/questions/171968/parentheses-not-balanced-even-though-i-escaped-it  -The escaped ( has special meaning in sed: it used for back-references. To match a literal (, simply use it without the backslash: /VALUES ([0-9]/d!

seqkit grep -rvf cluster85_5_env_nr_pruned_sel_flat.fas.seqids.txt cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas | grep ">" | sed "s/>//" > add_to_env_aln.txt

#Now make the seqs
python ~/Downloads/Telegram\ Desktop/makeSeqs.py add_to_env_aln.txt 2571 > cluster85_5_env_nr_trimmed_pruned_sel_flat_plus.fas

#Join the two files
cat cluster85_5_env_nr_trimmed_pruned_sel_flat.fas cluster85_5_env_nr_trimmed_pruned_sel_flat_plus.fas > cluster85_5_env_nr_trimmed_pruned_sel_flat_full.fas

## We still have some missing sequences...find and add
grep ">" cluster85_5_env_nr_trimmed_pruned_sel_flat_full.fas | sed "s/>//" | sort > cluster85_5_env_nr_trimmed_pruned_sel_flat_full_seqids_srt.fas.txt

grep ">" cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas | sed "s/>//" | sort > cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas.seqids_srt.txt

# diff <(sort text2) <(sort text1)
diff  cluster85_5_env_nr_trimmed_pruned_sel_flat_full_seqids_srt.fas.txt cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas.seqids_srt.txt  | grep ">" | sed "s/>//" > add_to_env_aln_2.txt

#Now make the seqs
python ~/Downloads/Telegram\ Desktop/makeSeqs.py add_to_env_aln_2.txt 2571 > cluster85_5_env_nr_trimmed_pruned_sel_flat_plus_2.fas

cat cluster85_5_env_nr_trimmed_pruned_sel_flat_full.fas cluster85_5_env_nr_trimmed_pruned_sel_flat_plus_2.fas > cluster85_5_env_nr_trimmed_pruned_sel_flat_full_full.fas

## Run hyphy
hyphy FEL --alignment cluster85_5_env_nr_trimmed_pruned_sel_flat_full_full.fas  --ci Yes --branches Internal --tree cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas.fast.tree --output cluster85_5_env_nr_trimmed_pruned_sel_flat_full_full.fas.fel.json

hyphy meme --alignment cluster85_5_env_nr_trimmed_pruned_sel_flat_full_full.fas --ci Yes --branches Internal --tree cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas.fast.tree --output cluster85_5_env_nr_trimmed_pruned_sel_flat_full_full.fas.meme.json

hyphy slac --alignment cluster85_5_env_nr_trimmed_pruned_sel_flat_full_full.fas --branches Internal --tree cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas.fast.tree --output cluster85_5_env_nr_trimmed_pruned_sel_flat_full_full.fas.SLAC.json

hyphy bgm --type nucleotide --code universal  --alignment cluster85_5_env_nr_trimmed_pruned_sel_flat_full_full.fas --output cluster85_5_env_nr_trimmed_pruned_sel_flat_full_full.fas.bgm.json --tree cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas.fast.tree


#### cluster85_5_Pol


##### Selection

##### Coevolution



#### Try with anmol extracts

../../cluster85wRefs_uniq_aln.fasta5/

seqkit grep -rvf ../../cluster85wRefs_uniq_aln.fasta5/badSeqs.txt Env.fa > cluster85_5_env_nr_pruned.fas

## Run hyphy
#diversifying selection
hyphy FEL --alignment cluster85_5_env_nr_pruned_sel_flat.fas  --ci Yes --branches Internal --tree ../../cluster85wRefs_uniq_aln.fasta5/cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas.fast.tree --output cluster85_5_env_nr_trimmed_pruned_sel_flat_full_full.fas.fel.json

hyphy fubar --alignment cluster85_5_env_nr_pruned_sel_flat.fas  --ci Yes --branches Internal --tree ../../cluster85wRefs_uniq_aln.fasta5/cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas.fast.tree --output cluster85_5_env_nr_trimmed_pruned_sel_flat_full_full.fas.fel.json


hyphy meme --alignment cluster85_5_env_nr_pruned_sel_flat.fas --ci Yes --branches Internal --tree ../../cluster85wRefs_uniq_aln.fasta5/cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas.fast.tree --output cluster85_5_env_nr_trimmed_pruned_sel_flat_full_full.fas.meme.json

hyphy slac --alignment cluster85_5_env_nr_pruned_sel_flat.fas --branches Internal --tree ../../cluster85wRefs_uniq_aln.fasta5/cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas.fast.tree --output cluster85_5_env_nr_trimmed_pruned_sel_flat_full_full.fas.SLAC.json

hyphy bgm --type nucleotide --code universal  --alignment cluster85_5_env_nr_pruned_sel_flat.fas --output cluster85_5_env_nr_trimmed_pruned_sel_flat_full_full.fas.bgm.json --tree ../../cluster85wRefs_uniq_aln.fasta5/cluster85_5_aln_rrs_nr_flat_sel_pruned6.rdp5.fas.fast.tree

## Deduplication results:
> Loaded an alignment with 16698 sequences and 9719 sites from /Users/sanemj/Temp/Bioinformatics/HIV/PANGEA/cluster85/wRefs/deduped/msa/cluster85wRefs_uniq_aln_nr.fasta0
There are **16637** unique sequences in alignment 

> Loaded an alignment with 9969 sequences and 9719 sites from /Users/sanemj/Temp/Bioinformatics/HIV/PANGEA/cluster85/wRefs/deduped/msa/cluster85wRefs_uniq_aln_nr.fasta1
There are **9947** unique sequences in alignment 

> Loaded an alignment with 69 sequences and 9719 sites from /Users/sanemj/Temp/Bioinformatics/HIV/PANGEA/cluster85/wRefs/deduped/msa/cluster85wRefs_uniq_aln_nr.fasta2
There are **68** unique sequences in alignment 

> Loaded an alignment with 307 sequences and 9719 sites from /Users/sanemj/Temp/Bioinformatics/HIV/PANGEA/cluster85/wRefs/deduped/msa/cluster85wRefs_uniq_aln_nr.fasta3

> Loaded an alignment with 1005 sequences and 9719 sites from /Users/sanemj/Temp/Bioinformatics/HIV/PANGEA/cluster85/wRefs/deduped/msa/cluster85wRefs_uniq_aln_nr.fasta5
There are **1004** unique sequences in alignment 

> Loaded an alignment with 25 sequences and 9719 sites from /Users/sanemj/Temp/Bioinformatics/HIV/PANGEA/cluster85/wRefs/deduped/msa/cluster85wRefs_uniq_aln_nr.fasta7
There are **25** unique sequences in alignment 
### No duplicate sequences found

> Loaded an alignment with 4342 sequences and 9719 sites from /Users/sanemj/Temp/Bioinformatics/HIV/PANGEA/cluster85/wRefs/deduped/msa/cluster85wRefs_uniq_aln_nr.fasta12
There are **3986** unique sequences in alignment 

> Loaded an alignment with 5946 sequences and 9719 sites from /Users/sanemj/Temp/Bioinformatics/HIV/PANGEA/cluster85/wRefs/deduped/msa/cluster85wRefs_uniq_aln_nr.fasta13

> Loaded an alignment with 22 sequences and 9719 sites from /Users/sanemj/Temp/Bioinformatics/HIV/PANGEA/cluster85/wRefs/deduped/msa/cluster85wRefs_uniq_aln_nr.fasta17
There are **13** unique sequences in alignment 


###### writeup snippets

can you please interpret this and create a script to do it in python or R? We filtered putative sequencing errors and ‘‘problematic’’ sequences. A mutation that occurs in X out of N total sequences (counting all sequences, not just the unique ones) was considered to be an ‘‘error’’ if the binomial probability of observing X
or more error mutations at a site was suffciently high (in our case p > 0.999) assuming a sequencing error rate of 1:10,000. For example, if N = 500,000, then X would be 29. This means that unless a mutation occurred in 30/500,000 or more individual sequences, it would have been treated as an error and replaced with a phylogenetically uninformative gap character (i.e., ‘‘-’’).


9 clusters were selected from 19 clusters containing multiple tips for follow-up phylogenetic analysis. 

HIV-1M exhibits . However, the majority of phylogenetic analysis and recombination detection tools provide reliable results for sequences at a threshold of eighty-five percent. Using pairwise sequence identity, we generated ten sequence clusters. Each cluster comprised sequences that were at least eighty-five percent similar. The sequences in each cluster spanned different time frames, with cluster 0 having the longest time frame spanning the entire study period of study (Figure 1). Cluster seventeen was the smallest with twenty-two sequences from 2019.

We further evaluated the distribution of subtypes across clusters. Cluster 0 comprised all detected subtypes, however, Africa was dominated by Subtype C while America and Europe were dominated by Subtype B. Clusters 1, 2, 3, and 5 were predominantly Subtype C while clusters 12, 13, 14, and 17 were predominantly Subtype B, irrespective of the location. An exception was cluster 7 which comprised only complex subtypes and subtype A. 



 export sequence alignments with recombinant sequences stripped of all readily detectable evidence of individual recombination events 
then be used with other computer programs such as BEAST (Bouckaert et al. 2014) or HYPHY (Kosakovsky-Pond et al. 2005) to make more accurate estimates of evolutionary rates or less error-prone inferences of positive selection.


We assessed the accummulation of break-points in one genomic region over another, given two preselected groups of sites or genomic regions in an analyzed alignment. 


### Selection
 jq '.analysis' hyphy/0/1995_2000/Gag/FEL/out.json 
 
 jq 'keys' hyphy/0/1995_2000/Gag/FEL/out.json 