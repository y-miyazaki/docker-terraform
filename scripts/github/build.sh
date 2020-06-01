#!/bin/bash
set -e
DIR=${1:-./}

cd $DIR
echo "#--------------------------------------------------------------"
echo "# terraform plan ($PWD)"
echo "#--------------------------------------------------------------"
githubtf plan -lock=false
