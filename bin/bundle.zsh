#!/bin/zsh 
set -e 
cd $(dirname $0)
mkdir -p ../build/
touch ../build/toolshell.inc
cat ../library/* >> ../build/toolshell.inc
cat ../core/* >> ../build/toolshell.inc