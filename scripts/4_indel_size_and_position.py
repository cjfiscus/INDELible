#!/usr/bin/env python3

# This script is takes a VCF file as an input and gives a .csv with..
# ..indel size and position.

# Grab sys arguments.
import sys
input_file = sys.argv[1]
output_file = sys.argv[2]

# Make lists to store indel IDs, sizes and positions.. and also chromosome number.
position = []
ref = []
alt = []
chromosome = []
# Loop through VCF file and store positions and sizes.
import vcf
vcf_reader = vcf.Reader(open(input_file, 'r'))
for record in vcf_reader:
	position.append(record.POS)
	ref.append(record.REF)
	alt.append(record.ALT)
	chromosome.append(record.CHROM)

# Make lists into dataframe
import pandas as pd
dat = {"position" : position, "ref" : ref, "alt" : alt, "chromosome" : chomosome}
dat_df = pd.DataFrame(dat)

# Save data as .csv
dat_df.to_csv(dat_df,sep='\t')

