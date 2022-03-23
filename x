#!/bin/zsh
PROJECT_NAME=woot
source ./woot 

run_tests() {
  for f in tests/*; do 
    ${=f}
  done
}

build "./bin/bundle"
run tests run_tests

woot