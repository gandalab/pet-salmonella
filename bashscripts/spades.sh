#!/bin/bash

# Usage: sh spades.sh <path to input files>

# --- MODIFY PATHS ---
# path to spades
SPADES=/path/to/spadesprogram

#path to main working directory
WD=/dir

cd $1

for f in *_1.trimmedP.fastq.gz
do
if [ -d "${f%_1.trimmedP.fastq.gz}" ]
then
echo 'skip'${f}
continue
fi
echo 'assemble' ${f%_1.trimmedP.fastq.gz}
$SPADES/SPAdes-3.15.4-Linux/bin/spades.py --isolate -1 $f -2 ${f%_1.trimmedP.fastq.gz}_2.trimmedP.fastq.gz -o ${f%_1.trimmedP.fastq.gz} -t 4;
done

mkdir contigs
for f in *_1.trimmedP.fastq.gz
do
        cd ${f%_1.trimmedP.fastq.gz}
        cat contigs.fasta > ${f%_1.trimmedP.fastq.gz}_contigs.fasta
        cp ${f%_1.trimmedP.fastq.gz}_contigs.fasta ../contigs
        cd ..;
        done

mkdir scaffolds
for f in *_1.trimmedP.fastq.gz
do
        cd ${f%_1.trimmedP.fastq.gz}
        cat scaffolds.fasta > ${f%_1.trimmedP.fastq.gz}_scaffolds.fasta
        cp ${f%_1.trimmedP.fastq.gz}_scaffolds.fasta ../scaffolds
        cd ..;
        done
        
mv contigs $WD

echo "assembly complete"