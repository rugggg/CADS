# read data from csv
rm(list=ls())
data = read.csv("cpi.csv")
set.seed(42)

normalize <- function(x) {
        return( (x-min(x))/(max(x) - min(x)))
}
denormalize <- function(x,minval,maxval) {
        return(x*(maxval-minval) + minval)
}
minvec <- sapply(data[,2:(ncol(data)-1)], min)
maxvec <- sapply(data[,2:(ncol(data)-1)], max)

data[,2:(ncol(data)-1)] = apply(data[,2:(ncol(data)-1)],2, normalize)
russia <- data[nrow(data),]
data = data[-nrow(data),]


russia.trim = russia[,2:(ncol(russia)-1)]
dists = apply(data[2:(ncol(data)-1)],1,function(x)sqrt(sum((x-russia.trim)^2)))
dists = sort(dists)
dists
dist.indexes = names(dists)
dist.indexes
data[,2:(ncol(data)-1)] = as.data.frame(Map(denormalize, data[,2:(ncol(data)-1)], minvec, maxvec))
data[dist.indexes[1],]
data[dist.indexes[2],]
data[dist.indexes[3],]

mean(c(data[dist.indexes[1],ncol(data)],
     data[dist.indexes[2],ncol(data)],
     data[dist.indexes[3],ncol(data)]))

