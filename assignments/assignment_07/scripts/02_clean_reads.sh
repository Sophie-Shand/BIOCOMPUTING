#!/bin/bash

set -euo pipefail

#define variables for the arguments and run fastp on every read pairs using
# a for loop
#set quality control to 20 with --average_qual

for i in ${HOME}/scr10/data/raw/*_1.fastq; do FWD_IN=${i}; REV_IN=${FWD_IN/_1.fastq/_2.fastq}; FWD_OUT=${FWD_IN/.fastq/.clean.fastq}; REV_OUT=${REV_IN/.fastq/.clean.fastq}; fastp --in1 $FWD_IN --in2 $REV_IN --out1 ${FWD_OUT/raw/clean} --out2 ${REV_OUT/raw/clean} --json /dev/null --html /dev/null --average_qual 20; done

