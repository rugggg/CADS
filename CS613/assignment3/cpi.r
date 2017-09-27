# read data from csv
rm(list=ls())
rawdata = read.csv("cpi.csv")
data = rawdata[-1,-1]

data = data[-nrow(data),]

set.seed(42)

normalize <- function(x) {
        return( (x-min(x))/(max(x) - min(x)))
}
denormalize <- function(x,minval,maxval) {
        return(x*(maxval-minval) + minval)
}
minvec <- sapply(data, min)
maxvec <- sapply(data, max)

data = as.data.frame(lapply(data, normalize))
russia = data[nrow(data),]
russia = russia[,-ncol(data)]

dists = apply(data,1,function(x)sqrt(sum((x-russia)^2)))
n <- length(unique(dists))
i1 = which(dists == sort(unique(dists),partial=2)[2])
i2 = which(dists == sort(unique(dists),partial=3)[3])
i3 = which(dists == sort(unique(dists),partial=4)[4])

data = as.data.frame(Map(denormalize, data, minvec, maxvec))

mean(data[i1,ncol(data)],data[i2,ncol(data)],data[i3,ncol(data)])
