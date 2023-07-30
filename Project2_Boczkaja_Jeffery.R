#0
library(readxl)
mtcars <- read_excel("C:/Users/whitl/OneDrive/Desktop/R Files/mtcars.xlsx")
View(mtcars)

#1
p1 <- lm(mpg~hp, data=mtcars)

#2
summary(p1)

#5
predict(p1, data.frame(hp =c(100)), interval ="confidence")

#6
plot(mtcars$hp, mtcars$mpg)
abline(p1, lwd=2, col="blue")

#7
p2 <- lm(mpg~cyl+disp+hp+wt+vs+gear, data=mtcars)
summary(p2)

#10
p3 <- lm(mpg~hp*wt, data=mtcars)
summary(p3)

