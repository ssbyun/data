### Plot bathymetry using marmap toolbox


rm(list = ls())

library(RNetCDF)
library(maps)
library(mapdata)
library(marmap)


# You have to upload gebco nc file
# bfname <- "D:/RScript/data/gebco_bathy.nc"
bfname <- "D:/RScript/data/gebco_2020_ES.nc"

# if(!require("ncdf4")) install.packages("ncdf4")
# library(ncdf4)
# nc <- nc_open(bfname)


dep <- readGEBCO.bathy(bfname, resolution=1, sid=FALSE)   # sid=FALSE (SID information is not included)
summary(dep)                                              # 수심 정보

blues <- colorRampPalette(c("lightblue","cadetblue1","white"))  # custom col palette
plot(dep, n=1, image=TRUE, bpal=blues(100))  # color filled bathymetry
box("plot",col="black",lty=1)                   # 외곽 테두리 뚜렷하게 

# --- contour lines
plot(dep, deep=-4000, shallow=0, step=500, lwd=0.5, col="blue") 

# Color filled + contour
plot(dep, n=1, image = TRUE, bpal=blues(100))  # n = 1 : color filled

plot(dep, n=5, image = TRUE, bpal=blues(100))  # n = 5 : color filled + contour lines 5
box("plot",col="black",lty=1)

# Insert Scale bar
plot(dep, image = TRUE)  # inserted contour
scaleBathy(dep, deg = 2, x="bottomleft", inset=5)

# contour with different colors
plot(dep, n=1, image=TRUE, bpal = blues(100),
     deep = c(-5000, -1000, 0),                   # -5000 ~ -1000m : light grey
     shallow = c(-1000, 0, 0),                    # -1000 ~ 0m : dark grey & others (0m): black
     step = c(1000, 1000, 0),
     lwd = c(0.8, 0.8, 1), lty = c(1, 1, 1),
     col = c("lightgrey", "darkgrey", "black"),
     drawlabel = c(FALSE, FALSE, FALSE))

box("plot",col="black",lty=1)                   # 외곽 테두리 뚜렷하게 

# Creating a custom palettte of blues
blues <- c("lightsteelblue4", "lightsteelblue3",
           "lightsteelblue2", "lightsteelblue1")

# Plotting with different colors for Land and Sea
plot(dep, n=1, image=TRUE, land=TRUE, lwd=0.1,
     bpal = list(c(0, max(dep), "grey"),                                # Land(0 ~ Land) : grey
                 c(min(dep), 0, blues)) )   # min(dep) ~ 0.5m : blues

box("plot",col="black",lty=1)
# making the coastline more visible
plot(dep, deep = 0, shallow = 0, step=0,
     lwd=2, add=TRUE)                           # lwd : Coastline width                  

# --- Point
lon1 <- c(130)
lat1 <- c(38)

plot(dep, n=1, image=TRUE, land=TRUE, lwd=0.1,
     bpal = list(c(0, 0.5, "grey"),                                # Land(0 ~ 0.5m) : grey, c(0, max(dep))
                 c(min(dep), 0.5, blues)) )  
box("plot",col="black",lty=1)                   # 외곽 테두리 뚜렷하게 

points(lon1, lat1, pch=19, cex=2, col=c("red"))                 # pch symbol (19 : circle)
text(lon1, lat1+0.3, "Buoy", col="blue", font = 3)


#========== Plot in the selected region

plot(dep, n=1, image=TRUE, bpal=blues(100), xlim=c(127, 132), ylim = c(35, 40)) # Xdiff 5, ydiff 5 : 꽉찬그림
box("plot",col="black",lty=1)


#========== Coastline only

plot(dep, n=1, image = FALSE, bpal=blues(100), xlim=c(127, 132), ylim = c(35, 40)) # x(127~132)를 가운데로 배치
box("plot",col="black",lty=1)
