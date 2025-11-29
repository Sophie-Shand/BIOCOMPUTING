#!/bin/bash
#SBATCH --job-name=qc
#SBATCH --nodes=1 # how many physical machines in the cluster
#SBATCH --ntasks=1 # how many separate 'tasks' (stick to 1)
#SBATCH --cpus-per-task=20 # how many cores (bora max is 20)
#SBATCH --time=1-00:00:00 # d-hh:mm:ss or just No. of minutes
#SBATCH --mem=120G # how much physical memory (all by default)
#SBATCH --mail-type=FAIL,BEGIN,END # when to email you
#SBATCH --mail-user=sshand@wm.edu # who to email
#SBATCH -o /sciclone/home/sshand/logs/%x_%j.out # change this!
#SBATCH -e /sciclone/home/sshand/logs/%x_%j.err # change this!

./scripts/02_qc.sh

