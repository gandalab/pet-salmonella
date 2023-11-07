#!/bin/bash

# --- MODIFY PATHS ---
TRIMMED=/path/to/trimmed
UNI=/path/to/Unicycler
OUT=/path/to/assemb

cd ${TRIMMED} #change to directory with trimmed reads

for f in *1P.fq.gz;
do

echo "assemble" ${f%_1P.fq.gz}

${UNI}/unicycler-runner.py -1 ${TRIMMED}/${f} \
-2 ${TRIMMED}/${f%_1P.fq.gz}_2P.fq.gz \
-s ${TRIMMED}/${f%_1P.fq.gz}_2U.fq.gz \
-o ${OUT}/${f%_1P.fq.gz} ;

done

mkdir ${OUT}/contigs #make directory for all contigs

# --- move all contig files into one directory

for f in *1P.fq.gz;
do

cd ${OUT}/${f%_1P.fq.gz}
cat assembly.fasta > ${f%_1P.fq.gz}_assembly.fasta
mv ${f%_1P.fq.gz}_assembly.fasta ${OUT}/contigs
cd ..;

done

echo "assmebly complete"
