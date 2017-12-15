d = read.table("T6-8.dat")
#header = c("WordDiff", "WordSame", "ArabicDiff", "ArabicSame")
#names(d)  <-  header
sink("problem6.out")
xbar = colMeans(d)
S=var(d)


C = cbind(rep(1,3), diag(rep(-1,3)))

q = dim(d)[2]
n = dim(d)[1]

T2 = t(C%*%xbar)%*%solve(C%*%S%*%t(C)/n)%*%(C%*%xbar)


# alpha = 0.05  
mes = (n-1)*(q-1)/(n-q+1)*qf(0.95,q-1,n-q+1)
# reject H0

if (T2>mes) cat("Reject Ho \n") else ("Fail to reject Ho \n")
# univariate T tests for treatment effects
#but what is cause? Well, lets do univariate T tests to find out
t.test(d$V1,d$V2, paired=T)
t.test(d$V1,d$V3, paired=T)
t.test(d$V1,d$V4, paired=T)
t.test(d$V2,d$V3, paired=T)
t.test(d$V2,d$V4, paired=T)
t.test(d$V3,d$V4, paired=T)

contrast.of.subject  <- function(x){
    c1 = (x[3]+x[4]) - (x[1] + x[2])
    c2 = (x[1]+x[3]) - (x[2] + x[4])
    c3 = (x[1]+x[4]) - (x[2] + x[3])
    return(c(c1,c2,c3))
}

contrast.m <-  apply(d,1,contrast.of.subject)
contrast.tm = t(contrast.m)
contrast.tm


print("We can say that yes a multivariate normal distribution is a reasonable model for this data because the resulting data comes from a linear transformation of another multivariate normal distributed data.")
sink()
