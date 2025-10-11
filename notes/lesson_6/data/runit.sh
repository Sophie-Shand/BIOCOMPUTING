#!/bin/bash

bbmap.sh ref=ecoli_bl21de3.fasta  in=lambda_reads.fastq out=mapping.sam nodisk=t ambiguous=best minid=0.9 threads=2 # only use a couple threads

