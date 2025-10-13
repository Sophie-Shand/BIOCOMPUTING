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

