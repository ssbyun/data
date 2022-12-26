rm(list=ls())

library(oce)
library(ncdf4)
library(ocedata)
library(lubridate) #date and time manipulation ~ as_datetime

# NOAA SST


ncin <- nc_open("D:/RScript/data/SST_NOAA_2020_01_Sep_daily.nc") # NOAA SST
print(ncin)

# get variables
t <- ncvar_get(ncin,"time")
lon <- ncvar_get(ncin,"lon")
lat <- ncvar_get(ncin,"lat")
sst <- ncvar_get(ncin,"sst") # degree C


# --- Time
ncatt_get(ncin,'time')   # 시간확인
# Time <- as_datetime(c(t*60*60),origin="1981-01-01") # hours --> seconds : t*60*60 
Time <- as_datetime(c(t*3600*24), origin="1800-01-01")  # day --> sec. (t*3600*24)/days since 1800-01-01 00:00:00
head(Time)


image(sst)

# # convert Kelvin to degree
# nsst <- sst -273.15   
# image(nsst)

# contour NO.1
filled.contour(x=lon, y=lat, z=sst,  
               color.palette = rainbow,  # rainbow, heat.colors, topo.colors, cm.colors
               # ylim = rev(range(dep)),        # Y-axis Reverse (ylim =rev(...))
               # xlim = c(8000,10000),
               
               plot.title = title(main = "Sea Surface Temperature",
                                  xlab = "Longitude",ylab = "Latitude", cex.lab=1.5 ),  # cex.axis
               
               key.title = title(main="ºC"))    
               
# contour NO.2
filled.contour(x=lon, y=lat, z=sst,  
               color.palette = rainbow,  # rainbow, heat.colors, topo.colors, cm.colors
               ylim = c(30, 45),        # Y-axis Reverse (ylim =rev(...))
               xlim = c(127,140),
               
               plot.title = title(main = "Sea Surface Temperature",
                                  xlab = "Longitude",ylab = "Latitude", cex.lab=1.5 ),  # cex.axis
               
               key.title = title(main="ºC"),                        # colorbar text
               
               plot.axes = {axis(1); axis(2); points(130, 43, pch=19, cex=3, col="blue");       # 지도위에 point 표시
                    contour(x=lon, y=lat, z=sst, levels = "20", col="black", add = TRUE )}) # 특정값(20도) line 표시




# ================  Contour with oce  ===============
clim <- c(0, 30)                      # colorbar limit
drawPalette(clim, col=oce.colorsJet)  # show colorbar

data("coastlineWorld")
mapPlot(coastlineWorld, lon, lat, longitudelim=c(120, 150), latitudelim=c(30,50), 
        projection="+proj=merc", grid=FALSE)

mapImage(lon, lat, sst, col=oce.colorsJet, zlim=clim)  # overlay sst

# overlay coastline fill in gray again
mapPolygon(coastlineWorld, col='grey')

# add variable label
lab = 'SST [deg C]'   # define unit label
mtext(lab, side = 3, line = 0, adj = 0, cex = 0.7)



# add title
# title(timestamp[1])









ncatt_get(ncin,'time')
#convert the hours into date + hour
#as_datetime() function of the lubridate package needs seconds
#time unit: hours since 1900-01-01

timestamp <- as_datetime(c(t*60*60),origin="1981-01-01")
head(timestamp)

# install.packages("insol")
library(insol)


to = insol::JDymd(year = 1981, month = 1, day = 1)   # original time : 1950, 1, 1
jd = to + t                                       # data time + original time 
date = insol::JD(jd, inverse = TRUE)                 # Real time

Ttime = tibble::as_tibble( data.frame(time, jd, date) )      # 시간배열 합치기

timestamp <- as_datetime(c(t*60*60),origin="1900-01-01")
head(timestamp)
