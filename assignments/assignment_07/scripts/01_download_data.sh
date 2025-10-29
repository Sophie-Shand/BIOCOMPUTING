#!/bin/bash

set -euo pipefail

#make data directory in scr10

mkdir -p ${HOME}/scr10/data/{raw,clean}

#loop through the first column of SRA run table starting at the second row and 
#use fasterq-dump to download the data and put it into raw directory in data directory

for i in $(cut -d "," -f 1 ./data/SraRunTable.csv | tail -n +2); do fasterq-dump $i -O ${HOME}/scr10/data/raw; done

#prepare dog_reference directory

mkdir -p ${HOME}/scr10/data/dog_reference

#download reference dog genome for the taxon *Canis lupus familiaris*

datasets download genome taxon "Canis lupus familiaris" --reference --filename ${HOME}/scr10/data/dog_reference/dog_reference_genome.zip

#unzip it in a temporary file that will contain all the bloat to be deleted

unzip ${HOME}/scr10/data/dog_reference/dog_reference_genome.zip -d ${HOME}/scr10/data/dog_reference/temp

#move the .fna file of interest out of the temp directory

mv $(find ${HOME}/scr10/data/dog_reference/temp -name *.fna) ${HOME}/scr10/data/dog_reference/dog_reference_genome.fna

#delete the bloat

rm -rf ${HOME}/scr10/data/dog_reference/temp

#delete the zip file

rm ${HOME}/scr10/data/dog_reference/dog_reference_genome.zip
