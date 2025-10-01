#!/bin/bash
set -ueo pipefail
#define direct paths to the directory of interest
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
