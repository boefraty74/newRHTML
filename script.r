#DEBUG in RStudio
fileRda = "C:/Users/boefraty/projects/PBI/R/tempData.Rda"
if(file.exists(dirname(fileRda)))
{
  if(Sys.getenv("RSTUDIO")!="")
    load(file= fileRda)
  else
    save(list = ls(all.names = TRUE), file=fileRda)
}





source('./r_files/flatten_HTML.r')

############### Library Declarations ###############
libraryRequireInstall("ggplot2");
libraryRequireInstall("plotly")
libraryRequireInstall("dplyr")
libraryRequireInstall("lubridate")
####################################################

masterFuture_intervals_narrow = Values

################### Actual code ####################

#g = qplot(`Petal.Length`, data = iris, fill = `Species`, main = Sys.time());

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

############# Create and save widget ###############

disabledButtonsList <- list('toImage', 'sendDataToCloud', 'zoom2d', 'pan', 'pan2d', 'select2d', 'lasso2d', 'hoverClosestCartesian', 'hoverCompareCartesian')
p$x$config$modeBarButtonsToRemove = disabledButtonsList

p <- config(p, staticPlot = FALSE, editable = FALSE, sendData = FALSE, showLink = FALSE,
            displaylogo = FALSE,  collaborate = FALSE, cloud=FALSE)

  

internalSaveWidget(p, 'out.html')

####################################################

#DEBUG in RStudio
if(Sys.getenv("RSTUDIO")!="")
  print(p)

