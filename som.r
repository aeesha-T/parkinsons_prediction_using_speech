require(kohonen)
#require(gridExtra)
#require(grid)
install.packages("gridExtra")
library(gridExtra)
library(grid)

#read the data
data <- read.csv("readtext.csv")
cat("Number of cols: ", ncol(data), "\n")
cat("Number of cols: ", nrow(data), "\n")

#drop the first(the ID) and last(the label) column
data_train <- data[, -c(1, 13)]
data_train_matrix <- as.matrix(scale(data_train))

#SOM
som_grid <- somgrid(xdim = 3, ydim = 3, topo = "hexagonal")
som_model <- som(data_train_matrix,
                  grid = som_grid, rlen = 800,
                  alpha = c(0.05, 0.01), keep.data = TRUE)

pdf_path <- "som_graphs2.pdf"
pdf(file = pdf_path, height = 11, width = 10)

#Training progress for SOM
plot(som_model, type = "changes")

#Number of samples per node
plot(som_model, type = "count", main = "Number of Samples per Nodes")

#U-matrix visualisation????
plot(som_model, type = "dist.neighbours", main = "SOM neighbour distances")

## See what node each sample is located in
res <- data.frame(som_model$distances, som_model$unit.classif)
colnames(res) <- c("distFromClus", "Cluster")
print("Cluster each sample belongs to")
print(res)

print("end")

#Weight Vector View
plot(som_model, type = "codes")

## Kohonen Heatmap creation......loop through each feature
##this is for the scaled version
#for (i in 1:11) {
#plot(som_model, type = "property",
      #property = getCodes(som_model)[, i],
     # main = colnames(getCodes(som_model))[i], palette.name = coolBlueHotRed)
#}

#coolBlueHotRed <- function(n, alpha = 1) {
                         # rainbow(n, end = 4 / 6, alpha = alpha)[n:1]
                         # }

#pretty_palette <- c("#1f77b4","#ff7f0e","#2ca02c", "#d62728","#9467bd","#8c564b","#e377c2")


  # Unscaled Heatmaps
  for (i in 1:11) {
var_unscaled <- aggregate(as.numeric(data_train[, i]),
 by = list(som_model$unit.classif), FUN = mean, simplify = TRUE)[, 2]
plot(som_model, type = "property", property = var_unscaled,
main = colnames(getCodes(som_model))[i], palette.name = coolBlueHotRed)
  }
dev.off()

pdf("samples_in_cluster.pdf", height = 11, width = 10)
grid.table(res)
dev.off()