#1
library(readxl)
day <- read.csv("C:/Users/whitl/OneDrive/Desktop/R Files/day.csv")
View(day)

#2.A
day$season[day$season=="1"]<-"spring"
day$season[day$season=="2"]<-"summer"
day$season[day$season=="3"]<-"fall"
day$season[day$season=="4"]<-"winter"

#2.B
day$weathersit[day$weathersit=="1"]<-"good"
day$weathersit[day$weathersit=="2"]<-"mist"
day$weathersit[day$weathersit=="3"]<-"bad"
day$weathersit[day$weathersit=="4"]<-"severe"

#3
class(day$season)
class(day$holiday)
class(day$workingday)
class(day$weathersit)
class(day$atemp)
class(day$hum)
class(day$windspeed)
class(day$casual)
day$season <- as.factor(day$season)
day$holiday <- as.factor(day$holiday)
day$workingday <- as.factor(day$workingday)
day$weathersit <- as.factor(day$weathersit)
day$casual <- as.factor(day$casual)

#4
min(day$cnt)
max(day$cnt)
mean(day$cnt)
median(day$cnt)
sd(day$cnt)
quantile(day$cnt, probs = c(.25, .5, .75))

#5
min(day$registered)
max(day$registered)
mean(day$registered)
median(day$registered)
sd(day$registered)
quantile(day$registered, probs = c(.25, .5, .75))

#6
cor(day$registered, day$cnt)

#7
table(day$season)

#8
xtabs(~ season + weathersit, data=day)
xtabs.season.weathersit <- xtabs(~ season + weathersit, data=day)
prop.table(xtabs.season.weathersit, margin=1)
prop.table(xtabs.season.weathersit, margin=2)

#9
library(ggplot2)
ggplot(data=day, aes(x=cnt))+ 
  geom_histogram(aes(y=after_stat(density)), colour='yellow', fill='orange')+
  geom_density(alpha=.2, fill="blue")+geom_vline(aes(xintercept=mean(cnt)),
                                                 color="purple", linetype="solid", linewidth=1)

#10
ggplot(data=day, aes(x=registered, y=cnt))+geom_point()+geom_smooth()

#11
ggplot(data=day, aes(x=weathersit, y=after_stat(..count..))) + geom_bar(aes(fill = season), position = "dodge")

#12
ggplot(data=day, aes(x=weathersit, y=cnt)) +
  geom_boxplot(aes(col=weathersit), notch=TRUE)
ggsave("C:\\Users\\whitl\\Documents\\cntweather.jpg", width=20, height=15, units="cm")

#13.A
cnt.model1 <- lm(cnt~season+weathersit+atemp+registered, data=day)
summary(cnt.model1)
summary(cnt.model1)$adj.r.squared

#13.C
cnt.model3 <- lm(cnt~season+holiday+workingday+weathersit+atemp+hum+windspeed+registered, data=day)
summary(cnt.model3)
summary(cnt.model3)$adj.r.squared

#15.A
day$holiday <- as.factor(day$holiday)
glm.a <- glm(holiday~cnt+season+registered, family=binomial, data=day)
library(pscl)
pR2(glm.a)
predicted.prob.a <- predict(glm.a, day, type = "response")
threshold <- .5
day$predicted.holiday.a <- ifelse(predicted.prob.a >= threshold, "0","1")
my.accuracy.a <- mean(day$predicted.holiday.a == day$holiday)
message("The accuracy is ", my.accuracy.a)

#15.B
glm.b <- glm(holiday~cnt+season++weathersit+registered, family=binomial, data=day)
pR2(glm.b)
predicted.prob.b <- predict(glm.b, day, type = "response")
threshold <- .5
day$predicted.holiday.b <- ifelse(predicted.prob.b >= threshold, "0","1")
my.accuracy.b <- mean(day$predicted.holiday.b == day$holiday)
message("The accuracy is ", my.accuracy.b)

#15.C
glm.c <- glm(holiday~cnt+season+weathersit+workingday+registered, family=binomial, data=day)
pR2(glm.c)
predicted.prob.c <- predict(glm.c, day, type = "response")
threshold <- .5
day$predicted.holiday.c <- ifelse(predicted.prob.c >= threshold, "0","1")
my.accuracy.c <- mean(day$predicted.holiday.c == day$holiday)
message("The accuracy is ", my.accuracy.c)
