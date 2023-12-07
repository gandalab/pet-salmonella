#!/bin/bash

# Usage: sh trimmomatic.sh <path to input files>

# --- MODIFY PATHS ---

TRIM=/path/to/trimmomatic
RAWDIR=/path/to/rawreads
OUTDIR=/path/to/trimmed

cd ${RAWDIR}

for f in *_1.fastq.gz
do
outfile=${f%_1.fastq.gz}.fq.gz
echo "${f}"

${TRIM}/trimmomatic PE "${f}" "${f%_1.fastq.gz}_2.fastq.gz" \
-baseout "${OUTDIR}/${outfile}" -threads 10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

done

echo "trimmomatic complete"