d=read.table("T5-1.DAT")
names(d)=c("Sweat Rate", "Sodium", "Potassium")
head(d)

# Hypothesis
# 
#
# H0 : | mu =  (4 )
#      |       (50) = mu0
#      |       (10)
#
#
# Ha : | mu != ""  , alpha = 0.05
#

muo = c(4,50,10)
xbar=colMeans(d)
xbar

S = var(d)
S

n = dim(d)[1]

T2=n*t(xbar-muo)%*%solve(S)%*%(xbar-muo)
T2

p=3

# do we reject H0?
(n-1)*p/(n-p)*qf(0.95,p,n-p)

#don't reject H0, as 9.73 < 10.7
