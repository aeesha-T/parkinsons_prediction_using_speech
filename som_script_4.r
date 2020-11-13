#repeatability of clusters
library(kohonen)
library(gridExtra)
library(grid)

#read the data
data <- read.csv("readtext.csv")

#drop the first(the ID) and last(the label) column
data_train <- data[, -c(1, 13)]
labels <- data[, c(13)]
data_train_matrix <- as.matrix(scale(data_train))

#SOM
som_grid <- somgrid(xdim = 3, ydim = 3, topo = "hexagonal")
som_model <- som(data_train_matrix,
                  grid = som_grid, rlen = 800,
                  alpha = c(0.05, 0.01), keep.data = TRUE)

print(som_model$grid$pts[1, ]) #prints row 1 and col 2 in the pts table
#print(som_model$grid$pts[2])
##### Measures ########
iterations <- 1
data_total <- data[, -c(1)]
accuracy_table <- NULL

setClass("dat", slots=list(sampless = "integer", center = "numeric"))
#Loop through iterations
for (iteration in 1:iterations) {
    print("Iteration")
    print(iteration)

    #som training
    som_model <- som(data_train_matrix,
                  grid = som_grid, rlen = 800,
                  alpha = c(0.05, 0.01), keep.data = TRUE)

    #array containing samples in clusters
    #x <- matrix(data = NA, nrow = iterations, ncol = 9)
    x <- vector("list", iterations)
    #x <- list()
    #print(som_model)
    for (j in 1:1) { #9 is the number of clusters (3*3)
        samples_in_cluster_i <- which(som_model$unit.classif == j)
        #store samples in cluster 1
        data <- list(samples = samples_in_cluster_i,
        centroid = som_model$grid$pts[j, ])
        obj <- new("dat", sampless = samples_in_cluster_i,
         center = som_model$grid$pts[j, ])
        x[[iteration]][[j]] <- obj
        print(obj)
        print(x[[iteration]][[j]]@center)
    }
    #print(x[1, 1])
    #print(x[1, 2]$centroid)

}



#plot the graph
# pdf("C:/Users/Aeesha/Documents/CMU/Research/Code/Research_Project/results_11.pdf", height = 15, width = 10)
# title <- paste("Quantization Error")
# grid::grid.text(title,x = (0.5), y = (0.99))
# grid.table(output)
# plot(output)
# grid::grid.newpage()
# title <- paste("Confusion Matrix Accuracy")
# grid::grid.text(title,x = (0.5), y = (0.99))
# grid.table(confusion_table)
# plot(confusion_table)

#dev.off()




