library(MVN)

d=read.table("T6-1.dat")
head(d)
dim(d)
names(d)=c("bod1", "ss1", "bod2", "ss2")
d

# bc we are two dimensional case, we are 

D = d[,3:4]-d[,1:2]
names(D) = c("D1","D2")
D.bar = colMeans(D)
S = var(D)
D.bar
S

p=2
n=11

T2= n*t(D.bar)%*%solve(S)%*%D.bar
T2

rejectionThreshold = p*(n-1)/(n-p)*qf(0.95,p,n-p)

rejectionThreshold

#the T2 is greater than our threshold, so reject H0

#now we can do a component by component t-test for both pair sets
t.test(d$bod2, d$bod1, paired=TRUE)
t.test(d$ss2, d$ss1, paired=TRUE)

#we find that the two vectors are different, but component by component says they are not

#how to explain?

#we never tested for normality, so that could be the issue
roystonTest(D)
# yup - that is it
# so maybe transform data to be multivariate normal?

# try a power transform, add 100 to make all postive and then log
D2 = cbind(log(D[,1]+100),log(D[,2]+100))
roystonTest(D2)
#well that actually made it worse...so I guess cant do much here
