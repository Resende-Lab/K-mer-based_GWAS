#!/bin/bash
#SBATCH --job-name=KOC
#SBATCH --mail-user=user_mail
#SBATCH --mail-type=END,FAIL
#SBATCH --nodes=1
#SBATCH --mem=120GB
#SBATCH --qos=mresende-b
#SBATCH --account=mresende
#SBATCH --time=96:00:00
#SBATCH --cpus-per-task=10
#SBATCH --output=kmers_%A_%j.out
#SBATCH --error=kmers_%A_%j.err
##SBATCH --array=1-693  #number of genotypes
#https://github.com/voichek/kmersGWAS/blob/master/manual.pdf

module load kmc/3.1.1
module load R/4.1
module load gemma/0.98.1
module load gcc/9.3.0
module load bamtoolspath="/path/to/Genotypes"

#X=$(cut -f1 /blue/mresende/share/viannam/Kmers/Sample-genotypes.txt| head -n ${SLURM_ARRAY_TASK_ID} | tail -n 1) #Genotypes name file list
mkdir ${path}/${X}

ls  /path/to/fasta_files/${X}/*${X}*R1*.fastq* /path/to/fasta_files/${X}/*${X}*R2*.fastq*  > ${path}/${X}/input_file_${X}.txt

cd ${path}/${X}/

#Run KMC for the fist time
#-t: number of threads
#-k: k-mer length
#-ci: threshold for counted k-mers. Depends on the coverage, sould be the same for all individuals

kmc -t2 -k31 -ci2 @input_file_${X}.txt output_kmc_canon_${X} ./ 1> kmc_all_${X}.1 2> kmc_all_${X}.2

#Running KMC for the second time
#Counting the kmer for the second time (whitout canonization) ci=0
#-t: number of threads
#-k: k-mer length
#-ci: threshold for counted k-mers. Depends on the coverage, sould be the same for all individuals. This time we count all k-mers
#-b: do not canonized k-mers

kmc -t2 -k31 -ci0 -b @input_file_${X}.txt output_kmc_all_${X} ./ 1> kmc_all_${X}.1 2> kmc_all_${X}.2

#Combining information
#-c: prefix of KMC DB files (with canonization)
#-n: prefix of KMC DB files (whitout canonization)
#-k: k-mer lenght
#-o: outpufile

./bin/kmers_add_strand_information -c output_kmc_canon_${X} -n output_kmc_all_${X} -k 31 -o kmers_with_strand_${X}
