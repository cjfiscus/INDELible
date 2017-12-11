#!/bin/sh

## Filtered vcf is hosted on figshare under a private link. Download with the following:

cd ../ # cd into main project directory
#mkdir results # make and change into new results directory  

wget -O ../results/filtered.vcf.gz https://ndownloader.figshare.com/files/9928819\?private_link\=77cb4ee59e590e5058d8
