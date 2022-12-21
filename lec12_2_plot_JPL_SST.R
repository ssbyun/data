rm(list=ls())

library(oce)
library(ncdf4)
library(ocedata)
library(lubridate) #date and time manipulation ~ as_datetime

# JPL SST


ncin <- nc_open("D:/RScript/data/SST_Aug_2012.nc") # JPL SST
print(ncin)

# get variables
t <- ncvar_get(ncin,"time")
lon <- ncvar_get(ncin,"lon")
lat <- ncvar_get(ncin,"lat")
sst <- ncvar_get(ncin,"analysed_sst")


# --- Time
ncatt_get(ncin,'time')   # 시간확인
# Time <- as_datetime(c(t*60*60),origin="1981-01-01") # hours --> seconds : t*60*60 
Time <- as_datetime(c(t), origin="1981-01-01")  # seconds since 1981-01-01 00:00:00
head(Time)


image(sst[,,1])

# convert Kelvin to degree
nsst <- sst -273.15   
image(nsst[,,1])

# contour NO. 1
filled.contour(x=lon, y=lat, z=nsst[,,1],  
               color.palette = rainbow,  # rainbow, heat.colors, topo.colors, cm.colors
               # ylim = rev(range(dep)),        # Y-axis Reverse (ylim =rev(...))
               # xlim = c(8000,10000),
               
               plot.title = title(main = "Sea Surface Temperature",
                                  xlab = "Longitude",ylab = "Latitude", cex.lab=1.5 ),  # cex.axis
               
               key.title = title(main="ºC"))    
               
# contour NO. 2
filled.contour(x=lon, y=lat, z=nsst[,,1],  
               color.palette = rainbow,  # rainbow, heat.colors, topo.colors, cm.colors
               ylim = c(30, 45),        # Y-axis Reverse (ylim =rev(...))
               xlim = c(127,134),
               
               plot.title = title(main = "Sea Surface Temperature",
                                  xlab = "Longitude",ylab = "Latitude", cex.lab=1.5 ),  # cex.axis
               
               key.title = title(main="ºC"),                        # colorbar text
               
               plot.axes = {axis(1); axis(2); points(130, 43);
                    contour(x=lon, y=lat, z=nsst[,,1], levels = "20", col="black", add = TRUE )}) # 특정값(20도) line 표시

# timeseries
ts <- nsst[10,10,]; plot(ts, type="l", col="blue", lwd=2)  # example

ESROB <- c(37+32.24/60, 129+12.92/60)

idlon <- which( lon > 129.21 & lon < 129.22) # && lat >= 37.0 & lat < 37.1)
idlat <- which( lat > 37.53 & lat < 37.54)

ts_ES <- nsst[idlon, idlat, ]
day <- c(10:20)
plot(day, ts_ES, type="l", col="blue", lwd=2, ylab="Temperature (ºC)", xlab="Time (day)")



