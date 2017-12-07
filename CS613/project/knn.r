library(class)
set.seed(40)
# load data
data = read.csv("FlightPerformance.csv")

delayed = data[,"delay"]

clean = data[,c("carrier","dest","origin","schedtime", "weather", "dayweek", "distance","daymonth")]


# replace categorical w/dummy variables
clean$carrier = as.numeric(data$carrier)
clean$dest = as.numeric(data$dest)
clean$origin = as.numeric(data$origin)

# normalize all variables
clean.data = scale(clean)

# test/train split
trainIdx <- sample(seq(1, nrow(clean.data)), floor(nrow(clean.data) * 0.70))
train.X <- clean.data[trainIdx,]
test.X <- clean.data[-trainIdx,]
train.Y <- delayed[trainIdx]
test.Y <- delayed[-trainIdx]

# iterate over a number of values of K to get optimal
# we could use gradient descent here if we wanted to get
# tricky
errors <- 0
for (kval in 1:50){
    knn.pred=knn(train.X, test.X, train.Y, k=kval)
    errors[kval] <- mean(test.Y != knn.pred)
}
plot(errors, type="l")
which.min(errors)

knn.pred=knn(train.X, test.X, train.Y, k=which.min(errors))
table(knn.pred, test.Y)
min(errors)

