## This can help us repeat same procedure for many times via multiple cores ----
## For example, produce several random numbers for many times. ----

# parallel_mcapply.R
library(parallel)

### make some data
x <- matrix(c(rep(1,100),runif(100),runif(100,max=10)),ncol=3,byrow=FALSE)
beta <- matrix(1:3,nrow=3)
y <- x %*% beta + rnorm(100)

f <- function(x_mat=x,y_mat=y,z){
  # return(x_mat)
  # return(y_mat)
  # return(z)
  boot_coef <- sample(1:100,size=100,replace=TRUE);
  results<-lm(y_mat[boot_coef]~0+x_mat[boot_coef,])$coefficients
  names(results)<-c("beta0","beta1","beta2")
  return(results)
}

#numCores <- detectCores() 
numCores <- parallelly::availableCores()
numreps <- 10000
results <- rep(0,numreps) ## preallocate to get compute timing

cat("setting cores to: ",numCores,sep="\n")

cat("using lapply \n")
system.time(
  results <- lapply(1:numreps,function(i)  f()) #this means repeat f() for numreps times, f() will not work on 1:numreps at all, since inputs (x_mat, y_mat) were already setted by x, y.
)
rowMeans(sapply(results,"[")) #this can transpose list content and build a new matrix

cat("using mcapply \n")
system.time(
  results <- mclapply(1:numreps,function(i)  f(), mc.cores = numCores)
)
rowMeans(sapply(results,"["))