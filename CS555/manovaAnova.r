library(MVN)

summary(iris)
# 50 observations, 4 dimensions, 3 plants
# are the average sepal lengths, widths, petal length, and petal widths different
# for different plants?
# Unlikely, lets find out

# H0 : mu1 = mu2 = mu3
# Ha : mui != muj

# where mus are the (avg sepal length, avg sepal width, avg petal length, avg petal width) for each type of plant


# first calculate wilkes lambda

xbar = colMeans(iris[,1:4])
# ok not the best, but works for now
x1bar = colMeans(iris[1:50,1:4])
x2bar = colMeans(iris[51:100,1:4])
x3bar = colMeans(iris[101:150,1:4])

xibars = c(x1bar, x2bar, x3bar)
p = 4
W = matrix(0,p,p)
for (i in 1:50){W=W+(unlist(iris[i,1:4])-x1bar)%*%t(unlist(iris[i,1:4])-x1bar)}
for (i in 51:100){W=W+(unlist(iris[i,1:4])-x2bar)%*%t(unlist(iris[i,1:4])-x2bar)}
for (i in 101:150){W=W+(unlist(iris[i,1:4])-x3bar)%*%t(unlist(iris[i,1:4])-x3bar)}
BplusW = matrix(0,p,p)
for (i in 1:150){BplusW=BplusW+(unlist(iris[i,1:4])-xbar)%*%t(unlist(iris[i,1:4])-xbar)}

WilksLambda = det(W)/det(BplusW)

BplusW = matrix(0,p,p)
(150-4-2)/4*((1-sqrt(WilksLambda))/sqrt(WilksLambda))

qf(0.95, 8, 2*144)

aov(iris$Sepal.Length~iris$Species)
summary(aov(iris$Sepal.Length~iris$Species))

