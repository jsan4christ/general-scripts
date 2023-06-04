
for fl in glob(f"{inf}/*"):
        bs = path.split(fl)[1]
        outfile = open(f"{otf}/{bs}", "w")
                outfile.write(f">{rec.description}\n{rec.seq}\n")
        outfile.close()

my $fh = Bio::SeqIO->new(-file=>$aln_file, -format=>'fasta', -alphabet=>'dna');
