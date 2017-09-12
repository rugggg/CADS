data = read.csv("data/arrythmia.csv")
subset = data[1:100, 1:5]

print(subset)

# mean -> 0 and stddev = 1
subset = scale(subset)

t(apply(subset,2,function(x)table(cut(x, 10))))
