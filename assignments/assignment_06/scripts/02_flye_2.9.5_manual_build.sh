#!/bin/bash

set -ueo pipefail

cd ~/programs

#copied instructions from INSTALL.md

git clone https://github.com/fenderglass/Flye

cd Flye

make

#go back to original directory

cd -


