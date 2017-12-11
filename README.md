# Team Project: INDELible

### Members: Chris Fiscus & Glen Morrison

The purpose of our project will be to identify indels in resequencing data from *Arabidopsis thaliana* and ask the following questions:  

1. Where do indels occur across the genome?  
2. Is indel length related to genomic position? 

For our data, we are proposing to use the 80 *A. thaliana* libraries that were sequenced as part of: 
Cao, J. et al. Whole-genome sequencing of multiple Arabidopsis thaliana populations. Nat. Genet. 43, 956–963 (2011).  

At the conclusion of this project we intend to deliver an interactive Shiny application. We will plot the distribution of indels identified in these samples genome-wide and subsetted by chromosome in genomic windows with the window size chosen by the user. We will also plot median indel size for each of these windows. 

### Pipeline
1. Download reference genome and index with bwa (0_setup_ref.sh)- produce an indexed reference genome.  
2. Download, quality trim, and align sequencing reads to the *A. thaliana* reference genome (1_dl_align.sh)- produce BAM files. 
3. Identify variants with freebayes (2_call_snps)- produce vcf. 
4. Filter variants with vcffilter (3_filter_vcf.sh)- produce filtered vcf. 
5. Extract indel size and position from filter VCF using a custom Python script (4_indel_size_and_position.py) write to an outfile. 
6. Plot results in a Shiny application (shiny_app/).  

To run the pipeline run each script in order (0_setup_ref.sh, 1_dl_align.sh etc.). 

### Results  
The filtered vcf produced by step 4 above is hosted on figshare at the following [link](https://figshare.com/s/77cb4ee59e590e5058d8). It has been compressed with BGZip to save disk space. 

The Shiny app that we produced is available [here](shinylink). 

### Project Contents
#### data
(see README in this folder for details)  

#### project_report  
Project report in .pdf along with scripts used to render the report. 

#### Scripts
0_setup_ref.sh  
1_dl_align.sh  
2_call_snps.sh  
3_filter_vcf.sh
4_indel_size_and_position.py    
dl_results.sh

#### shiny_app
code for the shiny app


 
