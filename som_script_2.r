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

print(som_model)

#som.events <- som_model$codes[[1]]
#print(som.events)
summary(som_model)

#Training progress for SOM
bgcols <- c("gray", "pink")
#plot(som_model, type = "mapping",
#col = bgcols[labels], pchs = labels,
#main = "mapping plot")


print(which(som_model$unit.classif == 1)) #which samples are in node 1

##### Measures ########
print("Quantization Error measure")
iterations <- 50
output <- NULL #<- matrix(ncol = 2, nrow = iterations)
confusion_table <- NULL
    #set.seed(123) #to make it constant
    data_total <- data[, -c(1)]
    #split data
    ind <- sample(2, nrow(data_total), replace = T, prob = c(0.75, 0.25))
    train <- data_total[ind == 1, ]
    test <- data_total[ind == 2, ]
    # Normalization
    trainX <- scale(train[, -12])
    testX <- scale(test[, -12],
                center = attr(trainX, "scaled:center"),
                scale = attr(trainX, "scaled:scale"))

    #print(nrow(testX))
    trainY <- factor(train[, 12])
    Y <- factor(test[, 12])
    test[, 12] <- 0
    testXY <- list(independent = testX, dependent = test[, 12])

for (iteration in 1:iterations) {
    print("Iteration")
    print(iteration)
    som_grid <- somgrid(xdim = 3, ydim = 3, topo = "hexagonal")
    som_model <- som(data_train_matrix,
                  grid = som_grid, rlen = 800,
                  alpha = c(0.05, 0.01), keep.data = TRUE)
    quant_error <- mean(som_model$distances)
    output <- rbind(output, data.frame(iteration, quant_error))

    ################# confusion matrix #####################
    # Classification & Prediction Model
    # set.seed(222)
    map1 <- xyf(trainX,
                classvec2classmat(factor(trainY)),
                grid = somgrid(3, 3, "hexagonal"),
                rlen = 100)
    #plot(map1, type="changes")

    # Prediction
    pred <- predict(map1, newdata = testXY)
    #print(testXY)
    print("Hi")
    print(pred)
    confusion_matrix <- table(Predicted = pred$predictions[[2]], Actual = Y)
    #confusion_matrix <- table(Y, pred$predictions)
    print(confusion_matrix)

    confusion_accuracy <- ((confusion_matrix[1, 1] + confusion_matrix[2, 2]) / 
                            (confusion_matrix[1, 1] + confusion_matrix[2, 2] + 
                            confusion_matrix[1, 2] + confusion_matrix[2, 1]))

    #print(confusion_accuracy)

    confusion_table <- rbind(confusion_table, data.frame(iteration, confusion_accuracy))

}


#plot the graph
pdf("C:/Users/Aeesha/Documents/CMU/Research/Code/Research_Project/results_11.pdf", height = 15, width = 10)
title <- paste("Quantization Error")
grid::grid.text(title,x = (0.5), y = (0.99))
grid.table(output)
plot(output)
grid::grid.newpage()
title <- paste("Confusion Matrix Accuracy")
grid::grid.text(title,x = (0.5), y = (0.99))
grid.table(confusion_table)
plot(confusion_table)

dev.off()




# Cluster Boundaries
#par(mfrow = c(1,2))
#plot(map1, 
     #type = 'codes',
     #main = c("Codes X", "Codes Y"))
#map1.hc <- cutree(hclust(dist(map1$codes[[2]])), 2)
#add.cluster.boundaries(map1, map1.hc)
#par(mfrow = c(1,1))