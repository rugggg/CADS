library(ISLR)
attach(Carseats)

lm.fit = lm(Sales~Price+Urban+US)
summary(lm.fit)

lm.fit2 = lm(Sales~Price+US)
summary(lm.fit2)

confint(lm.fit2)

par(mfrow = c(2,2))
plot(lm.fit2)
