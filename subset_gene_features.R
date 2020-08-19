#Load required package
library(stringr)

#Define function for subsetting gff file to only gene features, then replacing feature names with gene names
subset_gff = function(input, output){
	gff = read.delim(input, sep = "\t", header = F)

	#Subset only entries for desired feature
	gffsub = gff[which(gff$V3 == "gene"),]

	#Mark the transcription start sight of each gene feature
		#If strand is +, reassign end to start
	gffsub[which(gffsub$V7 == "+"),"V5"] = gffsub[which(gffsub$V7 == "+"),"V4"]
		#If strand is -, assign start same value as end
	gffsub[which(gffsub$V7 == "-"),"V4"] = gffsub[which(gffsub$V7 == "-"),"V5"]

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
subset_gff("notags_gff.tmp", "notags_wnames_gff.tmp")
