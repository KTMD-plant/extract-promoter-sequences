# extract-promoter-sequences
A seemingly simple step in many bioinformatic pipelines is the extraction of putative promoter regions from genomic sequence. Accomplishing this task often involves either typing lengthy python code, using command line functions that won't preserve the gene name for each promoter, or using complicated open source scripts. Here I provide an easier method that relies heavily on bedtools. 

**INPUT:**
1. a fasta-formatted sequence file,
2. a genome feature format (gff) file, 
3. the desired promoter length in basepairs

**OUTPUT:** 
a fasta file of promoter sequences where each promoter sequence has the same name as its associated gene sequence.

## USAGE
Download the three scripts in this repository and put them all in the same directory as the fasta file and gff file you want to extract promoter sequences from. Make sure
you make all three of these scripts executable with:

`chmod +x extract_prom_seq.bash`

`chmod +x build_genome_file.py`

`chmod +x subset_gene_features.R`

To extract promoter sequences, use:

`./extract_prom_seq.bash -f <FASTA FILE> -g <GFF FILE> -l <DESIRED PROMOTER LENGTH>`

For example:

`./extract_prom_seq.bash -f my.fasta -g my.gff -l 500`

will extract 500 bp of sequence upstream of every gene listed in my.gff from my.fasta.

## FORMAT NOTES
The final column in the GFF file is typically written as a dictionary in the format 
key1=value1;key2=value2;... etc.

In order for this code to work, every feature labeled as "gene" in the gff file should have 
a "Name" key whose value is the name of the gene. For example, a line in the gff file may look like this:

ch01    maker     gene      93750     94430     .     +     .     ID=somegene;Name=gene1.1

There can be as many dictionary entries in the final column as desired, so long as the "Name" entry exists.

## DEPENDENCIES

1. bedtools

Installation instructions are [here](https://bedtools.readthedocs.io/en/latest/content/installation.html)

2. R and the stringr package

I tested this with R 3.6

3. Biopython

Installation instructions are [here](https://biopython.org/wiki/Download)

4. dos2unix (maybe optional, but I need to do more testing)

Install with:

`sudo apt install dos2unix`
