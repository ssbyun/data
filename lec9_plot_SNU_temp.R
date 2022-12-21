
rm(list=ls())

#install.packages("plotly")
#install.packages("ncdf4")

library(plotly)
library(ggplot2)
library(ncdf4)

data <- nc_open("D:/RScript/data/60587.nc")

# get variables using ncdf4
time <- ncvar_get(data,"Time")
temp <- ncvar_get(data,"temp")
depth <- ncvar_get(data,"dep")

# --- Time
ncatt_get(data,'Time')   # 시간확인

# convert the julian day to gregorian calender

library(lubridate) #date and time manipulation ~ as_datetime
Ttime <- as_datetime(c(time)*60*60*24, origin="1950-01-01") # day from 1950
Ttime
  

# Temperature timeseries plot #1
plot_ly(opacity=1) %>%                                           # opacity : 투명도
  add_lines(x= ~time, y= ~temp[,1], name="5m") %>%
  add_lines(x= ~time, y= ~temp[,2], name="20m") %>%
  add_lines(x= ~time, y= ~temp[,3], name="40m") %>%
  add_lines(x= ~time, y= ~temp[,4], name="60m") %>%
  add_lines(x= ~time, y= ~temp[,5], name="110m") %>%
  layout(xaxis = list(title = 'Time'),
         yaxis=list(title = 'Temperature (ºC)')) 

# Temperature timeseries plot #2
plot_ly(opacity=1) %>%                                           # opacity : 투명도
  add_lines(x= ~time, y= ~temp[,1], name="5m", color=I("red"))  %>%
  add_lines(x= ~time, y= ~temp[,2], name="20m", color=I("magenta")) %>%
  add_lines(x= ~time, y= ~temp[,3], name="40m", color=I("purple")) %>%
  add_lines(x= ~time, y= ~temp[,4], name="60m", color=I("green")) %>%
  add_lines(x= ~time, y= ~temp[,5], name="110m", color=I("blue")) %>%
  layout(xaxis = list(title = 'Time'),
         yaxis=list(title = 'Temperature (ºC)'))

# make data.frame
# colnames(temp) <- c("5m", "20m", "40m", "60m", "110m")
# temp1 <- data.frame(temp)
# xtime <- c(1:length(time))

# ======= Filled contour

dep <- c(5, 20, 40, 60, 110)

# 1
filled.contour(x=1:nrow(temp), y=1:ncol(temp), z=temp,
               color.palette = terrain.colors)

# 2
filled.contour(x=1:nrow(temp), y=dep, z=temp,    # depth label
               color.palette = terrain.colors)

# 3 Colors
filled.contour(x=1:nrow(temp), y=dep, z=temp,    # rainbow, heat.colors, topo.colors, cm.colors
               color.palette = topo.colors, 
               ylim = rev(range(dep)),        # Y-axis Reverse (ylim =rev(...))
               # xlim = c(8000,10000),
               plot.title = title(main = "Subsurface Temperature @ ESROB",
                                  xlab = "Time",ylab = "Depth (m)", cex.lab=1.5 ) ) # X, Y 이름 크기
               
               # plot.axes = axis(1,cex.axis=2)                   # 1 : X축만 표시, 글자 크기 2
                                                                  # 2 : Y 축
# 4 time
filled.contour(x=time, y=dep, z=temp,    # rainbow, heat.colors, topo.colors, cm.colors
               color.palette = topo.colors, 
               ylim = rev(range(dep)),        # Y-axis Reverse (ylim =rev(...))
               # xlim = c(8000,10000),
               plot.title = title(main = "Subsurface Temperature @ ESROB",
                                  xlab = "Time",ylab = "Depth (m)", cex.lab=1.5 ) ) # axis : cex.axis


# Real time
filled.contour(x=Ttime, y=dep, z=temp,    # rainbow, heat.colors, topo.colors, cm.colors
               color.palette = topo.colors, 
               ylim = rev(range(dep)),        # Y-axis Reverse (ylim =rev(...))
               # xlim = c(8000,10000),
               plot.title = title(main = "Subsurface Temperature @ ESROB",
                                  xlab = "Time",ylab = "Depth (m)", cex.lab=1.5 ) ) # axis : cex.axis

# Real time 1
plot_ly(opacity=1) %>%                                           # opacity : 투명도
  add_lines(x= ~Ttime, y= ~temp[,1], name="5m") %>%
  layout( xaxis = list(tickformat = '%y.%m') )

# Real time ~ xlim
plot_ly(opacity=1) %>%                                           # opacity : 투명도
  add_lines(x= ~Ttime[100:500], y= ~temp[100:500,1], name="5m") %>%
  layout( xaxis = list(tickformat = '%y.%m') )

# Real time 2

plot_ly(opacity=1) %>%                                           # opacity : 투명도
  add_lines(x= ~Ttime, y= ~temp[,1], name="5m", color=I("red"))  %>%
  add_lines(x= ~Ttime, y= ~temp[,2], name="20m", color=I("magenta")) %>%
  add_lines(x= ~Ttime, y= ~temp[,3], name="40m", color=I("purple")) %>%
  add_lines(x= ~Ttime, y= ~temp[,4], name="60m", color=I("green")) %>%
  add_lines(x= ~Ttime, y= ~temp[,5], name="110m", color=I("blue")) %>%
  layout(xaxis = list(title = 'Time', tickformat = '%Y.%m'),      # '%Y.%m' : yyyymm / %m.%d
         yaxis=list(title = 'Temperature (ºC)')) 


# Real time 3

filled.contour(x=Ttime$time, y=dep, z=temp,   # x= Ttime$date
               color.palette = topo.colors, 
               ylim = rev(range(dep)),        # Y-axis Reverse (ylim =rev(...))
               # xlim = c(8000,10000),
               
               plot.title = title(main = "Subsurface Temperature @ ESROB",
                                  xlab = "Time",ylab = "Depth (m)", cex.lab=1.5 ) )   # axis : cex.axis

