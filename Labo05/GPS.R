library(here)
library(trackeR)

boucle <- readGPX("boucle2.gpx")

boucle_trackeR <- trackeRdata(boucle, units = NULL, sport = "running", session_threshold = 2, 
                 correct_distances = FALSE, from_distances = TRUE, 
                 country= NULL,mask = TRUE, lgap = 30, lskip = 5, m = 11, 
                 silent = FALSE)

boucle_trackeR2 <- trackeRdata(boucle, sport = "running")

plot(boucle_trackeR)
plot(boucle_trackeR, session = 1, what = c("altitude", "pace"))
plot_route(boucle_trackeR)

leaflet_route(boucle_trackeR)

summary(boucle_trackeR)
