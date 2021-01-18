#This program writes all of the output files from 'Wiiforloop.R' into one DF
#for subsequent analysis
#Created by Grant Handrigan (grant.handrigan@umoncton.ca)


#required libraries
library(here)

files=list.files(pattern="csv.csv$")
DF=NULL
for (file in files){
  
  print(file)
  subj_df=read.table(file, sep = ";", skip=1)
  subj_df$subject=substr(file, 1, 3)
  subj_df$trial=substr(file, 5, 10)
  DF=rbind(DF, subj_df)
}

names (DF) = c('RangeAP', 'RangeML', 'MeanCOPY', 'MeanCOPX', 'Total_Path', 
               'CoP_Speed','wiiweight','subject', 'trial')

write.csv(DF,"allwiidata.csv", row.names = FALSE)

