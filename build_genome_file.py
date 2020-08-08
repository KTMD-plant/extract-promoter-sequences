from Bio import SeqIO
import csv
import sys

#Create genome file for bedtools
print("Extracting chromosome lengths from %s ..." % str(sys.argv[1]))
ids = []
lengths = []
for rec in SeqIO.parse(str(sys.argv[1]), "fasta"):
	ids.append(rec.id)
	lengths.append(len(rec))

rows = zip(ids, lengths)
with open("genome.txt", "w") as f:
	writer = csv.writer(f)
	for row in rows:
		writer.writerow(row)

print("Chromosome lengths extracted.")
