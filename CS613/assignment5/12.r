set.seed(1)
x=1:100
y=2*x*rnorm(100)

fit = lm(y~0+x)
summary(fit)

fitinv = lm(x~0+y)
summary(fitinv)
x=1:100
y=1:100

fit = lm(y~0+x)
summary(fit)

fitinv = lm(x~0+y)
summary(fitinv)



