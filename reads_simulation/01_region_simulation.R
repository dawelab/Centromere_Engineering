#To handle the agp file
library(tidyverse)
agp <- read.table("/Users/yibingzeng/Desktop/SyntheticCentromere/final_scaffold.agp")
gapless_region <- agp %>% filter(V6!=100) %>% select(c("V1","V2","V3"))
names(gapless_region) <- c("chr","start","end")
read_region_sim <- function(region,x) {
  if (!is.integer(x)) x <- round(x)
   sequence_length <- region$end - region$start + 1 
  single_unit <- 150
  n <- round(sequence_length/single_unit)
  ##Generate the start sites of the whole region
  sim_start <- runif(n*x, region$start, region$end) %>% as.integer()
  ##Generate the length of for the region
  ##For the positive strand
  sim_length <- rnorm(n*x,150,4) %>% as.integer()
  sim_end <- sim_start + sim_length
  sim_end[sim_end > region$end] <- region$end
  sim_region <- data.frame(chr = region$chr,
                           start = sim_start,
                           end = sim_end)
  ##Sort the region 
  sort_output <- arrange(sim_region,
                         start)
  return(sort_output)
}
data_output <- data.frame()
for (i in 1:dim(gapless_region)[1]) {
  temp_region <- gapless_region[i,]
  temp <- read_region_sim(gapless_region[i,],10)
  sort_temp <- arrange(temp,start)
  data_output <- rbind(data_output,
                       sort_temp)
}
data_output$strand <- "+"
write.table(data_output,
            file = "/Users/yibingzeng/Desktop/SyntheticCentromere/simulated_positive_region.bed",
            quote = F, col.names = F,sep = "\t",row.names = F)
