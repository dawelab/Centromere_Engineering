setwd("/Users/yibingzeng/Desktop/SyntheticCentromere/EMmethyl")
file <- list.files()
name <- gsub("-","_",file)
name2 <- gsub(".mbin.500k.data","",name) 
for (i in 1:length(file)) {
    assign(name2[i],read.table(file[i]) %>% filter(V1=="chr4_RagTag") %>% 
             mutate(sample = strsplit(name2, ".", fixed = TRUE)[[i]][1]) %>%
             mutate(context = strsplit(name2, ".", fixed = TRUE)[[i]][2])) 
}
df_plot <- data.frame()
for (i in 1:length(name2)) {
  df_plot <- rbind(df_plot,get(name2[i]))
}
data =  df_plot %>% filter(context == "mCG") %>% as.data.frame()
ggplot(data2,aes(x,y,col=sample)) +
  geom_point()
