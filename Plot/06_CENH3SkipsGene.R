library(tidyverse)
###############################################################
# CUT & Tag
###############################################################
# Define working directory
work_dir <- "/Users/yibingzeng/Desktop/SyntheticCentromere/cenh3_gene/"

# Define sample column names
count_cols <- c("Neo4b(1)_CENH3", "Neo4a(3)_Neo4b(3)_IgG", "Neo4a(3)_Neo4b(3)_CENH3", "Neo4b(7)", "Neo4b(5)")


file_path <- file.path(work_dir, name_tpm[2])
  

chr4_1k <- read.table(file_path, header = FALSE, 
                         col.names = c("chr", "start", "end", count_cols))
  
  
df <- data.frame(
      chr = rep(chr4_1k$chr,5),
      start = rep(chr4_1k$start,5),
      end = rep(chr4_1k$end,5),
      count = unlist(c(chr4_1k[,4:8]),use.names = F),
      sample = rep(count_cols,each = length(chr4_1k$chr)) )

df$sample <- factor(df$sample,levels = count_cols[c(1,3,4,2,5)])
df %>%
  filter(start >= 188.5 * 1e6, end <= 189.1 * 1e6) %>%
  ggplot(aes(x = start / 1e6, y = count)) +
  geom_area(fill = "#440154FF", alpha = 1) +
  geom_line(color = "#440154FF", size = 0.1) +
  theme_classic() +
  facet_grid(rows = vars(sample), scales = "free_y")
  

###############################################################
# Gene Annotation
###############################################################
#Read in the gene annotation file
gene_annotation <- read.table("/Users/yibingzeng/Desktop/SyntheticCentromere/annotation/AbsGenomePBHIFI_version_1_liftoffA188.gff3")
##Select out the gene annotation in chr4
chr4_gene_annotation <- gene_annotation %>% filter(V3=="gene",V1=="chr4_RagTag") %>% select(V4,V5)
names(chr4_gene_annotation) <- c("start","end")

ggplot() +  
  geom_rect(data = chr4_gene_annotation, 
            aes(xmin = start/ 1e6, xmax = end/ 1e6, ymin = 2, ymax = 3), 
            fill = '#8b482d') +
  xlim(188.5 , 189.1 ) + 
  theme_classic() 
