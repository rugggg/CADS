x <- matrix(1:24, nrow=4)
x
# apply sum to each row
apply(x,1,sum)

#apply sum to each col
apply(x,2,sum)
