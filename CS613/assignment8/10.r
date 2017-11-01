library(ISLR)
library(MASS)
attach(Weekly)

train=(Year<2009)
Weekly.2010 = Weekly[!train,]
Direction2010 = Direction[!train]

lda.fit = lda(Direction ~ Lag2,data=Weekly,subset=train)

lda.pred = predict(lda.fit, Weekly.2010)
table(lda.pred$class, Direction2010)

qda.fit = qda(Direction ~ Lag2,data=Weekly,subset=train)

qda.pred = predict(qda.fit, Weekly.2010)
table(qda.pred$class, Direction2010)
