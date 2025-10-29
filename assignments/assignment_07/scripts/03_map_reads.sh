#!/bin/bash

set -euo pipefail

#set up the output directory in scratch 10

mkdir -p ${HOME}/scr10/output

#load in bbmap-env with conda

module load miniforge3

source "$(dirname $(dirname $(which conda)))/etc/profile.d/conda.sh"

conda activate bbmap-env

#use for loop that uses variable names for the desired fwd, rev, and out filenames
#use same for loop to run bbmap over each file in the clean directory
#use minid of 0.95 and specify max memory at 24GB because bbmap help function recommended 24g for human genome, dog genome is similar size

for i in ${HOME}/scr10/data/clean/*_1.clean.fastq; do fwd=${i}; rev=${fwd/_1.clean.fastq/_2.clean.fastq}; out=${fwd/_1.clean.fastq/.sam}; bbmap.sh -Xmx24g ref=${HOME}/scr10/data/dog_reference/dog_reference_genome.fna in1=$fwd in2=$rev out=$out minid=0.95; done

#move all .sam files to output directory

mv ${HOME}/scr10/data/clean/*.sam ${HOME}/scr10/output/

#deactivate conda

conda deactivate

#load in samtools module; MUST BE AVAILABLE ON HPC

module load samtools

#using samtools in a for loop to extract matched reads

for i in ${HOME}/scr10/output/*.sam; do out=${i/.sam/_dog-matches.sam}; samtools view -F 4 ${i} > $out; done

#clean up ref folder created by bbmap

rm -rf ./ref
