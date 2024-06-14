rm(list=ls())
args = commandArgs (trailingOnly = TRUE)

#This script will manipulate all gwas_trait output files from Voichek`s pipeline (lmm) to plot
# We are getting 100K kmers to plot
##First, lets merge all assoc files

setwd("/path/to/GWAS/outputs/folders")

directory_name <- as.character(args[1])
#directory_name <- as.character("trait_folder_name")

setwd(paste("/path/to/GWAS/outputs/folders", directory_name, "/kmers/output/", sep = ""))
getwd()

file_list <- list.files(paste("/path/to/GWAS/outputs/folders", directory_name, "/kmers/output/", sep = ""), pattern = "P*.assoc.txt")

file_list <- file_list[!grepl("phenotype_value.assoc.txt", file_list)]

# # Read the header from the first file
header <- read.table(file_list[1], header = FALSE, nrows = 1, sep = "\t")
header
#
# # Initialize an empty data frame to store the merged data
merged_data <- data.frame()
#
# # Loop through each file, read the data, and append it to the merged_data
for (file_path in file_list) {
#   # Read the data skipping the header
  data <- read.table(file_path, header = FALSE, skip = 1, sep = "\t")
#   # Append the data to the merged_data
   merged_data <- rbind(merged_data, data)
 }
#
 colnames(merged_data) <-  header
#
 head(merged_data)

write.table(merged_data, file = "all_P_assoc.txt", sep = "\t", quote = FALSE, row.names = FALSE)

merged_data <- read.table("all_P_assoc.txt", sep = "\t", header = TRUE)
head(merged_data)

#Split the "rs" column into "kmer_ID" and "number"
split_rs <- strsplit(as.character(merged_data$rs), "_")
kmer_data <- matrix(unlist(split_rs), ncol = 2, byrow = TRUE)
colnames(kmer_data) <- c("kmer", "Kmer_ID")
head(kmer_data)

merged_data <- cbind(merged_data, kmer_data)

# Drop the original "rs" column
merged_data <- merged_data[, !(names(merged_data) %in% c("rs"))]

head(merged_data)

merge_data_path <- paste("/blue/mresende/share/viannam/Kmers/kmersGWAS/", directory_name, "/kmers/output/all_P_assoc_filtered.txt", sep = "")
write.table(merged_data, file = merge_data_path, sep = "\t", quote = FALSE, row.names = FALSE)

##Second, lets create the kmer fasta file information

# Define the file path for the Fasta file
fasta_file_path <- paste("/path/to/GWAS/outputs/folders", directory_name, "/kmers/output/", directory_name, "all_P.fasta", sep = "")


# Open the file for writing
file_conn <- file(fasta_file_path, "w")

# Write Fasta entries to the file
for (i in 1:nrow(merged_data)) {
  kmer_id <- paste(merged_data$Kmer_ID[i])
  kmer <- merged_data$kmer[i]
  writeLines(paste(">", kmer_id, sep = ""), file_conn)
  writeLines(kmer, file_conn)
}

# Close the file connection
close(file_conn)
