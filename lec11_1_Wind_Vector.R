rm(list=ls())

install.packages(c("ggOceanMapsData", "ggOceanMaps"), 
                 repos = c("https://cloud.r-project.org",
                           "https://mikkovihtakari.github.io/drat"
                 )
)




library(ggplot2)
library(ggOceanMapsData)
library(ggOceanMaps)
library(data.table)
library(dplyr)
library(ncdf4)

library(lubridate) #date and time manipulation ~ as_datetime

fname <- "D:/RScript/data/ECMWF_wind.nc"   # version 6로 .mat 저장시 load 가능

data1 <- nc_open(fname)

# get variables using ncdf4
time <- ncvar_get(data1,"time")
u <- ncvar_get(data1,"u10")
v <- ncvar_get(data1,"v10")
lon <- ncvar_get(data1,"longitude")
lat <- ncvar_get(data1,"latitude")

ncatt_get(data1,'time')   # 시간확인
# Time <- as_datetime(c(t*60*60),origin="1981-01-01") # hours --> seconds : t*60*60 
Time <- as_datetime(c(time*3600), origin="1900-01-01")  # day --> sec. (t*3600*24)/days since 1800-01-01 00:00:00
head(Time)

# Method to convert POSIXct --> Year, Month, Day
Year <- year(Time); Month <- month(Time); Day <- day(Time)

# Find index
yy <- 2015; mm <- 01; dd <- 05
ind <- which(year(Time)==yy & month(Time)==mm & day(Time)==dd)  


image(u[,,ind])  # quick view


u1 <- u[,,ind];  v1 <- v[,,ind]
u11 <- matrix(u1,nrow=length(lon)*length(lat), ncol=1)   # 1열로 생성
v11 <- matrix(v1,nrow=length(lon)*length(lat), ncol=1)

u2 <- u11*0.07; v2 <- v11*0.07     # scale change

# data frame 만들기
lon1 <- rep(lon, length(lat)); lat1 <- rep(lat, each = length(lon)) # 경도변화, 같은위도반복

data1 <- cbind(lon1, lat1, u2, v2) %>% as.data.frame
colnames(data1) <- c("lon","lat","u","v")

# Velocity Color
data1$vel <- sqrt( (data1$u)^2 +(data1$v)^2 )  # data1 에 vel 추가
data1  <- within(data1 , Velocity <- as.integer(cut(vel, quantile(vel, probs=0:4/4, na.rm=TRUE), include.lowest=TRUE)))

# Figure

map1 <- basemap("EastSea", limits=c(lon[1],lon[length(lon)],lat[1],lat[length(lat)]), bathymetry=TRUE) +
  geom_segment(data = data1, aes(x = lon1, y = lat1, xend = lon1 + u2, yend = lat1 + v2, group = Velocity, color = Velocity),
               arrow = arrow(length = unit(0.1,"cm"))) + 
  
#  ggtitle(paste("Ocean Currents in the East sea, ", toString(Day),"/",month.abb[Month],"/", toString(Year) )) +
  
  ggtitle("ECMWF Wind in the East sea") +
  
  theme(plot.title = element_text(family = "serif", face = "bold", hjust = 0.5, size = 15, color = "black")) + 
  scale_colour_gradientn(colours = c("white", "yellow", "orange", "red")) 

map1   # plot figure

ggsave("D:/RScript/Figure/Wind_vector.png", device="png")


# write.csv(Time, file="./data/Times.csv")
# read.csv("./data/Times.csv")
