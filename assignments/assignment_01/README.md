- Start out in the assignments folder

touch assignment_01/assignment_01_essay.md

touch assignment_01/README.md

> Now the directory assignment_01 contains two markdown files for the assignment
- Move into the assignment_01 directory in order to create the project directories

cd ./assignments/assignment_01

mkdir data scripts results figures references logs

> Now the assignment_01 directory contains 6 directories that could structure a project

- Add sample files to each of the files

*Create two files within the data directory, one that would contain the raw unaltered data, and another that would contain cleaned data*

touch data/raw_data

touch data/clean_data

*Create a file to represent a plot which could go in the figures directory*

touch figures/plot.png

*Create a text file that could contain logs to keep track of project progress, important notes, etc*

touch logs/update_1.txt

*Create a python file that contains specific functions used in the data processing and analysis phases of the project. This could include gextensive detail on the functions, how they work, and the design logic*

touch references/functions.py

*Create a file that would contain the output of the data analysis phase of the project*

touch results/result_1.csv

*Create a file that contains the analysis work done on the cleaned data that yielded the results*

touch scripts/analyze.py

> Now each of the directories that make up the project structure contain hypothetical files

- Now that the structure has been created and the files populated, they are ready to be staged to push to GitHub

git add .

> The period here avoids having to type out the names of all created directories and files.

- The staged changes can be committed

git commit -m "Adding project directories and palceholder files"

- Push to GitHub

git push
