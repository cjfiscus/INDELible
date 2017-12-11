#!/bin/sh

## Filtered vcf is hosted on figshare under a private link. Download with the f$

cd ../ # cd into main project directory
#mkdir results # make and change into new results directory

cd results

wget -O filtered.vcf.gz https://ndownloader.figshare.com/files/9928819\?private$

module load bcftools # load module
bcftools view filtered.vcf.gz -Ov -o filtered.vcf

