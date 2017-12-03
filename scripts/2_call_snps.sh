#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=10
#SBATCH --mem=200G
#SBATCH --output=out/%j.stdout
#SBATCH --error=out/%j.stderr
#SBATCH --mail-user=cfisc004@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name="call_snps"
#SBATCH -p koeniglab 

## This script calls variants on a list of bams and does some rudimentary filtering  

module load freebayes/1.1.0 vcflib/20160719

cd ../ # run in project directory 

## Make a list of bam files to feed into SNP caller  
# ls results/*.bam > ./data/bam_list.txt

## call variants with freebayes only considering 4 alleles, only export vars with quality better than 20
freebayes -f data/Arabidopsis_thaliana.TAIR10.fa -L data/bam_list.txt --use-best-n-alleles 4 | vcffilter -f "QUAL > 20" >./results/variants.vcf

