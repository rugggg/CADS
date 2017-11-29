require(graphics)
require(biotools)
library(datasets)

#?InsectSprays
d = InsectSprays
summary(d)

summary(aov(d$count~d$spray))

# run THSD for univariate normality
TukeyHSD(aov(d$count~d$spray))

# for THSD - when the padj is close to 0, means there is lots of difference between the items being compared

#pairwise T test, also for univariate normality
pairwise.t.test(d$count, d$spray,p.adj="bonf")
#displays as matrix
# why do we get P-Values of 1?
#   bc with Bonferonni tests, it can adjust numbers up and over 1, at which point it will just set them to 1. 1 means not signfigant difference.

# ok, so then now what?
head(d)

# multivariate testing

bartlett.test(d$count, d$spray)
# what is this global test is telling us?
# it tells us if all variances are the same
#  p-value here is not good - we have a crack, not all equal

kruskal.test(d$count, d$spray)
# this is again, overwhelming evidence against H0 that all 6 sprays are equally effective

# ok, so we dont have normality, and we want to figure out what pairs are not the same

kruskal.test(d$count[d$spray %in% c("A", "B")], d$spray[d$spray %in% c("A", "B")])
# or keep it simpler
kruskal.test(d$count[1:24], d$spray[1:24])


#now lets play with iris data

# global test
d = iris
head(iris)
boxM(d[,1:4], d[5])

# check the differences between all species for each measurement
kruskal.test(d[,1],d[,5])
kruskal.test(d[,2],d[,5])
kruskal.test(d[,3],d[,5])
kruskal.test(d[,4],d[,5])

# now be specific - compare first and second classes with respect to attributes 4 
kruskal.test(d[1:100,4],d[1:100,5])



