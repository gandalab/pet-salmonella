#!/bin/bash

#PBS -N human-AMR
#PBS -l nodes=1:ppn=10
#PBS -l pmem=16gb
#PBS -l walltime=10:00:00
#PBS -A open
#PBS -j oe
#PBS -m e
#PBS -M PSUID@psu.edu

# set wd to location of fastq files and sample list file
$WD=/path/to/files
cd $WD

# activate conda environment
conda activate bioinfo

# define list of samples to run
NAMES=SrrHuman.txt

#create blastdb from megares database 
    #create directory
        mkdir refs
        cd refs
        mkdir blastdb
        cd blastdb
    #download reference file 
        wget https://megares.meglab.org/download/megares_v2.00/megares_full_database_v2.00.fasta
    #create blast database from reference file and output as megares
        makeblastdb -in megares_full_database_v2.00.fasta -dbtype nucl -out megares 

# get database path
DB=$WD/refs/blastdb/megares

#change directory back to WD
cd $WD

# FIRST STEP: trimmomatic 
    #create directory for trimmed reads
    mkdir trimmed
    
    # remove all reads under 50 bp
    cat $NAMES | parallel /path/to/miniconda3/envs/bioinfo/bin/trimmomatic PE $WD/{}_R1.fq.gz  $WD/_R2.fq.gz -baseout $WD/trimmed/trim_{}.fastq.gz -threads 10 MINLEN:50

# SECOND STEP: flash
    #create dreictory for merged reads
    mkdir merge

    # merge paired-end reads with default settings
    cat $NAMES | parallel /path/to/miniconda3/envs/bioinfo/bin/flash $WD/trimmed/trim_{}_1P.fastq.gz $WD/trimmed/trim_{}_2P.fastq.gz --output-prefix {} --threads 10 --max-overlap 100

    #move files into merge directory
    mv *.fastq merge
    mv *.hist* merge

# THIRD STEP: convert to fasta
    #create directory for fasta files
    mkdir fa

    # convert fastq to fasta
    cat $NAMES | parallel /path/to/miniconda3/envs/bioinfo/bin/seqkit fq2fa $WD/merge/{}.extendedFrags.fastq --out-file $WD/fa/{}.fasta --threads 10


# FOURTH STEP: blast against MEGARES db
    #create directory for file output
    mkdir blastn-out

    # perform local alignment against blastdb
    cat $NAMES | parallel /path/to/miniconda3/envs/bioinfo/bin/blastn -query $WD/fa/{}.fasta -db $DB -out $WD/blastn-out/{}.txt -num_threads 10 -outfmt "'6 qacc sacc pident qlen slen length covs qcovhsp qcovus'"

    # Filter output for percent ID >80 and coverage >80
    cat $NAMES | parallel cat $WD/blastn-out/{}.txt | cut -f 1-3,7 | awk '($3 >= 80) && ($4 >= 80)' > human-amr-filt.txt