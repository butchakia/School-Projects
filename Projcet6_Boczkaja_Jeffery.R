kc_house_data <- read.csv("C:/Users/whitl/OneDrive/Desktop/R Files/kc_house_data.csv")
View(kc_house_data)

lm.result <- lm(price~bedrooms+bathrooms+sqft_living, data=kc_house_data)
summary(lm.result)
summary(lm.result)$adj.r.squared
summary(lm.result)$r.squared

lm.result2 <- lm(price~bedrooms*bathrooms*sqft_living, data=kc_house_data)
summary(lm.result2)
summary(lm.result2)$adj.r.squared
summary(lm.result2)$r.squared

lm.result3 <- lm(price~bedrooms+I(bathrooms+sqft_living)+I(waterfront+grade), data=kc_house_data)
summary(lm.result3)
summary(lm.result3)$adj.r.squared
summary(lm.result3)$r.squared

lm.result4 <- lm(price ~ .-1-id-date-zipcode-lat-long, data=kc_house_data)
summary(lm.result6)$adj.r.squared

lm.result5 <- lm(price ~ bedrooms+bathrooms+sqft_living+sqft_lot+floors+waterfront+view+condition+grade, data=kc_house_data)
new.home <- data.frame(bedrooms=4, bathrooms=2, sqft_living=2560, sqft_lot=7650, floors=1.5, waterfront=1, view=3, condition=5, grade=10)
predict(lm.result7, newdata=new.home)
predict(lm.result7, newdata=new.home, interval = "predict")

