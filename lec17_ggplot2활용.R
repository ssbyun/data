# ggpolt2 graphics

library(ggplot2)

mpg
str(mpg)
help(mpg)

ggplot() +
   geom_point(data=mpg, mapping=aes(x=displ, y=cty))

ggplot() +
  geom_point(data=mpg, mapping=aes(x=displ, y=cty, color=class))

ggplot() +
  geom_point(data=mpg, mapping=aes(x=displ, y=cty, alpha=cty))

ggplot() +
  geom_point(data=mpg, mapping=aes(x=displ, y=cty, color=class, shape=drv))

ggplot() +
  geom_point(data=mpg, mapping=aes(x=displ, y=cty), color="blue")

colors()

ggplot() +
  geom_point(data=mpg, mapping=aes(x=displ, y=cty), color="blue", size=5)

ggplot() +
  geom_line(data=mpg, mapping=aes(x=displ, y=cty), color="blue")

ggplot() +
  geom_line(data=mpg, mapping=aes(x=displ, y=cty), color="blue", linetype=2)

ggplot() +
  geom_point(data=mpg, mapping=aes(x=displ, y=cty)) +
  geom_smooth(data=mpg, mapping=aes(x=displ, y=cty), color="red")

ggplot() +
  geom_point(data=mpg, mapping=aes(x=displ, y=cty)) +
  geom_smooth(data=mpg, mapping=aes(x=displ, y=cty), color="red", method="lm")

ggplot() +
  geom_point(data=mpg, mapping=aes(x=displ, y=cty)) +
  geom_smooth(data=mpg, mapping=aes(x=displ, y=cty), color="red", method="lm") +
  geom_text() + annotate("text", label="Regression line", x=5, y=25, size=8, color="red")

ggplot() +
    geom_point(data=mpg, mapping=aes(x=displ, y=cty), shape=3) +
  geom_smooth(data=mpg, mapping=aes(x=displ, y=cty), color="red")



ggplot() +
  geom_point(data=mpg, mapping=aes(x=displ, y=cty), shape=3) +
  geom_smooth(data=mpg, mapping=aes(x=displ, y=cty), color="red") +
  labs(title="배기량 vs. 시내 연비 ", x="배기량 (liter)", y="연비 (miles/gallon)") 

ggplot() +
  geom_point(data=mpg, mapping=aes(x=displ, y=cty, color=class, shape=drv)) +
  labs(color="차량종류", shape="구동방식")

ggplot() +
  geom_point(data=mpg, mapping=aes(x=displ, y=cty, color=class, shape=drv)) +
  labs(x="구동방식", y="시내연비", color="차량종류", shape="구동방식") +
  ggtitle("차량 구동방식과 시내연비") +
  theme(plot.title=element_text(size=25, face="bold")) +
  theme(plot.title = element_text(hjust=0.5)) +
  theme(axis.text=element_text(size=15))+
  theme(axis.title=element_text(size=18, face="bold")) +
  theme(legend.position="bottom")

ggplot() +
  geom_point(data=mpg, mapping=aes(x=displ, y=cty, color=class, shape=drv)) +
  labs(x="구동방식", y="시내연비", color="차량종류", shape="구동방식") +
  ggtitle("차량 구동방식과 시내연비") +
  theme(plot.title=element_text(size=25, face="bold")) +
  theme(plot.title = element_text(vjust=-5, hjust=0.1)) +
  
  geom_vline(xintercept=mean(mpg$displ), color="red", linetype=2)


ggplot() +
  geom_point(data=mpg, mapping=aes(x=displ, y=cty, color=class, shape=drv)) +
  labs(x="구동방식", y="시내연비", color="차량종류", shape="구동방식") +
  ggtitle("차량 구동방식과 시내연비") +
  theme(plot.title=element_text(size=25, face="bold")) +
  theme(plot.title = element_text(vjust=-5, hjust=0.1)) +
  
  geom_hline(yintercept=20, color="red", linetype=2)


# Bar chart

ggplot(mpg, aes(class)) + geom_bar()

ggplot(mpg, aes(class)) + geom_bar(aes(fill=drv))



## mtcars
ggplot(data=mtcars, mapping=aes(x=wt, y=mpg, color=disp)) +
  geom_point(size=5) +
  scale_color_gradient(low="green", high="blue") 

ggplot(data=mtcars, mapping=aes(x=wt, y=mpg, size=disp)) +
  geom_point(shape=21, color="black", fill="yellow") +
  scale_size_continuous(range=c(1,10))

#~~ y-axis reverse
ggplot(data=mtcars, mapping=aes(x=wt, y=mpg, size=disp)) +
  geom_point(shape=21, color="black", fill="yellow") +
  scale_size_continuous(range=c(1,10)) +
  scale_y_reverse() 

#~~ y-axis limits
ggplot(data=mtcars, mapping=aes(x=wt, y=mpg, size=disp)) +
  geom_point(shape=21, color="black", fill="yellow") +
  scale_size_continuous(range=c(1,10)) +
  scale_y_continuous(limits=c(0,40))
