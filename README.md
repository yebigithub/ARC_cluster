
# ARC_cluster
Workshop from ARC. https://www.docs.arc.vt.edu/usage/workshops.html  

## Cotent
- [Quick cluster tips](#quick-cluster-tips)
- [Steps to install and use R in ARC](#steps-to-install-and-use-r-in-arc).
- [How to use Jupyter notebook on ARC](#how-to-use-jupyter-notebook-on-arc)
- [How to install tensorflow-gpu on ARC](#how-to-install-tensorflow-gpu-on-arc)
- [How to install Pytorch-cuda on ARC.](#how-to-install-pytorch-cuda-on-arc)
- [How to submit slurm job to ARC.](#how-to-submit-slurm-job-to-arc)


### Quick cluster tips
```
jobload jobid # To check ur resource usage.
squeue -u yebi -o "%j" # To check job full name.
sacct -u yebi --format=JobID,Start,End,Elapsed # To check job status
sacct --starttime YYYY-MM-DD --endtime YYYY-MM-DD
sacct -o JobID,JobName%30,State
sacct --starttime $(date -d "yesterday 00:00:00" +"%Y-%m-%dT%H:%M:%S") -o JobID,JobName%30,State
```

## Connect your account to ARC
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

	- How to update R codes and files from local computer to cluster.
		- Copy single file:
		```scp test.R urid@tinkercliffs1.arc.vt.edu:/folder/position```

		- Copy whole folder: 
		```scp -r urFolerName urid@tinkercliffs1.arc.vt.edu:/folder/position```

- Method 2 to log in (Works better)  
	- Click **OnDemand** link: https://ood.arc.vt.edu/pun/sys/dashboard/  
	- On the top: "Files" --> "HomeDirectory" --> "Open in Terminal"  
	- Then you will go to the terminal window.  
	
- Method 3
	```
	ssh urid@tinkercliffs1.arc.vt.edu
	interact --account=yourallocation --nodes=2 --ntasks-per-node=4 --cpus-per-task=8
	#interact A yourallocation

	interact --time=30 --account=<yourallocation> --nodes=2
 	#it will log in one node among the two requested for u.
 
	```	
## Steps to install and use R in ARC.
### Step1 
Connect your account to ARC. [See here](#connect-your-account-to-arc)


### Step2
*(follow this link: https://www.docs.arc.vt.edu/software/r.html)*
```
module list 
```
- To see how many modules you already have, especially check if singularity with specific version is there or not.
- In the first time, singularity will not be there. So we will use step3-4 to load it.
### Step3
updated 2023, new version of singularity.
```
module load containers/singularity/apptainer-wrapper
```
- to find the specific version of singularity exist in the module system.
### Step4
``` 
module load containers/singularity/3.8.5 #To load and install R in your own system.
module list #to check if singularity is there or not.
```
- In short, singularity is kind of a box of different softwares, which of course includes R, thus to install R, we just need to install singularity into our system.

### Step5 
(From here we are trying one Rscript example)
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
`squeue -u userid` to check status of your current jobs  
`scancel jobid` to cancel specific job  
`squeue -u` can see all the users  



## How to use Jupyter notebook on ARC. 
- [VT_ARC-QuickSetupGuide](https://github.com/yebigithub/ARC_cluster/blob/main/VT_ARC-QuickSetupGuide.pdf)  
This file is pretty useful for starting your jupyter notebook in ARC, thanks for the help from my peers in Deep Learning (2023 Fall ECE 6524)🌟🔥

```
###to delete unwanted jupyter kernel
jupyter kernelspec list
jupyter kernelspec uninstall dl_gpu
```

## How to install tensorflow-gpu on ARC.
```
##on a100 nodes:
interact --account=multiomicquantgen --partition=a100_normal_q -N 1 -n 12 --gres=gpu:1
module load Anaconda3/2020.11
module list ## make sure cuda is loaded if you are using the GPU
nvidia-smi  ## make sure you see GPUs
conda create -n tf_gpu python==3.9
source activate tf_gpu ## easy!
#then pip install needed packages.

python -m pip install tensorflow[and-cuda]

python -c "import tensorflow as tf; print(tf.config.list_physical_devices('GPU'))"
python -c "import tensorflow as tf; print('Num of GPU:', len(tf.config.list_physical_devices('GPU')))"
```



## How to install Pytorch-cuda on ARC.
```
##code to check if GPU tensorflow is installed successfully.
module load Anaconda3/2020.11
module list
module load cuda….
nvidia-sim
source activate DL_gpu
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
##tips: if dones’t run, may need to install more packages. Just follow the instructions.

##To install pytorch-cuda
python3 -c "import tensorflow as tf; print(tf.config.list_physical_devices('GPU'))"

##To test if torch cuda works
python -c “import torch; print(torch.cuda.is_available())”
```

## How to submit python job to ARC.
- First write your .py file. Here is one example for ResNet50 in tensorflow. [Sample image](yebigithub/ARC_cluster/elephant.jpeg). [Sample code](yebigithub/ARC_cluster/ResNetcode.py)

```ResNetcode.py```
```
import keras
from keras.applications.resnet50 import ResNet50, preprocess_input, decode_predictions
import numpy as np

# Load the model
model = ResNet50(weights='imagenet')

# Load and preprocess the image
img_path = 'elephant.jpeg'
img = keras.utils.load_img(img_path, target_size=(224, 224))
x = keras.utils.img_to_array(img)
x = np.expand_dims(x, axis=0)
x = preprocess_input(x)

# Perform the prediction
preds = model.predict(x)

# Decode the predictions into a list of tuples (class, description, probability)
decoded_preds = decode_predictions(preds, top=3)[0]

# Print the predictions
print('Predicted:', decoded_preds)

# Save the predictions to a text file
output_file = 'predictions.txt'
with open(output_file, 'w') as file:
    file.write('Predicted:\n')
    for class_id, description, score in decoded_preds:
        file.write(f'{class_id}: {description} ({score:.4f})\n')

print(f'Predictions saved to {output_file}')
```

- Following is the example .sh file ```run.sh``` for your to submit job. To submit it, simply run ```sbatch run.sh```

```run.sh```
```
#!/bin/bash

#SBATCH --job-name=ResNet50
#SBATCH -N 2
#SBATCH -n 6
#SBATCH --gres=gpu:2
#SBATCH -t 4:00:00
#SBATCH -p dgx_normal_q
#SBATCH -A animalcv    
#SBATCH --mem=60G 

module load apps site/tinkercliffs/easybuild/setup
module load Anaconda3/2024.02-1
source activate tf_gpu
module list

python ResNetcode.py

exit;
```

## Tips??
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

4. "quota" to check your current storage usage

5. Some code
```
### This just in case, not so helpful.

	interact --account=ece6524-spring2023 --partition=a100_dev_q -N 1 -n 12 --gres=gpu:1
	conda install -c conda-forge cudatoolkit=11.8.0
	python3 -m pip install nvidia-cudnn-cu11==8.6.0.163 tensorflow==2.12.*
	mkdir -p $CONDA_PREFIX/etc/conda/activate.d
	echo 'CUDNN_PATH=$(dirname $(python -c "import nvidia.cudnn;print(nvidia.cudnn.__file__)"))' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
	echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/:$CUDNN_PATH/lib' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
	source $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
	# Verify install:
	python3 -c "import tensorflow as tf; print(tf.config.list_physical_devices('GPU'))"

--------------------------------------------------
	module load cuda-latest/toolkit/11.4.2
	##To check gpu status
	nvidia-smi
	pip install nvidia-cudnn-cu11==8.6.0.163

	mkdir -p $CONDA_PREFIX/etc/conda/activate.d

	echo 'CUDNN_PATH=$(dirname $(python -c "import nvidia.cudnn;print(nvidia.cudnn.__file__)"))' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh

	echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/:$CUDNN_PATH/lib' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh

	source $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh

	pip install tensorflow==2.12
```


##Test
https://github.com/microsoft/vscode-remote-release/issues/1722
```
#!/bin/bash

#SBATCH --job-name="tunnel"
#SBATCH --time=8:00:00     # walltime

/usr/sbin/sshd -D -p 2222 -f /dev/null -h ${HOME}/.ssh/id_ecdsa # uses the user key as the host key

```
## Ref
https://medium.com/mlearning-ai/install-tensorflow-on-mac-m1-m2-with-gpu-support-c404c6cfb580
https://www.nrel.gov/hpc/eagle-interactive-jobs.html
