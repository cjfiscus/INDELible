#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=10
#SBATCH --mem-per-cpu=4G
#SBATCH --output=%j.stdout
#SBATCH --error=%j.stderr
#SBATCH --mail-user=cfisc004@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name="dl_al"
#SBATCH -p batch 
#SBATCH --array=1-1

## This script downloads, trims, and aligns Illumina reads to A. thaliana reference genome, then converts sam to sorted bam 

module load sickle/1.33 bwa/0.7.12

cd ../ # run in project directory 

## get file to download 

## download file 


## Quality trimming- quality > 20 (default), 
sickle pe -g -f input_file1.fq.gz -r input_file2.fq.gz -t sanger \
-o trimmed_output_file1.fq.gz -p trimmed_output_file2.fq.gz \
-s trimmed_singles_file.fq.gz

## align with bwa, need to have matching samples but different readgroup  
bwa mem -t 20 -M -R '@RG\tID:mut\tSM:mut1' data/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa <(zcat /rhome/cfisc004/shared/SEQ_RUNS/10_2_2017/illumina.bioinfo.ucr.edu/illumina_runs/718/flowcell718_lane1_pair1_TGACCA.fastq.gz) <(zcat /rhome/cfisc004/shared/SEQ_RUNS/10_2_2017/illumina.bioinfo.ucr.edu/illumina_runs/718/flowcell718_lane1_pair2_TGACCA.fastq.gz) > ./results/mutant.sam

## sam to sorted bam
samtools view -bS $RESULT_DIR/"$NAME".sam | samtools sort -T $RESULT_DIR/temp_Pt - -o $RESULT_DIR/"$NAME".bam

## mark duplicates (from man samtools)
samtools rmdup ./results/"$NAME".bam ./results/"$NAME"_nodups.bam

## index BAM
samtools index ./results/"$NAME"_nodups.bam

## get mapping stats
samtools flagstat ./results/"$NAME"_nodups.bam > ./results/"$NAME"_stats.txt
