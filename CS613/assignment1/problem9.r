library(ISLR)
Auto = na.omit(Auto)
summary(Auto)

sapply(Auto[1:6], range) 

sapply(Auto[1:6], var)
sapply(Auto[1:6], sd)


Auto = Auto[-(10:85),]

sapply(Auto[1:6], range) 
sapply(Auto[1:6], var)
sapply(Auto[1:6], sd)

pairs(Auto)
par(mfrow=c(2,2))
attach(Auto)
plot(weight, mpg, main="Weight to MPG")
lines(lowess(weight,mpg), col="blue") # lowess line (x,y)

plot(cylinders, mpg, main="Cylinders to MPG")
lines(lowess(cylinders, mpg), col="blue") # lowess line (x,y)

plot(horsepower,acceleration, main="Horsepower to Acceleration")
lines(lowess(horsepower, acceleration), col="blue") # lowess line (x,y)

plot(origin, mpg, main="Origin & MPG")
lines(lowess(origin, mpg), col="green") # lowess line (x,y)

