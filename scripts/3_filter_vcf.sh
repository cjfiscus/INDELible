#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem=32G
#SBATCH --output=out/%j.stdout
#SBATCH --error=out/%j.stderr
#SBATCH --mail-user=cfisc004@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name="filter"
#SBATCH -p batch

## This script filters variants by quality, read count, and keeps only indels  

module load vcflib/20160719

cd ../ # run in project directory 

## keep only indels with at least 10 reads supporting (already quality filtered > 20 when variants called) 
vcffilter -f "( TYPE = ins | TYPE = del ) & DP > 10" ./results/variants.vcf > ./results/filtered.vcf

