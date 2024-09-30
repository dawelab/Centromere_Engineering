---
title: "ABS_A188_SyntenicPlot"
output: html_document
date: "2024-04-02"
---
library(stringr)
library(tidyverse)
library(karyoploteR)

setwd("/Users/yibingzeng/Desktop/SyntheticCentromere/annotation/")

ABSGff3 <- read.table("A188_liftoff_ABS_cds_chr4_gene.bed")
ABS_genome.gap <- read.table("/Users/yibingzeng/Desktop/SyntheticCentromere/annotation/ABS_genome.gap")
ABS_genome_TE <- read.table("/Users/yibingzeng/Desktop/SyntheticCentromere/annotation/AbsGenomePBHIFI_version_1.fa.chr4_merge_TE.bed")
#repeat_blast result
#Merge ABS with distance less than 10bp
read_toGRanges <- function(path){
  blast_region <- read.table(path)
  names(blast_region) <- c("seqname", "start", "end")
  blast_region$seqname <- gsub("_RagTag","",blast_region$seqname)
  blast_region$y <- 0.1
  blast_region_range <- toGRanges(blast_region)
 return(blast_region_range) 
}
#######################################################################
#################Set up toGrange object for repeats and pACH25 plasmid#
#######################################################################
#subtelomeric-4-12-1 subtelomeric_repeat2 Cent4 CentC  knob180 TR1 
work_path <- "/Users/yibingzeng/Desktop/SyntheticCentromere/blast/"
file <- list.files(work_path,pattern = "bed")
name <- gsub("repeat_blast_ABS_assembly_v1_result_chr4_","",file)
name <- gsub(".bed","",name)
name[1] <- "ABS"
name[2] <- "pACH25"

for (i in 1:length(file)) {
  assign(
    paste0(name[i],"_blast_range"),
    read_toGRanges(paste0(work_path,file[i])) 
  )
}

for (i in 1:length(file)) {
  assign(
    paste0(name[i],"_region"),
    read.table(paste0(work_path,file[i])) %>% mutate(chr="chr4")  %>% select(c("chr","V2","V3"))
  )
}

names(TR1_region) <- names(pACH25_region) <- names(ABS_region) <- names(Cent4_region) <-
  names(CentC_region) <- names(knob180_region) <- names(subtelomeric_repeat2_region) <- 
  names(`subtelomeric-4-12-1_region`) <- names(TR1_region) <-  c("seqname", "start", "end")
########Set up toGoRange for gene TE
A188Gff3_Heat <- A188Gff3[,c(1,3,4)]
names(A188Gff3_Heat) <- c("seqname", "start", "end")
A188Gff3_Heat$y <- 0.1 
A188_GFF_range <- toGRanges(A188Gff3_Heat)

ABS_gap <- ABS_genome.gap[,c(1,2,3)]
ABS_gap$V1 <- "chr4"
names(ABS_gap) <- c("seqname", "start", "end")
ABS_gap$y <- 0.1
ABS_gap_range <- toGRanges(ABS_gap)

ABS_genome_TE$y <- 0.1 
names(ABS_genome_TE) <- c("seqname", "start", "end","y")
ABS_genome_TE_range <- toGRanges(ABS_genome_TE)

gap1 <- ABS_genome.gap %>% filter(V1=="chr4_RagTag") %>% mutate(seqname = "chr4") %>% select(seqname,V2,V3)
gap1$start = c(1,gap1$V3[1:9])
gap1$end = gap1$V2
gap <- gap1[,c(1,4,5)] 
gap$y = 0.05
gap_odd <- gap[seq(1,10,2),]
gap_even <- gap[seq(2,10,2),]
gap_odd_range <- toGRanges(gap_odd)
gap_even_range<- toGRanges(gap_even)

######Set up the parameter for plotting
custom.genome <- toGRanges(data.frame(chr=c("chr4"), start=c(1), end=c(252636135)))
kp <- plotKaryotype(genome = custom.genome,plot.type =3)
kpAddBaseNumbers(kp, tick.dist = 5*10^7, tick.len = 10, tick.col="black", cex=1)
kpHeatmap(kp, data=gap_odd_range, chr="chr4", r0=0, r1 =0.05 ,colors ='#be8b2f')
kpHeatmap(kp, data=gap_even_range, chr="chr4", r0=0.05, r1 =0.1 ,colors ='#be8b2f')

kpHeatmap(kp, data=ABS_genome_TE_range, chr="chr4", r0=0.12, r1 =0.22 ,colors ='#85865f')
kpHeatmap(kp, data=A188_GFF_range, chr="chr4", r0=0.22, r1 =0.32 ,colors = '#8b482d')
kpHeatmap(kp, data=Cent4_blast_range, chr="chr4", r0=0.32, r1 =0.42 ,colors = '#B22222')
kpHeatmap(kp, data=ABS_blast_range, chr="chr4", r0=0.42, r1 =0.5 ,colors = '#26705e')
kpHeatmap(kp, data=pACH25_range, chr="chr4", r0=0.52, r1 =0.62 ,colors = '#7c6e81')
kpAddLabels(kp, labels="TE", r0=0.12, r1=0.22,side="left",label.margin=0.005,cex=1.0)
kpAddLabels(kp, labels="gene", r0=0.22, r1=0.32,side="left",label.margin=0.005,cex=1.0)
kpAddLabels(kp, labels="Cent4", r0=0.32, r1=0.42,side="left",label.margin=0.005,cex=1.0)
kpAddLabels(kp, labels="ABS", r0=0.42, r1=0.52,side="left",label.margin=0.005,cex=1.0)
kpAddLabels(kp, labels="pACH25", r0=0.52, r1=0.62,side="left",label.margin=0.005,cex=1.0)


# Color choice
#'#0000CD' '#7c6e81' '#667180' '#85865f' '#be8b2f' '#8b482d' '#26705e' '#B22222'
