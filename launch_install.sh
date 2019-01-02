#!/bin/bash

# Download Spark
# ./get_Spark.sh

ansibleExist=`command -v ansible-playbook`
if ! [ -x "$ansibleExist" ]
then
  echo ------------------------------
  echo You must install ansible before using this script
  echo See the official wiki : https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html?extIdCarryOver=true&sc_cid=701f2000001OH7YAAW#installing-the-control-machine
  echo ------------------------------
  exit 1
fi

ansible-playbook -i hosts install.yml
