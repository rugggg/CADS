library(goftest)
library(MASS)
library(nortest)
library(MVN)

sink("quiz1.txt")

dat=read.table("T4-6.DAT")
names(dat)=c("Indepdendence","Support","Benevolence", "Conformity", "Leadership")
d = dat[,3:4]
# univariate tests
apply(d, 2, shapiro.test)
apply(d, 2, cvm.test)

print("MULTIVARIATE TESTS")
# multivariate tests

par(mfrow=c(2,2))
hzTest(d)
roystonTest(d,qqplot=T)
mvOutlier(d,method="quan",label=TRUE)

n = 130
p = 2
mu = c(17, 22)
xbar = colMeans(d)
S = var(d)

#xbar

#t test
t.test(d[,1],mu=mu[1])
t.test(d[,2],mu=mu[2])

T2 = n*t(xbar-mu)%*%solve(S)%*%(xbar-mu)
T2

# should we reject or accept H0?
# need to compare to our rejection region
rejRegion = (n-1)*p/(n-p)*qf(0.95,p,n-p)
rejRegion

eigen = eigen(S)
lambda1 = eigen$value[1]
lambda2 = eigen$value[2]
e1 = eigen$vectors[,1]
e2 = eigen$vectors[,2]


# bonferroni

bl1 = xbar[1] - qt(1-0.01/4, n-1)*sqrt(S[1,1]/n)
br1 = xbar[1] + qt(1-0.01/4, n-1)*sqrt(S[1,1]/n)


bl2 = xbar[2] - qt(1-0.01/4, n-1)*sqrt(S[1,1]/n)
br2 = xbar[2] + qt(1-0.01/4, n-1)*sqrt(S[1,1]/n)
bl1
br1
bl2
br2



sink()
