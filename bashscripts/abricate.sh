#!/bin/bash

# activate conda env
conda activate abricate

# set directory paths
CONTIGS=/path/to/contigs
AMR=/path/to/abricate-amr
VF=/path/to/abricate-vf

# change to working directory
cd ${CONTIGS}

# run abricate for: amrg
abricate --db megares *.fasta > ${AMR}/amr.tab 

# summarize into presence absence matrix
abricate --summary ${AMR}/amr.tab > ${AMR}/amr_summary.txt

echo "AMR ended at $(date)"

# run abricate for: vf
abricate --db vfdb *.fasta > ${VF}/vf.tab 

# summarize into presence absence matrix
abricate --summary ${VF}/vf.tab > ${VF}/vf_summary.txt

echo "VF ended at $(date)"

echo "abricate complete"