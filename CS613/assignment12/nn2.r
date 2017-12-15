set.seed(40)
library(neuralnet)
data = read.csv("kc_house_data.csv")

normalize <- function(x){
    return((x-min(x))/(max(x)-min(x)))
}


# pick out elements we want ot use
df = data[,c("price","bedrooms","bathrooms", "sqft_living","sqft_lot", "floors","waterfront","view","condition","grade","sqft_above","sqft_basement")]

# normalize
scaled <- as.data.frame(lapply(df, normalize))

# test train split
train.size <- floor(0.7 * nrow(scaled))
train.index <- sample(sample(seq_len(nrow(scaled)), size = train.size))
train <- scaled[train.index,]
test <- scaled[-train.index,]

n <- names(train)
f <- as.formula(paste("price ~", paste(n[!n %in% "price"], collapse = " + ")))

nn <- neuralnet(f, data=train, hidden=c(8,4), linear.output=T)
#nn
#plot(nn)

# predicted price
train.pred <- compute(nn, train[,2:12])
test.pred <- compute(nn, test[,2:12])

#unscale
train.nn <- train.pred$net.result*(max(df$price)-min(df$price))+min(df$price)
test.nn <- test.pred$net.result*(max(df$price)-min(df$price))+min(df$price)

#train MSE
train.r <- (train$price)*(max(df$price)-min(df$price))+min(df$price)

# check test
test.truth <- (test$price)*(max(df$price)-min(df$price))+min(df$price)
train.truth <- (train$price)*(max(df$price)-min(df$price))+min(df$price)

# MSE
MSE.train <- sum((test.nn - test.truth)^2)/nrow(test)
MSE.test <- sum((train.nn - train.truth)^2)/nrow(train)

MSE.train 
MSE.test 
