#!/bin/bash

echo "USAGE: ./extract_prom_seq.bash -g <GFF FILE> -f <FASTA FILE> -u <BP UPSTREAM> -d <BP DOWNSTREAM> -o <OUTPUT FILE NAME>"
#Input gff file and fasta file names and desired promoter length
#Parse input arguments
while getopts g:f:u:d:o: option; do
		case "${option}" in
			g) GFF=${OPTARG};;
			f) FASTA=${OPTARG};;
			u) UP=${OPTARG};;
			d) DOWN=${OPTARG};;
			o) OUT=${OPTARG};;
		esac
	done

echo "Extracting promoter sequences $UP bp upstream and $DOWN bp downstream of transcription start site from $FASTA using coordinates in $GFF..."

#Generate genome file (i.e. tsv file of chromosome lengths)
python3 script0.0_build_genome_file.py $FASTA

#Remove hashtags from gff, then the empty lines that result
echo Formatting gff file for input into R...
sed 's/#.*//g' $GFF | sed '/^[[:space:]]*$/d' > notags_gff.tmp

#Subset gene features, replace feature name with gene names, this will keep the gene name
#with the promoter sequence when bedtools is called later
echo Extracting gene feature coordinates and names...
Rscript script0.1_subset_gene_features.R

#Extract coordinates for regions near TSS, account for strandedness, merge with original file so that start sites aren't lost
echo Extracting promoter coordinates...
bedtools flank -s -i notags_wnames_gff.tmp -g genome.tmp -l $UP -r $DOWN > notags_wnames_flanks_gff.tmp

#Filter out occurences where end < start
echo Filtering out flank artifacts...
awk '($4 <= $5)' notags_wnames_flanks_gff.tmp > notags_wnames_flanks_filt_gff.tmp

#Combine with original file, sort, then merge bookended features
cat notags_wnames_gff.tmp notags_wnames_flanks_filt_gff.tmp > notags_wnames_flanks_combined_gff.tmp
bedtools sort -i notags_wnames_flanks_combined_gff.tmp > notags_wnames_flanks_combined_sorted_gff.tmp

#Create fasta file of promoter sequences
echo Extracting promoter sequences...
bedtools getfasta -name -s -fi $FASTA -bed notags_wnames_flanks_combined_sorted_gff.tmp -fo prom_fasta.tmp

#Remove strandedness designation
echo Removing strand designation from header...
sed -i 's/[()+-]*//g' prom_fasta.tmp

#Merge sequences with the same id
echo Merging sequences with the same id...
python3 script0.2_seq_merge.py prom_fasta.tmp > $OUT

#Remove strandedness designator from fasta file
#Remove intermediate, unneccessary files
echo Cleaning up files...
rm genome.tmp notags_gff.tmp notags_wnames_flanks_combined_gff.tmp notags_wnames_flanks_combined_sorted_gff.tmp notags_wnames_flanks_gff.tmp notags_wnames_gff.tmp prom_fasta.tmp notags_wnames_flanks_filt_gff.tmp
echo Done.

