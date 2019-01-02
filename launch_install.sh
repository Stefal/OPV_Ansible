#!/bin/bash

# Download Spark
# ./get_Spark.sh

ansibleExist=`command -v ansible-playbook`
if ! [ -x "$ansibleExist" ]
then
  echo ------------------------------
  echo You must install ansible before using this script
  echo you can execute : sudo apt install ansible
  echo ------------------------------
  exit 1
fi

ansible-playbook -i hosts install.yml
