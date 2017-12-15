set.seed(40)
library(neuralnet)
data = read.csv("kc_house_data.csv")


# pick out elements we want ot use
df = data[,c("price","bedrooms","bathrooms", "sqft_living","sqft_lot", "floors","waterfront","view","condition","grade","sqft_above","sqft_basement")]
# normalize
maxValue = apply(df, 2, max)
minValue = apply(df, 2, min)
scaled <- as.data.frame(scale(df, center = minValue, scale=maxValue-minValue))
# test train split
train.size <- floor(0.7 * nrow(scaled))
train.index <- sample(sample(seq_len(nrow(scaled)), size = train.size))
train <- scaled[train.index,]
test <- scaled[-train.index,]

n <- names(train)
f <- as.formula(paste("price ~", paste(n[!n %in% "price"], collapse = " + ")))
f
nn <- neuralnet(f, data=train, hidden=c(3,2), linear.output=T)

predictions.train = compute(nn,train[,2:12])

predictions.train  <- predictions.train$net.result * +(max(df$price)-min(df$price)) + min(df$price)
actualValues.train  <-  (train$price)*(max(df$price) - min(df$price)) + min(df$price)
"Train MSE"
(MSE.train = sum((predictions.train - actualValues.train)^2)/nrow(train))

predictions.test = compute(nn,test[,2:12])

predictions.test  <- predictions.test$net.result * +(max(df$price)-min(df$price)) + min(df$price)
actualValues.test  <-  (test$price)*(max(df$price) - min(df$price)) + min(df$price)
"Test MSE"
(MSE.test = sum((predictions.test - actualValues.test)^2)/nrow(test))


#plot(nn)
"Train Correlation"
cor(predictions.train, train$price)
"Test Correlation"
cor(predictions.test, test$price)



