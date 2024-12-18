##the input data is save in the same folder named reformat_recombination_data
##Author: Meghan Brady
library(readxl)
library(ggplot2)

DATA <- read_excel("")

DATA$Recombination <- as.factor(DATA$Recombination)
DATA$Identity <- as.factor(DATA$Identity)


model = glm(Recombination ~ Identity, data=DATA, family="binomial")
summary(model)

ggplot(DATA, aes(x=Identity, fill = Recombination)) +
  geom_bar(stat="count")

