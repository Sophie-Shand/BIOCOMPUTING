#!/bin/bash
#SBATCH --job-name=myfirstjob
#SBATCH --nodes=1 #how many physical machines in the cluster
#SBATCH --ntasks=1 #how many separate tasks
#SBATCH --cpus-per-task=1 #how many cores (max is 20)
#SBATCH --time=1 # d-hh:mm:ss or just No. of minutes, max is 2 days
#SBATCH --mem=1G # how much physical memory (all by default)
#SBATCH --mail-type=FAIL,BEGIN,END # when to email you
#SBATCH --mail-user=sshand@wm.edu # who to email
#SBATCH -o firstjob_%j.out # STDOUT to file (%j is jobID)
#SBATCH -e firstjob_%j.err # STDERR to file (%j is jobID)
echo "Hello world!"
