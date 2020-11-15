#repeatability of clusters
library(kohonen)
library(gridExtra)
library(grid)
library(usedist)

#read the data
data <- read.csv("readtext.csv")

#drop the first(the ID) and last(the label) column
data_train <- data[, -c(1, 13)]
labels <- data[, c(13)]
data_train_matrix <- as.matrix(scale(data_train))

#SOM
som_grid <- somgrid(xdim = 3, ydim = 3, topo = "hexagonal")

#print(som_model$grid$pts[1, ]) #prints row 1 and col 2 in the pts table

##### Measures ########
iterations <- 3 #10
total_clusters <- 9 #9
data_total <- data[, -c(1)]
accuracy_table <- NULL

setClass("clusterDetails", slots = list(samples_in_cluster = "integer",
                                        cluster_centroid = "numeric"))
clusters_list <- vector("list", iterations)
SSE <- vector("list", total_clusters)
diff <- vector("list", total_clusters)
#Loop through iterations
for (iteration in 1:iterations) {
    print("Iteration")
    print(iteration)

    #som training
    som_model <- som(data_train_matrix,
                  grid = som_grid, rlen = 800,
                  alpha = c(0.05, 0.01), keep.data = TRUE)

    for (j in 1:total_clusters) { #9 is the number of clusters (3*3)
        samples_in_cluster_i <- which(som_model$unit.classif == j) #store the samples in this cluster
        centroid_cluster_i <- som_model$grid$pts[j, ]
        #store samples in cluster 1
        #data <- list(samples = samples_in_cluster_i,
        #centroid = som_model$grid$pts[j, ])
        obj <- new("clusterDetails", samples_in_cluster = samples_in_cluster_i,
                    cluster_centroid = centroid_cluster_i)
        clusters_list[[iteration]][[j]] <- obj
        #print(obj)
        #print(clusters_list[[1]][[1]]@cluster_centroid)
    }
}
 #print(clusters_list[[1]][[1]]@cluster_centroid)
print("Done1")

result_table <- NULL
for (clust in 1:total_clusters) {
    print(paste("clust no ", clust, sep = ""))
    SSE[[clust]] <- 0
    diff[[clust]] <- 0
    center <- clusters_list[[1]][[clust]]@cluster_centroid
    samples_in_cluster_iter1 <- clusters_list[[1]][[clust]]@samples_in_cluster
    for (j in 2:iterations) {
        min_dist <- 10000
        for (k in 1:total_clusters) {
            #find the dist btw cluster 1 in iteration 1 and
            #clusters in iteration 2
            center2 <- clusters_list[[j]][[k]]@cluster_centroid
            d <- dist(rbind(center, center2))
            dist <- dist_get(d, "center2", "center")
            print("cluster")
            print(k)
            print("iteration")
            print(j)
            #print(center)
            #print(clusters_list[[j]][[k]]@cluster_centroid)
            print(paste("d dist is: ", dist, sep = ""))
            print(paste("d min dist is: ", min_dist, sep = ""))
            if (dist < min_dist) {
                min_dist <- dist
                min_clust_index <- k
            }
        }
        print(paste("The final min dist is ", min_dist, " and the index is ", min_clust_index, sep=""))
        SSE[[clust]] <- SSE[[clust]] + min_dist
        print(paste("SSE for cluster ", clust, " at iteration ", j, " is ", SSE[[clust]], sep=""))
        #get the cluster details of the closest cluster
        samples_in_closest_cluster <-
        clusters_list[[j]][[min_clust_index]]@samples_in_cluster
        #get the no of samples that are different between the cluster data
        a <- length(setdiff(samples_in_cluster_iter1,
                            samples_in_closest_cluster)) #samples in first clust
        b <- length(setdiff(samples_in_closest_cluster,
                            samples_in_cluster_iter1)) #samples in first clust
        diff[[clust]] <-  diff[[clust]] + a + b
        print(paste("Diff for cluster ", clust, " at iteration ", j, " is ", diff[[clust]], sep=""))
        print("SAMPLES IN THE CLUSTER ")
        print(samples_in_cluster_iter1)
        print(samples_in_closest_cluster)
    }
    SS_Error <- SSE[[clust]]
    diff_in_samples <- diff[[clust]]
    print(SSE[[clust]])
    result_table <- rbind(result_table,
                            data.frame(clust, SS_Error, diff_in_samples))       
}

#calculate average 
SSE_avg <- mean(result_table[["SS_Error"]])
diff_avg <- mean(result_table[["diff_in_samples"]])

print(result_table)
#print
print(paste("Number of Iterations: ", iterations, sep = ""))
print(paste("The SSE average is ", SSE_avg, sep = ""))
print(paste("The Difference in samples average is ", diff_avg, sep = ""))