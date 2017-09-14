A=matrix(c(25,-2,4,-2,4,1,4,1,9), ncol=3)
t(A) # transpose

solve(A)

# check that solve A * A gives I
round(A%*%solve(A), 3)

#eigenvalues and eigenvectors

eigen(A)

# spectral decomp, just use a loop in practice
A1 = eigen(A)$values[1]*eigen(A)$vectors[,1]%*%t(eigen(A)$vectors[,1])
A2 = eigen(A)$values[2]*eigen(A)$vectors[,2]%*%t(eigen(A)$vectors[,2])
A3 = eigen(A)$values[3]*eigen(A)$vectors[,3]%*%t(eigen(A)$vectors[,3])

# so A should equal A1 + A2 + A3
print(A)
A1+A2+A3

# 
sum(diag(A))
sum(eigen(A)$values)

# note you need to use diag(diag to get a matrix. diag just gives the digas in a p*1
diag(diag(A))

D=diag(1/sqrt(diag(A)))
# the %*% means matrix multiplication
D%*%A%*%D

# single value decomp
svd(A)

#determinant
det(A)

#Identity matrix
diag(rep(1,10))


