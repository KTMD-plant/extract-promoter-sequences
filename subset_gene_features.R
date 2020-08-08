#Load required package
library(stringr)

#Define function for subsetting gff file to only gene features, then replacing feature names with gene names
subset_gff = function(input, output){
	gff = read.delim(input, sep = "\t", header = F)

	#Subset only entries for desired feature
	gffsub = gff[which(gff$V3 == "gene"),]

	#Extract gene names, remove extraneous dictionary keys and values as needed
	names = str_extract(gffsub$V9, "Name=.*;")
	names = gsub("Name=", "", names)
	names = gsub(";.*$", "", names)

	#Replace feature column with gene names
	gffsub$V3 = names

	#write output
	write.table(gffsub, output, quote = F, sep = "\t", row.names = F, col.names = F)
}

#Execute function
subset_gff("notags.gff", "notags_wnames.gff")
