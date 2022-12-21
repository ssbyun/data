# Animated gif

rm(list=ls())


#---- No. 1

setwd("D:/RScript/Ani")

png(file="example%02d.png", width=300, height=200)  # %2d : 2 digit number
for (i in c(10:1, "Fire~~!")){      
  plot.new()
  text(.5, .5, i, cex = 6)
}
dev.off()

# system("convert -delay 80 *.png ex.gif") # RCloud

system(' "C:/Program Files/ImageMagick-7.0.10-Q16-HDRI/magick.exe" -delay 80 *.png  ex.gif ') # ver.7.0 부터 convert --> magick 
file.remove(list.files(pattern=".png"))


# 시속 100km 자동차, 시속 30km 자동차 (V = L/T, L = V*T)

#--- NO.1
Car1 <- rep(NA,10)  
Car2 <- rep(NA,10)  
for ( t in 1:10 ) {     # hour
  Car1[t] <- 100 * t      # 거리 = 속력(100km/h) * 시간
  Car2[t] <- 30 * t
}

plot(Car1, col="blue", ylim=c(0,100*10+50), cex=2, xlab="Time(hour)", 
     ylab="Distance(km)", cex.lab = 1.6, cex.axis=1.5) # cex.axis : 축 글자크기

points(Car2, col="red", ylim=c(0,100*10+50), cex=2, cex.axis=1.5)

# cex.lab=1.5, cex.axis=1.5, cex.main=1.5, cex.sub=1.5



#--- NO. 2 Animation
png(file="example%02d.png", width=800, height=600)

Car1 <- rep(NA,10)  # hour
Car2 <- rep(NA,10)  # hour
for ( t in 1:10 ) {
  Car1[t] <- 100 * t      # 거리
  Car2[t] <- 30 * t
  plot( Car1, col="blue", ylim=c(0,100*10+50), cex=3, xlab="Time (hour)", 
              ylab="Distance (km)", cex.lab = 1.6, cex.axis=1.5 ) 
  
  points(Car2, col="red", ylim=c(0,100*10+50), cex=3, cex.axis=1.5)
  
  # legend("topright", legend = c(Car1, Car2))     # 거리를 값으로 지속 표시
  legend("topleft", legend=c("Car1 (100km/h)","Car2 (30km/h)"), fill=c("blue", "red"), 
         cex=1.5)
}
       
dev.off()

# system("convert -delay 80 *.png  Car.gif")
system(' "C:/Program Files/ImageMagick-7.0.10-Q16-HDRI/magick.exe" -delay 80 *.png  Car.gif ')

file.remove(list.files(pattern=".png"))



# legend("topright",legend=c("A","B"),fill=c("red","blue"),border="white",box.lty=0,cex=1.5)

#============ Animation ============
install.packages("plotly")
library(plotly)

# Car1,2 계산
Car1 <- rep(NA,10)  
Car2 <- rep(NA,10)  
for ( t in 1:10 ) {     # hour
  Car1[t] <- 100 * t      # 거리 = 속력(100km/h) * 시간
  Car2[t] <- 30 * t
}

# data frame 만들기
df <- data.frame( t = c(1:10), Car1, Car2, f = c(1:10) )

fig <- df %>%
  plot_ly(
    x = ~ t,
    y = ~ Car1,
    frame = ~ f,
    type = 'scatter',
    mode = 'markers', marker=list(size=20),
    showlegend = T,
    name = 'Car1 (100km/h)') %>%
     
    layout(xaxis=list(title="Hour"), yaxis=list(title="Distance(km)"))      

    
fig <- fig %>% add_trace(y = ~ Car2, name = 'Car2 (30km/h) ', 
                         mode = 'markers')

fig


# ------------ << 포물선 운동 >> -----------
# 특정 각도로 던질때
# y = v0*sin(theta)*t - 1/2*g*t^2  : 높이
# x = v0*cos(theta)*t            : 수평거리

time <- seq(0, 3, by=0.1)   # 0 ~ 3 sec / 0.1 sec 간격의 시간 할당 
y <- rep(NA, length(time)) 
x <- rep(NA, length(time))  
# xy <- rep(NA, length(time))

v0 <- 30            # 30m/s
theta <- 30*pi/180  # 30도
g <- 9.8

for ( t in 1:length(time) ) {     # second
  x[t] <- v0 * cos(theta)*time[t]
  y[t] <- v0 * sin(theta)*time[t] - 1/2*g*time[t]^2
}

plot(x, y, col="blue", cex=2, xlab="Distance(m)", 
     ylab="Height(m)", cex.lab = 1.6, cex.axis=1.5) # cex.axis : 축 글자크기


#--- Animation
df <- data.frame( x, y, f = c(0:30) )   

fig <- df %>%
  plot_ly(
    x = ~ x,
    y = ~ y,
    frame = ~f,
    type = 'scatter',
    mode = 'markers', marker=list(size=20),
    showlegend = T,
    name = 'Ball (100m/s), angle=30도') %>%
  
  layout(xaxis=list(title="Distance"), yaxis=list(title="Height")) 

fig


#==================== Original Example ==========================#

df <- data.frame(
  x = c(1,2,1), 
  y = c(1,2,1), 
  f = c(1,2,3)
)

fig <- df %>%
  plot_ly(
    x = ~x,
    y = ~y,
    frame = ~f,
    type = 'scatter',
    mode = 'markers',
    showlegend = F
  )

fig
