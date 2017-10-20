library(MASS)

set.seed(234)

GRE = as.data.frame(round(mvrnorm(200,mu=c(145,152),Sigma=matrix(c(100, 50, 50, 100), ncol=2))))
names(GRE)=c("Verbal", "Quantitative")

head(GRE)

#sample variance covariance matrix
S=var(GRE)

#get eigenvalues and vectors
eigen = eigen(S)
lambda1 = eigen$value[1]
lambda2 = eigen$value[2]
e1 = eigen$vectors[,1]
e2 = eigen$vectors[,2]

# plot focused on xbar
xbar = colMeans(GRE)
xbar
plot(xbar[1], xbar[2], type="n",xlim=c(xbar[1]-5, xbar[1]+5), ylim=c(xbar[2]-5, xbar[2]+5), xlab="Verbal", ylab="Quantitative")

# set n and p
p=2
n=200

# how far along each eigenvector the elipsis reaches
laxis1 = sqrt(lambda1*p*(n-1)/(n*(n-p))*qf(0.95,p,n-p))
laxis2 = sqrt(lambda2*p*(n-1)/(n*(n-p))*qf(0.95,p,n-p))

# build the ellipsis
t = seq(0, 2*pi, 0.001)
x = rep(0,length(t))
y = rep(0,length(t))

for(i in 1:length(t)){
        # going around the ellipsis
        # multiply by eign vectors tilt
    x[i] = xbar[1]+(eigen$vectors%*%c(laxis1*cos(t[i]), laxis2*sin(t[i])))[1] 
    y[i] = xbar[2]+(eigen$vectors%*%c(laxis1*cos(t[i]), laxis2*sin(t[i])))[2] 
}
points(x,y,type="l")


# t2 simultaneous CIs

tl1 = xbar[1] - sqrt(p*(n-1)/(n*(n-p))*qf(0.95,p,n-p)*S[1,1])
tr1 = xbar[1] + sqrt(p*(n-1)/(n*(n-p))*qf(0.95,p,n-p)*S[1,1])

                     
tl2 = xbar[2] - sqrt(p*(n-1)/(n*(n-p))*qf(0.95,p,n-p)*S[2,2])
tr2 = xbar[2] + sqrt(p*(n-1)/(n*(n-p))*qf(0.95,p,n-p)*S[2,2])


abline(v=tl1, lty=2)
abline(v=tr1, lty=2)

abline(h=tl2, lty=2)
abline(h=tr2, lty=2)


# bonferroni

bl1 = xbar[1] - qt(1-0.05/4, n-1)*sqrt(S[1,1]/n)
br1 = xbar[1] + qt(1-0.05/4, n-1)*sqrt(S[1,1]/n)

bl2 = xbar[2] - qt(1-0.05/4, n-1)*sqrt(S[1,1]/n)
br2 = xbar[2] + qt(1-0.05/4, n-1)*sqrt(S[1,1]/n)



abline(v=bl1, lty=2)
abline(v=br1, lty=2)

abline(h=bl2, lty=2)
abline(h=br2, lty=2)


