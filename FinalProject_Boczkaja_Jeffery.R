###############################################
#                                             #
# Author:     Jeffery Boczkaja                #
# Date:       5/1/23                          #
# Subject:    Final Project                   #
# Class:      DSCI 512                        #
# Section:    1W                              #         
# Instructor: Juan David Munoz                #
# File Name:  FinalProject_Boczkaja_Jeffery.R #
#                                             # 
###############################################


########################
# 1.  Data Preparation #
########################

# 1A.  Load the dataset insurance.csv into memory.
library(readr)
insurance <- read_csv("C:/Users/whitl/OneDrive/Desktop/R Files/insurance.csv")
View(insurance)
#  1B.  In the data frame, transform the variable charges by seting
#         insurance$charges = log(insurance$charges). Do not transform
#         it outside of the data frame.
insurance$charges = log(insurance$charges)
#     c.  Using the data set from 1.b, use the model.matrix() function
#         to create another data set that uses dummy variables in place
#         of categorical variables. Verify that the first column only has
#         ones (1) as values, and then discard the column only after
#         verifying it has only ones as values.
mtest <- model.matrix(~age+sex+bmi+children+smoker+region+charges, insurance)
print(mtest)
mtest <- model.matrix(~age+sex+bmi+children+smoker+region+charges-1, insurance)
print(mtest)
#     d.  Use the sample() function with set.seed equal to 1 to generate
#         row indexes for your training and tests sets, with 2/3 of the
#         row indexes for your training set and 1/3 for your test set. Do
#         not use any method other than the sample() function for
#         splitting your data.
set.seed(1)
index <- sample(1:nrow(insurance), (2/3)*nrow(insurance))
#     e.  Create a training and test data set from the data set created in
#         1.b using the training and test row indexes created in 1.d.
#         Unless otherwise stated, only use the training and test
#         data sets created in this step.
train <- insurance[index, ]
test <- insurance[-index, ]
#     f.  Create a training and test data set from data set created in 1.c
#         using the training and test row indexes created in 1.d
train2 <- mtest[index, ]
test2 <- mtest[-index, ]
#################################################
# 2.  Build a multiple linear regression model. #
#################################################

#     a.  Perform multiple linear regression with charges as the
#         response and the predictors are age, sex, bmi, children,
#         smoker, and region. Print out the results using the
#         summary() function. Use the training data set created in
#         step 1.e to train your model.
lm.fit <- lm(charges~age+sex+bmi+children+smoker+region, data=train)
summary(lm.fit)
#     b.  Is there a relationship between the predictors and the
#         response?
#There is a relationship between all the predictors and the response, all
#have p-values under 5%.
#     c.  Does sex have a statistically significant relationship to the
#         response?
#Yes sex has a statistically significant relationship to the response.
#     d.  Perform best subset selection using the stepAIC() function
#         from the MASS library, choose best model based on AIC. For
#         the "direction" parameter in the stepAIC() method, set
#         direciton="backward"
library(MASS)
lm.bwd <- stepAIC(lm.fit, direction="backward")
print(lm.bwd)
#     e.  Compute the test error of the best model in #3d based on AIC
#         using LOOCV using trainControl() and train() from the caret
#         library. Report the MSE by squaring the reported RMSE.
library(caret)
train_control <- trainControl(method="LOOCV")
model <- train(charges~age+sex+bmi+children+smoker+region, data=insurance, trControl=train_control, method="lm")
print(model)
#MSE
.05072477^2
#     f.  Calculate the test error of the best model in #3d based on AIC
#         using 10-fold Cross-Validation. Use train and trainControl
#         from the caret library. Refer to model selected in #3d based
#         on AIC. Report the MSE.
train_control2 <- trainControl(method="CV", number=10)
model2 <- train(charges~age+sex+bmi+children+smoker+region, data=insurance, trControl=train_control2, method="lm")
print(model2)
#MSE
.0505257^2
#     g.  Calculate and report the test MSE using the best model from 
#         2.d and the test data set from step 1.e.
model2 <- train(charges~age+sex+bmi+children+smoker+region, data=insurance, trControl=test, method="lm")
print(model2)
#MSE
.0505257^2
#     h.  Compare the test MSE calculated in step 2.f using 10-fold
#         cross-validation with the test MSE calculated in step 2.g.
#         How similar are they?
#  They happen to be the same

######################################
# 3.  Build a regression tree model. #
######################################

