#This small program is a for loop to process all of the files in the folder
#that is current working directory that have the extension .csv using the
#function 'Wiicop'
#Please load the function 'Wiicop' prior to running this program
#Created by Grant Handrigan (grant.handrigan@umoncton.ca)

#required libraries
library(here)
library(ggplot2)

files=list.files(pattern=".csv$")

for (f in files) {
  Wiicop(f)
  }
