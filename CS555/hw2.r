library(goftest)
library(nortest)
library(MVN)

sink("hw.txt")

dat=read.table("T4-6.DAT")
names(dat)=c("Indepdendence","Support","Benevolence", "Conformity", "Leadership")
d = dat[,1:5]
# univariate tests
#apply(d, 2, qqnorm)
apply(d, 2, shapiro.test)
apply(d, 2, ks.test, "pnorm")
apply(d, 2, ad.test)
apply(d, 2, cvm.test)
apply(d, 2, pearson.test)

print("MULTIVARIATE TESTS")
# multivariate tests

par(mfrow=c(2,2))
hzTest(d)
mardiaTest(d,qqplot=T)
roystonTest(d,qqplot=T)
dim(d)
mvOutlier(d,method="quan",label=TRUE)

sink()
