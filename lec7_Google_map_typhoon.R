rm(list=ls())

install.packages("ggplot2")
install.packages("ggmap") 

library(ggplot2)
library(ggmap)

register_google(key="AIzaSyCDp7vb5qTZ6BME6CxOeCbNXgmt-e3svtc") # google API Key

map <- get_googlemap(location = c(-71.2, 42.3, -71.0, 42.4), source = 'google')
ggmap(map)

# South Korea
ggmap(get_map(location="south korea", zoom=7, maptype='roadmap'))   # roadmap, hybrid
ggmap(get_map(location='south korea', zoom=7, maptype='terrain'))   # terrain
ggmap(get_map(location='south korea', zoom=7, maptype='satellite')) # satellite


# Google 지도에 표시
map <- ggmap(get_map(location='south korea', zoom=7, maptype='roadmap')) 
# Map type :  "terrain", "terrain-background", "satellite", "roadmap", and "hybrid"


# data frame 만들기 # 1
lon <- c(129, 130)
lat <- c(36, 37)
# lon <- matrix(129:132, byrow=F)
# lat <- matrix(35:38, byrow=F)
df <- data.frame(lon, lat)

# data frame 만들기 # 2
df <- data.frame( 129:131, c(36, 37.5, 38) )
# df <- data.frame( 128.5:128.75, c(35, 37.5, 35.17) ) # Jinhae
str(df)
colnames(df) <- c("lon", "lat")
str(df)
View(df)

# 사용되는 data는 data frame 구조여야 한다.
map + geom_point(data=df, aes(x=lon, y=lat), color="red", size=5 )            # only point red

map + geom_point(data=df, aes(x=lon, y=lat), color="black", size=5)           # only point black

map + geom_line(data=df, aes(x=lon, y=lat), color="red", linetype=1) # only Line

map + geom_point(data=df, aes(x=lon, y=lat), color="red", size=5 ) +
      geom_line(data=df, aes(x=lon, y=lat), color="blue", linetype=1) # point + line

map + geom_point(data=df, aes(x=lon, y=lat), color="red", size=5 ) +
  geom_line(data=df, aes(x=lon, y=lat), color="black", linetype=1, size=2) # point + line

map + geom_line(data=df, aes(x=lon, y=lat), color="blue", linetype=1, show.legend = FALSE) +
      geom_point(data=df, aes(x=lon, y=lat), color="blue", size=5, show.legend = FALSE) # line + point

# 
map <- ggmap(get_map(location='south korea', zoom=7, maptype='roadmap', color='bw')) 



# 서울을 가운데로 지도 그리기
se <- geocode(enc2utf8("서울"))   # Longitude of the Branch
ct <- as.numeric(se)              # in numbers
map <- get_googlemap(center=ct) # Creating a map

ggmap(map) # on the map

# 강원도를 가운데로 지도 그리기
gw <- geocode(enc2utf8("강원도"))   # Longitude of the Branch
ct <- as.numeric(gw)              # in numbers
map <- get_googlemap(center=ct, zoom=8, maptype='roadmap') # Creating a map

ggmap(map) # on the map

# 좌표값 중심으로 지도불러오기
qmap(location = c(lon = 127, lat = 37.5), zoom = 11,
     maptype = 'terrain', source = 'google')

# 정확한 경위도 범위내 지도 그리기
lat_bottom = 10  
lat_top    = 50   
lon_left   = 110   
lon_right  = 150 

trymap <- get_map(location = c(lon_left,lat_bottom,lon_right,lat_top), 
                  maptype='terrain')
 ggmap(trymap)


track <- read.csv("D:/RScript/data/typhoon2020.csv", header=T, as.is=T) # no column name(see typhoon.csv)
View(track)
dim(track)
track1 <- track[,] / 10.0    
View(track1)
colnames(track1) <- c("lat", "lon","lat1", "lon1","lat2", "lon2","lat3", "lon3","lat4", "lon4",
                      "lat5", "lon5","lat6", "lon6","lat7", "lon7","lat8", "lon8","lat9", "lon9",
                      "lat10", "lon10","lat11", "lon11","lat12", "lon12","lat13", "lon13","lat14", "lon14",
                      "lat15", "lon15","lat16", "lon16","lat17", "lon17","lat18", "lon18","lat19", "lon19",
                      "lat20", "lon20","lat21", "lon21","lat22", "lon22","lat23", "lon23","lat24", "lon24",
                      "lat25", "lon25","lat26", "lon26")
View(track1)


# track1 == typhoon.csv

# Typhoon track on the map 
ggmap(trymap) + geom_point(data=track1, aes(x=lon, y=lat), color="blue") +
  geom_point(data=track1, aes(x=lon1, y=lat1), color="red") +
  geom_point(data=track1, aes(x=lon10, y=lat10), color="black")


# Check  
  ggmap(trymap) + geom_point(data=track1, aes(x=lon1, y=lat1), color="red") +
     geom_line(data=track1, aes(x=lon1, y=lat1), color="black", linetype=1)
  
#--- geom path  (geom_line 은 선 연결시 error 발생)
  ggmap(trymap) + geom_point(data=track1, aes(x=lon1, y=lat1), color="red") +
    geom_path(data=track1, aes(x=lon1, y=lat1), color="black", linetype=1) +
    
    geom_point(data=track1, aes(x=lon2, y=lat2), color="blue") +
    geom_path(data=track1, aes(x=lon2, y=lat2), color="black", linetype=1) +
    
    geom_point(data=track1, aes(x=lon10, y=lat10), color="blue") +
    geom_path(data=track1, aes(x=lon10, y=lat10), color="black", linetype=1) +
    
    geom_point(data=track1, aes(x=lon11, y=lat11), color="yellow") +
    geom_path(data=track1, aes(x=lon11, y=lat11), color="black", linetype=1) +
    
      annotate("text", x=136, y=35.2, label="Typhoon", size=5, color="black")                 # Text


# Save Figure     
  ggsave(file="D:/RScript/Figure/Typhoon_01.png")
  
  
  # ================= Direct reading from JTWC DATA ===================
  track <- read.csv("D:/RScript/data/bwp082019.dat", header=F, as.is=T) # From JTWC
  lat=track[,7]
  lat1 <- as.numeric(sub("N", "", lat))  # N 을 없애고 숫자로 만든다
  lon1=track[,8]
  track <- cbind(lon1, lat1)
  track1 <- track[,]/10                  # 실제 경위도 값 고려 10으로 나눔
  
  # make data frame
  track_df <- data.frame(track1)
  colnames(track_df) <- c("lon", "lat")
  
  
  # Map
  lat_bottom = 10  
  lat_top    = 40   
  lon_left   = 100   
  lon_right  = 130 
  
  trymap <- get_map(location = c(lon_left,lat_bottom,lon_right,lat_top), 
                    maptype='terrain')
  
  #--- geom path 
  ggmap(trymap) + geom_point(data=track_df, aes(x=lon, y=lat), color="red") +
    geom_path(data=track_df, aes(x=lon, y=lat), color="black", linetype=1) 
  