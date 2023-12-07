#!/bin/bash

# --- MODIFY PATHS ---
CONTIGS=/path/to/contigs
OUT=/path/to/checkm_out

conda activate checkm # activate conda env

#--- run
checkm lineage_wf -x fasta ${CONTIGS} ${OUT} --tab_table

echo "checkm complete"