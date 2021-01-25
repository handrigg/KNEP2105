# KNEP 2105 - Laboratoire 02 "Électromyographie et la force musculaire"
# Ce fichier s'agit d'un KNEP2105 - Labo02 Il s'agit d'un programme court pour 
# démontrer le paquet "biosignalEMG" créé par J.A. Guerrero & J.E. Macias-Diaz
# Ce paquet est disponible sur CRAN à l'adresse suivante : 
# https://cran.r-project.org/package=biosignalEMG 
# Ce laboratoire a été dévloppé par Grant Handrigan - Université de Moncton
# Janvier 2021

#Charge les paquets nécessaires pour ce programme
library(biosignalEMG)



op <- par(mfrow = c(2, 2))

emgx <- syntheticemg(n.length.out = 5000, on.sd = 1, 
                     on.duration.mean = 350,on.duration.sd = 10, off.sd = 0.05, 
                     off.duration.mean = 300, off.duration.sd = 20,
                     on.mode.pos = 0.75, shape.factor = 0.5, 
                     samplingrate = 1000, units = "mV",
                     data.name = "Synthetic EMG")

plot(emgx, main = "Synthetic EMG")


# Full-wave rectified EMG
emgr <- rectification(emgx, rtype = "fullwave")
plot(emgr, main = "Rectified EMG")

# Integration of the full-wave rectified EMG with reset points every
# 200 samples
emgi <- integration(emgr, reset = TRUE, reset.criteria = "samples", vreset = 200)

plot(emgi, main = "Integrated EMG")

# MA-envelope
emgma <- envelope(emgx, method = "MA", wsize = 60)
# Ensemble-averaged EMG
ea <- eaemg(emgma, runs = emgx$on.off, what = 1, timenormalization = "mean",
               scalem = 1, empirical = TRUE, level = 0.9)
plot(ea, lwd = 2, main = "Ensemble-averaged EMG")

# reset graphical parameters
par(op)

# Voici maintenant un exemple réel.
# Ces données proviennent d'un projet de mémoire qu'un étudiant de quatrième 
# année a terminé l'année dernière, juste avant la fermeture due à COVID-19. 


#Charge les paquets nécessaires pour cette partie du programme

library(readr)
library(here)

emgDF <- read_delim("FINAL0306_a.tsv", 
                      "\t", escape_double = FALSE, col_names = FALSE, 
                      trim_ws = TRUE)

colnames(emgDF) <- c("Jauge_plaf", "Inclino_1", "Inclino_2", "EMG_Delt", "EMG_TAnt", "EMG_Gastroc", "EMG_Obliques", "Stop")

emgDF <- emgDF[1:(length(emgDF)-1)]
emgDF <- na.omit(emgDF)
View(emgDF)

emgx <- as.emg(emgDF$EMG_TAnt, samplingrate = 1500, units = "V")
#emgx <- as.emg(emgDF$EMG_Delt, samplingrate = 1500, units = "V")
#emgx <- as.emg(emgDF$EMG_Gastroc, samplingrate = 1500, units = "V")
#emgx <- as.emg(emgDF$EMG_Obliques, samplingrate = 1500, units = "V")

op <- par(mfrow = c(2, 2))

plot(emgx, main = "Données EMG (brutes)")

#removes the DC bias in the signal
emgy <- dcbiasremoval(emgx)
plot(emgy, main = "EMG with zero mean")
abline(h = mean(emgy$values), col = "red", lwd = 2) # Show the position of the overall mean


# Full-wave rectified EMG
emgr <- rectification(emgy, rtype = "fullwave") 
plot(emgr, main = "Rectified EMG")

# RMS-envelope
emgrms <- envelope(emgr, method = "RMS", wsize = 1) 


# Integration of the full-wave rectified EMG with reset points every
# 1500 samples
emgi2 <- integration(emgrms, reset = TRUE, reset.criteria = "samples", vreset = 1500)
plot(emgi2, main = "Integrated EMG (with reset)")


