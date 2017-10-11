library(MASS)
attach(Boston)
head(Boston)
head(Boston[,-1])
fit = lm(as.matrix(Boston[,-1])~Boston[,1])
summary(fit)

k = apply(Boston[,-1],2,function(x)summary(lm(Boston[,1]~x)))

fitMulti = lm(crim ~ ., data = Boston)
summary(fitMulti)
