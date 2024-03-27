### Notes and cmmands

hyphy /Applications/biotools/hyphy-analyses/remove-duplicates/remove-duplicates.bf ENV="DATA_FILE_PRINT_FORMAT=9" \
--msa cluster85wRefs_uniq_aln_nr_combined.fasta \
--output cluster85wRefs_uniq_aln_nr_combined_compressed.fasta

# if sequences not aligned
bealign -r {input.input_gene_ref_seq} -m HIV_BETWEEN_F {input.input_genome} {output.output}

bam2msa {input.input_bam} {output.output_msa}

cat comp_Env.fa | seqkit translate -T 11 > comp_Env_aa.fa

# if aligned, make alignment compliant:
hyphy /Applications/biotools/hyphy-analyses/codon-msa/pre-msa.bf --input cluster85wRefs_uniq_aln.fasta3.rdp5.nr_pol_rrr.fas # outputs cluster85wRefs_uniq_aln.fasta3.rdp5.nr_pol_rrr.fas_protein.fas

mafft --nomemsave --thread 2 --auto cluster85wRefs_uniq_aln.fasta3.rdp5.nr_pol_rrr.fas_protein.fas > cluster85wRefs_uniq_aln.fasta3.rdp5.nr_pol_rrr.fas_protein.msa

hyphy /Applications/biotools/hyphy-analyses/codon-msa/post-msa.bf --protein-msa cluster85wRefs_uniq_aln.fasta3.rdp5.nr_pol_rrr.fas_protein.msa --nucleotide-sequences cluster85wRefs_uniq_aln.fasta3.rdp5.nr_pol_rrr.fas_nuc.fas --output cluster85wRefs_uniq_aln.fasta3.rdp5.nr_pol_rrr.fas

# remove ambiguities. Input alignment must have the number of sites that is divisible by 3 and must not contain stop codons

hyphy scripts/strike-ambigs.bf --alignment cluster85wRefs_uniq_aln.fasta3.rdp5.nr_pol_rrr.fas --output cluster85wRefs_uniq_aln.fasta3.rdp5.nr_pol_rrr_na.fas  

python3 scripts/tn93_cluster.py --input cluster85wRefs_uniq_aln.fasta3.rdp5.nr_pol_rrr_na.fas --output_fasta cluster85wRefs_uniq_aln.fasta3.rdp5.nr_pol_rrr_na_tn93.fas --output_json cluster85wRefs_uniq_aln.fasta3.rdp5.nr_pol_rrr_na_tn93.json --threshold {params.THRESHOLD_REF} --max_retain {params.MAX_REF} --reference_seq {input.input_gene_ref_seq}

# Combine alignments - back and foreground
python3 scripts/combine.py --input {input.input_compressed_fas} -o {output.output} --threshold {params.THRESHOLD_QUERY} --msa {input.input_msa} --reference_seq {input.input_gene_ref_seq}

# convert to protein
hyphy conv Universal 'Keep Deletions' {input.combined_fas} {output.proteinput_fas}

raxml-ng --model GTR --msa {input.combined_fas} --threads {params.THREADS} --tree pars{{3}} --force

#or iqtree
iqtree2 -s cluster85wRefs_uniq_aln.fasta3.rdp5.nr_pol_rrr_na.fas -bb 1000 -m GTR -pre ccluster85wRefs_uniq_aln.fasta3.rdp5.nr_pol_rrr_na.fas.uf

bash scripts/annotate.sh {input.input_tree} 'REFERENCE' {input.input_compressed_fas} {LABEL} {BASEDIR}

mpirun -np {PPN} HYPHYMPI FEL --alignment {input.input_msa} --tree {input.input_tree} --output {output.output} --branches {LABEL}

hyphy FEL --alignment cluster85wRefs_uniq_aln.fasta3.rdp5.nr_pol_rrr_na.fas \
 --ci Yes \
--tree ccluster85wRefs_uniq_aln.fasta3.rdp5.nr_pol_rrr_na.fas.uf.treefile \
--output cluster85wRefs_uniq_aln.fasta3.rdp5.nr_pol_rrr_na.fas.fel.json


/Users/sanemj/Temp/Bioinformatics/HIV/PANGEA/cluster85/wRefs/deduped/msa/rdp5/cluster85wRefs_uniq_aln.fasta3.rdp5.nr_rrr.fas.uf.treefile 

### Cluster 2

## whole genome seqs
cp cluster85wRefs_uniq_aln.fasta2.rdp5.nr_rrs_pruned.fas cluster85wRefs_uniq_aln.fasta2.rdp5.nr_rrs_pruned_sel.fas

