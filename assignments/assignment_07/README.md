# Introduction
> This readme describes all steps taken to complete Assignment 7 for APSC 460.
> The followings tools are needed available from the user's path:
>> fasterq-dump (from NCBI), datasets (from NCBI), fastp
>>
>> tree (used for sanity checks in slurm pipeline, not critical)
>
> The following tools are also needed:
>> A bbmap environment set up with conda needs to be set up before running the scripts. It needs to be called bbmap-env
>>
>> Script 03_map_reads.sh requires a samtools module to be available to load in.

# Task 1 - setting up assignment structure

#starting logged into bora, inside my assignment 7 directory

#a directory containing a scripts and data directory is required before running the pipeline script

mkdir scripts data

# Task 2 - Downloading sequence data from SRA

## SRA Search

> The following search terms were used
>
>> (soil[All Fields] AND communities[All Fields]) AND "peat metagenome"[orgn] AND ("biomol dna"[Properties] AND "strategy wgs"[Properties] AND "library layout paired"[Properties] AND "platform illumina"[Properties] AND "filetype fastq"[Properties])
>
> Within the run selector, results were filtered to "RANDOM" only within the LibrarySelection field

#the first 10 lines were selected and downloaded using the metadata option in the run selector

## Move the downloaded csv file to the remote server on the hpc

#the downloaded csv table is called SraRunTable.csv and exists in my local Desktop directory

#in a NEW shell window that is not connected to the hpc, I will move into my Desktop dir

cd ./Desktop #specific to user's computer

#sftp into hpc

sftp sshand@bora.sciclone.wm.edu

#move into data directory in assignment 7

cd ./BIOCOMPUTING/assignments/assignment_07/data

#put the run table in that directory from the local server

put SraRunTable.csv

#exit sftp

bye

#you can now close that shell window and return to the bora window

#sanity check

ls -l ./data

#looks good

## Create a script

#move into scripts dir

cd ./scripts

#make download script

nano 01_download_data.sh

## Script START

#!/bin/bash

set -euo pipefail

#make data directory in scr10

mkdir -p ${HOME}/scr10/data/{raw,clean}

#loop through the first column of SRA run table starting at the second row and 
#use fasterq-dump to download the data and put it into raw directory in data directory

for i in $(cut -d "," -f 1 ./data/SraRunTable.csv | tail -n +2); do fasterq-dump $i -O ${HOME}/scr10/data/raw; done

#prepare dog_reference directory

mkdir -p ${HOME}/scr10/data/dog_reference

#download reference dog genome for the taxon *Canis lupus familiaris*

datasets download genome taxon "Canis lupus familiaris" --reference --filename ${HOME}/scr10/data/dog_reference/dog_reference_genome.zip

#unzip it in a temporary file that will contain all the bloat to be deleted

unzip ${HOME}/scr10/data/dog_reference/dog_reference_genome.zip -d ${HOME}/scr10/data/dog_reference/temp

#move the .fna file of interest out of the temp directory

mv $(find ${HOME}/scr10/data/dog_reference/temp -name *.fna) ${HOME}/scr10/data/dog_reference/dog_reference_genome.fna

#delete the bloat

rm -rf ${HOME}/scr10/data/dog_reference/temp

#delete the zip file

rm ${HOME}/scr10/data/dog_reference/dog_reference_genome.zip

## Script END

#make it executable

chmod 755 01_download_data.sh

# Task 3 - Trim the sequences with fastp

## All default parameters for fastp will be used.

#create fastp script

nano 02_clean_reads.sh

## Script START

#!/bin/bash

set -euo pipefail

#define variables for the arguments and run fastp on every read pairs using a for loop
#set quality control to 20 with --average_qual

