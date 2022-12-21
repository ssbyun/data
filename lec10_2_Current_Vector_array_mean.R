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

# fname <- "D:/RScript/data/AVISO_1993_2018.nc"   # version 6로 .mat 저장시 load 가능
fname <- "D:/RScript/data/Aviso_2015.nc"

data1 <- nc_open(fname)

# get variables using ncdf4
time <- ncvar_get(data1,"time1")
u <- ncvar_get(data1,"ugs1")
v <- ncvar_get(data1,"vgs1")
lon <- ncvar_get(data1,"lon1")
lat <- ncvar_get(data1,"lat1")


Year <- 2015  # toString(Year)
Month <- 12   # month.abb[Month], month.name[Month]

# ind <- which(time[,1]==Year & time[,2]==12 & time[,3]==Day)                 # find index
 ind <- which(time[,1]==Year & time[,2]==Month)

uu1 <- u[,,ind];  vv1 <- v[,,ind]

u1 <- apply(uu1,c(1,2),mean, na.rm=T) # 1 : rows, 2 : columns
v1 <- apply(vv1,c(1,2),mean, na.rm=T) # 1 : rows, 2 : columns

#~~! Mean of Array
# uu <- apply(u1,c(1,2),mean, na.rm=T) # 1 : rows, 2 : columns

# Check the mean of u1 and uu are the same
# mean(uu,na.rm=T)
# mean(u1,na.rm=T)


u2 <- matrix(u1,nrow=length(lon)*length(lat), ncol=1)   # 1열로 생성
v2 <- matrix(v1,nrow=length(lon)*length(lat), ncol=1)


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
  ggtitle(paste("Ocean Currents in the East sea, ", month.abb[Month],"/", toString(Year) )) +
  
  theme(plot.title = element_text(family = "serif", face = "bold", hjust = 0.5, size = 15, color = "black")) + 
  scale_colour_gradientn(colours = c("white", "yellow", "orange", "red")) 

map1   # plot figure

ggsave("D:/RScript/Figure/Current_avg.png", device="png")


#=== Quick View of Current vector / OceanView

install.packages("OceanView")
library(OceanView)


quiver2D(u1,v1,x=lon,y=lat, scale = 5, arr.max = 0.2, col="blue")  # OceanView toolbox