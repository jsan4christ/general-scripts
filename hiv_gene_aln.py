from pyfaidx import Fasta
from sys import argv
import pandas as pd
from os import path, makedirs


# TODO: Rplace stop codon with --- if it occus in between
# Replace partial codon with ---
def replace_partial_codon_and_stop_codon(seq):
    new_seq = ""
    seq = str(seq)
    if len(seq) % 3 != 0:
        seq = seq[:-1 * (len(seq) % 3)]
    for i in range(0, len(seq), 3):
        if (seq[i:i + 3] in ['TAG', 'TGA', 'TAA']) or '-' in seq[i:i + 3]:
            new_seq += '---'
        else:
            new_seq += seq[i:i + 3]
    return new_seq


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
            seq = replace_partial_codon_and_stop_codon(seq)
            fout.write(f">{k}\n{seq}\n")
