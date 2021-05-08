findSimilarClusters <- function (clusters_list, total_clusters, iterations){
  library(entropy)
  
  result_table <- NULL
  SSE <- vector("list", total_clusters)
  diff <- vector("list", total_clusters)
  
  for (clust in 1:total_clusters) {
    print(paste("cl
                uster no:", clust, sep = ""))
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
  
  return(result_table )
}


findSimilarClustersUsingClassLabels <- function (clusters_list, class_labels, total_clusters, iterations){
  
  result_table <- NULL
  SSE <- vector("list", total_clusters)
  diff <- vector("list", total_clusters)
  
  for (clust in 1:total_clusters) {
    print(paste("cl
                uster no:", clust, sep = ""))
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
      
      class_labels_iter1 = class_labels$label[samples_in_cluster_iter1];
      class_labels_in_closest_cluster = class_labels$label[samples_in_closest_cluster];
      
      #get the no of samples that are different between the cluster data
      #samples in first clust but not in second
      a <- length(setdiff(class_labels_iter1,
                          class_labels_in_closest_cluster))
      diff[[clust]] <-  diff[[clust]] + a
      print(paste("Diff for cluster ", clust,
                  " in iteration 1 with the closest cluster at iteration ",
                  j, " is ", a, sep = ""))
      # print("SAMPLES IN THE CLUSTER ")
      # print(samples_in_cluster_iter1)
      # print(samples_in_closest_cluster)
    }
    ss_error <- SSE[[clust]]
    diff_in_samples <- diff[[clust]]
    #populate the result_table
    result_table <- rbind(result_table,
                          data.frame(clust, ss_error, diff_in_samples))
  }
  
  return(result_table )
}

checkIfClusterHasSameLabels <- function (clusters_list, class_labels, total_clusters, iterations){
  num_classes=length(unique(class_labels$label))
  if (num_classes == 1){
    print("Number of classes is 1. Nothing to compute here")
    return()
  }
    
  for (j in 1:iterations) {
    print(paste("Iteration # ", j))
    for (clust in 1:total_clusters){
      curr_class_label = class_labels$label[clusters_list[[j]][[clust]]@samples_in_cluster]
      a=rep(as.factor(curr_class_label))
      b=summary(a)
      curr_entropy = entropy(b) / log(num_classes)
      number_of_unique_classes = length(unique(curr_class_label))
      if (number_of_unique_classes != 1){
        print(paste("    Cluster ", clust, " has confusions. No of classes=", number_of_unique_classes, " Entropy=", curr_entropy))
      }
    }
  }
}
