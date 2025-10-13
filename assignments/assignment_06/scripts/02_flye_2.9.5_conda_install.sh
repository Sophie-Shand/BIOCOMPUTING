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

