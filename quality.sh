#!/bin/bash

#PBS -N "JOB_NAME"
#PBS -l nodes=1:ppn=1
#PBS -l pmem=16gb
#PBS -l walltime=10:00:00
#PBS -A open
#PBS -j oe
#PBS -m e
#PBS -M PSUID@psu.edu

# activate conda environment
conda activate bioinfo

# set directory
DIR=/path/to/files

#STEP ONE: FASTQC
    #change to directory containing fastq.gz files
    cd $DIR 
    #run fastqc with output to quality directory
    fastqc *fq.gz -o $DIR/quality/


#STEP TWO: MulitQC
    #change to directory containing fastqc.zip files
    cd $DIR/quality

    #run these to prevent recurrent error when run without them
    export LC_ALL=en_US.utf-8
    export LANG=en_US.utf-8

    #run multiqc
    multiqc $DIR/quality/*_fastqc.zip 



