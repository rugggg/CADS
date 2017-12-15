
df = read.table("T8-5.DAT")

df.pca.cor = prcomp(df, scale=TRUE, center=TRUE, retx=TRUE)
df.pca.cov = prcomp(df, scale=FALSE, center=TRUE, retx=TRUE)

png(file="dfpcacor.png")
plot(df.pca.cor, type="l")
dev.off()
summary(df.pca.cor)
png(file="biplot_cor.png")
biplot(df.pca.cor) 
dev.off()
png(file="dfpcacov.png")
plot(df.pca.cov, type="l")
dev.off()
summary(df.pca.cov)
png(file="biplot_cov.png")
biplot(df.pca.cov) 
dev.off()

# We do note that we can achieve our objective with both methods, however we can use less PCs with covariance as it does not scale our
# data. Thus, it can be summarized in as few as 3 dimensions with the covariance method. The principal components have been plotted for interpretation.