sed -i '' -e "s/ /_/g" -e "s/:/_/g" -e "s/|/_/g" -e "s/-/_/g" -e "s/\//_/g"   -e "s/\./_/g" cluster85wRefs_uniq_aln.fasta2.rdp5.nr_rrs_pruned_sel.fas

## Only modify sequence headers /^>/ 
sed -i '' -e "/^>/ s/ /_/g" -e "/^>/ s/:/_/g" -e "/^>/ s/|/_/g" -e "/^>/ s/-/_/g" -e "/^>/ s/\//_/g"   -e "/^>/ s/\./_/g" cluster85wRefs_uniq_aln.fasta2.rdp5.nr_rrs_pruned_sel.fas


iqtree2 -s cluster85wRefs_uniq_aln.fasta2.rdp5.nr_rrs_pruned_sel.fas -bb 1000 -m GTR -pre cluster85wRefs_uniq_aln.fasta2.rdp5.nr_rrs_pruned_sel.fas.uf
iqtree2 -s cluster2_gag1_nr_rrs_pruned.fas -bb 1000 -m GTR -pre cluster2_gag1_nr_rrs_pruned.fas.uf


## GAG1

hyphy /Applications/biotools/hyphy-analyses/codon-msa/pre-msa.bf --input cluster2_gag1_nr_rrs_pruned.fas --compress No

mafft --nomemsave --thread 2 --auto cluster2_gag1_nr_rrs_pruned.fas_protein.fas > cluster2_gag1_nr_rrs_pruned.fas_protein.msa

hyphy /Applications/biotools/hyphy-analyses/codon-msa/post-msa.bf --protein-msa cluster2_gag1_nr_rrs_pruned.fas_protein.msa --nucleotide-sequences cluster2_gag1_nr_rrs_pruned.fas_nuc.fas --output cluster2_gag1_nr_rrs_pruned.fas --compress No

hyphy /Applications/biotools/RASCL/scripts/strike-ambigs.bf --alignment cluster2-proteins/cluster2_gag1_nr_rrs_pruned.fas  --output ccluster2-proteins/cluster2_gag1_nr_rrs_pruned_na.fas



hyphy FEL --alignment cluster2-proteins/cluster2_gag1_nr_rrs_pruned.fas \
 --ci Yes \
--tree cluster85wRefs_uniq_aln.fasta2.rdp5.nr_rrs_pruned_sel.fas.uf.treefile \
--output cluster2-proteins/cluster2_gag1_nr_rrs_pruned_sel.fas.fel.json


hyphy FEL --alignment cluster2_gag1_nr_rrs_pruned.fas \
 --ci Yes \
--tree cluster2_gag1_nr_rrs_pruned.fas.uf.treefile \
--output cluster2_gag1_nr_rrs_pruned.fas.fel.json


### Help lines
# filter outliers from the whole genome treen from the subalignments
seqkit grep -rvf badSeqs.txt cluster2-proteins/cluster2_gag1_nr_rrs.fas > cluster2-proteins/cluster2_gag1_nr_rrs_pruned.fas

# get all ids missing in the subalignement and add back as empty seqs.
grep ">" cluster2-proteins/cluster2_gag1_nr_rrs_pruned.fas | sed "s/>//" | sort > cluster2-proteins/cluster2_gag1_nr_rrs_pruned.fas.ids.srt.txt
seqkit grep -rvf cluster2-proteins/cluster2_gag1_nr_rrs_pruned.fas.ids.txt cluster85wRefs_uniq_aln.fasta2.rdp5.nr_rrs_pruned_sel.fas | grep ">" | less # (if too many print to file and transfer), otherwise, copy and use a text-editor to add.

# to get duplicates that are not being picked up
seqkit grep -rvf cluster2-proteins/cluster2_gag1_nr_rrs_pruned.fas.ids.txt cluster85wRefs_uniq_aln.fasta2.rdp5.nr_rrs_pruned_sel.fas | grep ">" | sed "s/>//" | sort > cluster85wRefs_uniq_aln.fasta2.rdp5.nr_rrs_pruned_sel.fas.ids.srt.txt

diff cluster2-proteins/cluster2_gag1_nr_rrs_pruned.fas.ids.srt.txt cluster85wRefs_uniq_aln.fasta2.rdp5.nr_rrs_pruned_sel.fas.ids.srt.txt

