#!/bin/bash

set -ueo pipefail

#create data directory and output directory
#download tarball and place into raw directory within data directory
#unpack tar ball to extract fastq files
./scripts/01_prep_data.sh

#save information using seqkit stats command about all of the fastq files
#save info in text file in output directory
./scripts/02_get_stats.sh

#remove downloaded tar ball (NOT unzipped files)
./scripts/03_cleanup.sh
