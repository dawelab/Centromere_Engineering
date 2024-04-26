library(tidyquant)
setwd("/Users/yibingzeng/Desktop/SyntheticCentromere/KaPa_illumina_Data")
file <- list.files()[15:34]
name <- gsub("_win_10k_genomecov.bed","",file)
name <- gsub("-","_",name)
for (i in 1:length(name)){
  assign(name[i],read.csv(file[i], header = F, sep = "\t"))
}

for (i in 1:length(name)) {
  yinter <- get(name[i]) %>% filter(V3<130000000) %>% select(V4) %>% summarise(mean(V4,na.rm=T)) %>% unlist(use.names = F)
 pdf(paste0("/Users/yibingzeng/Desktop/SyntheticCentromere/Plot/",name[i],".pdf"),width=5.8,height=4.7)
  pl <- get(name[i]) %>% filter(V1=="chr4_RagTag") %>% ggplot(aes(x=V2,y=V4)) +
    geom_point(size=0.1) + xlab("Chr4") + ylab("Coverage (10k window)") + theme_classic() +
    geom_ma(        n = 100,    size = 1,  color = "red") + ylim(0,5*yinter) +
    geom_hline(yintercept=yinter , color="blue") +
    ggtitle(name[i]) +
  geom_vline(xintercept = 189007108, color = "green") +
  geom_vline(xintercept = 189589028, color = "green") 
  
  print(pl)
  dev.off()
}