## cluster2_env1-gp120_nr_rrs.fas
seqkit grep -rvf badSeqs.txt cluster85wRefs_uniq_aln_rrs_nr_asp.fasta2.fas > cluster85wRefs_uniq_aln_rrs_nr_asp.fasta2.fas

#remove-line-breaks-in-a-fasta-file
seqkit seq -w 0 cluster85wRefs_uniq_aln_rrs_gag2.fasta2.fas > cluster85wRefs_uniq_aln_rrs_gag2_sel_flat.fasta2.fas


sed -i '' -e "/^>/ s/ /_/g" -e "/^>/ s/:/_/g" -e "/^>/ s/|/_/g" -e "/^>/ s/-/_/g" -e "/^>/ s/\//_/g"   -e "/^>/ s/\./_/g" cluster85wRefs_uniq_aln_rrs_gag2_sel_flat.fasta2.fas

hyphy FEL --alignment cluster85wRefs_uniq_aln_rrs_nr_gag2_sel_flat.fasta.fas  --ci Yes --tree cluster85wRefs_uniq_aln_rrs_nr_gag_sel_flat.fasta2.fas.uf.treefile --output cluster85wRefs_uniq_aln_rrs_nr_gag_sel_flat.fasta2.fas.fel.json



hyphy FEL --alignment cluster2-proteins/cluster2_env1-gp120_nr_rrs_pruned_flat.fas \
--ci Yes \
--tree cluster85wRefs_uniq_aln.fasta2.rdp5.nr_rrs_pruned_sel.fas.uf.treefile \
--output cluster2-proteins/cluster2_env1-gp120_nr_rrs_pruned.fas.fel.json

#### Else

hyphy /Applications/biotools/hyphy-analyses/codon-msa/pre-msa.bf --input cluster2_env1-gp120_nr_rrs_pruned.fas --compress No

mafft --nomemsave --thread 2 --auto cluster2_env1-gp120_nr_rrs_pruned.fas_protein.fas > cluster2_env1-gp120_nr_rrs_pruned.fas_protein.msa

hyphy /Applications/biotools/hyphy-analyses/codon-msa/post-msa.bf --protein-msa cluster2_env1-gp120_nr_rrs_pruned.fas_protein.msa --nucleotide-sequences cluster2_env1-gp120_nr_rrs_pruned.fas_nuc.fas --output cluster2_env1-gp120_nr_rrs_pruned.fas --compress No

hyphy scripts/strike-ambigs.bf --alignment cluster2_env1-gp120_nr_rrs_pruned.fas  --output luster2_env1-gp120_nr_rrs_pruned_na.fas  

iqtree2 -s cluster85wRefs_uniq_aln_rrs_nr_gag1_sel_flat.fasta2.fas -m GTR -pre cluster85wRefs_uniq_aln_rrs_nr_gag1_sel_flat.fasta2.fas.uf
FastTree -nt -gtr -gamma < cluster85wRefs_uniq_aln_nr.fasta3.rdp5.rrs_sel_flat.fas > cluster85wRefs_uniq_aln_nr.fasta3.rdp5.rrs_sel_flat.fas.fast.tree

#If you already have a Newick tree file and you just need to remove the support values, you can use the following UNIX command:

sed -E s/)[0-9.]+:/):/g [input] > [output]



hyphy FEL --alignment cluster85wRefs_uniq_aln_rrs_nr_gag1_sel_flat.fasta2.fas \
 --ci Yes \
--tree cluster85wRefs_uniq_aln_rrs_nr_gag1_sel_flat.fasta2.fas.uf.treefile \
--output cluster85wRefs_uniq_aln_rrs_nr_gag1_sel_flat.fasta2.fas.fel.json


### cluster 3 ML
Creating fast initial parsimony tree by random order stepwise addition...
2.155 seconds, parsimony score: 104029 (based on 6136 sites)
Perform fast likelihood tree search using GTR+I+G model...
Estimate model parameters (epsilon = 1.000)
1. Initial log-likelihood: -457247.666
2. Current log-likelihood: -457245.956
Optimal log-likelihood: -457245.750
Rate parameters:  A-C: 2.06207  A-G: 5.94989  A-T: 1.00386  C-G: 0.71031  C-T: 6.75197  G-T: 1.00000
Base frequencies:  A: 0.345  C: 0.186  G: 0.239  T: 0.229
Proportion of invariable sites: 0.280
Gamma shape alpha: 0.605


### BGM
# we used the following invocation in the macOS Terminal:
HYPHYMP BASEPATH=/usr/local/lib/hyphy/ pwd/fit_codon_model.bf