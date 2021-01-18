Wiicop <- function(filename) {
  #This function calculates the COP parameters from the Wii balance board 
  #using the 'brainblox' program
  #BrainBlox available from: 
  #https://www.colorado.edu/neuromechanics/research/wii-balance-board-project
  #Created by Grant Handrigan (grant.handrigan@umoncton.ca)
  
  Var=filename #Dynamically assigns filename to Var for naming output files
  
  wii <- read.csv(file = filename, header = FALSE, sep = ";")
  x = wii[,6]
  y = wii[,7]
  weight = mean(wii[,8])
  #specify the length of the trial, here it is 30 seconds
  trial_length = 30
  
  #Calculating some descriptive variables of interest
  #Range Medio-lateral
  RangeX = max(x)-min(x)
  #Range Anterior-posterior
  RangeY = max(y)-min(y)
  #Mean CoPx and CoPy positions
  MeanCoPx = mean(x)
  MeanCoPy = mean(y)
  
  #Calculating the total_path length and the CoP_speed
  numpoints <-length (x)
  Wii2 <- data.frame(x = wii[,6], y = wii[,7], dist = as.numeric(NA))
  Wii2$dist[2:numpoints] <- sqrt((Wii2$x[2:numpoints] - Wii2$x[1:numpoints-1]) 
                                 ^ 2 + (Wii2$y[2:numpoints] - 
                                          Wii2$y[1:numpoints-1]) ^ 2)
  
  total_path <- sum(Wii2$dist[2:numpoints])
  
  CoP_speed <- total_path/trial_length
  
  
  #Creates a df of the table contents that are written in the next section
  sum_table <-
    list("Ranges" =
           list("A-P(cm)" =  (RangeY),
                "M-L(cm)" =  (RangeX)),
         "Mean CoP positions" =
           list("CoPA-P" = (MeanCoPy),
                "CoPM-L" = (MeanCoPx)),
         "Total path" =
           list("Path(cm)" = (total_path)),
         "Mean CoP speed" =
           list("CoP speed" = (CoP_speed)), 
         "Weight" = 
           list("Weight" = (weight)))
  
  #writes the summary table to an unformatted .csv file, 
  #Exports to current working folder
  write.table(sum_table, file = sprintf("%s.csv",Var), sep = ";", 
              quote = FALSE, row.names = F)
  
  #Creates a graph of the CoP data
  Wii_graph <-ggplot(Wii2, aes(x=x, y=y)) +
    xlab("Medio-lateral displacement (cm)") + #X-axis label
    ylab("Anterior-posterior displacement (cm)") + #Y-axis label
    geom_point(shape=1)+
    guides(fill=guide_legend("Distance between points")) +
    geom_path(aes(colour = (dist)))+
    ggtitle("Total path displacement of the CoP M-L vs. CoP A-P") + #plot title
    theme(plot.title = element_text(lineheight=.8, face="bold"))+ #plot
    theme(panel.background = element_blank())+
    theme(panel.background = element_rect(fill = "transparent"))+ #panel bg
    theme(plot.background = element_rect(fill = "transparent", color = NA))+ 
    theme(legend.background = element_rect(fill = "transparent"))+ 
    theme(legend.box.background = element_rect(fill = "transparent"))+
    theme(axis.line = element_line(colour = "black"))+
    theme(axis.text = element_text(size=14))+
    theme(axis.title = element_text(size=14, face = "bold"))+
    theme(legend.text=element_text(size=14))+
    theme(legend.title=element_text(size=14))
  
  #exports the figure to current folder
  ggsave(sprintf("%s.png", Var), width=14, height=8, dpi=300) 
}
