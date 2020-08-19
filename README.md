# extract-promoter-sequences
A *seemingly* simple step in many bioinformatic pipelines is the extraction of putative promoter regions from genomic sequence. Accomplishing this task often involves either typing lengthy python code, using command line functions that won't preserve the gene name for each promoter, or using complicated open source scripts. Here I provide an easier method that relies heavily on bedtools. 

**INPUT**

There are 5 required inputs to this script:

1. a fasta-formatted sequence file (-f)
2. a genome feature format (gff) file (-g)
3. number of basepairs upstream of the transcription start site to extract (-u)
4. number of basepairs downstream of the transcription start site to extract (-d)
5. a name for the output file containing the promoter sequences in fasta format (-o)

**OUTPUT** 

a fasta file of promoter sequences where each promoter sequence has the same name (same fasta header line) as its associated gene sequence.

**IMPORTANT**

Thi code **will*** account for chromosome boundaries.

This code will **NOT** account for overlaps between promoter sequences and the coding sequence of adjacent gene models. If two gene models are close together or are overlapping in your gff file, the promoter regions will bleed into coding sequence. Such instances should be relatively rare in most datasets. I explicitly avoided accounting for promoter-gene overlaps because there's no obvious answer for how to handle situations where one gene feature fully overlaps with another gene feature on a chromosome.


## USAGE
Download the three scripts in this repository and put them all in the same directory as the fasta file and gff file you want to extract promoter sequences from. Make sure
you make all three of these scripts executable with:

`chmod +x extract_prom_seq.bash`

`chmod +x build_genome_file.py`

`chmod +x subset_gene_features.R`

`chmod +x seq_merge.py`

To extract promoter sequences, use:

`./extract_prom_seq.bash -g <GFF FILE> -f <FASTA FILE> -u <BP UPSTREAM OF TSS> -d <BP DOWNSTREAM OF TSS> -o <NAME OF OUTPUT FASTA FILE>`

For example:

`./extract_prom_seq.bash -f my.fasta -g my.gff -u 1000 -d 500 -o my_prom.fasta`

will extract sequences that include 1000 bp upstream of the transcription start site, 500 bp downstream of the transcription start site, and the transcription start site itself for every gene listed in my.gff from my.fasta. These sequences are then saved to my_prom.fasta. Thus, most of the final sequences will be 1501 bp long (1000 + 500 + 1). Gene features near the ends of chromosomes may be shorter than this simply because sequence cannot be extracted beyond the chromosome boundaries. 

## FORMAT NOTES
The final column in the GFF file is typically written as a dictionary in the format 
key1=value1;key2=value2;... etc.

In order for this code to work, every feature labeled as "gene" in the gff file should have 
a "Name" key whose value is the name of the gene. For example, a line in the gff file may look like this:

```
ch01    maker     gene      93750     94430     .     +     .     ID=somegene;Name=gene1.1
```

There can be as many dictionary entries in the final column as desired, so long as the "Name" entry exists.

## DEPENDENCIES

1. bedtools

Installation instructions are [here](https://bedtools.readthedocs.io/en/latest/content/installation.html)

2. R and the stringr package

I tested this with R 3.6

3. Biopython

Installation instructions are [here](https://biopython.org/wiki/Download)

## REFERENCES

I acquired the code in the seq_merge.py file from this [Stack Overflow post](https://bioinformatics.stackexchange.com/questions/4714/how-to-merge-transcript-sequence-with-same-name-in-a-fasta-file).
