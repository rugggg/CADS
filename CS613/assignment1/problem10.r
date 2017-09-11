library(MASS)

?Boston
attach(Boston)

par(mfrow=c(3,3))
plot(dis, medv, main="Distance to Home Values")
plot(rm, medv, main="Rooms to Home Value")
plot(nox, indus, main="NO^2 to Industry")
plot(ptratio, crim, main="P/T v Crime")
plot(ptratio, medv, main="P/T v Home Value")
plot(ptratio, lstat, main="P/T v Lower Class")

pairs(Boston)

plot(crim)
plot(ptratio)
plot(tax)

table(Boston$chas)

summary(Boston$ptratio)

which.min(Boston$medv)
Boston[399,]

beantown <- subset(Boston,rm >= 7)
dim(beantown)
beantown <- subset(Boston,rm >= 8)
dim(beantown)

summary(beantown)
