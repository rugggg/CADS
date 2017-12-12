library(party)
set.seed(40)

data = read.csv("FlightPerformance.csv")
clean = data[,c("carrier","dest","origin","schedtime", "weather", "date", "delay")]

# test/train split
trainIdx <- sample(seq(1, nrow(clean)), floor(nrow(clean) * 0.70))
train <- clean[trainIdx,]
test <- clean[-trainIdx,]


train <- clean[trainIdx,]


# Create the tree.
output.tree <- ctree(delay ~ ., data = train)

png(file="dtree.png")
# Plot the tree.
plot(output.tree)
dev.off()

pred <- predict(output.tree, test)
table(pred, test$delay)
mean(pred == test$delay)



