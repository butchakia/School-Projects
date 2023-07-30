#1 Load data set, view for verification
library(readr)
Bike <- read_csv("C:/Users/whitl/OneDrive/Desktop/R Files/Bike.csv")
View(Bike)
# Convert holiday into factor
Bike$holiday <- as.factor(Bike$holiday)
# Set the seed value and split the data for the training set
set.seed(5)
train = sample(nrow(Bike), nrow(Bike)/1.5)

#2 Build a support machine vector model, load library for e1071
library(e1071)
#A use svm function to create support vector
svm.bike <- svm(holiday~season+workingday+casual+registered, data=Bike[train, ], Kernel="radial", gamma=10, cost=100)
#B perfomr grid search to find best model using tune()
tune.out <- tune(svm, holiday~season+workingday+casual+registered, data=Bike[train, ], Kernel="radial",
                 ranges= list(cost= c(1,10,50,100), gamma=c(1,3,5)))
#C Print out the model results
summary(tune.out)
#D Forecast holiday using the test dataset and the best model found in C
pred = predict(tune.out$best.model, newdata = Bike[-train, ])
#E Get true observations of holiday in the test dataset
trueObservation=Bike[-train, "holiday"]
#F Compute the test error with confusion matrix
table(trueObservation$holiday, pred)
#Calculate percentage of accuracy
(3520+8)/(3520+7+8+94)
