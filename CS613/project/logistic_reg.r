library(ISLR)
set.seed(40)
# load data
data = read.csv("FlightPerformance.csv")


clean = data[,c("carrier","dest","origin","schedtime", "weather", "dayweek", "distance","daymonth","delay")]


# replace categorical w/dummy variables
clean$carrier = as.numeric(data$carrier)
clean$dest = as.numeric(data$dest)
clean$origin = as.numeric(data$origin)
clean$delay = as.numeric(data$delay)

# normalize all variables
maxs <- apply(clean, 2, max)
mins <- apply(clean, 2, min)
clean.data = scale(clean, center = mins, scale=maxs-mins)

# test/train split
trainIdx <- sample(seq(1, nrow(clean.data)), floor(nrow(clean.data) * 0.70))
train <- as.data.frame(clean.data[trainIdx,])
test <- as.data.frame(clean.data[-trainIdx,])

glm.fits = glm(delay ~ ., family=binomial, data=train)
summary(glm.fits)

#plot(errors, type="l")
#which.min(errors)

#knn.pred=knn(train.X, test.X, train.Y, k=which.min(errors))
#table(knn.pred, test.Y)
#min(errors)

