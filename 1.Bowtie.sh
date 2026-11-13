#!/bin/bash
#SBATCH --job-name=bowtie2
#SBATCH --mail-user=viannam@ufl.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --nodes=1
#SBATCH --mem=10MB
#SBATCH --qos=mresende-b
#SBATCH --account=mresende
#SBATCH --time=96:00:00
#SBATCH --output=bowtie2_%A.out
#SBATCH --error=bowtie2_%A.err

module load bowtie2
module load samtools

#------- 1. To build a index first

bowtie2-build -f /path/to/Zm-Ia453-REFERENCE-FL-1.0.fa Ia453

bowtie2 --very-sensitive -f -x Ia453  kmers_germ.fa -S Ia453_kmers_germ.sam

# ------- 2. to remove header

samtools view Ia453_kmers_germ_100k.sam > Ia453_germ_100k.sam 

# ------- 3. unmapped

samtools view -f4 Ia453_kmers_gem_100k.sam > Ia453_germ_100k_unmapped.sam

