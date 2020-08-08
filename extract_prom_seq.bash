#!/bin/bash

#Input gff file and fasta file names and desired promoter length
#Parse input arguments
while getopts g:f:l: option; do
		case "${option}" in
			g) GFF=${OPTARG};;
			f) FASTA=${OPTARG};;
			l) LENGTH=${OPTARG};;
		esac
	done

echo "Extracting promoter sequences $LENGTH bp long from $FASTA using coordinates in $GFF..."

#Generate genome file (i.e. tsv file of chromosome lengths)
python3 build_genome_file.py $FASTA

#Replace commas with tabs in genome file
sed -i 's/,/\t/g' genome.txt
dos2unix genome.txt
echo Conversion done.
#Remove hashtags from gff, then the empty lines that result
echo Formatting gff file for input into R...
sed 's/#.*//g' $GFF > notags.gff
sed -i '/^[[:space:]]*$/d' notags.gff

#Subset gene features, replace feature name with gene names, this will keep the gene name
#with the promoter sequence when bedtools is called later
echo Extracting gene feature coordinates and names...
Rscript subset_gene_features.R

#Extract coordinates for regions 1000 bp upstream of genes, account for strandedness
echo Extracting promoter coordinates...
bedtools flank -s -i notags_wnames.gff -g genome.txt -l $LENGTH -r 0 > prom.gff

#Create fasta file of promoter sequences
echo Extracting promoter sequences...
bedtools getfasta -name -s -fi $FASTA -bed prom.gff -fo prom.fasta

#Remove strandedness designator from fasta file
#Remove intermediate, unneccessary files
echo Cleaning up files...
sed -i 's/[()+-]*//g' prom.fasta

rm genome.txt
rm prom.gff
rm notags.gff
rm notags_wnames.gff

echo Done

