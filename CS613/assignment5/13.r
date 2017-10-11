set.seed(1)
x=rnorm(100)
eps = rnorm(100,mean=0,sd=sqrt(0.25))
y=-1+0.5*x+eps
length(y)

fit = lm(y~x)
summary(fit)

fit2 = lm(y~x+I(x^2))
summary(fit2)

plot(x,y)
abline(fit, col="orange")
abline(-1,0.5, col="blue")
legend("topleft", c("LeastSquares", "Regression"),col=c("orange","blue"),lty=c(1,1))

x2=rnorm(100)
eps2 = rnorm(100,mean=0,sd=sqrt(0.125))
y2=-1+0.5*x2+eps2
length(y2)

fit3 = lm(y2~x2)
summary(fit3)

plot(x2,y2)
abline(fit, col="orange")
abline(-1,0.5, col="blue")
legend("topleft", c("LeastSquares", "Regression"),col=c("orange","blue"),lty=c(1,1))

x3=rnorm(100)
eps3 = rnorm(100,mean=0,sd=sqrt(0.75))
y3=-1+0.5*x3+eps3
length(y3)

fit4 = lm(y3~x3)
summary(fit4)

plot(x3,y3)
abline(fit4, col="orange")
abline(-1,0.5, col="blue")
legend("topleft", c("LeastSquares", "Regression"),col=c("orange","blue"),lty=c(1,1))

confint(fit)
confint(fit3)
confint(fit4)
