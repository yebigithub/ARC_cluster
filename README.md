# ARC_cluster
Sample Rscript and slurm files to use ARC in Virginia Tech


## Copy single file:
scp test.R urid@tinkercliffs1.arc.vt.edu:/folder/position

## Copy whole folder: 
scp -r urFolerName


## Steps to install and use R in ARC.
### Step1
1. (Alternative)  
	Log into your thinkerclffs account via terminal  
	ssh urid@tinkercliffs1.arc.vt.edu or  
	urid@tinkercliffs2.arc.vt.edu
	
	#### Command lines to set $TIN1 and $TIN2 in environment.
```
nano .bash_profile
export TIN1=yebi@tinkercliffs1.arc.vt.edu
source .bash_profile
```
1.1 (Works better)  
	click **OnDemand** link: https://ood.arc.vt.edu/pun/sys/dashboard/  
	On the top: "Files" --> "HomeDirectory" --> "Open in Terminal"  
	Then you will go to the terminal window.  
	

### Step2
2. module list 
	to see how many modules you already have
### Step3
3. module spider singularity 
	to find the specific version of singularity
### Step4
4. Run "module load containers/singularity/3.8.5" 
	Then “module list” to see if singularity is there or not.
### Step5
5. nano run_R.sh as following.

## Sample slurm file
- This file will let cluster system know how much resource you plan to use for running your code.
- Adjust N, n, t, A, according to your own use.
```
#!/bin/bash

### run_R.sh
###########################################################################
## environment & variable setup
####### job customization
#SBATCH --job-name="mpg plot"
#SBATCH -N 1
#SBATCH -n 16
#SBATCH -t 1:00:00
#SBATCH -p normal_q
#SBATCH -A multiomicquantgen    #### <------- change me
####### end of job customization
# end of environment & variable setup
###########################################################################
#### add modules on TC/Infer
module load containers/singularity/3.8.5
### from DT/CA, use module load singularity
module list
#end of add modules
###########################################################################
###print script to keep a record of what is done
cat hp_mpg.R
cat run_R.sh
###########################################################################
echo start running R
## note, on DT/CA, you should replace projects with groups

singularity exec --bind=/work,/projects \
    /projects/arcsingularity/ood-rstudio141717-bio_4.1.0.sif Rscript hp_mpg.R

exit;
```

## Step6
6. nano hp_mpg.R as following:

## Sample Rscript
```
## hp_mpg.R
## R script for generating a plot of mpg vs hp
library(ggplot2)
attach(mtcars)
p <- ggplot(data=mtcars, aes(x=hp, y=mpg)) + geom_line()
ggsave(file="hp_mpg.pdf",p)
```

## Step7
7. Then just “sbatch run_R.sh” and check results later.

## Step8
8. Run `squeue -u yebi` to check status of your current jobs  
`scancel jobid` to cancel specific job  
`squeue -u` can see all the users  

## Step9
9. ls | wc -l


## Tips for farmcpu

1. Be careful about GAPIT download.
```
#Select specific R version
.libPaths()
.libPaths(.libPaths()[3:1])

#install packages from CRAN
install.packages("poolr", repos = "http://cran.us.r-project.org")

#install packages from github
install.packages("devtools", repos = "http://cran.us.r-project.org")
devtools::install_github("jiabowang/GAPIT3",force=TRUE)
library(GAPIT3)
```

2. Used to transfer rmd to .r

`knitr::purl("purl.Rmd”, documentation = 0)`

3. 'liji_par1.R' and 'liji_part1.sh' files are sample files for real data. 


## For parallele (still in testing)
Different methods can fulfile different purposes.
1. Method1: mclapply
	ACR_parallel_mcapply.R
2. Method2: foreach

## Method to reach your allocation

OnDemand --> Clusters --> Cascades Shell Access
