#!/bin/bash

# Download Spark
./get_Spark.sh

ansible-playbook -i hosts install.yml
