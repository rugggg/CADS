library(neuralnet)
set.seed(40)
# load data
data = read.csv("FlightPerformance.csv")

clean = data[,c("carrier", "dest", "origin", "schedtime", "weather", "distance","delay")]
# let's get a baseline of how many flights are delayes
# mean(clean$delay == "ontime")
# replace categorical w/dummy variables
clean$carrier = as.numeric(data$carrier)
clean$dest = as.numeric(data$dest)
clean$origin = as.numeric(data$origin)
clean$delay = as.numeric(data$delay)

# normalize all predictor variables
maxs <- apply(clean, 2, max)
mins <- apply(clean, 2, min)
clean.data = as.data.frame(scale(clean, center = mins, scale=maxs-mins))
# add delay to our scaled data
#clean.data["delay"]  <- clean[,"delay"]

# test/train split
trainIdx <- sample(seq(1, nrow(clean.data)), floor(nrow(clean.data) * 0.70))
train <- clean.data[trainIdx,]
test <- clean.data[-trainIdx,]

# model fitting
n <- names(train)
f <- as.formula(paste("delay ~", paste(n[!n %in% "delay"], collapse = " + ")))
# 3,4, 2 is best layers so far
# 0.822
# 0.815
nn <- neuralnet(f, data=train, hidden=c(2,3,4,2), linear.output=FALSE)

predictions.train = compute(nn,subset(train, select=-c(delay)))
pr.nn <- predictions.train$net.result

# convert variables back to categorical
pr.nn2 = rep("delayed",nrow(train))
pr.nn2[pr.nn>.5]="ontime"

truth.train = rep("delayed",nrow(train))
truth.train[train$delay>.5]="ontime"

# check accuracy
mean(pr.nn2 == truth.train)


predictions.test = compute(nn,subset(test, select=-c(delay)))
pr.test <- predictions.test$net.result

# convert variables back to categorical
pr.test.2 = rep("delayed",nrow(test))
pr.test.2[pr.test>.5]="ontime"

truth.test = rep("delayed",nrow(test))
truth.test[test$delay>.5]="ontime"

# check accuracy
mean(pr.test.2 == truth.test)



