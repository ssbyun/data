# Western Intensification ~ Stommel Theory
# # ramda = 10,000km, b=6249km, D=200m

rm(list=ls())

D=200      
b=6249000    # 6,249km
r=10000000   # 10,000km
R=0.02       # Friction coefficient
F=0.1        # wind stress

y <- seq(0, b, by=100000)  # 0:b 까지, 간격 100000
x <- seq(0, r, by=100000) 

Gamma <- (F*pi)/(R*b)

# ==== Coriolis force is linear function of latitude
 a <- D/R*10^-9        # Original value is D/R*10^-13  
 # a <- 0              # No western intensification (no rotating frame)


Psi <- matrix(data = NA, nrow = 63, ncol = 101, byrow=F, dimnames = NULL)

for (i in 1:101) {
    for (j in 1:63) {

  CAL_1 <- Gamma * ((b/pi)^2)
  CAL_2 <- sin(pi*y[j]/b)           
  nj <- pi/b

# ----------------------------------------------------
  
  Aj <- -a/2 + sqrt(a^2/4+(nj)^2)
  Bj <- -a/2 - (sqrt(a^2/4+(nj)^2) )   


  p <- (1-exp(Bj*r))/(exp(Aj*r)-exp(Bj*r))
  q <- 1-p


  CAL_3 <- ( p *exp(Aj*x[i]) + q *exp(Bj*x[i]) -1 )

# -----------------------------------------------------
  
  
  Psi[j,i] <- -1*CAL_1 * CAL_2 * CAL_3

    } 
}

# --- Contour
x1 <- c(1:nrow(Psi))
y1 <- c(1:ncol(Psi))

# filled.contour(Psi)
# contour(Psi)
filled.contour(x=x1, y=y1, z=Psi,    # rainbow, heat.colors, topo.colors, cm.colors
               color.palette = topo.colors, 
               # ylim = rev(range(Psi)),        # Y-axis Reverse (ylim =rev(...))
               # xlim = c(8000,10000),
               plot.title = title(main = "Stommel Theory (Streamlines for the linear Coriolis force)",
                                  xlab = "Length",ylab = "Latitude", cex.lab=1.5 ) ) # X, Y 이름 크기


#==== Transpose : t( )
# png("D:/RScript/Figure/Stommel.png")

Psi_t <- t(Psi)

filled.contour(x=y1, y=x1, z=Psi_t,    # rainbow, heat.colors, topo.colors, cm.colors
               color.palette = topo.colors, 
               # ylim = rev(range(Psi)),        # Y-axis Reverse (ylim =rev(...))
               # xlim = c(8000,10000),
               plot.title = title(main = "Stommel Theory (Streamlines for the linear Coriolis force)",
                                  xlab = "Length",ylab = "Latitude", cex.lab=1.5 ) ) # X, Y 이름 크기

 # dev.off()

# cylabels=get(cb,'ytick').*2/10^5;