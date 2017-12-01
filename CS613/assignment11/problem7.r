library(ISLR)
library(e1071)
sink("11.out")
set.seed(32)
mpgMedian = median(Auto$mpg)
dummy = ifelse(Auto$mpg > mpgMedian, 1,0)
Auto$mpglevel = as.factor(dummy)
costs = list(cost = c(0.01, 0.1, 1, 5, 10, 100))
gone = tune(svm, mpglevel ~ ., data = Auto, kernel = "linear", ranges = costs)
summary(gone)

costs = list(cost = c(0.01, 3, 15, 20))
dgr = c(2,3,4)

gone2 = tune(svm, mpglevel ~ ., data = Auto, kernel = "linear", ranges = costs, degree = dgr)

summary(gone2)

costs = list(cost = c(0.01, 0.1, 1, 5, 10, 100))
gone = tune(svm, mpglevel ~ ., data = Auto, kernel = "linear", ranges = costs)
summary(gone)

svm.linear = svm(mpglevel ~ ., data = Auto, kernel = "linear", cost = 1)
svm.poly = svm(mpglevel ~ ., data = Auto, kernel = "polynomial", cost = 10, 
    degree = 2)
svm.radial = svm(mpglevel ~ ., data = Auto, kernel = "radial", cost = 10, gamma = 0.01)
plotpairs = function(fit) {
    for (name in names(Auto)[!(names(Auto) %in% c("mpg", "mpglevel", "name"))]) {
        plot(fit, Auto, as.formula(paste("mpg~", name, sep = "")))
    }
}
plotpairs(svm.linear)
