
# Time series data

sst <- scan("https://raw.githubusercontent.com/ssbyun/data/main/Ex_timeseries.dat", skip=2)
plot(sst)

ts.sst <- ts(sst)
ts.sst

ts.sst <- ts(sst, frequency=12, start=c(2000, 1))
ts.sst

plot(ts.sst, type="b")
plot.ts(ts.sst, type="b")

ts.sst <- ts(sst, frequency=1, start=c(2000,1))
ts.sst
plot.ts(ts.sst, type="b")


# Moving Average
plot.ts(AirPassengers)

library("TTR")
Air.avg <- SMA(AirPassengers, n=5)
plot.ts(Air.avg)

# Decompsing time series
Air.dec <- decompose(AirPassengers)
str(Air.dec)

plot(Air.dec)
plot(Air.dec$trend, col="blue")
plot(Air.dec$x, col="blue")
plot(Air.dec$seasonal, col="blue")   # xlim=c(1,24)
# grid(Air.dec$seasonal, 10)           # only y-axis
abline(v=c(1950:1960), col="red", lty=2)

sp <- seq(1950,1960, by=0.5)
abline(v=sp, col="red", lty=2)


plot(Air.dec$seasonal[1:12], col="blue", cex=2)

# Forecasting
Air.log <- log(AirPassengers)
plot(AirPassengers)       # original
plot(Air.log)             # log

Air.forc <- HoltWinters(Air.log)
Air.forc
plot(Air.forc)

#--- dev.new() # dev.off()로 새로운 그림이 안 열릴때 사용
# The forecasts made by HoltWinters() are stored in "fitted"
Air.forc$fitted
plot(Air.forc$fitted)

# # If not clude beta & gamma
# Air.forc2 <- HoltWinters(Air.log, beta=FALSE, gamma=FALSE)
# plot(Air.forc2)

# To make forecasts for future times not included in the original time series
install.packages("forecast")
library(forecast)
# detach(package:forecast)   # unload package

Air.forc.long <- forecast(Air.forc, h=48) # 48 more months
plot(Air.forc.long)
Air.forc.long

exp(Air.forc.long$mean)
exp(Air.forc.long$lower)
exp(Air.forc.long$upper)

#~~~~ 로그 안 취한것과 비교그림 : 차이가 큼
Air.unlog <- HoltWinters(AirPassengers)  # seasonal = "additive" or "multiplicative"
Air.unlog.long <- forecast(Air.unlog, h=48)

plot(exp(Air.forc.long$mean), ylab="Air passengers")
points(Air.unlog.long$mean, col="red", type="l")
legend( 1961,900, c("Log", "Original   "), text.col= c("black","red"))

# ===== Global CO2
#gco2 <- read.csv("https://raw.githubusercontent.com/ssbyun/data/main/co2_mm_gl.csv")

gco2 <- read.csv("./data/co2_mm_gl.csv")
gco2

plot(gco2$decimal, gco2$average, type="l")
points(gco2$decimal, gco2$trend, type="l", col="red")

#--- make time from data frame [1]
library(lubridate)
time.ym <- make_date(year=gco2$year, month=gco2$month)
plot(time.ym, gco2$average)

#--- make time using ts [2]
ts.gco2 <- ts(gco2$average, frequency=12, start=c(1980, 1)) # CO2 농도자료에 시간추가
head(ts.gco2, 20)
plot(ts.gco2)


#--- Decompose
gco2.dec <- decompose(ts.gco2)
plot(gco2.dec)

#~~~ Removed seanonal components
gco2_season <- ts.gco2 - gco2.dec$seasonal
plot(gco2_season)

plot(ts.gco2)                               # original time series
points(gco2.dec$trend, type="l", col="red") # decomposed trend
points(gco2$decimal, gco2$trend, type="l", col="green") # trend in original data

plot(gco2.dec$seasonal[1:12]) # low CO2 in summer 


#--- forecast
# gco2.log <- log(ts.gco2)
# gco2.forc <- HoltWinters(gco2.log)
gco2.forc <- HoltWinters(ts.gco2)
plot(gco2.forc)
gco2.forc

head(gco2.forc)
plot(gco2.forc$x)
plot(gco2.forc$fitted[,2])

gco2.forc$SSE # sum of squared errors (forecast errors)

