library(MASS)
library(ROCR)
set.seed(40)
# load data
data = read.csv("FlightPerformance.csv")

clean = data[,c("carrier","dest","origin","schedtime", "weather", "date", "delay")]
# let's get a baseline of how many flights are delayes
mean(clean$delay == "ontime")
# replace categorical w/dummy variables
clean$carrier = as.numeric(data$carrier)
clean$dest = as.numeric(data$dest)
clean$origin = as.numeric(data$origin)
clean$date = as.numeric(data$date)

# normalize all predictor variables
maxs <- apply(clean[,-ncol(clean)], 2, max)
mins <- apply(clean[,-ncol(clean)], 2, min)
clean.data = as.data.frame(scale(clean[,-ncol(clean)], center = mins, scale=maxs-mins))
# add delay to our scaled data
clean.data["delay"]  <- clean[,"delay"]

# test/train split
trainIdx <- sample(seq(1, nrow(clean.data)), floor(nrow(clean.data) * 0.70))
train <- clean.data[trainIdx,]
test <- clean.data[-trainIdx,]

# model fitting
lda.fit = lda(delay ~ ., data=clean.data, subset=(1:length(trainIdx)))
lda.fit
# training validation
lda.pred = predict(lda.fit, train)
lda.class = lda.pred$class

table(lda.class, train$delay)
mean(lda.class == train$delay)

# test validation
lda.pred.test = predict(lda.fit, test, decision.values=TRUE)
lda.class.test = lda.pred.test$class

table(lda.class.test, test$delay)
mean(lda.class.test == test$delay)

# ROC Curve
pred <- prediction(lda.pred.test$posterior[,2], test$delay) 
perf <- performance(pred,"tpr","fpr")
png(file="lda_roc.png")
plot(perf, avg="threshold", colorize=T, lwd=3, main="LDA ROC")
dev.off()
