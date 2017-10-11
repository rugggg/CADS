set.seed(1)
x=rnorm(100)
y=2*x+rnorm(100)

fit = lm(y~0+x)
summary(fit)

fitinv = lm(x~0+y)
summary(fitinv)

n = length(x)
t = sqrt(n-1)*(x%*%y)/sqrt(sum(x^2)*sum(y^2)-(x%*%y)^2)
as.numeric(t)

fitint = lm(y~x)
summary(fitint)

fitinvint = lm(x~y)
summary(fitinvint)

