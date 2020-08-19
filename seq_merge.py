#CODE CAME FROM: https://bioinformatics.stackexchange.com/questions/4714/how-to-merge-transcript-sequence-with-same-name-in-a-fasta-file
import sys

seqs = {}
with open(sys.argv[1], "r") as fh:
    curr = ""
    for line in fh:
        if line.startswith(">"):
            curr = line
            if curr not in seqs:
                seqs[curr] = ""
        else:
            seqs[curr] += line.strip()

for ident, seq in seqs.items():
    print("{}{}".format(ident, seq))
