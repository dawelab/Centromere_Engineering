library(stringr)
library(tidyverse)
library(karyoploteR)

setwd("/Users/yibingzeng/Desktop/SyntheticCentromere/annotation/")

A188Gff3 <- read.table("Zm-A188-REFERENCE-KSU-1.0_Zm00056aa.1_gene_chr4.bed")
ABSGff3 <- read.table("A188_liftoff_ABS_cds_chr4_gene.bed")
ABS_genome.gap <- read.table("/Users/yibingzeng/Desktop/SyntheticCentromere/annotation/ABS_genome.gap")

df <- merge(A188Gff3,ABSGff3, by = "V2", all = F)
inversion <- df[df$V3.y >189644277-100 & df$V3.y< 189687949,]
normal <- df[-(df$V3.y >189644277-100 & df$V3.y< 189687949),]

start.regs <- data.frame("A188",df$V3.x, df$V4.x)  %>% toGRanges()
end.regs <- data.frame("ABS", df$V3.y,  df$V4.y)  %>% toGRanges()

inver.start.regs <- data.frame("A188",inversion$V3.x, inversion$V4.x)  %>% toGRanges()
inver.end.regs <- data.frame("ABS", inversion$V3.y, inversion$V4.y)  %>% toGRanges()

nor.start.regs <- data.frame("A188",normal$V3.x, normal$V4.x)  %>% toGRanges()
nor.end.regs <- data.frame("ABS", normal$V3.y, normal$V4.y)  %>% toGRanges()


#This alters plot parameters, this is actually just the default still
pp <- getDefaultPlotParams(plot.type=1)
pp$ideogramheight <- 1
pp$data1height <- 200
pp$data2height <- 100
pp$bottommargin <- 200

A188Gff3_Heat <- A188Gff3[,c(1,3,4)]
A188Gff3_Heat$V1 <- "A188"
names(A188Gff3_Heat) <- c("seqname", "start", "end")
A188Gff3_Heat$y <- 0.1 
A188_GFF_range <- toGRanges(A188Gff3_Heat)

ABS_A188_Heat <- ABSGff3[,c(1,3,4)]
ABS_A188_Heat$V1 <- "ABS"
names(ABS_A188_Heat) <- c("seqname", "start", "end")
ABS_A188_Heat$y <- 0.1 
ABS_A188_range <- toGRanges(ABS_A188_Heat)


ABS_gap <- ABS_genome.gap[,c(1,2,3)]
ABS_gap$V1 <- "ABS"
names(ABS_gap) <- c("seqname", "start", "end")
ABS_gap$y <- 0.1
ABS_gap_range <- toGRanges(ABS_gap)
#Merge ABS with distance less than 10bp
ABS_blast <- read.table("/Users/yibingzeng/Desktop/SyntheticCentromere/blast/ABS_blast_ABSPacBioHIFI_result_merge.bed")
ABS_blast$V1 <- "ABS"
names(ABS_blast) <- c("seqname", "start", "end")
ABS_blast$y <- 0.1
ABS_blast_range <- toGRanges(ABS_blast)

pACH25 <- read.table("/Users/yibingzeng/Desktop/SyntheticCentromere/blast/pACH25_blast_ABS_result.bed") 
names(pACH25) <- c("seqname", "start", "end")
pACH25$y <- 0.1
pACH25_range <- toGRanges(pACH25)
gap_even_range <- toGRanges(data.frame(chr="chr4",
                                       start=173348777,
                                       end =189142585))

gap_odd_range <- toGRanges(data.frame(chr="chr4",
                                       start=189142686,
                                       end =201037852))
custom.genome <- toGRanges(data.frame(chr=c("A188", "ABS"), start=c(187000000, 187000000), end=c(193000000, 193000000)))
kp <- plotKaryotype(genome = custom.genome,plot.type=2, plot.params=pp)
kpAddBaseNumbers(kp, tick.dist = 500000, tick.len = 10, tick.col="red", cex=1,
                 minor.tick.dist = 500000, minor.tick.len = 5, minor.tick.col = "gray")
kpPlotLinks(kp, data=start.regs, data2=end.regs,  r0=-.5, r1 = -.25, y= 1.6,col ='#667180' )
kpHeatmap(kp, data=A188_GFF_range, chr="A188", r0=0.0, r1 = 0.1, col =  '#8b482d')
kpHeatmap(kp, data=ABS_A188_range, chr="ABS", r0=-0.2, r1 =-0.3, col =  '#8b482d')
kpHeatmap(kp, data=ABS_blast_range, chr="ABS", r0=-0.3, r1 =-0.4 ,colors = '#26705e')
kpHeatmap(kp, data=pACH25_range, chr="ABS", r0=-0.4, r1 =-0.5 ,colors = '#7c6e81')
kpRect(kp, chr="ABS", x0=173348777, x1=189064044, y0=1, y1=0.6, r0= -0.5, r1 = -0.6, col='#be8b2f')
kpRect(kp, chr="ABS", x0=189064045, x1=189142585, y0=1, y1=0.6, r0= -0.55, r1 = -0.65, col='#be8b2f')
kpRect(kp, chr="ABS", x0=189142686, x1=189483512, y0=1, y1=0.6, r0= -0.5, r1 = -0.6, col='#be8b2f')
kpRect(kp, chr="ABS", x0=189483513, x1=201037852, y0=1, y1=0.6, r0= -0.55, r1 = -0.65, col='#be8b2f')
kpRect(kp, chr="ABS", x0=202061917, x1=210000000, y0=1, y1=0.6, r0= -0.7, r1 = -0.8, col='green')
kpRect(kp, chr="ABS", x0=173348777, x1=189142585, y0=1.5, y1=0.6, r0= -0.9, r1 = -1.0, col='#be8b2f',border=NA)
kpRect(kp, chr="ABS", x0=189142686, x1=201037852, y0=1.5, y1=0.6, r0= -0.75, r1 = -0.85, col='#be8b2f',border=NA)


