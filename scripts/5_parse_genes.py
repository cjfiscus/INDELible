#!/usr/bin/env python3

## This script annotates the output of 4_indel_size_and_position.py with T/F in the first column if an indel lays within a coding region. 
##
## The gene list that we are referencing against was created with the following (bash):
## egrep "\s+gene\s+" Arabidopsis_thaliana.TAIR10.37.gff3 | cut -f1,4,5 > genes.txt

## In
Genes=open("genes.txt","r")
Indels=open("indels.txt","r")

## Out 
OutFile=open("indels2.txt", "w")


GeneList={}

## Create a list of genes 
for Line in Genes:
    cat=Line.split("\t")
    addToList=cat[1]+":"+cat[2].strip("\n") # format is 1,1:1 where chr,pos_start:pos_end
    
    if cat[0] in GeneList.keys():
        old=GeneList.get(cat[0]) 
        new=old+","+addToList
        GeneList[cat[0]]=new

    else:
        GeneList.update({cat[0]:addToList})

Genes.close()

## Iterate through indels, checking against gene list 
LineNum=1
for Line in Indels:
    annot="FALSE" # reset to default 
    if LineNum > 1: # skip first line 
        cat=Line.split("\t")

        positions = GeneList.get(cat[2]) # gene pos for that chr 
        positions = positions.split(",")

        for pos in positions:
            end=pos.split(":")
            if cat[3] > pos[1]: # indel position greater than end
                pass
            else: # indel position less than end 
                if pos[0] > cat[3]: # indel within region
                    annot="TRUE"
                    break
                else: # indel not within region 
                    annot="FALSE"
                    break

        OutFile.write(annot+"\t"+Line) # annotate line 

    else: 
        LineNum = LineNum + 1
        OutFile.write("InCodingRegion\t"+Line) # new header 
