#!/bin/bash

# --- MODIFY PATHS ---
CONTIGS=/path/to/contigs
OUT=/path/to/sistr_out

cd ${CONTIGS} # change to working directory

conda activate sistr # activate conda env


for f in *.fasta ; do echo ${f%_assembly.fasta} ; sistr --qc \
-vv \
-t 4 \
--alleles-output ${f%_assembly.fasta}_allele-results.json \
--novel-alleles ${f%_assembly.fasta}_novel-alleles.fasta \
--cgmlst-profiles ${f%_assembly.fasta}_cgmlst-profiles.csv \
-f tab \
-o ${f%_assembly.fasta}-output.tab ${f} ; done

#move results to output directory:
for f in *_contigs.fasta
do
        mv ${f%_assembly.fasta}_allele-results.json ${OUT}/alleles
        mv ${f%_assembly.fasta}_novel-alleles.fasta ${OUT}/novel
        mv ${f%_assembly.fasta}_cgmlst-profiles.csv ${OUT}/cgmlst
        mv ${f%_assembly.fasta}-output.tab ${OUT}/output
        done

#create one file
cd ${OUT}/output
cat *.tab > sistroutput.tsv
cd ../cgmlst
cat *.csv > cgmlst.tsv

echo "sistr complete"
