#move into quiz 2 directory
cd ./BIOCOMPUTING
cd ./quizzes
cd ./quiz_02
#create file
echo 'Connected successfully!' > remote_test.txt
exit
#move into local quiz 2 directory
cd ./BIOCOMPUTING/quizzes/quiz_02
#connect with sftp
sftp sshand@bora.sciclone.wm.edu
#move into quiz 2 directory
cd ./BIOCOMPUTING/quizzes/quiz_02
ls
#get file
get remote_test.txt
bye
#sanity check
ls