#     a.  Build a regression tree model using function tree(), where
#         charges is the response and the predictors are age, sex, bmi,
#         children, smoker, and region.
library(tree)
tree.insurance <- tree(charges~age+sex+bmi+children+smoker+region, insurance)
#     b.  Find the optimal tree by using cross-validation and display
#         the results in a graphic. Report the best size.
cv.insurance <- cv.tree(tree.insurance)
plot(cv.insurance)
#the best size is 4
#     c.  Justify the number you picked for the optimal tree with
#         regard to the principle of variance-bias trade-off.
# I chose 4 because its about where the graph begins to level off, we want to balance between
# variance and bias. We could get less bias if we went with 5 or higher but we would end up
# getting too much variance at that point.
#     d.  Prune the tree using the optinal size found in 3.b
prune.insurance <- prune.tree(tree.insurance, best=4)
#     e.  Plot the best tree model and give labels.
plot(prune.insurance)
text(prune.insurance, pretty=0)
#     f.  Calculate the test MSE for the best model.
yhat <- predict(prune.insurance, newdata=insurance[-train, ])
insurance.test <- insurance[-train, "charges"]
mean((yhat-insurance.test$charges)^2)

####################################
# 4.  Build a random forest model. #
####################################

#     a.  Build a random forest model using function randomForest(),
#         where charges is the response and the predictors are age, sex,
#         bmi, children, smoker, and region.
library(randomForest)
rf.insurance <- randomForest(charges~age+sex+bmi+children+smoker+region, data=insurance, importance=TRUE)
#     b.  Compute the test error using the test data set.
yhat.rf = predict(rf.insurance, newdata = insurance[-train,])
Insurance.test = insurance[-train, "charges"]
mean((yhat.rf - Insurance.test$charges)^2)
#     c.  Extract variable importance measure using the importance()
#         function.
importance(rf.insurance)
#     d.  Plot the variable importance using the function, varImpPlot().
#         Which are the top 3 important predictors in this model?
varImpPlot(rf.insurance)
# The top 3 important predictorsare smoker, age, and children
############################################
# 5.  Build a support vector machine model #
############################################

#     a.  The response is charges and the predictors are age, sex, bmi,
#         children, smoker, and region. Please use the svm() function
#         with radial kernel and gamma=5 and cost = 50.
library(e1071)
svm.insurance <- svm(charges~age+sex+bmi+children+smoker+region, data=insurance[train, ], kernel="radial", gamma=5, cost=50)
#     b.  Perform a grid search to find the best model with potential
#         cost: 1, 10, 50, 100 and potential gamma: 1,3 and 5 and
#         potential kernel: "linear","polynomial","radial" and
#         "sigmoid". And use the training set created in step 1.e.
tune.out <- tune(svm, charges~age+sex+bmi+children+smoker+region, data=insurance[train, ], kernel="radial",
                 ranges= list(cost=c(1, 10, 50, 100), gamma=c(1,3,5)))
#     c.  Print out the model results. What are the best model
#         parameters?
print(tune.out)
#     d.  Forecast charges using the test dataset and the best model
#         found in c).
pred = predict(tune.out$best.model, newdata = insurance[-train, ])
#     e.  Compute the MSE (Mean Squared Error) on the test data.
trueObservation=insurance[-train, "charges"]
mean((trueObservation$charges-pred)^2)

#############################################
# 6.  Perform the k-means cluster analysis. #
#############################################

#     a.  Use the training data set created in step 1.f and standardize
#         the inputs using the scale() function.
library("cluster")
library("factoextra")
scaled.insurance <- scale(train2)
#     b.  Convert the standardized inputs to a data frame using the
#         as.data.frame() function.
scaled.insurance <- as.data.frame(scaled.insurance)
#     c.  Determine the optimal number of clusters, and use the
#         gap_stat method and set iter.max=20. Justify your answer.
#         It may take longer running time since it uses a large dataset.
fviz_nbclust(scaled.insurance, kmeans, method = "gap_stat", iter.max=20)
# We can see that the optimal number of clusters is 4 as calculated by the fviz_nblust
# function. Its the number of clusters with the dashed line through it.
#     d.  Perform k-means clustering using the optimal number of
#         clusters found in step 6.c. Set parameter nstart = 25
km.res <- kmeans(scaled.insurance, 4, nstart=25)
#     e.  Visualize the clusters in different colors, setting parameter
#         geom="point"
fviz_cluster(km.res, data=scaled.insurance, geom="point")

