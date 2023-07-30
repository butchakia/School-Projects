#0
library(readxl)
mtcars <- read_excel("C:/Users/whitl/OneDrive/Desktop/R Files/mtcars.xlsx")
View(mtcars)

#1
mtcars$am = factor(mtcars$am)

#2
nrow(mtcars)
train <- head(mtcars, 35)
mtcars.test <- tail(mtcars, 6)

#3
glm.fit <- glm(am~mpg+cyl+hp+wt, data=mtcars, family=binomial)

#4
glm.probs <- predict(glm.fit, mtcars.test, type = "response")
glm.pred <- rep("0", nrow(mtcars.test))
glm.pred[glm.probs>.5]="1"
table(glm.pred, mtcars.test$am)
mean(glm.pred == mtcars.test$am)

#Part 2
#0
library(readr)
Bike <- read_csv("C:/Users/whitl/OneDrive/Desktop/R Files/Bike.csv")
View(Bike)

#1
lm.model <- lm(count~season+holiday+workingday+weather+atemp+registered, data=Bike)

#2
library(bestglm)
library(leaps)
Q2 <- Bike[, c("season", "holiday", "workingday", "weather", "atemp", "registered", "count")]
Q2=as.data.frame(Q2)
lm.best = bestglm(Q2, IC = "BIC")
lm.best

#3
library(caret)
train_control <- trainControl(method = "LOOCV")
model <- train(count~season+holiday+workingday+weather+atemp+registered, data=Bike, trControl=train_control, method="lm")
print(model)

#4
train_control2 <- trainControl(method="CV", number=10)
model2 <- train(count~season+holiday+workingday+weather+atemp+registered, data=Bike, trControl=train_control2, method="lm")
print(model2)

#5
lm.cv <- bestglm(Q2, IC = "CV")
lm.cv

#6
library(MASS)
Q6 <- lm(count~season+holiday+workingday+weather+atemp+registered, data=Bike)
lm.bwd <- stepAIC(Q6, direction="backward")
lm.bwd
