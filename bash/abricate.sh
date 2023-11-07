#!/bin/bash

# --- MODIFY PATHS ---
RAWDIR=/path/to/rawreads
AMR=/path/to/abricate-amr

conda activate abricate # activate conda env

cd ${CONTIGS} # change to working directory


abricate --db megares *.fasta > ${AMR}/amr.tab  # run abricate for: amrg


abricate --summary ${AMR}/amr.tab > ${AMR}/amr_summary.txt # summarize into presence absence matrix

echo "AMR ended at $(date)"

# run abricate for: vf
abricate --db vfdb *.fasta > ${VF}/vf.tab  # run abricate for: vf


abricate --summary ${VF}/vf.tab > ${VF}/vf_summary.txt # summarize into presence absence matrix

echo "VF ended at $(date)"

echo "abricate complete"