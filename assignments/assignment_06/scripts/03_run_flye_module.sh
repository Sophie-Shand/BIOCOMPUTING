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
