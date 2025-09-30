#!/bin/bash
set -ueo pipefail

MAIN_DIR=${HOME}/BIOCOMPUTING/notes/lesson_5

cd ${MAIN_DIR}

seqkit stats ./data/*.fastq
