library(ggplot2)
library(dplyr)
library(plotly)
library(lubridate)

#save(masterFuture_intervals_narrow,file="./results/masterFuture_intervals_narrow.RData")
#load(file="./results/masterFuture_intervals_narrow.RData")

# loads the data frame: masterFuture_intervals_narrow
load(file="masterFuture_intervals_narrow.RData")
#masterFuture_intervals_narrow.RData = Values 

# plots
masterFuture_intervals_narrow_E <- masterFuture_intervals_narrow %>%
  filter(mix!="allE") %>% mutate(label=ifelse(os_status!="E",sprintf("%d|%d|%d",faz_cod,talhao_cod,os_cod),""))
maxLeft <- max(masterFuture_intervals_narrow_E$days)
minLeft <- min(masterFuture_intervals_narrow_E$days)

plot_os_dispatch <- masterFuture_intervals_narrow_E %>%
  ggplot(aes(x=days,y=area)) +
  geom_point(aes(color=left,shape=os_status),alpha=.5,size=I(10)) +
  guides(size=FALSE) +
  geom_text(aes(label=label),angle=45,size=4,hjust=0) +
  theme_bw() +
  #scale_y_log10() +
  scale_x_reverse() +
  geom_vline(xintercept=0,linetype=2) +
  theme(axis.text = element_text(size=12),
        axis.title=element_text(size=14,face="bold")) +
  labs(x="days to expire",y="block area",
       title=sprintf("%s, N=%d",today(), nrow(masterFuture_intervals_narrow_E)))

# sends it to ggplotly

p = ggplotly(plot_os_dispatch)
