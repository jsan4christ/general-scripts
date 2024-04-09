## Ok after deduplicated the 16M spike sequences we get 158,450 so I ran the spike extractor script to 
## get the RBD regions for those and then filtered for sequences ge 150aa and we are left with 158,422. 
## I've clustered those at id .9 which gives us 156 clusters

# Remove spaces in sequence names, replacing them with _

sed '/^>/ s/ /_/g' < spikenuc0213.fasta > spikenuc0213_nospaces.fasta

augur parse --sequences spikenuc0213.fasta \
	--output-sequences spikenuc0213_sequences.fasta
	--output-metadata  spikenuc0213_metadata.fasta
	--fields gene,strain,date,epi_id,type,virus,host,submitting_lab,originating_lab,province,country

/datacommons/dhvi/KJW/scripts_dev/spike_extractor/spike_extractor -q  WIV04_RBD.fasta -i GISAID_spikes.dedup.fasta -go 11 \
 -ge 1 -matrix /datacommons/dhvi/KJW/scripts_dev/spike_extractor/BLOSUM62.txt > RBD_extractor_output.fasta

/datacommons/dhvi/bin/usearch -cluster_fast ../RBD_extractor_output.ungapped.ge150.fasta -id .9 -centroids nr.fasta -uc clusters.uc -sort size -clusters clusters/

srun -p dhvi --mem=128G --exclude=dcc-dhvi-12 --pty bash -i

nextclade run \
   --verbose \
   --input-dataset data/sars-cov-2 \
   --output-all=output/ \
   --cds-selection=S \
   --output-tsv=output/nextclade.tsv \
   --output-tree-nwk=output/nextclade.tree.nwk \
   --output-translations=output/nextclade_CDS_{cds}.translation.fasta.zst \
   spikenuc0213.fasta
   
   
   
   
### Rm

seqkit rmdup -e ".xz" -j 64 -sn --ignore-case spikenuc0213.fasta -o deduped/spikenuc0213_uniq.fasta0 --dup-seqs-file deduped/dups/spikenuc0213_dups.fasta0 --dup-num-file deduped/dups/spikenuc0213_dups.txt


seqkit sample -n 3 {} ::: seq 0 157


## MB
/datacommons/dhvi/bin/usearch -cluster_fast ../RBD_extractor_output.utf8.ungapped.ge200.fasta -id .9 -centroids nr.fasta -uc clusters.uc -sort size -clusters clusters/

# 304 clusters, 3.4 million sequences
"/datacommons/dhvi/mb488/COVID/GISAID/spikeprot0317/RBD_extractor/dedup/usearch"

# Average number of files per cluster:

seqkit seq -w 0 sample3.fasta > sample3_nb.fasta

parallel 'seqkit seq -w 0 {} > {}_nobreaks.fasta'  ::: $(ls * | sort -n)

parallel 'wc -l {}_nobreaks.fasta >> n_seqs.txt ' ::: $(ls *_nobreaks.fasta | cut -d '_' -f1 | sort -n)

# https://mafft.cbrc.jp/alignment/software/closelyrelatedviralgenomes.html
mafft --6merpair --mapout --keeplength --addfragments  sample3_nb.fasta ../WIV04_RBD.fasta > sample3_nb_aln.fasta

# https://www.biostars.org/p/302162/
# Columns: (i) sequence identifier, (ii) position in the alignment, (iii) character in this sequence, (iv) character in the reference sequence.
python count_mutations.py sample3_nb_aln.fasta > mutations.txt

# https://stackoverflow.com/questions/39255781/what-is-difference-between-geom-point-and-geom-jitter-in-simple-language-in-r


python /datacommons/dhvi/mb488/COVID/spikenuc0213/.count_X.py RBD_extractor_output.fasta X > /datacommons/dhvi/mb488/COVID/spikenuc0213/x_count.txt
python /datacommons/dhvi/mb488/COVID/spikenuc0213/.count_X.py RBD_extractor_output.fasta - > /datacommons/dhvi/mb488/COVID/spikenuc0213/dash_count.txt