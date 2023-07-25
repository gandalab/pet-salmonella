#!/bin/bash

# --- download reference Salmonella LT2 ----

cd /dir/

wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/006/945/GCF_000006945.2_ASM694v2/GCF_000006945.2_ASM694v2_genomic.fna.gz

#decompress to run phame
gunzip GCF_000006945.2_ASM694v2_genomic.fna.gz

#rename
mv GCF_000006945.2_ASM694v2_genomic.fna ref.fa 

# --- run phame ---
#change to correct wd with phame.ctl file
cd /path/to/phame.ctl

#activate phame env
conda activate phame_env

#run phame.ctl
/storage/home/smk459/miniconda3/envs/phame_env/PhaME/src/phame phame.ctl 

echo "phame completed"