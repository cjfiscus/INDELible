#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=10
#SBATCH --mem-per-cpu=2G
#SBATCH --output=%j.stdout
#SBATCH --error=%j.stderr
#SBATCH --mail-user=cfisc004@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name="dl_al"
#SBATCH -p batch 
#SBATCH --array=1-1

## This script downloads, trims, and aligns Illumina reads to A. thaliana reference genome, then converts sam to sorted bam 

module load sickle/1.33 bwa/0.7.12 samtools/1.4.1

cd ../ # run in project directory 

## get file to download 
LINE=$(expr $SLURM_ARRAY_TASK_ID + 1) # which line of file_list to read from 

FILES=$(head -n $LINE data/file_list.txt | tail -n 1 | cut -f4) # get files to dl from 4th column in this file 

## get file basename (for subsequent steps) 
NAME=$(basename "$FILES" | cut -d_ -f1)
RESULT_DIR=./results/$NAME

## download files 
for i in $(echo $FILES | tr ";" "\n")
	do
		wget -nv -P ./data/ "$i"
	done

## Quality trimming- quality > 20 (default), 
sickle pe -g -f ./data/"$NAME"_1.fastq.gz -r ./data/"$NAME"_2.fastq.gz -t sanger \
-o  $RESULT_DIR/"$NAME"_1_trimmed.fq.gz -p $RESULT_DIR/"$NAME"_2_trimmed.fq.gz \
-s $RESULT_DIR/"$NAME"_singles.fq.gz

## Determine read group
a="'@RG\tID:" ; c="\tSM:" ; d="'" 
SAMPLE=$(head -n $LINE data/file_list.txt | tail -n 1 | cut -f2)
READGROUP=$a$SLURM_ARRAY_TASK_ID$c$SAMPLE$d # Example: '@RG\tID:1\tSM:SRS155653'

## align with bwa, need to have matching samples but different readgroup  
bwa mem -t 10 -M -R $READGROUP data/Arabidopsis_thaliana.TAIR10.fa $RESULT_DIR/"$NAME"_1_trimmed.fq.gz $RESULT_DIR/"$NAME"_2_trimmed.fq.gz > $RESULT_DIR/"$NAME".sam 

## sam to sorted bam
samtools view -bS $RESULT_DIR/"$NAME".sam | samtools sort -T $RESULT_DIR/temp_Pt - -o $RESULT_DIR/"$NAME".bam

## index BAM
samtools index $RESULT_DIR/"$NAME".bam

## export mapping stats
samtools flagstat $RESULT_DIR/"$NAME".bam | gzip > ./results/"$NAME"_aln_stats.txt.gz 

## cleanup temp files
#rm -r $RESULT_DIR
#rm data/"$NAME"*
