######################################################################
#####Visualize the scaffold contigs based on the agp and paf files####
######################################################################
library(tidyverse)
library(pafr)
B73_paf <- read_paf("/Users/x/Desktop/SyntheticCentromere/PacBio_HIFI/paf/B73_unmask_unmask_nopost_ragtag.scaffold.asm.paf")  %>% as.data.frame() 
B73_agp <- read.table("/Users/x/Desktop/SyntheticCentromere/PacBio_HIFI/agp/B73_unmask_unmask_nopost_scaffold.agp")
library(tidyverse)
library(pafr)
plot_paf <- function(chr="chr5",agp,paf){
  agp_chr <- paste0(chr,"_RagTag")
  chr_agp <- agp %>% filter(V1 == agp_chr & V5 ==  "W") %>% select(c(4,6,8)) %>% arrange(V4)
  chr_agp$V4 <- 1:dim(chr_agp)[1]
  names(chr_agp) <- c("location","qname","size")
  chr_paf <- paf %>% filter(tname == chr)  %>% as.data.frame()
  com <- merge(chr_agp,chr_paf,by="qname",all.x = T) %>% arrange(location,tstart) %>% na.omit() 
  com$mean_identity <- com$nmatch/com$alen
  p <- com %>% ggplot() +
    geom_segment(aes(x = tstart, y = location, 
                     xend = tend, yend = location, 
                     colour = mean_identity)) +
    theme_classic() +
    scale_color_gradient(low = "yellow", high = "darkblue") +
    xlab(paste0(chr,"(Mb)")) +
   # theme(#axis.text.y = element_blank(),
       #   axis.line.y = element_blank(),
         # axis.ticks.y = element_blank()) +
    ylab(paste0("contigs", 1," to ",max(com$location))) + 
    scale_x_continuous(labels = seq(0,350000000/10^6,20),
                       breaks = seq(0,350000000,20*10^6))
  return(p)
}
#####Save the plot for 10 pseduchromosome of ABS first verision genome
for (i in 1:10) {
  pdf(paste0("/Users/x/Desktop/SyntheticCentromere/plot/paf/chr",i,"_paf_vis.pdf"),
      width = 7.0,
      height = 4.0)
  print(plot_paf(paste0("chr",i),B73_agp,B73_paf))
  dev.off()
}

###############################################################################
#########################Identify the overlapped contigs#######################
###############################################################################
#1. Combine location and paf files together
B73_paf_agp <- NULL
for (i in 1:10) {
 B73_agp_sim <- B73_agp %>%  filter(V1 == paste0("chr",i,"_RagTag"), V5 ==  "W") %>% 
   select(c(1,4,6,8)) %>% arrange(V4) %>% mutate(V4=1:length(V4))
 names(B73_agp_sim) <- c("chr","location","qname","size")
 B73_agp_sim$chr <- gsub("_RagTag","",B73_agp_sim$chr)
 B73_paf_agp <-  rbind(B73_paf_agp,B73_agp_sim)
}

chr_paf <- B73_paf  %>% select(names(B73_paf)[c(1,3,4,6,7,8,9,10,11)]) %>% as.data.frame() 
com <- merge(B73_paf_agp,chr_paf,by="qname",all.x = T) %>% arrange(location,tstart) %>% na.omit() 
com <- com %>% filter(chr == tname)
B73_paf_agp <- com
B73_paf_agp$mean_identity <- B73_paf_agp$nmatch/B73_paf_agp$alen

