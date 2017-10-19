library(ISLR)
attach(Auto)
lm.fit = lm(mpg~horsepower)
summary(lm.fit)
coef(lm.fit)
predict(lm.fit,data.frame(horsepower=c(98)), interval="confidence")
predict(lm.fit,data.frame(horsepower=c(98)), interval="prediction")
plot(horsepower, mpg)
abline(lm.fit)
par(mfrow=c(2,2))
plot(lm.fit)