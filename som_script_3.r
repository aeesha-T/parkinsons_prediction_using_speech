#one holdout method
library(kohonen)
library(gridExtra)
library(grid)

#read the data
data <- read.csv("readtext.csv")

##### Measures ########
iterations <- 5
#drop the first column because it is the voice ID
data_total <- data[, -c(1)]
accuracy_table <- NULL
#Loop through iterations
for (iteration in 1:iterations) {
    print(paste("Iteration", iteration, sep = ""))
    accuracy <- 0
    prediction_table <- NULL
    for (i in 1:37) {
    # Select sample no i as test, and all others as train.
    train <- data_total [-c(i), ]
    test <- data_total [i, ]
    #Extract the train data by excluding the 12 column which is label
    trainX <- scale(train[, -12])
    testX <- scale(test[, -12],
                center = attr(trainX, "scaled:center"),
                scale = attr(trainX, "scaled:scale"))
    #Extract the label (the 12th column) for both the train and test
    trainY <- factor(train[, 12])
    Y <- factor(test[, 12])
    train_Y_matrix <- classvec2classmat(trainY)
    #model
    map1 <- xyf(trainX,
                train_Y_matrix,
                grid = somgrid(3, 3, "hexagonal"),
                rlen = 100)

    #make predictions
    pred <- predict(map1, newdata = testX, whatmap = 1)
    #print(pred$predictions)
    predicted_y <- classmat2classvec(pred$predictions[[2]])
    #print(predicted_y)
    #print(data.frame(i, Y, predicted_y))
    if (Y == predicted_y) {
        accuracy <- accuracy + 1
    }
    #populate the prediction table
    prediction_table <- rbind(prediction_table, data.frame(i, Y, predicted_y))
    }

    print(prediction_table)
    #calculate the accuracy value
    accuracy_value <- accuracy / 37
    print(accuracy_value)
    #populate accuracy table
    accuracy_table <- rbind(accuracy_table, data.frame(iteration, accuracy_value))
}
print(accuracy_table)



#save to a file
pdf("C:/Users/Aeesha/Documents/CMU/Research/Code/Research_Project/OneHoldOutEvaluation.pdf", height = 15, width = 10)
title <- paste("Accuracy Table")
grid::grid.text(title, x = (0.5), y = (0.99))
grid.table(accuracy_table)
plot(accuracy_table)
dev.off()