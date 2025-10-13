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
