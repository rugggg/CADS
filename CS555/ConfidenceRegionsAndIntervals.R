
# GRE scores

# Simulation

library(MASS)
set.seed(24)
GRE=round(mvrnorm(200, mu = c(147.25,152.25), Sigma = matrix(c(5.25^2,0.42*5.25*5.5,0.42*5.25*5.5,5.5^2),ncol=2)))
names(GRE)=c("Quantitative","Verbal")
GRE=data.frame(GRE)

# 95% confidence region (ellipses) for population average Quantitative and Verbal scores
xbar=colMeans(GRE)
S=var(GRE)
lambda1=eigen(S)$values[1]
lambda2=eigen(S)$values[2]
e1=eigen(S)$vectors[,1]
e2=eigen(S)$vectors[,2]


plot(xbar[1],xbar[2],type="n",xlim=c(xbar[1]-2,xbar[1]+2),ylim=c(xbar[2]-2,xbar[2]+2),
     xlab="Quantitative",ylab="Verbal")
arrows(xbar[1],xbar[2],xbar[1]+e1[1],xbar[2]+e1[2])
arrows(xbar[1],xbar[2],xbar[1]+e2[1],xbar[2]+e2[2])
p=2 
n=200
laxis1=sqrt(lambda1*p*(n-1)*qf(0.95,p,n-p)/(n*(n-p)))
laxis2=sqrt(lambda2*p*(n-1)*qf(0.95,p,n-p)/(n*(n-p)))


t=seq(0,2*pi,0.001)
x=rep(0,length(t))
y=rep(0,length(t))
for (i in 1:length(t)){
  x[i]=xbar[1]+(eigen(S)$vectors%*%c(laxis1*cos(t[i]),laxis2*sin(t[i])))[1]
  y[i]=xbar[2]+(eigen(S)$vectors%*%c(laxis1*cos(t[i]),laxis2*sin(t[i])))[2]
}
points(x,y,type="l")


# 95% simulteneous T^2 confidence intervals

tl1=xbar[1]-sqrt(p*(n-1)*qf(0.95,p,n-p)*S[1,1]/(n*(n-p)))
tr1=xbar[1]+sqrt(p*(n-1)*qf(0.95,p,n-p)*S[1,1]/(n*(n-p)))

tl2=xbar[2]-sqrt(p*(n-1)*qf(0.95,p,n-p)*S[2,2]/(n*(n-p)))
tr2=xbar[2]+sqrt(p*(n-1)*qf(0.95,p,n-p)*S[2,2]/(n*(n-p)))

abline(v=tl1,lty=2)
abline(v=tr1,lty=2)
abline(h=tl2,lty=2)
abline(h=tr2,lty=2)


# 95% Bonferroni confidence intervals

bl1=xbar[1]-qt(1-0.05/(2*p),n-1)*sqrt(S[1,1]/n)
br1=xbar[1]+qt(1-0.05/(2*p),n-1)*sqrt(S[1,1]/n)

bl2=xbar[2]-qt(1-0.05/(2*p),n-1)*sqrt(S[2,2]/n)
br2=xbar[2]+qt(1-0.05/(2*p),n-1)*sqrt(S[2,2]/n)

abline(v=bl1,lty=3)
abline(v=br1,lty=3)
abline(h=bl2,lty=3)
abline(h=br2,lty=3)


legend(149,154,c("Confidence ellipse","T2 CI","Bonferroni CI"),lty=1:3)









