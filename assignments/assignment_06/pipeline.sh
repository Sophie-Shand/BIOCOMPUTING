#!/bin/bash

set -ueo pipefail

#run the download script

./scripts/01_download_data.sh

#run install/build scripts

./scripts/02_flye_2.9.5_conda_install.sh

./scripts/02_flye_2.9.5_manual_build.sh

#run all run scripts

./scripts/03_run_flye_conda.sh

./scripts/03_run_flye_local.sh

./scripts/03_run_flye_module.sh

#print last 10 lines of each log file

echo -e "CONDA RESULTS\n$(tail -n 10 $(find ./assemblies/assembly_conda/conda_flye.log))\nMODULE RESULTS\n$(tail -n 10 $(find ./assemblies/assembly_module/module_flye.log))\nLOCAL RESULTS\n$(tail -n 10 $(find ./assemblies/assembly_local/local_flye.log))"

