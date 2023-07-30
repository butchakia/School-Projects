#1 Load dataset wine.csv
library(readr)
wine <- read_csv("C:/Users/whitl/OneDrive/Desktop/R Files/wine.csv")
View(wine)

#Load neuralnet package
library(neuralnet)

#2A Standardize inputs with scale()
scaled.wine <- scale(wine)
#2B Convert standardized input to data frame using as.data.frame()
scaled.wine <- as.data.frame(scaled.wine)
#2C Split data into training set, 3/4 in original, 1/4 for test
set.seed(7)
index <- sample(1:nrow(scaled.wine), 0.75*nrow(scaled.wine))
train <- scaled.wine[index, ]
test <- scaled.wine[-index, ]

#3A Build neural network with quality as response, 1 hidden layer, 1 neuron
nn.model <- neuralnet(quality~volatile.acidity+density+pH+alcohol, data=train, hidden=c(1,1))
#3B Plot the neural network
plot(nn.model)
#3C Forecast the wine quality in the test dataset
predict.nn <- compute(nn.model, test[, c("volatile.acidity", "density", "pH", "alcohol")])
#3D Get the observed wine quality for the test dataset
observ.test <- test$quality
#3E Compute the test error
mean((observ.test-predict.nn$net.result)^2)

