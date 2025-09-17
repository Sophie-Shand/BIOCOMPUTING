# Sophie Shand, Sept 18 2025, Assignment 03

# Task 1

#once inside hpc, navigate to assignment_03

cd ./BIOCOMPUTING/assignments/assignment_03

# Task 2

#make a folder for the data to go into

mkdir data

cd ./data

#download

wget https://gzahn.github.io/data/GCF_000001735.4_TAIR10.1_genomic.fna.gz

#uncompress

gunzip GCF_000001735.4_TAIR10.1_genomic.fna.gz

#sanity check

ll

#looks good

# Task 3

## Q1 - number of sequences in file

grep -c "^>" GCF_000001735.4_TAIR10.1_genomic.fna

#output is 7

## Q2 - number of nucleotides

grep -v "^>" GCF_000001735.4_TAIR10.1_genomic.fna | tr -d "\n" | wc -c

#output is 119668634

## Q3 - total lines in file

wc -l GCF_000001735.4_TAIR10.1_genomic.fna

#output is 14

## Q4 - number of header lines with "mitochondrion"

grep "^>" GCF_000001735.4_TAIR10.1_genomic.fna | grep -c "mitochondrion"

#output is 1

## Q5 - number of header lines with "chromosome"

grep "^>" GCF_000001735.4_TAIR10.1_genomic.fna | grep -c "chromosome"

#output is 5

## Q6 - number of nucleotides in each of the first three chromosome sequences

#first chrom seq

grep "chromosome" -A 1 GCF_000001735.4_TAIR10.1_genomic.fna | head -n 6 | grep -v "^>" | head -n 1 | wc -c

#output is 30427672

#second chrom seq

grep "chromosome" -A 1 GCF_000001735.4_TAIR10.1_genomic.fna | head -n 6 | grep -v "^>" | head -n 2 | tail -n 1 | wc -c

#output is 19698290

#third chrom seq

grep "chromosome" -A 1 GCF_000001735.4_TAIR10.1_genomic.fna | head -n 6 | grep -v "^>" | tail -n 1 | wc -c

#output is 23459831

## Q7 - number of nucleotides in the chromosome 5 sequence

grep "chromosome 5" -A 1 GCF_000001735.4_TAIR10.1_genomic.fna | tail -n 1 | wc -c

#output is 26975503

## Q8 - number of sequences containing "AAAAAAAAAAAAAAAA"

grep "AAAAAAAAAAAAAAAA" GCF_000001735.4_TAIR10.1_genomic.fna | wc -l

#output is 1

## Q9 - which header contains the first sequence sorted alphabetically

grep -B 1 -f <(sort GCF_000001735.4_TAIR10.1_genomic.fna | head -n 1) GCF_000001735.4_TAIR10.1_genomic.fna | head -n 1

#output is >NC_037304.1 Arabidopsis thaliana ecotype Col-0 mitochondrion, complete genome

## Q10 - tab separated file of the sequence headers and their corresponding sequences

paste <(grep "^>" GCF_000001735.4_TAIR10.1_genomic.fna) <(grep -v "^>" GCF_000001735.4_TAIR10.1_genomic.fna) > tsv_GCF_000001735.4_TAIR10.1_genomic.fna

# Task 4

nano README.md

#at this point I will add all my steps I've been saving in a text editor in the READMED file and write up my reflection!

# Task 5 - Reflection

### Normally, when I am faced with a file of data, my first instinct is to look at its first few lines to gain a sense of what I’m working with. However I quickly discovered that these sequences were way too long to look at (I used ctrl+C many times throughout the assignment). The most I could do was look at the very first line. I had the table of commands we learned from the class notes out, and for every question I would look over them. Since I couldn’t always check every step in my pipelines (since the output was sometimes way too long) I had to think hard about how each command would function and what the output would look like. It took some trial and error, but it helped me get very familiar with the different commands available to me. For example, in question 2 (Task 3), I had to realize that the line breaks would be counted as characters in the command wc -c, so I had to remove them with tr -d.

### I felt frustrated with Q6 because I wanted a way to get all three outputs in one command, but I could not think of any way to do that.

### I struggled the most with Q9. My instinct was to directly feed the sequence line into grep in order to pull out its accompanying header. I tried to use variables or $() but I kept getting error messages that the argument I was giving grep was too long. Finally, after searching around and using grep --help, I discovered that I could feed grep a file, so I was able to create a vanishing file and get the desired output that way.

### Being able to manipulate sequence data through a command-line interface is crucial to working with genetic data. In this assignment, I felt that I came face to face with just how large genetic data is. Being able to parse through the data, and pipe outputs to other commands directly is necessary to avoid wasting computing time.
