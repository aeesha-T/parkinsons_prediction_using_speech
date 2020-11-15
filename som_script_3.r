#one holdout method 
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

##### Measures ########
iterations <- 10
data_total <- data[, -c(1)]
accuracy_table <- NULL
#Loop through iterations
for (iteration in 1:iterations) {
    print("Iteration")
    print(iteration)
accuracy <- 0
prediction_table <- NULL
for (i in 1:37) {
    train <- data_total [-c(i), ]
    test <- data_total [i, ]

    # Normalization
    trainX <- scale(train[, -12])
    testX <- scale(test[, -12],
                center = attr(trainX, "scaled:center"),
                scale = attr(trainX, "scaled:scale"))
    trainY <- factor(train[, 12])
    Y <- factor(test[, 12])
    train_Y_matrix <- classvec2classmat(trainY)
    #print(classmat2classvec(xx))
    map1 <- xyf(trainX,
                train_Y_matrix,
                grid = somgrid(3, 3, "hexagonal"),
                rlen = 100)

    pred <- predict(map1, newdata = testX, whatmap = 1)
    print(pred$predictions)
    predicted_y <- classmat2classvec(pred$predictions[[2]])
    #print(predicted_y)
    #print(data.frame(i, Y, predicted_y))
    if (Y == predicted_y) {
        accuracy <- accuracy + 1
    }
   prediction_table <- rbind(prediction_table, data.frame(i, Y, predicted_y))

    #confusion_matrix <- table(Predicted = pred$predictions[[2]], Actual = Y)
    # som_grid <- somgrid(3,3, "hexagonal")
    # som_model <- som(trainX, som_grid)
    # som.prediction <- predict(som_model, newdata = testX)
    # error.df <- data.frame(Y,
    #                    predicted = som.prediction$unit.classif)
    #                    print(error.df)
}
print(prediction_table)
accuracy_value <- accuracy / 37
print(accuracy_value)
#populate accuracy table
accuracy_table <- rbind(accuracy_table, data.frame(iteration, accuracy_value))
}
print(accuracy_table)



#plot the graph
pdf("C:/Users/Aeesha/Documents/CMU/Research/Code/Research_Project/OneHoldOutEvaluation.pdf", height = 15, width = 10)
title <- paste("Accuracy Table")
grid::grid.text(title, x = (0.5), y = (0.99))
grid.table(accuracy_table)
plot(accuracy_table)
# grid::grid.newpage()
# title <- paste("Confusion Matrix Accuracy")
# grid::grid.text(title,x = (0.5), y = (0.99))
# grid.table(confusion_table)
# plot(confusion_table)

dev.off()




