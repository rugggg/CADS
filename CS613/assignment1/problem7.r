data = read.csv("data/RawDataUSCities.csv")

data = data[,-(1:2)]

data = apply(data,2, function(x)(x - mean(x))/sd(x))
data[1:6,]
data = apply(data, 2, function(x)(x-min(x))/(max(x)-min(x)))
data[1:6,]
