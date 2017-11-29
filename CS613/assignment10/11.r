library(MASS)
library(glmnet)
set.seed(4221)

test = sample(1:dim(Boston)[1], dim(Boston)[1]/3)
train = -test
Boston.train = Boston[train,]
Boston.test = Boston[test,]

x = model.matrix(crim ~ . - 1, data = Boston)
y = Boston$crim
cv.lasso = cv.glmnet(x, y, type.measure = "mse")
plot(cv.lasso)

cv.ridge = cv.glmnet(x, y, type.measure = "mse", alpha=0)
plot(cv.ridge)

