#!/bin/bash
set -ueo pipefail

#n_files=0

#for i in ${1}; do n_files=n_files+1; echo ${n_files}; done

ls -1 ${1} | wc -l

#find $1 | wc -l
