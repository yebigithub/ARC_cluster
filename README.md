# ARC_cluster
- Sample Rscript and slurm files to use ARC in Virginia Tech
- How to use Jupyter notebook on ARC. 

## How to update R codes and files from local computer to cluster.
- Copy single file:
```scp test.R urid@tinkercliffs1.arc.vt.edu:/folder/position```

- Copy whole folder: 
```scp -r urFolerName urid@tinkercliffs1.arc.vt.edu:/folder/position```

************************************************************************************************************************
## Steps to install and use R in ARC.
### Step1
- Method 1 to log in (Alternative)  
	- Log into your thinkerclffs account via terminal  
	```
	ssh urid@tinkercliffs1.arc.vt.edu # you can use 1 or 2
	ssh urid@tinkercliffs2.arc.vt.edu
	ssh $CAS1 ### used for login node.
	```
	- Command lines to set $TIN1 and $TIN2 in environment. After that you just need to use $TIN1 or $TIN2 to log in, no need to type in the long email address any more.

	```
	nano .bash_profile
	export TIN1=yebi@tinkercliffs1.arc.vt.edu
	source .bash_profile 
	```
- Method 2 to log in (Works better)  
	- Click **OnDemand** link: https://ood.arc.vt.edu/pun/sys/dashboard/  
	- On the top: "Files" --> "HomeDirectory" --> "Open in Terminal"  
	- Then you will go to the terminal window.  
	

### Step2 
*(follow this link: https://www.docs.arc.vt.edu/software/r.html)*
```
module list 
```
- To see how many modules you already have, especially check if singularity with specific version is there or not.
- In the first time, singularity will not be there. So we will use step3-4 to load it.
### Step3
```
module spider singularity 
```
- to find the specific version of singularity exist in the module system.
### Step4
``` 
module load containers/singularity/3.8.5 #To load and install R in your own system.
module list #to check if singularity is there or not.
```
- In short, singularity is kind of a box of different softwares, which of course includes R, thus to install R, we just need to install singularity into our system.

### Step5 (From here we are trying one Rscript example)
```
nano run_R.sh
```
- To create your own sh file. This will be used for cluster terminal to run your R script.
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

### Step6
``` 
nano hp_mpg.R
```
- This is your own R script.

```
## hp_mpg.R
## R script for generating a plot of mpg vs hp
library(ggplot2)
attach(mtcars)
p <- ggplot(data=mtcars, aes(x=hp, y=mpg)) + geom_line()
ggsave(file="hp_mpg.pdf",p)
```

### Step7
```sbatch run_R.sh```
- Run this sh file in system and check results later.

### Step8
`squeue -u yebi` to check status of your current jobs  
`scancel jobid` to cancel specific job  
`squeue -u` can see all the users  

### Step9
`ls | wc -l`
- To see how many files you produced.
********************************************************************************************************************************************************
## Updated!!! How to use Jupyter Notebook in ARC. 
- [VT_ARC-QuickSetupGuide](https://github.com/yebigithub/ARC_cluster/blob/main/VT_ARC-QuickSetupGuide.pdf)  
This file is pretty useful for starting your jupyter notebook in ARC, thanks for my classmate's help in Deep Learning.

## Tips for myself (FarmCPU usage)
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


## For parallele (still in testing, doesn't work for long time...)
Different methods can fulfile different purposes.
1. Method1: mclapply
	ACR_parallel_mcapply.R
2. Method2: foreach

## Method to reach your allocation

OnDemand --> Clusters --> Cascades Shell Access
