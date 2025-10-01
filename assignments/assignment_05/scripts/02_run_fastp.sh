#!/bin/bash

set -ueo pipefail

#set the 4 arguments for fastp, the only argument this script takes is one forward read

FWD_IN=${1} #the given argument (input)

REV_IN=${FWD_IN/_R1_/_R2_} #define the name of the reverse file

FWD_OUT=${FWD_IN/.fastq.gz/.trimmed.fastq.gz} #the desired name for the trimmed forward file

REV_OUT=${REV_IN/.fastq.gz/.trimmed.fastq.gz} #the desired name for the trimmed reverse file

#call fastp, with our 2 inputs and 2 outputs as defined above. Do not give an html or json report file as output.

fastp --in1 $FWD_IN --in2 $REV_IN --out1 ${FWD_OUT/raw/trimmed} --out2 ${REV_OUT/raw/trimmed} --json /dev/null --html /dev/null
