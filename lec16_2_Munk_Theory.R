# Munk Theory


rm(list=ls())

r=10000  # 10000 으로 하면 계산은 느리지만  표현은 잘 된다.(1000으로 하면 모양 약간 이상)
b=600

beta=10^-13

y=c(0:b)
x=c(0:r)
k=0.016
B=(2/sqrt(3) - sqrt(3)/(k*r));

#----
Psi <- matrix(data = NA, nrow = length(c(1:b)), ncol = length(c(1:r)), byrow=F, dimnames = NULL)
X <- matrix(data=NA, nrow= length(c(1:r)), ncol=1, dimnames = NULL)
tau <- matrix(data=NA, nrow=length(c(1:b)), ncol=1, dimnames = NULL)


for (i in 1:r) {

 for (j in 1:b) {                        # Affeced by Wind : tau --> wind stress
  
  if (j>=1 && j< 150) {
     tau[j]=10^-11*sin(90*j/150*pi/180)
  } else if (j>=150 && j< 300) {
     tau[j]=10^-11*sin(90*j/150*pi/180) 
  } else if (j>=300 && j< 450) {            
     tau[j]=10^-11*sin(90*j/150*pi/180)  # increase

  } else {
     tau[j] = 10^-11*sin(90*j/150*pi/180) 
  }

X[i] <- -B*exp((-1/2)*k*x[i])*cos(sqrt(3)/2*k*x[i] + sqrt(3)/(2*k*r)-pi/6)+1  + # 다음줄 계속
         -1/(k*r)* (k*x[i] - exp(-k*(r-x[i])) -1)
Psi[j,i] <- X[i] * r * (1/beta) * tau[j] 
}
}



Psi_t <- -1*t(Psi)   # transpose of Psi


# ================================ Figure(1) ====

filled.contour(x=c(1:nrow(Psi_t)), y=c(1:ncol(Psi_t)), z=Psi_t,    # rainbow, heat.colors, topo.colors, cm.colors
               color.palette = topo.colors,
               plot.title = title(main = "Munk Theory",
                                  xlab = "Length",ylab = "Latitude", cex.lab=1.5 ) ) # X, Y  이름 크기
# filled.contour(Psi_t)



# ================================ Figure(2) ==== 
par(mfrow=c(2,1))  # 그래프를 행 우선 배치
plot(X)            # 1

xmax <- b-1
plot(c(0:xmax), -1*tau)  # 2

