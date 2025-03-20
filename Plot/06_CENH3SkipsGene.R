library(tidyverse)
###############################################################
# CUT & Tag
###############################################################
# Define working directory
work_dir <- "/Users/yibingzeng/Desktop/SyntheticCentromere/cenh3_gene/"

# List all input files
name_tpm <- list.files(work_dir)

# Remove "coverage_" prefix and ".bed.txt" suffix safely
name_tpm2 <- gsub("coverage_", "", name_tpm)
name <- gsub(".bed.txt", "", name_tpm2, fixed = TRUE)

# Initialize an empty list to store transformed data from all files
all_results <- list()

# Define sample column names
count_cols <- c("Neo4b(1)_CENH3", "Neo4a(3)_Neo4b(3)_IgG", "Neo4a(3)_Neo4b(3)_CENH3", "Neo4b(5)", "Neo4b(7)")

# Process each file
for (i in seq_along(name)) {
  file_path <- file.path(work_dir, name_tpm[i])
  
  # Read data
  chr4_10k <- read.table(file_path, header = FALSE, 
                         col.names = c("chr", "start", "end", count_cols))
  
  # Transform data into long format
  result_list <- list()
  
  for (j in seq_along(count_cols)) {
    df <- data.frame(
      chr = rep(chr4_10k$chr,5),
      start = rep(chr4_10k$start,5),
      end = rep(chr4_10k$end,5),
      count = unlist(c(chr4_10k[,4:8]),use.names = F),
      sample = rep(count_cols[j],each = length(chr4_10k$chr)),
      file_source = name[i]  
    )
    result_list[[j]] <- df
  }
  
  # Combine results for this file
  file_result <- do.call(rbind, result_list)
  all_results[[i]] <- file_result
}

# Combine all files into one data frame
final_df <- do.call(rbind, all_results)

# Display the final data frame
view(final_df)

final_df %>% filter(sample == count_cols[1]) %>%
  filter(file_source == "chr4_1k") %>% 
  filter(start >= 188.5 * 1e6, end <= 189.1 * 1e6) %>%
  ggplot(aes(x = start / 1e6, y = count)) +
  geom_area(fill = "#440154FF", alpha = 1) +
  geom_line(color = "#440154FF", size = 0.1) + theme_classic() 

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
