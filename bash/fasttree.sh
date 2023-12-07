#!/bin/bash

# --- MODIFY PATHS ---
OUT=/path/to/output
ALIGN=/path/to/phame/workdir/results/

conda activate FT_env #activate fasttree environment

cd ${OUT}

fasttree -nt -gtr -log fasttree.log -boot 1000 ${ALIGN}/dogphylo_all_alignment.fna > dog_fasttree

echo "fasttree complete"