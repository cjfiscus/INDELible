# Team Project: INDELible

### Members: Chris Fiscus & Glen Morrison

The purpose of our project will be to identify indels in resequencing data from *Arabidopsis thaliana* and ask the following questions:  

1. Where do indels occur across the genome?  
2. Is indel length related to genomic position? 

For our data, we are proposing to use the 80 *A. thaliana* individuals that were sequenced as part of: 
Cao, J. et al. Whole-genome sequencing of multiple Arabidopsis thaliana populations. Nat. Genet. 43, 956–963 (2011).  

At the conclusion of this project we intend to deliver an interactive Shiny application. We will plot the distribution of indels identified in these samples genome-wide and subsetted by chromosome in genomic windows with the window size chosen by the user. We will also plot median indel size for each of these windows. 

### Pipeline
1. Download reference genome and index with bwa (**0_setup_ref.sh**)- produce an indexed reference genome.  
2. Download, quality trim, and align sequencing reads to the *A. thaliana* reference genome (**1_dl_align.sh**)- produce BAM files. 
3. Identify variants with freebayes (**2_call_snps**)- produce vcf. 
4. Filter variants with vcffilter (**3_filter_vcf.sh**)- produce filtered vcf. 
5. Extract indel size and position from filter VCF using a custom Python script (**4_parse_vcf.py**) write to an outfile. 
6. Annotate parsed indels with boolean values corresponding to presence within a coding region (**5_parse_genes.py**). 
7. Plot results in a Shiny application (**shiny_app/**).  

### Results  
The filtered vcf produced by step 4 above is hosted on figshare at the following [link](https://figshare.com/s/77cb4ee59e590e5058d8). It has been compressed with BGZip to save disk space. 

The Shiny app that we produced is available [here](https://cjfiscus.shinyapps.io/shiny_app/). 

### Project Contents
#### data
(see README in this folder for details)  

#### project_report  
Project report in .pdf along with scripts used to render the report. 

#### results
output from script 5 above, plotted in Shiny app

#### Scripts
0_setup_ref.sh  
1_dl_align.sh  
2_call_snps.sh  
3_filter_vcf.sh  
4_parse_vcf.py  
5_parse_genes.py    
dl_annot.sh   
dl_results.sh

#### shiny_app
code for the shiny app 

#### old_shiny_apps
code for the 5 separate shiny apps that were combined into the final shiny_app (above)


 
