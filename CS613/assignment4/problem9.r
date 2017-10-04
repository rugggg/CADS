library(ISLR)
pairs(Auto)
attach(Auto)
subAuto = subset(Auto, select=-name)
detach(Auto)
cor(subAuto)
attach(subAuto)
lm.fit = lm(mpg~.,data=subAuto)
summary(lm.fit)
coefficients(lm.fit)["year"]
par(mfrow=c(2,2))
plot(lm.fit)
lm.fitI = lm(mpg~cylinders*displacement+displacement*weight)
summary(lm.fitI)

lm.fit2 = lm(mpg~cylinders+displacement+weight+acceleration+year+origin+horsepower+I(horsepower^2))
summary(lm.fit2)
plot(lm.fit2)
anova(lm.fit2, lm.fit)

lm.fit3 = lm(mpg~cylinders+displacement+weight+acceleration+log(acceleration)+year+origin+horsepower)
summary(lm.fit3)
plot(lm.fit3)
anova(lm.fit, lm.fit3)




