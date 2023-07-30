#1
library(readxl)
Boston <- read.csv("C:/Users/whitl/OneDrive/Desktop/R Files/Bostonnew.csv")
View(Boston)

#2
dim(Boston)

#3
Boston[c(1,100,500), c("tax", "medv")]

#4
cor(Boston$crim, Boston$zn)
cor(Boston$crim, Boston$indus)
cor(Boston$crim, Boston$chas)
cor(Boston$crim, Boston$nox)
cor(Boston$crim, Boston$rm)
cor(Boston$crim, Boston$age)
cor(Boston$crim, Boston$dis)
cor(Boston$crim, Boston$rad)
cor(Boston$crim, Boston$tax)
cor(Boston$crim, Boston$ptratio)
cor(Boston$crim, Boston$lstat)
cor(Boston$crim, Boston$medv)

#5
pairs(~crim + rad + tax, data = Boston)
pairs(~crim + tax + indus, data = Boston)
pairs(~tax + indus + lstat, data = Boston)

#6
hist(Boston$crim, col = "blue")
range(Boston$crim)

#7
length(which(Boston$chas==1))
length(which(Boston$chas==0))

#8
median(Boston$ptratio)
mean(Boston$ptratio)

#9
length(which(Boston$rm>7))
length(which(Boston$rm>8))
summary(Boston[Boston$rm > 8,])
summary(Boston)

#10
Boston$chas <- as.factor(Boston$chas)
boxplot(Boston$chas, Boston$medv, xlab = "Charles River", ylab = "Median Value")


        