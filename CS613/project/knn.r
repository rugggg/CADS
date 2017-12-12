library(class)
library(ROCR)
set.seed(40)
# load data
data = read.csv("FlightPerformance.csv")

delayed = data[,"delay"]

clean = data[,c("carrier","dest","origin","schedtime", "weather", "date")]
# replace categorical w/dummy variables
clean$carrier = as.numeric(data$carrier)
clean$dest = as.numeric(data$dest)
clean$origin = as.numeric(data$origin)
clean$date = as.numeric(data$date)

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
accuracy <- 0
for (kval in 1:50){
    knn.pred=knn(train.X, test.X, train.Y, k=kval)
    accuracy[kval] <- mean(test.Y == knn.pred)
}
png(file="knn_k.png")
plot(accuracy, type="l")
dev.off()
which.max(accuracy)

knn.pred=knn(train.X, test.X, train.Y, k=which.max(accuracy), prob=TRUE)
table(knn.pred, test.Y)
max(accuracy)

prob <- attr(knn.pred, "prob")
#ROC curve
pred_knn <- prediction(prob, as.numeric(test.Y))
prob_knn <- performance(pred_knn, "tpr", "fpr")
png(file="knn_roc.png")
plot(prob_knn, avg="threshold", colorize=T, lwd=3, main="KNN ROC")
dev.off()
