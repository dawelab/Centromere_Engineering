setwd("/Users/x/Desktop/SyntheticCentromere/PacBio_HIFI/confidence")
#Read in the confidence files
con_file <- list.files()[1:16]
con_name <- gsub("_ragtag.scaffold.confidence.txt","",con_file)

for (i in 1:16 ) {
    assign(con_name[i],
           read.table(con_file[i],header = T)) 
}
## Read in the contig length & read depth
cont_nopost <- read.table("/Users/x/Desktop/SyntheticCentromere/PacBio_HIFI/noseq_gfa/ABS_nopostoin_noseq.gfa",
                          col.names = c("query","length","depth"))
cont_post <- read.table("/Users/x/Desktop/SyntheticCentromere/PacBio_HIFI/noseq_gfa/ABS_postoin_noseq.gfa",
                        col.names = c("query","length","depth"))

#Merge the confidence information andd contig length & depth together
for (i in 1:16) {
  assign(
    paste0("com_",con_name[i]),
    merge(get(con_name[i]), cont_nopost,by="query")
  )
}
#Make the tidy dataframe
for (i in 1:16){
  assign(paste0("df_",con_name[i]),
         data.frame(contig = rep(unlist(get(paste0("com_",con_name[i]))[1], use.names = F),3),
                    score = c(get(paste0("com_",con_name[i]))[2] %>% unlist(use.names = F),
                                  get(paste0("com_",con_name[i]))[3]%>% unlist(use.names = F),
                                  get(paste0("com_",con_name[i]))[4]%>% unlist(use.names = F)),
                    type = rep(c("group","location","orientation"),
                               each = dim(get(paste0("com_",con_name[i])))[1]),
                    assembly = rep(con_name[i], each = 3 * dim(get(paste0("com_",con_name[i])))[1])
                    )
         )
}
#combine into a list for plotting
df_score_dist <- get(paste0("df_",con_name[1]))
for (i in 2:16) {
  df_score_dist <- rbind(df_score_dist,
                         get(paste0("df_",con_name[i])))
}
df_score_dist$assembly <- factor(df_score_dist$assembly,
                                 levels = con_name[c(5,3,6,4,
                                                     7,1,8,2,
                                                     13,11,12,14,
                                                     15,9,16,10)])
df_score_dist$reference <- df_score_dist$assembly
df_score_dist$reference <- gsub("_unmask","",df_score_dist$reference)
df_score_dist$reference <- gsub("_nopost","",df_score_dist$reference)

df_score_dist$reference <- gsub("_mask","",df_score_dist$reference)
df_score_dist$reference <- gsub("_post","",df_score_dist$reference)
table(df_score_dist$reference)

df_score_dist  %>% ggplot(aes(x=type,y=score,col = reference)) + 
  geom_boxplot() + 
  geom_jitter(size= 0.01) +
  facet_wrap(~assembly, ncol = 4) + 
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45))


###
location_score = 0.5
group_score= 0
orientation_score= 0

B73_unmask_unmask_nopost$quality <- "Y"
B73_unmask_unmask_nopost$quality[B73_unmask_unmask_nopost$orientation_confidence < orientation_score  | B73_unmask_unmask_nopost$location_confidence <  location_score |  B73_unmask_unmask_nopost$grouping_confidence < group_score] <- "N"
table(B73_unmask_unmask_nopost$quality)
test <- merge(cont_nopost,B73_unmask_unmask_nopost,by="query",all=T)
test$quality[is.na(test$quality)] <- "unknown"
test %>% ggplot(aes(y=log(length),x=depth,col=quality)) +
  geom_point() + theme_classic()

cont_post %>% ggplot(aes(y=length,x=depth)) +
  geom_point() + theme_classic()
#group location orientation
df_score_dist %>% filter(type=="orientation" & assembly == "B73_unmask_unmask_nopost") %>%  ggplot(aes(x=score)) + geom_histogram() + theme_classic()

#Check if chromosome 5 generally has lower coverage
B73_chr <- B73_agp %>% filter(V5 == "W") %>% select(c("V1","V6"))
names(B73_chr) <- c("chr","query")
merge(B73_chr,cont_nopost) %>% 
  filter(chr %in% paste0("chr",1:10,"_RagTag")) %>% 
  ggplot(aes(x=depth,y=length)) + geom_point(size=0.01) + facet_wrap(~chr)

merge(B73_chr,cont_nopost) %>% 
  filter(chr %in% paste0("chr",1:10,"_RagTag")) %>% 
  ggplot(aes(x=depth)) + geom_histogram() + facet_wrap(~chr) +
  theme_classic()

merge(B73_chr,cont_nopost) %>% 
  filter(chr %in% paste0("chr",1:10,"_RagTag")) %>% 
  ggplot(aes(x=log(length))) + geom_histogram() + facet_wrap(~chr) +
  theme_classic()
