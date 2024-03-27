 lanl_refset_ns.txt - final nextstrain refset with old names
 
 seqkit grep -rf lanl_refset_ns.txt lanl_refs.fasta > nexstrain_lanl_refs.fasta #keep only those sequences
 
 for i in `cat rename_refs.txt`;  do  on=$(echo $i | cut -d "," -f1);  nn=$(echo $i | cut -d "," -f2);  sed -i '' "s#$on#$nn#g" nexstrain_lanl_refs.fasta;  done

nexstrain_lanl_metadata.tsv
nexstrain_lanl_refseqs.fasta

cluster85_2_nextstrain_metadata.tsv	
cluster85_2_nextstrain_sequences.fasta	