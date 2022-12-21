# Basic graphics & Linear Regression

plot(iris$Petal.Width, iris$Petal.Length)

big <- with(iris, iris[Petal.Width > 0.6,])
points(big$Petal.Width, big$Petal.Length, col="red")

points(big$Petal.Width, big$Petal.Length, col="red", pch=17)

plot(iris$Petal.Width, iris$Petal.Length, xlab="Width", 
     ylab="Length", main="Iris Petal Width vs. Length")

# Vertical & Horizontal Lines
abline(v=1.0, col="green")
abline(h=4, col="purple")


# Regression
iris_lm <- lm(iris$Petal.Length ~ iris$Petal.Width)
iris_lm

abline(a=coef(iris_lm)[1], b=coef(iris_lm)[2], col="red")
abline(coef(iris_lm)[1], coef(iris_lm)[2], col="red")
abline(iris_lm, col="red")

text(0.5, 5, "y = 1.084 + 2.23x", col="blue" )
text(0.5, 5, "y = 1.084 + 2.23x", col="blue", cex=1.8)

# Save Figure
png(file = "D:/RScript/Figure/test.png", bg="yellow")

plot(iris$Petal.Width, iris$Petal.Length, xlab="Width", 
     ylab="Length", main="Iris Petal Width vs. Length")

dev.off()

#--- dev.new() # dev.off()이후 새로운 그림이 안 열릴때 사용
