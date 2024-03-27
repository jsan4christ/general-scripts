from pyfaidx import Fasta
from sys import argv
import pandas as pd
from os import path, makedirs


# TODO: Rplace stop codon with --- if it occus in between
# Replace partial codon with ---

fasta = Fasta(argv[1])
print(argv[1])
seq_range = pd.read_csv(argv[2], comment="#")
flb = path.split(argv[1])[1].split('.')[0]
print(flb)
makedirs(flb, exist_ok=True)
for _, row in seq_range.iterrows():
    with open(f"{flb}/{row['gene']}.fa", 'w') as fout:
        for k in fasta.keys():
            seq = fasta[k][row['start'] - 1:row['end']]
            fout.write(f">{k}\n{seq}\n")
