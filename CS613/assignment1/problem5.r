# read data from csv
data = read.csv("data/kc_house_data.csv")

invisible((nData = nrow(data)))

invisible(set.seed(0))

invisible(trainIdx <- sample(seq(1, nrow(data)), floor(nrow(data) * 0.70)))

mean(trainSet <- data$price[trainIdx])
mean(testSet <- data$price[-trainIdx])
