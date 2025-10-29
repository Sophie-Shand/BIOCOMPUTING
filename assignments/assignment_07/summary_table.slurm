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

#create variables for the sample ID, total reads, and dog mapped reads
#these are tab separated in the echo command

for i in ${HOME}/scr10/data/clean/*_1.clean.fastq; do i=${i%%_*}; sample_id=${i##*/}; total_reads=$(grep -c "^@SRR" ${i}_1.clean.fastq); dog_reads=$(grep -c "^SRR" ${HOME}/scr10/output/${sample_id}_dog-matches.sam); echo "${sample_id}	${total_reads}	${dog_reads}" >> ./output/summary_table.txt; done
