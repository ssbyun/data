rm(list=ls())


install.packages("spectral")

library(spectral)
library(ncdf4)

# get variables
ts <- nc_open("./data/OS_EC1_200211_D_RCM7-360m.nc")

time <- ncvar_get(ts, "TIME")
temp <- ncvar_get(ts, "TEMP")
u <- ncvar_get(ts, "UCUR")

#--- convert julian to gregorian

install.packages("insol")
library(insol)

ncatt_get(ts, "TIME")
t0 <- insol::JDymd(year = 1950, month = 1, day = 1) # UTC
jd <- t0 + time
date <- insol::JD(jd, inverse = TRUE)
Time <- tibble::as_tibble(data.frame(time, jd, date))

#--- Interpolation

install.packages("gsignal")
library(gsignal)

ids <- which(Time$date =="2003-01-01")
ide <- which(Time$date =="2003-12-31")

Time[ids[1],]
Time[ide[length(ide)],]
xtime <- Time[ids[1]:ide[length(ide)], 3]

u2 <- u[ ids[1]:ide[length(ide)] ]  # select only year 2003
ind <- which(u2==-99999)            # find missing value
u2[ind]=NA                         # convert missing value
u3 <- as.vector(u2)                 # convert array to vector

install.packages("imputeTS")
library(imputeTS)
u4 <- na_interpolation(u3, option = "linear")  # please use vector
plot(u3, type="l", col="gray")
lines(u4, type="l", col="blue")

u5 <- u4*100   # m/s --> cm/s

# # detrend : removes the mean or linear trend from data.
# u5 <- detrend(u4)
# plot(u4, type="l")
# lines(u5, type="l", col="red")

#================== Filter
install.packages("dplR")
library(dplR)

# low-pass filter -- note Freq is passed in (0.5 --> 1/2)
# 30 min interval(1/2 h = 0.5), 30 h --> 1/60 (1/(2*30))

b.low <- pass.filt(u5, W=1/60, type="low", method="Butterworth")  
c.low <- pass.filt(u5, W=1/60, type="low", method="ChebyshevI")
plot(u5, type="l", col="grey")
lines(b.low, col="red")
lines(c.low, col="blue")

library(plotly)
plot_ly(opacity=1) %>%
  add_lines(x = ~ Time$date, y = ~ b.low) %>%
  layout(xaxis=list(title="Time", titlefont=list(size=30), tickformat = "%m/%Y", tickfont=list(size=15)),
         yaxis=list(title="U-velocity (cm/s)", titlefont=list(size=20), tickfont=list(size=15)))

# high-pass filter (1/2 --> 2) -- note Period is passed in
b.high <- pass.filt(u5, W = 26, type="high")  # 13 h highpass filter
plot(u5, type="l", col="grey")
lines(b.high, col="red")


# band-pass filter / 18~22 h -- note Freqs are passed in
b.band <- pass.filt(u5, W=c(1/(18*2), 1/(22*2)), type="pass")
c.band <- pass.filt(u5, W=c(1/(18*2), 1/(22*2)), type="pass", method="ChebyshevI")
plot(u5, type="l", col="grey")
lines(b.band, col="red")
lines(c.band, col="blue")


#===== Spectrum [https://cran.r-project.org/web/packages/gsignal/vignettes/gsignal.html]

library(gsignal)

fs=2 # 1/2 hour

wd=length(u5)            # window에 따라 달라짐
wd=round(length(u5)/2)
wd=round(length(u5)/3)
wd=round(length(u5)/4)
wd=round(length(u5)/5)
wd=round(length(u5)/8)
wd=round(length(u5)/10)


# plot(u5, type = "l", xlab = "Time (s)", ylab = "", main = "Original signal")
pw <- pwelch(u5, window = wd, fs = fs) #, detrend = "none")
  plot(pw, xlim = c(0, 0.1), main = "PSD estimate using FFT", ylim=c(0,2000),
     col="blue", lty=1, lwd=2)

idx <- which(pw$spec >= 1500 & pw$spec <= 1700)
1/pw$freq[idx]   # find the period with the second maximum


#-- log scale

library(ggplot2)
ggplot() + aes(x=pw$freq, y=pw$spec) + geom_line(color="blue") + scale_x_log10() +
  labs(title="Spectrum of u-current", x="Frequency(cph)", y=bquote((cm/s)^2/cph)  ) +   # 윗첨자: ^, 아래첨자: []
  theme(axis.title = element_text(size=15), axis.text=element_text(size=12, face="bold"))




