library(ISLR)
library(MASS)
attach(Auto)

mpg01 <- rep(0, length(mpg))
mpg01[mpg > median(mpg)] <- 1
Auto <- data.frame(Auto, mpg01)

cor(Auto[, -9])
pairs(Auto)
boxplot(cylinders~mpg01, data=Auto, main="Cylinders vs mpg01")

train <- (year %% 2 == 0)
Auto.train <- Auto[train, ]
Auto.test <- Auto[!train, ]
mpg01.test <- mpg01[!train]

fit.lda <- lda(mpg01 ~ cylinders + weight + displacement + horsepower, data = Auto, subset = train)
fit.lda

pred.lda <- predict(fit.lda, Auto.test)
table(pred.lda$class, mpg01.test)
mean(pred.lda$class != mpg01.test)

fit.qda <- qda(mpg01 ~ cylinders + weight + displacement + horsepower, data = Auto, subset = train)
fit.qda

pred.qda <- predict(fit.qda, Auto.test)
table(pred.qda$class, mpg01.test)
mean(pred.qda$class != mpg01.test)

