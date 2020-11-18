#repeatability of clusters
library(kohonen)
library(gridExtra)
library(grid)
library(usedist)

#read the data
data <- read.csv("readtext.csv")

#drop the first(the ID) and last(the label) column
data_train <- data[, -c(1, 13)]
data_train_matrix <- as.matrix(scale(data_train))

#Specify the grid to use in the SOM model
som_grid <- somgrid(xdim = 3, ydim = 3, topo = "hexagonal")

#print(som_model$grid$pts[1, ]) #prints row 1 and col 2 in the pts table

#declare the number of iterations
iterations <- 5
#declare the total number of clusters whihc is xdim*ydim
total_clusters <- 9

#create the clusterDetails class with samples_in_cluster and cluster_centroid as properties
setClass("clusterDetails", slots = list(samples_in_cluster = "integer",
                                        cluster_centroid = "numeric"))
clusters_list <- vector("list", iterations)
SSE <- vector("list", total_clusters)
diff <- vector("list", total_clusters)
#Loop through iterations
for (iteration in 1:iterations) {
    #som training
    som_model <- som(data_train_matrix,
                  grid = som_grid, rlen = 800,
                  alpha = c(0.05, 0.01), keep.data = TRUE)

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

result_table <- NULL
for (clust in 1:total_clusters) {
    print(paste("cluster no:", clust, sep = ""))
    SSE[[clust]] <- 0
    diff[[clust]] <- 0
    #retrieve the centroid for this cluster in iteration 1
    center <- clusters_list[[1]][[clust]]@cluster_centroid
    #retrieve the samples in this cluster in iteration 1
    samples_in_cluster_iter1 <- clusters_list[[1]][[clust]]@samples_in_cluster
    for (j in 2:iterations) {
        min_dist <- 10000
        print(paste("Iteration: ", j, sep = ""))
        for (k in 1:total_clusters) {
            #find the dist between this cluster in iteration 1 and all clusters in iteration 2
            center2 <- clusters_list[[j]][[k]]@cluster_centroid
            d <- dist(rbind(center, center2))
            dist <- d[1]
            print(paste("We are checking iteration 1 and cluster ",
            clust, " with iteration ", j, " and cluster ", k,
             ". The dist is: ", dist, sep = ""))
            if (dist < min_dist) {
                min_dist <- dist
                min_clust_index <- k
            }
            print(paste("d min dist at this point is: ", min_dist, sep = ""))
        }
        print(paste("The final min dist is ", min_dist,
        " and the index is ", min_clust_index, sep = ""))

        SSE[[clust]] <- SSE[[clust]] + min_dist
        print(paste("SSE for cluster ", clust,
         " in iteration 1 with the closest cluster at iteration ",
         j, " is ", SSE[[clust]], sep = ""))
        #get the cluster details of the closest cluster using the index saved above
        samples_in_closest_cluster <-
        clusters_list[[j]][[min_clust_index]]@samples_in_cluster
        #get the no of samples that are different between the cluster data
        #samples in first clust but not in second
        a <- length(setdiff(samples_in_cluster_iter1,
                            samples_in_closest_cluster))
        #samples in second clust but not in first
        b <- length(setdiff(samples_in_closest_cluster,
                            samples_in_cluster_iter1))
        diff[[clust]] <-  diff[[clust]] + a + b
        print(paste("Diff for cluster ", clust,
        " in iteration 1 with the closest cluster at iteration ",
         j, " is ", a + b, sep = ""))
        print("SAMPLES IN THE CLUSTER ")
        print(samples_in_cluster_iter1)
        print(samples_in_closest_cluster)
    }
    ss_error <- SSE[[clust]]
    diff_in_samples <- diff[[clust]]
    #populate the result_table
    result_table <- rbind(result_table,
                            data.frame(clust, ss_error, diff_in_samples))
}

#calculate average
sse_avg <- mean(result_table[["ss_error"]])
diff_avg <- mean(result_table[["diff_in_samples"]])

print(result_table)
#print
print(paste("Number of Iterations: ", iterations, sep = ""))
print(paste("The SSE average is ", sse_avg, sep = ""))
print(paste("The Difference in samples average is ", diff_avg, sep = ""))