#!/bin/bash

# Usage: sh trimmomatic.sh <path to input files>

# --- MODIFY PATHS ---
TRIM=/path/to/trimmomaticprogram

cd $1
echo | pwd
for f in *.fastq.gz
do
if [ -f "${f%_1.fastq.gz}_1.trimmedP.fastq.gz}" ]
then
echo 'skip'${f}
continue
fi
echo 'trim' ${f}
java -jar
$TRIM/Trimmomatic-0.39/trimmomatic-0.39.jar 
PE -threads 10 -phred33 -trimlog log $f ${f%_1.fastq.gz}_2.fastq.gz
${f%_1.fastq.gz}_1.trimmedP.fastq.gz
${f%_1.fastq.gz}_1.trimmedS.fastq.gz
${f%_1.fastq.gz}_2.trimmedP.fastq.gz
${f%_1.fastq.gz}_2.trimmedS.fastq.gz
ILLUMINACLIP:$TRIM/Trimmomatic-0.39/adapters/NexteraPE-PE.fa:2:30:10:2
  SLIDINGWINDOW:4:15 LEADING:3 TRAILING:3 MINLEN:36;
done;

echo "trimmomatic complete"