library(MASS)
d=Cars93
dim(d)

summary(d)

str(d)

# what did we do to make mpg out of MPG.city and MPG.highway?

summary(lm(mpg~Weight))

summary(lm(mpg~Type))
# the first Estimate, one tagged as (Intercept) is the baseline stat, which will
# be the first category, in this case Compact


# when Pr(>|t|) is low, will have *s indicating if differs signifigantly


# lets adjust for weight when looking for type - we will see that actually, when
# we adjust for weight, Type of car no longer matters!
summary(lm(mpg~Weight+Type)