for i in ${HOME}/scr10/data/raw/*_1.fastq; do FWD_IN=${i}; REV_IN=${FWD_IN/_1.fastq/_2.fastq}; FWD_OUT=${FWD_IN/.fastq/.clean.fastq}; REV_OUT=${REV_IN/.fastq/.clean.fastq}; fastp --in1 $FWD_IN --in2 $REV_IN --out1 ${FWD_OUT/raw/clean} --out2 ${REV_OUT/raw/clean} --json /dev/null --html /dev/null --average_qual 20; done

## Script END

#make it executable

chmod 755 02_clean_reads.sh

# Task 4 and 5 - Map clean reads to dog genome and extract them!

#create the mapping script

nano 03_map_reads.sh

## Script START

#!/bin/bash

set -euo pipefail

#set up the output directory in scratch 10

mkdir -p ${HOME}/scr10/output

#load in bbmap-env with conda

module load miniforge3

source "$(dirname $(dirname $(which conda)))/etc/profile.d/conda.sh"

conda activate bbmap-env

#use for loop that uses variable names for the desired fwd, rev, and out filenames
#use same for loop to run bbmap over each file in the clean directory
#use minid of 0.95 and specify max memory at 24GB because bbmap help function recommended 24g for human genome, dog genome is similar size

for i in ${HOME}/scr10/data/clean/*_1.clean.fastq; do fwd=${i}; rev=${fwd/_1.clean.fastq/_2.clean.fastq}; out=${fwd/_1.clean.fastq/.sam}; bbmap.sh -Xmx24g ref=${HOME}/scr10/data/dog_reference/dog_reference_genome.fna in1=$fwd in2=$rev out=$out minid=0.95; done

#move all .sam files to output directory

mv ${HOME}/scr10/data/clean/*.sam ${HOME}/scr10/output/

#deactivate conda

conda deactivate

#load in samtools module; MUST BE AVAILABLE ON HPC

module load samtools

#using samtools in a for loop to extract matched reads

for i in ${HOME}/scr10/output/*.sam; do out=${i/.sam/_dog-matches.sam}; samtools view -F 4 ${i} > $out; done

## Script END

#make it executable

chmod 755 03_map_reads.sh

# Task 6 - Submit to SLURM

#get out of scripts directory

cd ..

#make pipeline slurm job!

nano assignment_7_pipeline.slurm

## Script START

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

#create output directory for SLURM output files (separate from output directory in scr10 space)

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

## Script END

#make it executable

chmod 755 assignment_7_pipeline.slurm

#run it!

sbatch assignment_7_pipeline.slurm

# Task 8 - Summarize results in a table

#move into output directory

cd ./output

#create headings for the summary table text file (tab separated)

echo "Sample ID	Total Reads	Dog-Mapped Reads" >> summary_table.txt

#move back into main directory for assignment

cd ..

#create a slurm job to count the number of reads in the fastq files--it's a slow process!

nano summary_table.slurm

## Script START

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

for i in ${HOME}/scr10/data/clean/*_1.clean.fastq; do i=${i%%_*}; sample_id=${i##*/}; total_reads=$(grep -c "^@SRR" ${i}_1.clean.fastq); dog_reads=$(grep -c "^SRR" ${HOME}/scr10/output/${sample_id}_dog-matches.sam);
echo "${sample_id}	${total_reads}	${dog_reads}" >> ./output/summary_table.txt; done

## Script END

#make it executable

chmod 755 summary_table.slurm

#run it!

sbatch summary_table.slurm

## Here is the result of my summary table:

>Sample ID      Total Reads      Dog-Mapped Reads
>
>SRR10854750      40128171      2186
>
>SRR10854759       82802743      6764
>
>SRR10854783       29233145      1917
>
>SRR10854792      40754269      4532
>
>SRR10854808      33296002      2581
>
>SRR10854813      34502569      2496
>
>SRR10854814       34949782      9624
>
>SRR10854827      32081674      3202
>
>SRR10854829      32310004      5546
>
>SRR10854835      33772547      3664

# Task 9 - Reflection

>This assignment was exciting. It felt like a lot of different concepts were coming together. 
>I also felt more comfortable using different tools and loading them in different ways. 
>Understanding how these tools take in files was still a little tricky. The hardest part 
>was the parameter expansion and making sure that every file was accessible and would expand 
>correctly. Not being able to check my scripts was really nerve wracking. Looking back, 
>I should've taken the time to play around with a dataset of small reads. I was so antsy 
>to submit my job to the slurm since I didn't know how long it would take, that I think I rushed 
>the script making part a little bit more than I should've. I didn't submit my job completely blind, however. 
>I first read through all of my scripts and used a whiteboard to write out with the outputs would be, 
>how different file names/paths would expand, and how the tree of my directory would build out. 
>I also copied and pasted my entire readme containing all of my scripts to chatgpt and asked 
>it to verify that everything would work as expected. Chatgpt did catch two critical mistakes 
>in my file paths. However, it was pretty persnickety about a lot of things, and it didn't 
>catch one remaining typo that caused my job to fail after 7 hours. 
>In the end, however, the trial and error portion with the hpc still wasn't as bad as I expected. 
>I learned the hard way that I need to put my data directly into the scratch space, 
>but I was still able to rerun my updated scripts in time to verify that my new filepaths 
>into the scratch space wouldn't cause any issues. Finally, I ran into some issues when making my summary table. 
>It turns out that grep takes a really long time when a file contains over 40 million reads. 
>It also takes a long time when all those files are stored in the scratch space. But luckily I was 
>able to whip up a slurm script and the hpc turned a ~20 minute per file process into a 3 min per 10 file process!
> Overall, this assignment really solidified concepts from past assignments and lessons and helped me see the bigger picture.
