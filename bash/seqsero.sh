#!/bin/bash

# --- MODIFY PATHS ---
CONTIGS=/path/to/contigs
OUT=/path/to/seqsero_out

conda activate seqsero # activate conda env

cd ${CONTIGS} #change to working directory

# -m "k" for raw reads and genome assembly k-mer 
# -t "4" for genome assembly as input data type 
# -i path to input file 
# -d output directory

for f in *.fasta ; do echo ${f%_contigs.fasta} ; SeqSero2_package.py -m k -t 4 -i ${CONTIGS}/${f} -d ${OUT}/${f%_contigs.fasta}_seqsero -n ${f%_contigs.fasta} ; done

# ---- create one file
cd ${OUT}
cat *_seqsero/*_result.tsv > seqserosummary.tsv

echo "seqsero complete"