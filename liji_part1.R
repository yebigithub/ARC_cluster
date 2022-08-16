# setwd("~/Library/CloudStorage/OneDrive-VirginiaTech/Research/Codes/research/ClemsonMaize")
.libPaths()
.libPaths(.libPaths()[3:1])

# install.packages("poolr", repos = "http://cran.us.r-project.org")

library(poolr)
library(tidyverse)


genoC20 <- readRDS("../Data/data/genoC20.rds")
mapC20 <- readRDS("../Data/data/mapC20.rds")


ll0 = round(cumsum(rep(table(mapC20$chrom)/10, each=10)))

# ll = c(0, ll0)
# r=list()
# for(i in 1:20){
#   cat("Now is running, ", i, "th genoC20 \n")
#   r[[i]] = cor(genoC20[, (ll[i]+1):(ll[i+1])])
#   saveRDS(r[[i]], file=paste0("corr_",i,".rds"))
# }
# 
meff <- list()
for(i in 4:20){
  cat("Now is running, ", i, "th meff \n")
  r <- readRDS(paste0("./liji_outputs/","corr_",i,".rds"))
  meff[[i]] <- meff(r, method = "liji")
  saveRDS(meff[[i]], file=paste0("./liji_outputs/meff_",i,".rds"))
}


setwd("~/OneDrive - Virginia Tech/Research/Codes/research/ClemsonMaize/meff")
myfile <- list.files(pattern = ".rds")
meff<-list()
for (i in 1:100){
  meff[[i]] <- readRDS(myfile[i])
}

# # Sum up all the chromosome specific Meff to obtain the genome-wide Meff
Meff <- do.call(sum, meff)
cat("Meff is ", Meff, "\n")
alpha = 1 - (1 - 0.05)^(1/Meff) #Meff is  36416 
cat("alpha is ", alpha, "\n")  #1.408536e-06 
