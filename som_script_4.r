#repeatability of clusters
library(kohonen)
library(gridExtra)
library(grid)
library(usedist)
source("clusterSimilarityFunctions.r")

#read the data
data <- read.csv("readtext.csv")
data <- read.csv("alc_features.csv")
data <- read.csv("MDVR_all_features.csv")
num_variables = length(data)
#drop the first(the ID) and last(the label) column
data_train <- data[, -c(1, num_variables)]
data_train_matrix <- as.matrix(scale(data_train))
class_labels <- data[c(num_variables)]
grid_x = 3
grid_y = 2
#Specify the grid to use in the SOM model
som_grid <- somgrid(xdim = grid_x, ydim = grid_y, topo = "hexagonal")

#print(som_model$grid$pts[1, ]) #prints row 1 and col 2 in the pts table

#declare the number of iterations
iterations <- 5
#declare the total number of clusters whihc is xdim*ydim
total_clusters <- grid_x * grid_y

#create the clusterDetails class with samples_in_cluster and cluster_centroid as properties
setClass("clusterDetails", slots = list(samples_in_cluster = "integer",
                                        cluster_centroid = "numeric"))
clusters_list <- vector("list", iterations)

#Loop through iterations
for (iteration in 1:iterations) {
    #som training
    som_model <- som(data_train_matrix,
                  grid = som_grid, rlen = 800,
                  alpha = c(0.05, 0.01), keep.data = TRUE)
    clusters_list[[iteration]] <- vector("list", total_clusters)
    
    for (j in 1:total_clusters) {
        #store the samples in this cluster
        samples_in_cluster_i <- which(som_model$unit.classif == j)
        #extract the centroid for this cluster and store it
        centroid_cluster_i <- som_model$codes[[1]][j, ]
        #create an object of the clusterDetails and pass in these values
        obj <- new("clusterDetails", samples_in_cluster = samples_in_cluster_i,
                    cluster_centroid = centroid_cluster_i)
        #save this object in the cluster list
        clusters_list[[iteration]][[j]] <- obj
        #print(obj)
        #print(clusters_list[[1]][[1]]@cluster_centroid)
    }
}
print("Done1")

#result_table=findSimilarClusters(clusters_list, total_clusters, iterations);
checkIfClusterHasSameLabels(clusters_list, class_labels, total_clusters, iterations)
result_table = findSimilarClustersUsingClassLabels(clusters_list, class_labels, total_clusters, iterations);

#calculate average
sse_avg <- mean(result_table[["ss_error"]])
diff_avg <- mean(result_table[["diff_in_samples"]])

print(result_table)
#print
print(paste("Number of Iterations: ", iterations, sep = ""))
print(paste("The SSE average is ", sse_avg, sep = ""))
print(paste("The Difference in samples average is ", diff_avg, sep = ""))
