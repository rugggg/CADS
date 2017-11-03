d = read.table("T6-2.dat")
# data is about dogs receiving anethesia drugs, 4 different.
# Each measure is howmuch each drug slowed the dogs heartbeat. 
# So measure is avg time in ms between heartbeats
#t2 = (C*xbar)^T (CSC^T/n)^-1 ~ (((n-1)(q-1))/(n-q+1)) Fq-1, n-q+1)
xbar = colMeans(d)
S=var(d)

# make the C matrix by binding a col of 1 with a diagonal matrix of -1s
C = cbind(rep(1,3), diag(rep(-1,3)))

# set q and n
q = dim(d)[2]
n = dim(d)[1]

T2 = t(C%*%xbar)%*%solve(C%*%S%*%t(C)/n)%*%(C%*%xbar)

(n-1)*(q-1)/(n-q+1)*qf(0.95,q-1,n-q+1)

# ok - so we can reject this H0 one

#but what is cause? Well, lets do univariate T tests to find out
t.test(d$V1,d$V2, paired=T)
t.test(d$V1,d$V3, paired=T)
t.test(d$V1,d$V4, paired=T)

t.test(d$V2,d$V3, paired=T)
t.test(d$V2,d$V4, paired=T)

t.test(d$V3,d$V4, paired=T)

# so we find a whole lot of differences
# turns out that drugs 3 and 4 are best, they have laegesw

