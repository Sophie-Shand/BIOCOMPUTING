# Task 1

#once logged into bora and in assignments dir...

#here I'm building my assignment_05 tree in one line.

mkdir -p assignment_05/{scripts,log,data/{raw,trimmed}}

# Task 2

#move into the scripts directory

cd ./assignment_05/scripts

#create and edit download scripts

nano 01_download_data.sh

#Inside script STARTS:

#!/bin/bash

set -ueo pipefail

#define direct paths to the directory of interest, change paths as necessary

MAIN_DIR=${HOME}/BIOCOMPUTING/assignments/assignment_05

RAW_DATA_DIR=${MAIN_DIR}/data/raw

#move into the raw data directory

cd ${RAW_DATA_DIR}

#get tarball from url

wget https://gzahn.github.io/data/fastq_examples.tar

#download and extract contents of tar ball

tar -xf fastq_examples.tar

#clean up the .tar file

rm fastq_examples.tar

#Script ENDS - crtl+o+enter+x

#check access

ll

#not executable!

chmod +x 01_download_data.sh

#sanity check

ll

#looks good!

#test it

./01_download_data.sh

#sanity check

cd ../data/raw

ll

#lots of new files!

# Task 3

#move to programs dir

cd ~/programs

#follow instructions to download latest prebuilt binary for Linux users fastp tool:

wget http://opengene.org/fastp/fastp

chmod a+x ./fastp

# Task 4

#create and edit script

nano 02_run_fastp.sh

#Inside script STARTS

#!/bin/bash

set -ueo pipefail

#set the 4 arguments for fastp, the only argument this script takes is one forward read

FWD_IN=${1} #the given argument (input)

REV_IN=${FWD_IN/_R1_/_R2_} #define the name of the reverse file

FWD_OUT=${FWD_IN/.fastq.gz/.trimmed.fastq.gz} #the desired name for the trimmed forward file

REV_OUT=${REV_IN/.fastq.gz/.trimmed.fastq.gz} #the desired name for the trimmed reverse file

#call fastp, with our 2 inputs and 2 outputs as defined above. Do not give an html or json file as output.

fastp --in1 $FWD_IN --in2 $REV_IN --out1 ${FWD_OUT/raw/trimmed} --out2 ${REV_OUT/raw/trim> --json /dev/null --html /dev/null

#Script ENDS - crtl+o+enter+x

#make it executable

chmod +x 02_run_fastp.sh

#move into assignment_05 dir

cd ..

#test it

./scripts/02_run_fastp.sh ./data/raw/6083_001_S1_R1_001.subset.fastq.gz

cd ./data/trimmed

ls

#looks good!

cd ../..

# Task 5

#create pipeline script

nano pipeline.sh

#START:

#!/bin/bash

set -ueo pipefail

#run the data script to download our desired data

./scripts/01_download_data.sh

#for loop which iterates over each forward file in raw data and runs the run script

for i in ./data/raw/*R1*; do ./scripts/02_run_fastp.sh ${i}; done

#END - ctrl+o+enter+x

#edit permissions

chmod +x pipeline.sh

#sanity check

ll

#looks good!

#TEST IT!

./pipeline.sh

#check if it produced trimmed files

cd ./data/trimmed

ll

#looks great!

# Task 6

rm ./data/raw/*.gz ./data/trimmed/*.gz

#sanity check

cd ./data/raw

ls

#all gone

cd ../..

#test it again

./pipeline.sh

#sanity check

cd ./data/trimmed

ls

#looks good!

cd ../..

# Task 7

cd ./log

nano README.md

## Reflection

> This assignment didn't feel as challenging as the last one for me. I felt pretty comfortable creating bash scripts. One thing that would make me pause was thinking about where my scripts exist in relation to one another, since their relative paths were important when running the scripts, or even when thinking about accessing files. We split this up into two scripts which are called in one overall script to simplify troubleshooting and because it is safer to split things up in case something fails along the way. A downside of this approach is that it uses up more memory.

# Task 8

#put all files in .gitignore file

cd ..

nano .gitignore

#START:

6083*

fastp.html

fastp.json

#END - ctrl+o+enter+x
