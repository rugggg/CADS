library(ISLR)
attach(Weekly)
dim(Weekly)
pairs(Weekly)
cor(Weekly[,-9])

glm.fits = glm(Direction~Lag1+Lag2+Lag3+Lag4+Lag5+Volume, data=Weekly, family=binomial)
summary(glm.fits)
glm.probs = predict(glm.fits, type="response")
pred.glm = rep("Down", length(glm.probs))
pred.glm[glm.probs > 0.5]="Up"
table(pred.glm, Direction)

train=(Year<2009)
Weekly.2010 = Weekly[!train,]
Direction2010 = Direction[!train]
glm.fit2 = glm(Direction ~ Lag2,data=Weekly,family=binomial,subset=train)
summary(glm.fit2)
glm2.probs=predict(glm.fit2,Weekly.2010,type="response")
glm2.pred = rep("Down", length(glm2.probs))
glm2.pred[glm2.probs > 0.5]="Up"
table(glm2.pred, Direction2010)
