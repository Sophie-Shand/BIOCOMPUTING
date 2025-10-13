# Task 1 - already logged into bora and in my assignments directory

#create assignment_06 directory with script subdirectory and move into it

mkdir -p assignment_06/{scripts}

cd ./assignment_06

# Task 2 - download raw data with a script

#move into scripts dir

cd ./scripts

#create the script

nano 01_download_data.sh

## script START

#!/bin/bash

set -ueo pipefail

#create data directory here ./

mkdir data

#download into data dir -- I had to remove the ?download=1 at the end of the url from the doc

wget -P ./data https://zenodo.org/records/15730819/files/SRR33939694.fastq.gz

## script END - ctrl+o+enter, ctrl+x

#make it executable

chmod +x 01_download_data.sh

#sanity check

ll

#good!

#test it from main assignment directory

cd ..

./scripts/01_download_data.sh

#check

cd ./data

ls

#looks the same as the assignment doc example!

# Task 3 - local build Flye v2.9.6

#move back into scripts dir

cd ../scripts

#create manual build script

nano 02_flye_2.9.5_manual_build.sh

## script START

#!/bin/bash

set -ueo pipefail

#move to programs directory for the build

cd ~/programs

#copied instructions from INSTALL.md

git clone https://github.com/fenderglass/Flye

cd Flye

make

#go back to original directory

cd -

## script END

#edit permissions

chmod +x 02_flye_2.9.5_manual_build.sh

#sanity check

ll

#yup!

#run the script from parent dir

cd ..

./scripts/02_flye_2.9.5_manual_build.sh

#check that it's there

find ~/programs/Flye

#a lot got installed!

#add location of executable to PATH

export PATH=$PATH:~/programs/Flye/bin

#sanity check

echo $PATH

#it's there!

# Task 4 - conda build

#move into scripts dir

cd ./scripts

#create conda build script

nano 02_flye_2.9.5_conda_install.sh

## script START

#!/bin/bash

set -ueo pipefail

#load in the miniforge3 module

module load miniforge3

#initialize conda.sh

source "$(dirname $(dirname $(which conda)))/etc/profile.d/conda.sh"

#set up the env

mamba create -y -n flye-env -c bioconda flye

#activate the env

conda activate flye-env

#document the environment

conda env export --no-builds > flye-env.yml

#deactivate

conda deactivate

## script END

#change permissions

chmod +x 02_flye_2.9.5_conda_install.sh

ll

#looks good, ready to test!

cd ..

#test

./scripts/02_flye_2.9.5_conda_install.sh

# Task 5 - Using Flye

#learn more

flye --help #also look through github

> Things learned:
> * For the most recent high-quality data from oxford nanopore, I should use --nano-hq before my filename
> * You can use --meta to specify that there might be more than one phage
> * Google says the size might be about 43-170kb, I can use -g 100kb
> * -t 6 will keep it at 6 threads
> * A lot of directories and files other than assembly and log are created as outputs
> * Using the meta tag changed the assembly output from 1 contig to 2 contigs with 200kb, 100kb also produced 2 contigs

#my flye command:

flye --nano-hq ./data/SRR33939694.fastq.gz --meta -o test -g 100k --threads 6

#the nano-hq is for nanopore high quality data, meta is for multiple genomes, 

#o is the output directory (I used a test dir)

#g is the expected size, threads is how many nodes I'm using

# Task 6A - conda run

#create the script

nano 03_run_flye_conda.sh

## script START

#!/bin/bash

set -ueo pipefail

#load in conda and initiate

module load miniforge3

source "$(dirname $(dirname $(which conda)))/etc/profile.d/conda.sh"

#activate flye-env

conda activate flye-env

#create assemblies and assembly_conda directories

mkdir -p assemblies/assembly_conda

#run flye and store the output into assembly_conda

flye --nano-hq ./data/SRR33939694.fastq.gz --meta -o assemblies/temp -g 100k --threads 6

#copy and paste the files of interest into the conda directory and rename them

mv ./assemblies/temp/assembly.fasta ./assemblies/assembly_conda/conda_assembly.fasta

mv ./assemblies/temp/flye.log ./assemblies/assembly_conda/conda_flye.log

#delete the temp directory

rm -rf ./assemblies/temp

#deactivate flye-env

conda deactivate

## script END

#add permissions

chmod +x 03_run_flye_conda

#san check

ll

#looks good

#test it from parent dir

cd ..

./scripts/03_run_flye_conda.sh

#check output is what I expect

ls -l ./assemblies

ls -l ./assemblies/assembly_conda

#looks good

# Task 6B - module

#create the script

nano 03_run_flye_module.sh

## script START

#!/bin/bash

set -ueo pipefail

#load in the module Flye

module load Flye

#create assemblies and assembly_module directories

mkdir -p assemblies/assembly_module

#run flye and store the output into assembly_module

