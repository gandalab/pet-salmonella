#!/bin/bash

# --- MODIFY PATHS ---
RAWDIR=/path/to/rawreads
QUALDIR=/path/to/quality

conda activate bioinfo # activate conda env

# --- Download Reads with fastq-dump ---
#NOTE: inlist needs to be in working directory

# reads from acclist
for i in `cat acclist`; do printf ${i}"\t" ; fastq-dump ${i} --gzip --split-files --outdir $RAWDIR ; done

echo "fastq-dump complete"

# --- QC Check with FastQC and MultiQC ---

# run fastqc
fastqc $RAWDIR/*.gz -o $QUALDIR -t 10

#run multiqc
export LC_ALL=en_US.utf-8
export LANG=en_US.utf-8

multiqc $QUALDIR/*.zip -o $QUALDIR --interactive

echo "qc complete"

echo "Job ended at $(date)"