#!/bin/bash
#SBATCH --job-name=assignment_7
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --time=1-00:00:00 # 1 day
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH --mail-user=sshand@wm.edu
#SBATCH -o /sciclone/home/sshand/BIOCOMPUTING/assignments/assignment_07/output/%x_%j.out
#SBATCH -e /sciclone/home/sshand/BIOCOMPUTING/assignments/assignment_07/output/%x_%j.err

set -euo pipefail

#create output directory for SLURM output files (separate from output dir in scr10 space)

mkdir -p ./output

#add program install locations to path for datasets, fastp, and fasterq-dump

export PATH=$PATH:/sciclone/home/sshand/programs #datasets, fastp

export PATH=$PATH:/sciclone/home/sshand/programs/sratoolkit.3.2.1-ubuntu64/bin #fasterq-dump

export PATH=$PATH:/sciclone/home/sshand/programs/tree #tree for the sanity checks

#sanity check

echo "Here is your path, here we go!"

echo $PATH

#run script 1!

./scripts/01_download_data.sh

#sanity check for script 1

echo "This is the scr10 directory structure after running script 1!"

tree ${HOME}/scr10

echo "This is the assignment directory structure after running script 1!"

tree

#run script 2!

./scripts/02_clean_reads.sh

#sanity check for script 2

echo "This is the scr10 directory structure after running script 2!"

tree ${HOME}/scr10

echo "This is the assignment directory structure after running script 2!"

tree

#run script 3!

./scripts/03_map_reads.sh

#sanity check for script 3

echo "This is the scr10 directory structure after running script 3!"

tree ${HOME}/scr10

echo "This is the assignment directory structure after running script 3!"

tree
