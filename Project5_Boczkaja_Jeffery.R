#1
#load the data set and view for verification
library(readr)
Bike <- read_csv("C:/Users/whitl/OneDrive/Desktop/R Files/Bike.csv")
View(Bike)
#set the seed value and split the data for the training set
set.seed(3)
train = sample(nrow(Bike), nrow(Bike)/1.5)

#2
#load tree from library
library(tree)
#a use tree() function to create model
tree.bike <- tree(count~season+holiday+workingday+temp+atemp+humidity+windspeed+casual+registered, Bike, subset=train)
#b perform cross-validation of model
cv.bike <- cv.tree(tree.bike)
#C plot the results of the model, use to determine best size
plot(cv.bike$size, cv.bike$dev, ttpe = 'b')
#d with best size, call prune.tree() function
prune.bike <- prune.tree(tree.bike, best=8)
#e plot the best tree model, call text() function for labels
plot(prune.bike)
text(prune.bike, pretty=0)
#f compute the test erorr using the data set, call predict() function, assign data, call mean() funtion
yhat = predict(prune.bike, newdata=Bike[-train, ])
bike.test <- Bike[-train, "count"]
mean((yhat-bike.test$count)^2)

#3 load randomForest from library
library(randomForest)
#a set seed and create training set, then use randomForest() function to create model
set.seed(3)
train = sample(1:nrow(Bike), nrow(Bike)/2)
rf.bike = randomForest(count~season+holiday+workingday+temp+atemp+humidity+windspeed+casual+registered, data = Bike, subset = train, importance = TRUE)
#b Compute the test error using predict(), label test data, run with mean() function
yhat.rf = predict(rf.bike, newdata = Bike[-train,])
Bike.test = Bike[-train, "count"]
mean((yhat.rf - Bike.test$count)^2)
#c extract variable importance measure using importance() function
importance(rf.bike)
#d plot the variable importance using varImpPlot() function
varImpPlot(rf.bike)
