library(ISLR)
library(glmnet)

sink("9.out")
set.seed(4221)
d = College

test = sample(1:dim(College)[1], dim(College)[1]/3)
train = -test
College.train = College[train,]
College.test = College[test,]

lm.fit = lm(Apps~., data=College.train)
lm.pred = predict(lm.fit, College.test)

mean((College.test[, "Apps"] - lm.pred)^2)


x = model.matrix(Apps~., data=College.train)
y = model.matrix(Apps~., data=College.test)
grid = 10 ^ seq(4, -2, length=100)
ridge = cv.glmnet(x, College.train[,"Apps"] ,alpha=0, lambda = grid)
ridge.lambda = ridge$lambda.min

ridge.pred = predict(ridge, newx=x, s=ridge.lambda)
mean((College.test[, "Apps"] - ridge.pred)^2)

lasso = cv.glmnet(x, College.train[,"Apps"] ,alpha=1, lambda = grid)
lasso.lambda = lasso$lambda.min

lasso.pred = predict(ridge, newx=x, s=lasso.lambda)
mean((College.test[, "Apps"] - lasso.pred)^2)


predict(lasso, s=lasso.lambda, type="coefficients")



