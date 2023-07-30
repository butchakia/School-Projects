#1
#Load the data set into R memory and view it for verification
library(readr)
Boston <- read_csv("C:/Users/whitl/OneDrive/Desktop/R Files/Bostonnew.csv")
View(Boston)

#2
##Use the lm function along with poly inside of it to find a cubic
#polynomial regression. Set degree of freedom to 3 for cubic. 
#Use summary function to report the regression output.
Q2 <- lm(nox~poly(dis,3), data=Boston)
summary(Q2)

#3
#Load caret from libray then set the training model using trainControl
#set seed for model to use, often a random number we chose .5
#run the train function with a polynomial inside with degrees of freedom
#varying from 2 to 5. Print out the results of each to see which one
#has the best RSME
library(caret)
train_control=trainControl(method="cv", number=10)
set.seed(.5)
cv5 = train(nox~poly(dis, 5), data=Boston, trControl=train_control,
       method="lm")
print(cv5)
cv4 = train(nox~poly(dis, 4), data=Boston, trControl=train_control,
            method="lm")
print(cv4)
cv3 = train(nox~poly(dis, 3), data=Boston, trControl=train_control,
            method="lm")
print(cv3)
cv2 = train(nox~poly(dis, 2), data=Boston, trControl=train_control,
            method="lm")
print(cv2)

#4
#load gam from library, next use gam function to create 
#smoothing spline models. After run an anova analysis to 
#see which has best p-value.
library(gam)
gamA = gam(nox ~s(dis,3)+s(medv,2), data=Boston)
gamB = gam(nox~s(dis,2)+s(medv,1), data=Boston)
anova(gamA, gamB)