flye --nano-hq ./data/SRR33939694.fastq.gz --meta -o assemblies/temp -g 100k --threads 6

#copy and paste the files of interest into the module directory and rename them

mv ./assemblies/temp/assembly.fasta ./assemblies/assembly_module/module_assembly.fasta

mv ./assemblies/temp/flye.log ./assemblies/assembly_module/module_flye.log

#delete the temp directory

rm -rf ./assemblies/temp

## script END

#add permissions

chmod +x 03_run_flye_module.sh

#san check

ll

#test

cd ..

./scripts/03_run_flye_module.sh

#check output is what I expect

ls -l ./assemblies

ls -l ./assemblies/assembly_module

#looks good

# Task 6C - local

#create the script

nano 03_run_flye_local.sh

## script START

#!/bin/bash

set -ueo pipefail

#Flye should already be in programs from local install

#add Flye to $PATH so you can call Flye from anywhere

export PATH=$PATH:~/programs/Flye/bin

#create assemblies and assembly_local directories

mkdir -p assemblies/assembly_local

#run flye and store the output into assembly_local

flye --nano-hq ./data/SRR33939694.fastq.gz --meta -o assemblies/temp -g 100k --threads 6

#copy and paste the files of interest into the module directory and rename them

mv ./assemblies/temp/assembly.fasta ./assemblies/assembly_local/local_assembly.fasta

mv ./assemblies/temp/flye.log ./assemblies/assembly_local/local_flye.log

#delete the temp directory

rm -rf ./assemblies/temp

## script END

#add permissions

chmod +x 03_run_flye_module.sh

#san check

ll

#test

cd ..

./scripts/03_run_flye_local.sh

#check output is what I expect

ls -l ./assemblies

ls -l ./assemblies/assembly_module

#looks good

# Task 7 - compare results

#conda

tail -n 10 $(find ./assemblies/assembly_conda/conda_flye.log)

#module

tail -n 10 $(find ./assemblies/assembly_module/module_flye.log)

#local

tail -n 10 $(find ./assemblies/assembly_local/local_flye.log)

#All outputs look the exact same!

# Task 8 - pipeline script

nano pipeline.sh

## script START

#!/bin/bash

set -ueo pipefail

#run the download script 

./scripts/01_download_data.sh

#run install/build scripts

./scripts/02_flye_2.9.5_conda_install.sh

./scripts/02_flye_2.9.5_manual_build.sh

#run all run scripts

./scripts/03_run_flye_conda.sh

./scripts/03_run_flye_local.sh

./scripts/03_run_flye_module.sh

#print last 10 lines of each log file

echo -e "CONDA RESULTS\n$(tail -n 10 $(find ./assemblies/assembly_conda/conda_flye.log))\nMODULE RESULTS\n$(tail -n 10 $(find ./assemblies/assembly_module/module_flye.log))\nLOCAL RESULTS\n$(tail -n 10 $(find ./assemblies/assembly_local/local_flye.log))"

## script END

#add permissions

chmod +x pipeline.sh

#san check

ll #nice

# Task 9

#delete everything but scripts

rm -rf assemblies

rm -rf data

rm flye-env.yml

cd ../../../programs

rm -rf Flye

cd ../BIOCOMPUTING/assignments/assignment_06

#test the pipeline script

./pipeline.sh

# Task 10

## Reflection

> This assignment got me thinking a lot about paths and reproducibility. I felt pretty confident installing and 
> building environments on my own computer, but it was difficult to think about how things would look on someone
> else's computer. It was also nerve-wracking that that's not something I can really test for.
> Another challenge I had to tackle was the fact that Flye takes a while to run, so every time
> there was a bug in my script, it was a huge time cost. Something that helped was running my scripts
> by chatgpt and asking it if it would run correctly/what the expected output is. That wasn't fool proof, however.
> Something else that surprised me was a bug in my install conda script that I didn't notice until I
> had built my pipeline script. It turned out that I had forgotten to actually specify that I wanted
> flye when I built my conda environment. I had mamba create -y -n flye-env and that's it!
> I didn't run into any issues when I first created that script because I created it in the same
> work session as I had done my local build! So when I checked my conda script, everything worked fine
> because Flye did exist in my path from my local build. However, when I tested my pipeline
> I had logged out of the hpc and logged back in so Flye was gone from my path. The error message
> helped me locate the exact line where it failed, and I figured it out from there.
> I also learned that environments you activate within a subshell from a script, will not
> usually carry over to your original shell from which you ran the script. I was not expecting that.
> With conda, I didn't like having to initialize every time, I thought it was a bit of a tedious process.
> I prefer the module load to set up the software since it is the easiest, but I could see myself
> feeling frustrated in the future by how it restricts which version I can load in. The local
> build was a bit more tedious (but not as tedious as conda) but gave me the most control which
> I appreciate.
