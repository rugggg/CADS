ga <- read.csv(file="07-P7Train.csv")
glm.fits = glm(Converted~Pageviews+AvgSessionLength+SessionCount, data=ga, family=binomial)

newdata = data.frame(Pageviews = 13, AvgSessionLength = 16.8, SessionCount = 24)

predict(glm.fits, newdata, type="response")
