library("tidyverse")
work_path  <- "/Users/yibingzeng/Desktop/SyntheticCentromere/EMmethyl/"
win_500k <- read.csv(paste0(work_path,"500kb_mbin/","combine_500k.workw"), 
                     col.names = c("chr","start","end","mC","sample","context")) %>% 
            filter(chr == "chr4_RagTag")
win_500k$end <- as.numeric(win_500k$end)
win_1m <- read.csv(paste0(work_path,"1M_mbin/","combine_1M.work"), 
                     col.names = c("chr","start","end","mC","sample","context")) %>% 
  filter(chr == "chr4_RagTag")
#Keep each replicate separated
win_500k %>% ggplot(aes(x=as.numeric(end)/10^6,y=as.numeric(mC),col = context)) +
  geom_point(size = 0.1) + ylim(0,1) +
  geom_line() +
  facet_grid(sample~context) + theme_bw() +
  geom_vline(xintercept = 110047454/10^6, color = "red") +
  geom_vline(xintercept = 110265488/10^6, color = "red") +
  geom_vline(xintercept = 189007108/10^6, color = "green") +
  geom_vline(xintercept = 189589028/10^6, color = "green") +
  ylab("methylated levels (500kb)") +
  xlab("Chr4 (Mb)") 
  
win_1m %>% filter(context!="mCHH") %>%  ggplot(aes(x=as.numeric(end)/10^6,y=as.numeric(mC),col = context)) +
  geom_point(size = 0.1) + 
  geom_line() +
  facet_grid(sample~context) + theme_bw() +
  geom_vline(xintercept = 110047454/10^6, color = "red") +
  geom_vline(xintercept = 110265488/10^6, color = "red") +
  geom_vline(xintercept = 189007108/10^6, color = "green") +
  geom_vline(xintercept = 189589028/10^6, color = "green") +
  ylab("methylated levels (1M kb)") +
  xlab("Chr4 (Mb)") 

#Merged replicates
merge_1m <- read.csv("/Users/yibingzeng/Desktop/SyntheticCentromere/EMmethyl/1M_mbin/combine.work_merge",
                     col.names = c("chr","start","end","mC","sample","context"))

merge_1m$end <- as.numeric(merge_1m$end)
merge_1m$mC <- as.numeric(merge_1m$mC)

merge_1m %>% filter(context != "CHH", chr == "chr4_RagTag") %>%  ggplot(aes(x=as.numeric(end)/10^6,y=as.numeric(mC),col = context)) +
  geom_point(size = 0.1) + 
  geom_line() +
  facet_grid(sample~context) + theme_bw() +
  geom_vline(xintercept = 110047454/10^6, color = "red") +
  geom_vline(xintercept = 110265488/10^6, color = "red") +
  geom_vline(xintercept = 189007108/10^6, color = "green") +
  geom_vline(xintercept = 189589028/10^6, color = "green") +
  ylab("methylated levels (1M kb)") +
  xlab("Chr4 (Mb)") 
