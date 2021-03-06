library(MASS)
library(car)

# set output file
sink("pension_report.txt")
# read data
pension = as.data.frame(read.table("Pension.txt", head=TRUE))

# read first 6 rows
head(pension)

# apply(pension, 2, is.na)
# remove na
# pension = na.omit(pension)
# get dimensions
dim(pension)
# read names
names(pension)

# get summary stats
summary(pension)


pension.clean  <-  na.omit(pension)
# histogram and boxplot each col
for(col in 1:ncol(pension)){
    print(names(pension)[col])
    png(file=paste("hist_",names(pension)[col],".png"))
    hist(pension[,col], main=names(pension)[col], xlab=names(pension)[col])
    dev.off()
    # skip box plotting wealth
    if((names(pension)[col]) != "wealth89"){
        png(file=paste("boxplot_",names(pension)[col],".png"))
        f = as.formula(paste("wealth89 ~ ",names(pension)[col]))
        boxplot(f, data=pension, main=names(pension)[col], xlab=names(pension)[col])
        dev.off()
    }
}

#png(file="scatterplot_small.png")
# some options to create a higher res scatterplot
#png(file="scatterplot",  height=10, width=10, units="in", res=1000, pointsize=4)
#par(
#  mar      = c(5, 5, 2, 2),
#  xaxs     = "i",
#  yaxs     = "i",
#  cex.axis = 2,
#  cex.lab  = 2
#)
scatterplotMatrix(pension)
#dev.off()

base  <- lm(formula=wealth89 ~ .,data = pension.clean)
step  <- stepAIC(base, trace = FALSE)
step$anova
refined.fit <- lm(formula = refined.formula, data=pension.clean)
summary(refined.fit)

step2  <- stepAIC(base, ~ .^2 + I(age)^2, trace = FALSE)
step2$anova
refined.formula  <- formula(step2)

refined.fit <- lm(formula = refined.formula, data=pension.clean)
summary(refined.fit)

# unset sink file
sink()

