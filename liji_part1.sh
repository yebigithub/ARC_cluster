#!/bin/bash

### liji.sh
###########################################################################
## environment & variable setup
####### job customization
#SBATCH --job-name="liji_part"
#SBATCH -N 5
#SBATCH -n 20
#SBATCH -t 3:00:00
#SBATCH --mem-per-cpu=48G
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
cat liji.sh
###########################################################################
echo start running R
## note, on DT/CA, you should replace projects with groups

singularity exec --bind=/work,/projects \
    /projects/arcsingularity/ood-rstudio141717-bio_4.1.0.sif Rscript liji_part1.R 

exit;
