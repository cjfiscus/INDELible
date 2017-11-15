# Team Project: INDELible

### Members: Chris Fiscus & Glen Morrison

The purpose of our project will be to identify indels in resequencing data from *Arabidopsis thaliana* and ask the following questions:  

1. Where do indels occur across the genome?  
2. Is indel length indicative of genomic position? 

For our data, we are proposing to use the 80 *A. thaliana* libraries that were sequenced as part of: 
Cao, J. et al. Whole-genome sequencing of multiple Arabidopsis thaliana populations. Nat. Genet. 43, 956–963 (2011).  

At the conclusion of this project we intend to deliver an interactive Shiny application. We will plot the distribution of indels identified in these samples genome-wide and subsetted by chromosome in genomic windows with the window size chosen by the user. We will also plot median indel size for each of these windows. 

### Proposed Pipeline (in-progress)
1. Download and trim sequencing reads (remove Illumina barcode and quality trim)- produce trimmed reads.
2. Align to *A. thaliana* reference genome- produce BAM file. 
3. Identify indels in each sample- produce VCF file. 
4. Extract indel size and position from VCF using a custom Python script- write to an outfile. 
5. Plot results in a Shiny application.  

 
