#!/bin/zsh
SCRIPT_NAME=$0
PROJECT_NAME=toolshell
source ./toolshell_dev.inc

requires_tool zsh
requires_tool zunit 0.8

set_build_command "./bin/bundle.zsh"
add_command "tests" "zunit"

toolshell_main