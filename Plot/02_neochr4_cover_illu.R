library(tidyquant)
library(tidyverse)
working_dir <- "/Users/yibingzeng/Desktop/SyntheticCentromere/KaPa_illumina_Data/normalization/ABS/no_filter"
setwd(working_dir)

#For win_100k
file <- list.files(working_dir,
                   pattern = "_ABS.bed_ABS_100k.bed_add_control")
name <- gsub("_ABS.bed_ABS_100k.bed_add_control","",file)
name <- gsub("-","_",name)

for (i in 1:length(name)) {
  assign(name[i], read.table(file[i]))
}

data_filter <- function(i) {
  get(name[i]) %>% 
    mutate( ploidy = (V4/sum(V4))/ ((V5)/sum(V5))  ) %>%
    filter(V1 == "chr4_RagTag") %>%
    mutate(location = ((V2+V3)/2)/10^5) %>%
    select(c("ploidy","location")) %>%
    mutate(Neo4b = name[i])
}

df_Neo4bs <- data_filter(1)

for (i in 2:length(name)) {
  df_Neo4bs <- rbind(df_Neo4bs,
                     data_filter(i))
}

df_Neo4bs  %>% ggplot(aes(x=location/10,y=ploidy*2)) +
  geom_point(size=0.01) +theme_bw() + ylim(0,6) +
  geom_ma(  n = 100,    size = 1,  color = "purple") + 
  geom_vline(xintercept = 110047454/10^6, color = "red") +
  geom_vline(xintercept = 110265488/10^6, color = "red") +
  geom_vline(xintercept = 189007108/10^6, color = "green") +
  geom_vline(xintercept = 189589028/10^6, color = "green") +
  facet_wrap(~Neo4b, ncol=4) +
  theme(
    strip.text = element_text(size  = 7),
    strip.background = element_rect(
      colour = "white",
      fill = "white"
      ),
    panel.border = 
    ) +
  ylab("Ploidy Estimation") +
  xlab("Chr4 (Mb)")

name_replacement <- data.frame(old_name = name[c(3,4,5,6,19,
                                                 8,20,18,9,43,
                                                 24,25,29,
                                                 33,37)],
                               new_name = c("ABS_hemi_J721","ABS_hemi_KD4277",
                                            "4a(1) 4b(1) gen2",
                                            "4b(2)_gen1","4b(2)_gen4",
                                            "4b(3)_gen1","4a(3) 4b(3)_gen3_telo","4a(3) 4b(3)_gen3_meta",
                                            "4b(4)_gen1",
                                            "4b(5)_gen3",
                                            "4b(6)_gen4",
                                            "4b(7)_gen3",
                                            "4b(8)_gen2", 
                                            "4b(9)_gen3",
                                            "4b(10)_gen4")
                               )

df_select <- df_Neo4bs %>% filter(Neo4b %in% name_replacement$old_name)

for (i in 1:length(name_replacement$new_name)) {
    df_select$Neo4b[df_select$Neo4b == name_replacement$old_name[i]] <- rep(name_replacement$new_name[i],2527)
}

df_select$Neo4b = factor(df_select$Neo4b,levels = name_replacement$new_name)


df_select  %>%  ggplot(aes(x=location/10,y=ploidy*2)) +
  geom_point(size=0.01) + 
  theme_bw() + 
  ylim(0,6) +
  geom_ma(  n = 100,    size = 1,  color = "purple") + 
  geom_vline(xintercept = 110047454/10^6, color = "red") +
  geom_vline(xintercept = 110265488/10^6, color = "red") +
  geom_vline(xintercept = 189007108/10^6, color = "green") +
  geom_vline(xintercept = 189589028/10^6, color = "green") +
  facet_wrap(~Neo4b, ncol=2) +
  theme(
    strip.text = element_text(size  = 7),
    strip.background = element_rect(
      colour = "white",
      fill = "white")) +
  ylab("Ploidy Estimation") +
  xlab("Chr4 (Mb)")
 
