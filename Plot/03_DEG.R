library('DESeq2')
library(tidyverse)
path="/Users/yibingzeng/Desktop/SyntheticCentromere/"
L3_exon_count <- read.table(paste0(path,"L3_exon_count.counts"), header = T)
count_data <- L3_exon_count[,c(1,7:14)]
na <- gsub("Aligned.sortedByCoord.out.bam","",names(count_data) )
names(count_data)  <- na
##Checking if the names are matched 
(count_data %>% group_by(Geneid) %>% summarise(sum(KD4315.2)) %>% select(Geneid) != count_data %>% group_by(Geneid) %>% summarise(sum(KD4315.4)) %>% select(Geneid)) %>% sum()
df_count <- cbind(
  count_data %>% group_by(Geneid) %>% summarise(sum(KD4315.2)),
  count_data %>% group_by(Geneid) %>% summarise(sum(KD4315.4)) %>% select(2),
  count_data %>% group_by(Geneid) %>% summarise(sum(KD4315.5)) %>% select(2),
  count_data %>% group_by(Geneid) %>% summarise(sum(KD4315.8)) %>% select(2),
  count_data %>% group_by(Geneid) %>% summarise(sum(yz306.2))  %>% select(2),
  count_data %>% group_by(Geneid) %>% summarise(sum(yz306.3)) %>% select(2),
  count_data %>% group_by(Geneid) %>% summarise(sum(yz306.5)) %>% select(2),
  count_data %>% group_by(Geneid) %>% summarise(sum(yz306.6)) %>% select(2))
names(df_count) <- na

head(df_count)
row.names(df_count) <- df_count$Geneid
count_data <- df_count[,-1]
condition <- factor(c("control","control","control","control",
                      "eleven","eleven","eleven","eleven"))
col_data <- data.frame(row.names = colnames(count_data), condition)
45271
dds <- DESeqDataSetFromMatrix(countData = count_data,colData = col_data,design = ~ condition)
nrow(dds)
dds_filter <- dds[ rowSums(counts(dds))>1, ]
dds_out <- DESeq(dds_filter)
res <- results(dds_out)
summary(res)
table(res$padj<0.01)
table(res$log2FoldChange>0)
res_deseq <- res[order(res$padj),]
#一般选取Foldchange值和经过FDR矫正过后的p值，取padj值(p值经过多重校验校正后的值)小于0.05，log2FoldChange大于1的基因作为差异基因集
diff_gene_deseq2 <- subset(res_deseq, padj<0.05 & (log2FoldChange > 1 | log2FoldChange < -1))
res_diff_data <- merge(as.data.frame(res),as.data.frame(counts(dds_out,normalize=TRUE)),by="row.names",sort=FALSE)
write.csv(res_diff_data,file = "alpaca_data_new.csv",row.names = F)
rld <- rlog(dds, blind = FALSE)
plotPCA(rld,intgroup=c("condition"))
library("genefilter")
library("pheatmap")
topVarGene <- head(order(rowVars(assay(rld)),decreasing = TRUE),50)
mat  <- assay(rld)[ topVarGene, ]
pheatmap(mat, annotation_col=col_data)
pheatmap(mat,cluster_row=T,scale="row", annotation_col=col_data) res0.5 <- results(dds, contrast = c("condition","Basal","LP"),alpha=0.05)
#另一种绘图方式
mat  <- mat - rowMeans(mat)
pheatmap(mat, annotation_col=col_data)

CENH3_affected_gene <- data.frame(Row.names= c( 
 "Zm00056aa025473",
  "Zm00056aa025474",
 "Zm00056aa025487",
  "Zm00056aa025488",
 "Zm00056aa025490",
  "Zm00056aa025491",
 "Zm00056aa025492",
  "Zm00056aa025494",
 "Zm00056aa025495",
  "Zm00056aa025496",
 "Zm00056aa025498",
  "Zm00056aa025499",
 "Zm00056aa025500",
  "Zm00056aa025501",
 "Zm00056aa025502",
  "Zm00056aa025503",
 "Zm00056aa025504",
  "Zm00056aa025505",
 "Zm00056aa025506",
  "Zm00056aa025507",
 "Zm00056aa025508",
  "Zm00056aa025509",
 "Zm00056aa025510",
  "Zm00056aa025511",
 "Zm00056aa025512",
  "Zm00056aa025513"))
deg_CENH3_affected_gene <- merge(CENH3_affected_gene,res_diff_data, by = "Row.names")
deg_CENH3_affected_gene2 <- merge(CENH3_affected_gene,df_count, by = "Row.names")
row.names(deg_CENH3_affected_gene) <- deg_CENH3_affected_gene$Row.names
deg_CENH3_affected_gene[deg_CENH3_affected_gene$pvalue<=0.01,]
pheatmap(deg_CENH3_affected_gene[,8:15])
row.names(res_diff_data) <- res_diff_data$Row.names
pheatmap(res_diff_data[sample(dim(res_diff_data)[1],22),8:15],cluster_rows=F)
hist(res_diff_data$log2FoldChange)
hist(deg_CENH3_affected_gene$log2FoldChange)

#######Plotting for the overlaying histogram
# Generate sample data
set.seed(123)
data1 <- res$log2FoldChange
data2 <- deg_CENH3_affected_gene$log2FoldChange

# Create data frame for ggplot
df <- data.frame(
  value = c(data1, data2),
  group = c(rep("All", length(data1)), rep("CEN", length(data2)))
)

# Calculate densities for scaling
hist1 <- hist(data1, breaks = 30, plot = FALSE)
hist2 <- hist(data2, breaks = 30, plot = FALSE)
scale_factor <- 23204/22

# Plot
ggplot(df, aes(x=value,fill=group)) +
  geom_histogram(
    data = subset(df, group == "All"),
    aes( y = ..count..),
    bins = 30,
    fill = "blue",
    alpha = 0.5
  ) +
  geom_histogram(
    data = subset(df, group == "CEN"),
    aes( y = ..count.. * scale_factor),
    bins = 30,
    fill = "orange",
    alpha = 0.5
  ) +
  scale_y_continuous(
    name = "All",
    sec.axis = sec_axis(~ . / scale_factor, name = "CENH3")
  ) +
  xlim(-15,15) +
  scale_fill_manual(
    values = c("Histogram 1" = "blue", "Histogram 2" = "orange"),
    name = "Legend"
  ) +
  theme_minimal() +
  theme(legend.position = "top")
