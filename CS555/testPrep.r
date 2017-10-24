d = read.table("T1-8.DAT")

head(d)
dim(d)
# 6 observations on 25 people
n = 25
p = 6
mu = c(0.9, 0.9, 2, 2, 0.8, 0.8)
xbar = colMeans(d)
S = var(d)

T2 = n*t(xbar-mu)%*%solve(S)%*%(xbar-mu)
T2

# should we reject or accept H0?
# need to compare to our rejection region
rejRegion = (n-1)*p/(n-p)*qf(0.95,p,n-p)
rejRegion

# we fall in the rejection region as 41.97 > 19.91, so 
# we say that at least one of our means is misspecified.

# so we can then dig deeper that this global test to figure
# out which of mu is wrong.

