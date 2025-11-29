#!/bin/bash
#SBATCH --job-name=Practice
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --time=10
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH --mail-user=sshand@wm.edu
#SBATCH -o /sciclone/home/sshand/logs/%x_%j.out
#SBATCH -e /sciclone/home/sshand/logs/%x_%j.err

echo "Hello world!"