library(forecast)
gco2.forc.long <- forecast(gco2.forc, h=12*8)
plot(gco2.forc.long)
plot(gco2.forc.long, shadecols=c("yellow", "orange")) # desig shade colors
plot(gco2.forc.long, col="red", lwd=2, shadecols=c("green", "darkgreen"))
plot(gco2.forc.long, lwd=2, shadecols=c("grey", "darkgrey"))

plot(gco2.forc.long$mean)
points(gco2.forc.long$upper[,1], col="red", type="l")  # confidence level 1 or 2
points(gco2.forc.long$lower[,1], col="red", type="l")

tail(gco2.forc.long$upper)
tail(gco2.forc.long$lower)

#~~~~ 로그 안 취한것과 비교그림 : 차이가 거의 없음
gco2.log <- log(ts.gco2)
plot(gco2.log)
gco2.forc.log <- HoltWinters(gco2.log)
gco2.forc.log.long <- forecast(gco2.forc.log, h=12*8)

plot(gco2.forc.log.long)
exp(gco2.forc.log.long$mean)  # 예측값 : log 취했을때와 큰 차이 없음.
gco2.forc.long$mean

plot(exp(gco2.forc.log.long$mean))
points(gco2.forc.long$mean, col="red", type="l")

tail(exp(gco2.forc.log.long$x)) # 로그취한 값과 원본 값은 동일
tail(gco2.forc.long$x)



#<<< 참고 : ARIMA Model >>>
##--------------- ARIMA Model --------------##
## auto.arima in forecast package automatically select 
## the best ARIMA forecast model

#~~~ Check of staionarity [gco2]
library(forecast)

ndiffs(ts.gco2)  # 적절한 차분 횟수결정 included in forecast package

dgco2 <- diff(ts.gco2)
plot(dgco2)
Acf(ts.gco2)  # original data
Acf(dgco2)             # 0 으로 안 떨어짐(정상성이 아님)


lgco2 <- log(ts.gco2)
plot(lgco2)
Acf(lgco2)


dlgco2 <- diff(lgco2)
plot(dlgco2)
Acf(dlgco2)            # 0으로 안 떨어짐(정상성이 아님)

gco2.arima <- auto.arima(ts.gco2)
gco2.arima.forc <- forecast(gco2.arima, h=5*12)
plot(gco2.arima.forc)

Box.test(gco2.arima.forc)  # p=0.00 유의수준 0.05내 포함. 잔차들의 자기상관은 0 이라 할 수 있다.
                           # 잔차의 자기상관이 0이 아니어야 하는데, 0이므로 모델 부적합.


#~~~ Check of staionarity [AirPassengers]
dAir <- diff(AirPassengers)
plot(dAir)
Acf(dAir)

lAir <- log(AirPassengers)
plot(lAir)
Acf(lAir)

dlAir <- diff(lAir)
plot(dlAir)
Acf(dlAir)
pacf(dlAir)

Air.arima <- auto.arima(dlAir)
Air.arima.forc <- forecast(Air.arima, h=12*3)
plot(Air.arima.forc)

Box.test(Air.arima.forc$residuals) # 잔차 p=0.84 / 유의수준 0.05 벗어남. 
                                   # 잔차의 자기상관 0과 다르다 할 수 없다.따라서 예측모델 적합.

# 로그 & 차분 취하지 않았을 때

Air.arima2 <- auto.arima(AirPassengers)
Air.arima.forc2 <- forecast(Air.arima2, h=12*3)
plot(Air.arima.forc2)
Box.test(Air.arima.forc2)          # p=0.016 / 0.05 이내 포함, 모델 부적합.

# Global CO2
gco2.arima <- auto.arima(ts.gco2)
gco2.arima

gco2.forc <- forecast(gco2.arima, h=12*8) 
plot(gco2.forc)

tail(gco2.forc$mean)        # ARIMA
tail(gco2.forc.long$mean)   # HoltWinters  두 모델의 예측값이 매우 유사함.


# Air Passengers
AP.arima <- auto.arima(AirPassengers)
AP.arima

AP.forc <- forecast(AP.arima, h=48)
plot(AP.forc)
points(AirPassengers, type="o")

tail(AP.forc$mean)
tail(exp(Air.forc.long$mean))
plot(Air.forc.long)

plot(AP.forc$mean)
points(exp(Air.forc.long$mean), type="l", col="red")


