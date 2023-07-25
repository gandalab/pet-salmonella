#!/bin/bash

# Usage: sh quast.sh <path to input contigs files>

# --- MODIFY PATHS ---
QUAST=/path/to/quastprogram

cd $1
echo | pwd

python $QUAST/quast-5.0.2/quast.py -o quast_results  --min-contig 500 --threads 4 *_contigs.fasta

echo "quast complete"
