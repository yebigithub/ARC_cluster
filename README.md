# ARC_cluster
Sample Rscript and slurm files to use ARC in Virginia Tech



## Copy single file:
scp test.R urid@tinkercliffs1.arc.vt.edu:/folder/position

## Copy whole folder: 
scp -r


## Steps to install and use R in ARC.
### Step1
1. Log into your thinkerclffs account via terminal 
	ssh urid@tinkercliffs1.arc.vt.edu or
 	urid@tinkercliffs2.arc.vt.edu
	
	#### Command lines to set $TIN1 and $TIN2 in environment.
```
nano .bash_profile
export TIN1=yebi@tinkercliffs1.arc.vt.edu
source .bash_profile
```

### Step2
2. Module list 
	to see how many modules you already have
### Step3
3. Module spider singularity 
	to find the specific version of singularity
### Step4
4. Try module load containers/singularity/3.8.5 
	Then “module list” to see if singularity is there or not.
### Step5
5. Nano run_R.sh as following.

## Sample slurm file
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
6. Nano hp_mpg.R as following:

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
8. Run squeue -u yebi
scancel jobid

## Step9
9. ls | wc -l



## Tips for farmcpu

1. Be careful about GAPIT download.
```
.libPaths()
.libPaths(.libPaths()[3:1])

install.packages("devtools", repos = "http://cran.us.r-project.org")

devtools::install_github("jiabowang/GAPIT3",force=TRUE)

library(GAPIT3)
```

2. Used to transfer rmd to .r

`knitr::purl("purl.Rmd”, documentation = 0)`

3. 'liji_par1.R' and 'liji_part1.sh' files are sample files for real data. 


## For parallele
Different methods can fulfile different purposes. hhhh
1. Method1: mclapply
	ACR_parallel_mcapply.R
2. Method2: foreach
