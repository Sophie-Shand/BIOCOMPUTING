# Sophie Shand, September 11th 2025, Assignment 2

bora #enter your password

# my BIOCOMPUTING repository was already cloned into the hpc from class 9/9 so no action was taken for task 1

cd ./BIOCOMPUTING/assignments

mkdir assignment_02

touch assignment_02/README.md

cd ./assignment_02

mkdir data

ls #to check that everything was correctly created

exit

brew install lftp #had to do this to connect to ncbi via ftp

lftp ftp.ncbi.nlm.nih.gov

#didn't need to login

cd genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/ #navigating to the correct directory

get GCF_000005845.2_ASM584v2_genomic.fna.gz #download first file

get GCF_000005845.2_ASM584v2_genomic.gff.gz #download second file

bye #leave ncbi

# Task 3

sftp sshand@bora.sciclone.wm.edu #connect to bora just to move files around

#entered password

cd ./BIOCOMPUTING/assignments/assignment_02/data #navigate to data directory

put GCF_000005845.2_ASM584v2_genomic.fna.gz #copy over the first file

put GCF_000005845.2_ASM584v2_genomic.gff.gz #copy over the second file

ll # check that they are there and what their access permissions are

#the files show -rw------- meaning they are not readable by anyone but me

chmod a+r GCF_000005845.2_ASM584v2_genomic.fna.gz #change access to all can read

chmod a+r GCF_000005845.2_ASM584v2_genomic.gff.gz #same thing for the second file

#verify I successfully changed it

ll

#Looks good!

# Task 4

exit #leave hpc 

md5sum GCF_000005845.2_ASM584v2_genomic.fna.gz

# output: c13d459b5caa702ff7e1f26fe44b8ad7

md5sum GCF_000005845.2_ASM584v2_genomic.gff.gz

# output: 2238238dd39e11329547d26ab138be41

bora # enter password

md5sum GCF_000005845.2_ASM584v2_genomic.fna.gz

# output: c13d459b5caa702ff7e1f26fe44b8ad7

md5sum GCF_000005845.2_ASM584v2_genomic.gff.gz

# output: 2238238dd39e11329547d26ab138be41

# They match!

# Task 5

bora #enter password

alias #check that aliases u,d,ll already exist -- They do!

# u allows user to go up to the parent directory, it clears the terminal screen, it shows the ultimate path to the present directory, and it lists all files in the present directories in long listing format with human-readable sizes while grouping directories first

# d allows user to go back to the previous directory they were in. Outside of changing directories, u and d do all the same things (clear, ult path, list)

# ll lists everything in the current directory in a long format, showing ALL files including hidden ones, with human-readable sizes, and while appending symbols to indicate what the file type is (e.g. a directory will have / appended to the end of the directory name)

cd ./BIOCOMPUTING/assignments/assignment_02 #moving into assignment 2 to edit readme

nano README.md #adding everything I did to my read me file, bye.
