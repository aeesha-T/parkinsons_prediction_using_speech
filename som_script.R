#Script for analyzing the pattern in the data using
require(kohonen)
library(gridExtra)
library(grid)
library(ggplot2)

# read the data
data <- read.csv("C:/Users/Aeesha/Documents/CMU/Research/Code/Research_Project/readtext.csv")

#drop the first(the ID) and last(the label) column
data_train <- data[, -c(1, 13)]
data_train_matrix <- as.matrix(scale(data_train))

# set the number of iterations
iterations <- 10

pdf("C:/Users/Aeesha/Documents/CMU/Research/Code/Research_Project/script_results_2.pdf", height = 11, width = 10)
for (i in 1:iterations){
#SOM
som_grid <- somgrid(xdim = 3, ydim = 3, topo = "hexagonal")
som_model <- som(data_train_matrix,
                 grid = som_grid, rlen = 800,
                 alpha = c(0.05, 0.01), keep.data = TRUE)


## See what node each sample is located in
samples <- c(1:37)
res <- data.frame(samples, som_model$distances, som_model$unit.classif)
colnames(res) <- c("SampleID","distFromCluster", "Cluster")
newx <- c(1:37)
res["Label"] <- newx
res$Label <- ifelse(res$SampleID <= 21, 0, 1)
                         

#plot scatter plot
#plot(res[, 3],res[, 1])
title <- paste("Iteration", i)
grid::grid.text(title,x = (0.5), y = (0.99))
grid.table(res)

plot1 <- ggplot(res,aes(res[, "Cluster"],res[, "SampleID"],colour=Label))+geom_point()
print(plot1)
grid::grid.newpage() #new page


#grid::grid.newpage()
}

dev.off()