overlap <- B73_paf_agp %>% select(qname,location,qstart,qend,tname,tstart,tend,nmatch,alen,mean_identity) 
###Use two for loop to iterate the target i  and query  j size block overlap proportion and sum them up
###Use one more for loop to iterate the location k 
Identify_overlap <-  function(df,step=1,chr){
location <- df %>% filter(tname  == chr) %>% summarise(max(location)) %>% unlist(use.names = F)
df2 <- df %>% filter(tname == chr)
loc <- 1:(location-step)
neary_by_1  <- data_frame(pos1=1:max(loc),pos2 = 2:(max(loc)+1),overlap = 0 )
for (k in loc) {
  (target_start <- df2 %>% filter(location == loc[k]) %>% select(tstart) %>% unlist(use.names = F))
  (target_end <- df2 %>% filter(location == loc[k]) %>% select(tend) %>% unlist(use.names = F))
  (query_start <- df2 %>% filter(location == loc[k]+step) %>% select(tstart) %>% unlist(use.names = F))
  (query_end <- df2 %>% filter(location == loc[k]+step) %>% select(tend) %>% unlist(use.names = F))
  (target_size <- query_end - query_start)
  overlap_list <- NULL
  for (i in 1:length(target_end)) {
    for (j in 1:length(query_start)) {
      if (query_start[j] >= target_end[i]) overlap_size <- 0
      if ( (query_start[j] < target_end[i]) & (query_end[j] > target_end[i]) ) overlap_size <- abs(query_start[j] - min(query_end[j],target_end[i]))
      else overlap_size <- 0
    }
    overlap_list <- c(overlap_list,overlap_size)
  }
  neary_by_1[k,3] <- sum(overlap_list)/sum(target_size)
}
return(neary_by_1)
}
#Identify_overlap(df=overlap,step=1,chr = "chr1")
Identify_overlap(df=overlap,step=1,chr = "chr2")  ###12/13  19/20
#Identify_overlap(df=overlap,step=1,chr = "chr3")
#Identify_overlap(df=overlap,step=1,chr = "chr4")
Identify_overlap(df=overlap,step=1,chr = "chr5") %>% view()
Identify_overlap(df=overlap,step=1,chr = "chr6")
#Identify_overlap(df=overlap,step=1,chr = "chr7")
#Identify_overlap(df=overlap,step=1,chr = "chr8")
Identify_overlap(df=overlap,step=1,chr = "chr9")
#Identify_overlap(df=overlap,step=1,chr = "chr10")

####Combine with paf visualization plot, remove the redundant contigs
###########################################################################
##### misassembled contigs between reference based on the paf  ###
###########################################################################
#1.Identify the mis-assembled contigs
mis_assemble_contig <- B73_paf %>% group_by(qname) %>% 
  filter(mapq == 60 & alen >10^6) %>% 
  filter(length(unique(tname))>=2 ) %>% 
  select(qname) %>% 
  unique() %>%
  unlist(use.names = F)

##################################################################################################
#Use the B73 as the reference, ragtag software break the contigs files in following agp files####
##################################################################################################

agp <- read.table("/Users/x/Desktop/SyntheticCentromere/PacBio_HIFI/agp/correct/ragtag.correct.agp")
agp_break <- data.frame()
for (i in 1:dim(agp)[1]) {
  if ("+" %in% strsplit(agp$V6[i],split = "")[[1]]){
    agp_temp <- agp[i,]
    agp_break <- rbind(agp_break,
                       agp_temp)
  }
}
##Find out the position that ragtag breaks
break_position <- agp_break %>% filter(V1==mis_assemble_contig) %>% select(V3) %>% unlist(use.names = F)
noseq_nopost <- read.csv("/Users/x/Desktop/SyntheticCentromere/PacBio_HIFI/noseq_gfa/ptg000071l_end.noseq",
                         sep = "\t",
                         col.names = c("reads","contig","S_start","strand","ccs","start","end","id","HG"))

df_noseq <- data.frame(start = noseq_nopost$S_start,
                       end =  noseq_nopost$S_start+noseq_nopost$end) 
df_noseq$position <- 1:length(df_noseq$start)

df_noseq[15:35,] %>% ggplot() +
  geom_segment(aes(x = start, y = position, 
                   xend = end, yend = position)) +
  theme_classic() +
  xlab(mis_assemble_contig) +
  theme(axis.text.y = element_blank(),
        axis.line.y = element_blank(),
        axis.ticks.y = element_blank()) +
  ylab("ccs reads") + 
  geom_vline(aes(xintercept=break_position[1]),color="red",linetype="dashed") +
  geom_vline(aes(xintercept=16000357),color="black",linetype="dashed") +
  geom_vline(aes(xintercept=16103245),color="black",linetype="dashed") 
