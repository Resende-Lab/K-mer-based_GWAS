#!/bin/bash
#SBATCH --job-name=SweetTrim
#SBATCH --qos=mresende
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=30
#SBATCH --mem=150gb
#SBATCH --time=96:00:00
#SBATCH --output=1.tmp/1.trimmomatic_flex_%j.log
#SBATCH --error=2.error/2.trimmomatic_flex_%j.err

module load trimmomatic

INPUT_DIR="/path/to/dataRaw/Fastqs_WGS/"
OUTPUT_DIR="/output/WGS_Trim/"
ADAPTERS="/0.adapter_for_trimming/TruSeq3-PE.fa"

R1_FILES=( $(find "${INPUT_DIR}" -type f -name "*_R1_001.fastq.gz") )

total_files=${#R1_FILES[@]}
current_file=0

echo "Found ${total_files} R1 FASTQ files in ${INPUT_DIR}"

for R1 in "${R1_FILES[@]}"; do
    ((current_file++))
    echo "Processing file ${current_file} of ${total_files}: ${R1}"
    
    # Derive the matching R2 filename
    R2="${R1/_R1_001.fastq.gz/_R2_001.fastq.gz}"

    # Extract only the portion of the filename between 'UFL_' and '_i5'
    basefile=$(basename "${R1}")
    sample_name=$(echo "${basefile}" | sed -n 's/.*\(UFL_[^_]*_[^_]*_[^_]*\).*/\1/p')

    # Run Trimmomatic in paired-end mode
    trimmomatic PE -threads 30 \
      "${R1}" "${R2}" \
      "${OUTPUT_DIR}/${sample_name}_R1_paired.fastq.gz" \
      "${OUTPUT_DIR}/${sample_name}_R1_unpaired.fastq.gz" \
      "${OUTPUT_DIR}/${sample_name}_R2_paired.fastq.gz" \
      "${OUTPUT_DIR}/${sample_name}_R2_unpaired.fastq.gz" \
      ILLUMINACLIP:"${ADAPTERS}":2:30:10 \
      LEADING:3 TRAILING:3 \
      SLIDINGWINDOW:4:15 \
      MINLEN:36

done

echo "Trimmomatic pre-processing complete. Processed ${total_files} paired-end datasets."