######################################
# 7.  Build a neural networks model. #
######################################

#     a.  Using the training data set created in step 1.f, create a 
#         neural network model where the response is charges and the
#         predictors are age, sexmale, bmi, children, smokeryes, 
#         regionnorthwest, regionsoutheast, and regionsouthwest.
#         Please use 1 hidden layer with 1 neuron. Do not scale
#         the data.
library(neuralnet)
nn.model <- neuralnet(charges~age+sexmale+bmi+children+smokeryes+regionnorthwest+regionsoutheast+regionsouthwest, data=train2, hidden=c(1,1))
#     b.  Plot the neural network.
plot(nn.model)
#     c.  Forecast the charges in the test dataset.
predict.nn <- compute(nn.model, test2[, c("age","sexmale","bmi","children","smokeryes","regionnorthwest","regionsoutheast","regionsouthwest")])
#     d.  Compute test error (MSE).
observ.test <- test$charges
mean((observ.test-predict.nn$net.result)^2)

################################
# 8.  Putting it all together. #
################################

#     a.  For predicting insurance charges, your supervisor asks you to
#         choose the best model among the multiple regression,
#         regression tree, random forest, support vector machine, and
#         neural network models. Compare the test MSEs of the models
#         generated in steps 2.g, 3.f, 4.b, 5.e, and 7.d. Display the names
#         for these types of these models, using these labels:
#         "Multiple Linear Regression", "Regression Tree", "Random Forest", 
#         "Support Vector Machine", and "Neural Network" and their
#         corresponding test MSEs in a data.frame. Label the column in your
#         data frame with the labels as "Model.Type", and label the column
#         with the test MSEs as "Test.MSE" and round the data in this
#         column to 4 decimal places. Present the formatted data to your
#         supervisor and recommend which model is best and why.
Data_Frame <-data.frame(
  Model.Type = c("Multiple Linear Regresson", "Regression Tree", "Random Forest", "Support Vector Machine", "Neural Network"),
  Test.MSE = c(.0026, .0062, .0010, .1980, .8737))
Data_Frame
# Based on the table of MSEs for the various models the choice for best model is the Random Forest. We want our
# result to be as close to zero as possible and this one is clearly the closest.
#     b.  Another supervisor from the sales department has requested
#         your help to create a predictive model that his sales
#         representatives can use to explain to clients what the potential
#         costs could be for different kinds of customers, and they need
#         an easy and visual way of explaining it. What model would
#         you recommend, and what are the benefits and disadvantages
#         of your recommended model compared to other models?
# I would recommend using a cluster model. Clusters provide nice visualizations that are easier for people who
# are not data literate to understand. Also you can vary how many groupings you would like to make, so it could
# range from something specific to more general. It adapts to new examples very well. The disadvantages of this method
# would be that some outliers could get grouped together. Maybe making that data a little unreliable. You need to know 
# how to pick the best number of clusters otherwise you're data could aslo be off.
#     c.  The supervisor from the sales department likes your regression
#         tree model. But she says that the sales people say the numbers
#         in it are way too low and suggests that maybe the numbers
#         on the leaf nodes predicting charges are log transformations
#         of the actual charges. You realize that in step 1.b of this
#         project that you had indeed transformed charges using the log
#         function. And now you realize that you need to reverse the
#         transformation in your final output. The solution you have
#         is to reverse the log transformation of the variables in 
#         the regression tree model you created and redisplay the result.
#         Follow these steps:
#
#         i.   Copy your pruned tree model to a new variable.
prune.insurance2 <- prune.tree(tree.insurance, best=4)
#         ii.  In your new variable, find the data.frame named
#              "frame" and reverse the log transformation on the
#              data.frame column yval using the exp() function.
#              (If the copy of your pruned tree model is named 
#              copy_of_my_pruned_tree, then the data frame is
#              accessed as copy_of_my_pruned_tree$frame, and it
#              works just like a normal data frame.).
prune.insurance2$frame
insurance$charges = exp(insurance$charges)
tree.insurance <- tree(charges~age+sex+bmi+children+smoker+region, insurance)
cv.insurance <- cv.tree(tree.insurance)
prune.insurance2 <- prune.tree(tree.insurance, best=4)
prune.insurance2$frame
#         iii. After you reverse the log transform on the yval
#              column, then replot the tree with labels.
plot(prune.insurance2)
text(prune.insurance2, pretty=0)

