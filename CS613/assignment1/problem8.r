library(Hmisc)

college <- read.csv("data/College.csv")
rownames(college)=college[,1]
college = college[,-1]

latex(summary(college))

pairs(college[,1:10])
# force new plot window
dev.new()
# split plot window
par(mfrow=c(3,3))
attach(college)

plot(as.factor(Private), Outstate, xlab="Private", ylab="OutState", main="Private/Out of State Tuition")

Elite = rep("No", nrow(college))
Elite[college$Top10perc > 50] = "Yes"
Elite = as.factor(Elite)
college = data.frame(college, Elite)

eliteSummary = summary(college)

latex(eliteSummary)


plot(Elite, Outstate, xlab="Elite", ylab="Outstate", main="Elite Colleges Out of State Tuition")

hist(Apps)
hist(Grad.Rate, breaks=50)
hist(Books, breaks=50)
hist(Accept, breaks=200)
