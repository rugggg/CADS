library(goftest)
library(nortest)
library(MVN)

x=rnorm(100)

# qqnorm(x)
#in goftest
ks.test(x,"pnorm")
shapiro.test(x)
#in both goftest and nortest
ad.test(x)
cvm.test(x)
pearson.test(x)

# multivariate
#iris
summary(iris$Species)
#all in mvn
hzTest(setosa)
mardiaTest(setosa[,1:2],qqplot=TRUE)
roystonTest(setosa[,1:2],qqplot=TRUE)
#univariate tests with mvn
uniNorm(setosa[,1], type="CVM")
uniNorm(setosa[,1], type="AD")
#shapiro-francia test(variation of shapiro-wilks)
uniNorm(setosa[,1], type="SF")

mvOutlier(setosa[,1:2],method="quan",label=T)



