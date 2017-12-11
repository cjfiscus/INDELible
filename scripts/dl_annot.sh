#!/bin/bash

## download annotation file 
wget ftp://ftp.ensemblgenomes.org/pub/plants/release-37/gff3/arabidopsis_thaliana/Arabidopsis_thaliana.TAIR10.37.gff3.gz

gunzip Arabidopsis_thaliana.TAIR10.37.gff3.gz

## create a list of gene positions 
egrep "\s+gene\s+" Arabidopsis_thaliana.TAIR10.37.gff3 | cut -f1,4,5 > genes.txt