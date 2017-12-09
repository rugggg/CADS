library(ISLR)
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
glm.fits = glm(delay ~ ., family=binomial, data=clean.data, subset=(1:length(trainIdx)))

# training validation
glm.probs.train = predict(glm.fits, train ,type="response")
glm.preds.train = rep("delayed",nrow(train))
glm.preds.train[glm.probs.train>.5]="ontime"

table(glm.preds.train,train$delay)
mean(glm.preds.train == train$delay)

# testing validation
glm.probs.test = predict(glm.fits, test, type="response")
glm.preds.test = rep("delayed",nrow(test))
glm.preds.test[glm.probs.test>.5]="ontime"

table(glm.preds.test,test$delay)
mean(glm.preds.test == test$delay)





