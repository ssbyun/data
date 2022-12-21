# Set Option
# memory.limit(size = 9999999999999)

rm(list = ls())
setwd("D:/RScript")

install.packages("rsoi")
install.packages("extrafont")
install.packages("tidyverse")
install.packages("plotly")
install.packages("reshape2")

# library(extrafont); 
library(tidyverse); library(rsoi)
library(plotly); library(reshape2); library(ggplot2)

# options(digits = 10); Sys.setlocale("LC_TIME", "english"); font = "Palatino Linotype"


# load data


Enso_idx = rsoi::download_enso()
dplyr::tbl_df(Enso_idx)

# set limitation
Xmin="1950-01-01"
Xmax="2022-09-01"

# Figure
ggplot(data=Enso_idx, aes(x=Date, y=ONI, fill=phase)) +
   theme_bw() +
   geom_col() +
   scale_fill_manual(values = c( "dodgerblue", "springgreen4", "tomato1")) +    # designate color
   scale_x_date(expand = c(0,0), date_breaks = "10 years", date_labels = "%Y",
                limits = as.Date(c(Xmin, Xmax))) +
   scale_y_continuous(expand=c(0,0), breaks=seq(-2,2,1), limits=c(-2,2)) +
   
   labs(
       x="Time (year)"
       , y="ENSO Index"
       , fill="Phase"
       , title="El Nino-Southern Oscillation"
       , subtitle="Period : April 01, 1951 - Jan 01, 2022"
#       , caption="Source : rsoi"
        ) +
   theme(
       plot.title=element_text(face="bold", size=18, colour="black")
       , axis.title.x=element_text(face="bold", size=18, colour="black")
       , axis.title.y=element_text(face="bold", size=18, colour="black", angle=90)
       , axis.text.x=element_text(face="bold", size=18, colour="black")
       , axis.text.y=element_text(face="bold", size=18, colour="black")
       , legend.title=element_text(face="bold", size=14, colour="black")
       , legend.position="bottom"
       , legend.justification=c(0,0.96)
       , legend.key=element_blank()
       , legend.text=element_text(size=14, colour="black")
       , legend.background=element_blank()
    #   , text=element_text(family=font)
       , plot.margin=unit(c(0, 8, 0 ,0), "mm")
       ) 

       ggsave(filename=paste0("D:/RScript/Figure/ENSO_Index.png"), width=12, height=8, dpi=600)
       
       
       
       
       
       
       