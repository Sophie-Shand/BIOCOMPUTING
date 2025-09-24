# Task 1

#logged in to W&M hpc, in home directory

mkdir programs

# Task 2

#move into programs directory

cd ./programs

#download gzipped tarball from github reserves

wget https://github.com/cli/cli/releases/download/v2.74.2/gh_2.74.2_linux_amd64.tar.gz

#unpack a gzipped tarball

tar -xzvf gh_2.74.2_linux_amd64.tar.gz

#delete zipped tarball

rm gh_2.74.2_linux_amd64.tar.gz

# Task 3

#create script and paste in all Task 2 commands starting at wget

nano install_gh.sh

#use ctrl+O, enter, ctrl+X to save and exit

# Task 4

#removed unzipped directory to test new script

rm -r gh_2.74.2_linux_amd64

#check permissions on script

ll

#script is not executable!

#make script executable for all

chmod a+x install_gh.sh

#sanity check

ll

#-rwx--x--x

#run the script!

./install_gh.sh

#sanity check

ls

#gh directory correctly installed

# Task 5

#adding install_gh.sh to path

export PATH=$PATH:/sciclone/home/sshand/programs/gh_2.74.2_linux_amd64/bin

#sanity check

echo $PATH

#it's there!

# Task 6

gh auth login

#follow instructions

# Task 7

#create script and open with nano

nano install_seqtk.sh

#the following lines 97 through 103 are written inside the script

#move to programs directory so that seqtk is installed there

cd ~/programs

#install seqtk according its GitHub instructions

git clone https://github.com/lh3/seqtk.git;

cd seqtk; make

#automatically add seqtk to path by adding instructions to .bashrc

echo "export PATH=$PATH:/sciclone/home/sshand/programs/seqtk" >> ~/.bashrc

#save and exit script

#check access

ll

#not executable

chmod a+x install_seqtk.sh

#sanity check

ll

#good! -rwx--x--x

#run it!

./install_seqtk.sh

#reload .bashrc to complete the addition to path

source ~/.bashrc

#sanity check

echo $PATH

#it's there!

# Task 9

#inside the assignment_04 directory

#create and edit script

nano summarize_fasta.sh

#write in START:

#store given argument as name_file variable

name_file=${1}

#store number of sequences as seq_num variable

seq_num=$(cut -f 1 <(seqtk size ${1})) #seqtk size gives first number of sequences and nucleotide numbers, hence cut -f1

#store number of nucleotides in all sequences as nuc_num variable

nuc_num=$(cut -f 2 <(seqtk size ${1}))

#create a table of sequence IDs and their respective lengths, save as table variable

#seqtk comp gives a bunch of tab separated values, the first two being ID and lengths

table=$(seqtk comp ${1} | cut -f1,2)

#report the info

echo "The file $name_file contains $seq_num number of sequences and a total of $nuc_num number of nucleotides. Each of the sequence names and len>

echo "$table"

#write in STOP

# Task 10

#copy the fasta file from assignment 3 over two times for a total of three files

cp GCF_000001735.4_TAIR10.1_genomic.fna ./GCF_000001735.4_TAIR10.1_genomic_copy1.fna

cp GCF_000001735.4_TAIR10.1_genomic.fna ./GCF_000001735.4_TAIR10.1_genomic_copy2.fna

#sanity check

ls

#looks good!

#move all fasta files into a data folder

mv GCF* ./data

#move into this data folder

cd ./data

#check all fasta files are there!

ll

#looks good!

#run loop! from inside the data folder!

for file in *; do ../summarize_fasta.sh $file; sleep 1; done

#done!

# Task 11

### Note: all file names in data folder were saved to a .gitignore file, so they will not be pushed to github!

### Reflection

> This was the most challenging assignment for me yet. Everything up to Task 9 felt comfortable for me. The concepts of how we use $PATH felt pretty familiar to me following our various classes. Adding the absolute path to my script to the variable PATH allows for that script to be found when I call it, since the computer checks all the locations specified under PATH when a command is called. The fact that I didn't add my summarize_fasta.sh script to my PATH variable is the reason why I had to call the relative path to the script when trying to run it within my data directory in Task 10. I was very challenged by Task 9. In a different class, my professor mentioned that he likes to write/draw out his logic when building programs. That process helped me with the first two tasks of the summarize fasta script (total number of sequences and nucleotides). But with the table task, whatever I came up with failed. This was a big teaching moment for me. I had to rethink and analyze what each component of what I would try did, which was a good learning opportunity. At one point, I was attempting to create the table by using the paste command with two temporary files, one using grep for sequence IDs, and the other using a for loop that iterated through the number of sequences in a file and used a pipe with head and tail to pull a specific sequence and count the number of characters in it. Since the number of sequences is variable, I included the seq_num variable in the for loop command as {1..$seq_num}. That's when I learned that apparently variables are processed after a for loop is processed? Finally, I realized that the seqtk comp command would give me columns with those ID names and their matching lengths. That made my life a whole lot easier. The biggest thing I took away from this is that in Task 8, I should've spent more time understanding what every single command did. I had read through the github documentation, and looked at the list of commands, but I didn't quite understand what the outputs of all those commands would be. Struggling with task 9 really underscored the importance of trying things out as a way of investigating and understanding.

