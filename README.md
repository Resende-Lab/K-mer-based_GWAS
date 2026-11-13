# K-mer-based GWAS and GS in a sweet corn population

### Paper

**Title**: Genome-wide association and genomic selection through k-mer-based variants in sweet corn.  
**Authors**: Vianna, Mariana S.; Peixoto, Marco A.; Resende, Marcio F. R.  
**DOI**: *

<br>

### Content

*01.kmers_KOC.sh*: Builds the k-mer catalog for each sample/genotype from raw FASTQ files using KMC (k-mer counting), keeping both canonical and non-canonical versions and strand info. 

*02.kmers_table*: Takes the per-sample k-mer files and creates the population-level k-mer presence/absence table; also computes kinship and converts the table to PLINK-style format for GWAS. 

*03.kmer-GWAS*: Runs the actual k-mer GWAS analysis using kmers_gwas.py and GEMMA, with a permutation-based threshold. 

*04.alignment*: Aligns the generated k-mer sequences against a reference genome using Bowtie and filters the SAM output. 

*05.input_assoc.R*: Merges association result files into one table, reformats k-mer IDs, and writes a combined association file / fasta set for downstream analysis. 

*06.Bowtie.sh*: Builds a Bowtie2 index and aligns k-mer sequences to the reference genome; also extracts unmapped reads. 

*07.Trimming.sh*: Preprocesses raw paired-end WGS reads with Trimmomatic to remove adapters and low-quality bases before k-mer counting. 



***

If you have any questions about the analyses, please, contact me!  

Mariana Vianna
Email: mvianna@abacusbio.com



<br>



### Bibliography

He C, Washburn JD, Schleif N, Hao Y, Kaeppler H, Kaeppler SM, Zhang Z, Yang J, Liu S. 2024. Trait association and prediction through integrative k‐mer analysis. The Plant Journal. 120(2):833–850. https://doi.org/10.1111/tpj.17012.

Voichek Y, Weigel D. 2020. Identifying genetic variants underlying phenotypic variation in plants without complete genomes. Nat Genet. 52(5):534–540. https://doi.org/10.1038/s41588-020-0612-7.
