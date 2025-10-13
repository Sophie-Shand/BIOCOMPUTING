#!/bin/bash

set -ueo pipefail

#create data directory here ./

mkdir data

#download into data dir

wget -P ./data https://zenodo.org/records/15730819/files/SRR33939694.fastq.gz

