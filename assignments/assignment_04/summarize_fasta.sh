# save the filename argument as a variable

name_file=${1}

# store as variable number of sequences

seq_num=$(cut -f 1 <(seqtk size ${1}))

# store as variable number of nucleotides

nuc_num=$(cut -f 2 <(seqtk size ${1}))

# create a table of sequence names and lengths and store as variable

table=$(seqtk comp ${1} | cut -f1,2)

# report the info

echo "The file $name_file contains $seq_num number of sequences and a total of $nuc_num number of nucleotides. Each of the sequence names and lengths are as follows"
echo "$table"
