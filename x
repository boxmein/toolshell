#!/bin/zsh
PROJECT_NAME=woot
source ./woot 

build "./bin/bundle"
run tests "zunit"

woot