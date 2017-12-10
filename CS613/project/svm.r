library(e1071)
set.seed(40)
# load data
data = read.csv("FlightPerformance.csv")

clean = data[,c("carrier","dest", "origin", "schedtime", "weather", "distance","delay")]

# let's get a baseline of how many flights are delayes
mean(clean$delay == "ontime")
# replace categorical w/dummy variables
clean$carrier = as.numeric(data$carrier)
clean$dest = as.numeric(data$dest)
clean$origin = as.numeric(data$origin)

# normalize all predictor variables
maxs <- apply(clean[-ncol(clean)], 2, max)
mins <- apply(clean[-ncol(clean)], 2, min)
clean.data = as.data.frame(scale(clean[-ncol(clean)], center = mins, scale=maxs-mins))
# add delay to our scaled data
clean.data["delay"]  <- clean[,"delay"]

# test/train split
trainIdx <- sample(seq(1, nrow(clean.data)), floor(nrow(clean.data) * 0.70))
train <- clean.data[trainIdx,]
test <- clean.data[-trainIdx,]

# model fitting

# Linear SVM

# svmfit = svm(delay~., data=train, kernel="linear", cost=100, scale=FALSE)

# use tune to cross validate and get the best cost param
# tune.out = tune(svm, delay~., data=train, kernel="linear", scale=FALSE, ranges=list(cost=c(0.001, 0.01, 0.1, 1, 5, 10, 100)))

# summary(tune.out)

# ok - all of 0.1, 1, 5, 10, 100 have same error.
# use 0.1
svmfit = svm(delay~., data=train, kernel="linear", cost=0.1, scale=FALSE)

#summary(svmfit)
pred = predict(svmfit, test)
table(predict = pred, truth=test$delay)
mean(pred == test$delay)

# try polynomial kernel
#svmfit.poly = svm(delay~., data=train, kernel="polynomial", cost=0.1,, scale=FALSE)
# use tune to cross validate and get the best cost param and gamma param
#tune.out.poly = tune(svm, delay~., data=train, kernel="polynomial", scale=FALSE, ranges=list(cost=c(0.001, 0.01, 0.1, 1, 5, 10, 100)))

#summary(tune.out.poly)

# 1 is the best cost param

svmfit.poly = svm(delay~., data=train, kernel="polynomial", cost=1, scale=FALSE)

#summary(svmfit.poly)
pred.poly = predict(svmfit.poly, test)
table(predict = pred.poly, truth=test$delay)
mean(pred.poly == test$delay)

# try polynomial kernel
#svmfit.poly = svm(delay~., data=train, kernel="polynomial", cost=0.1,, scale=FALSE)
# use tune to cross validate and get the best cost param and gamma param
#tune.out.poly = tune(svm, delay~., data=train, kernel="polynomial", scale=FALSE, ranges=list(cost=c(0.001, 0.01, 0.1, 1, 5, 10, 100)))

#summary(tune.out.poly)

# 1 is the best cost param

#svmfit.poly = svm(delay~., data=train, kernel="radial", cost=1, gamma=, scale=FALSE)
tune.out.radial = tune(svm, delay~., data=train, kernel="radial", scale=FALSE,
                       ranges=list(cost=c(0.001, 0.01, 0.1, 1, 5, 10, 100),
                       gamma=c(0.5,1,2,3,4))
                       )

summary(tune.out.radial)
#pred.radial = predict(svmfit.radial, test)
#table(predict = pred.radial, truth=test$delay)
#mean(pred.radial == test$delay)
