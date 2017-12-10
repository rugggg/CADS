library(neuralnet)
# load data

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
n <- names(train)
f <- as.formula(paste("delay ~", paste(n[!n %in% "price"], collapse = " + ")))
f
nn <- neuralnet(f, data=train, hidden=c(3), linear.output=T)

predictions.train = compute(nn,train[,2:12])

