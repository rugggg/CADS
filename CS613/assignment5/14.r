set.seed(1)
x1=runif(100)
x2=0.5*x1+rnorm(100)/10
y=2+2*x1+0.3*x2+rnorm(100)
cor(x1,x2)
plot(x1,x2)

fit = lm(y~x1+x2)
summary(fit)
fit2 = lm(y~x1)
summary(fit2)
fit3 = lm(y~x2)
summary(fit3)

