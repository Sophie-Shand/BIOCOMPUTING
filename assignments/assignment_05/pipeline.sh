#!/bin/bash

set -ueo pipefail

#run the install script

./scripts/01_download_data.sh

#for loop which iterates over each forward file in raw data and runs the run script

for i in ./data/raw/*R1*; do ./scripts/02_run_fastp.sh ${i}; done
