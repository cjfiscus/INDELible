#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mem=16G
#SBATCH --output=out/%j.stdout
#SBATCH --error=out/%j.stderr
#SBATCH --mail-user=cfisc004@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name="setup"
#SBATCH -p batch

## This script downloads the reference genome and indexes with bwa 

module load bwa/0.7.12

cd ../data/ ## dir to download ref to  

## download reference genome 
wget ftp://ftp.ensemblgenomes.org/pub/plants/release-37/fasta/arabidopsis_thaliana/dna/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz

## remove compression 
gunzip Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz 

## rename
mv Arabidopsis_thaliana.TAIR10.dna.toplevel.fa Arabidopsis_thaliana.TAIR10.fa

## index
bwa index Arabidopsis_thaliana.TAIR10.fa

