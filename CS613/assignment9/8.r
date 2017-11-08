library(leaps)

set.seed(4)
x = rnorm(100)
eps = rnorm(100)
b0 = 2
b1 = -1
b2 = 4
b3 = 1.5

y = b0 + b1*x+b2*x^2+b3*x^3+err

data.full = data.frame(y=y, x=x)
regsubs = regsubsets(y ~ poly(x, 10, raw = T), data = data.full, nvmax = 10)
reg.summary = summary(regsubs)

which.min(reg.summary$cp)
which.min(reg.summary$bic)
which.min(reg.summary$adjr2)

par(mfrow=c(2,2))
plot(reg.summary$cp, xlab = "Subset Size", ylab = "Cp", pch = 20, type = "l")
points(3, reg.summary$cp[3], pch = 4, col = "red", lwd = 7)

plot(reg.summary$bic, xlab = "Subset Size", ylab = "BIC", pch = 20, type = "l")
points(3, reg.summary$bic[3], pch = 4, col = "red", lwd = 7)

plot(reg.summary$adjr2, xlab = "Subset Size", ylab = "Adjusted R2", pch = 20, type = "l")
points(3, reg.summary$adjr2[3], pch = 4, col = "red", lwd = 7)

coefficients(regsubs, id = 3)


mod.fwd = regsubsets(y ~ poly(x, 10, raw = T), data = data.full, nvmax = 10, method = "forward")
mod.bwd = regsubsets(y ~ poly(x, 10, raw = T), data = data.full, nvmax = 10, method = "backward")
fwd.summary = summary(mod.fwd)
bwd.summary = summary(mod.bwd)
which.min(fwd.summary$cp)
which.min(bwd.summary$cp)
which.min(fwd.summary$bic)
which.min(bwd.summary$bic)
which.max(fwd.summary$adjr2)
which.max(bwd.summary$adjr2)
