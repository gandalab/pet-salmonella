#!/bin/bash

# --- Modify These Variables ---

# working directory
WD=/dir

# output directory for fastq files
RAWDIR=/dir/rawreads

# output directory for fastqc and multiqc output
QUALDIR=/dir/quality

#activate bioinfo conda environment 
conda activate bioinfo 

# --- Download Reads with fastq-dump ---
#NOTE: inlists need to be in working directory ($WD)

#create subdirectories for output
mkdir -p $RAWDIR/dog
mkdir -p $RAWDIR/human

# reads from sradog.txt
cat $WD/sradog.txt | parallel /storage/work/smk459/miniconda3/envs/bioinfo/bin/fastq-dump {} --gzip --split-files --outdir $RAWDIR/dog

# reads from srahuman.txt
cat $WD/srahuman.txt | parallel /storage/work/smk459/miniconda3/envs/bioinfo/bin/fastq-dump {} --gzip --split-files --outdir $RAWDIR/human

echo "fastq-dump complete"

# --- QC Check with FastQC and MultiQC ---

# create subdirectories for output
mkdir -p $QUALDIR/dog
mkdir -p $QUALDIR/human


# run fastqc
fastqc $RAWDIR/dog/*.gz -o $QUALDIR/dog -t4
fastqc $RAWDIR/human/*.gz -o $QUALDIR/human -t4

#run multiqc 
multiqc $QUALDIR/dog/*.zip -o $QUALDIR/dog/ --interactive
multiqc $QUALDIR/human/*.zip -o $QUALDIR/human/ --interactive

echo "qc complete"




