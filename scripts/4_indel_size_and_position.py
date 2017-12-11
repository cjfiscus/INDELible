#!/usr/bin/env python3

# This script is takes a VCF file as an input and gives a .csv with..
# ..indel size and position.

# Grab sys arguments.
import sys
input_file = sys.argv[1]
output_file = sys.argv[2]

# Make lists to store indel IDs, sizes and positions.. and also chromosome number.
indel_ID = []
position = []
size = []
chromosome = []
# Loop through VCF file and store positions and sizes.
import vcf
vcf_reader = vcf.Reader(open(input_file, 'r'))
for record in vcf_reader:
	indel_ID.append(record.ID)
	position.append(record.POS)
	size.append(record.LEN)
	chromosome.append(record.CHROM)

# Make lists into dataframe
import pandas as pd
dat = {"indel_ID" : indel_ID, "position" : position, "size" : size, "chromosome" : chomosome}
dat_df = pd.DataFrame(dat)

# Save data as .csv
dat_df.to_csv(dat_df,sep='\t')

