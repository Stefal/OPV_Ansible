#!/bin/bash

# Download Spark
spark_version=2.2.0
hadoop_version=2.7

# Compute the filename
filename="spark-${spark_version}-bin-hadoop${hadoop_version}.tgz"
filepath="roles/spark/files/${filename}"

if [ -f ./roles/spark/files/${filename} ] ; then
	echo "You already have Spark!"		
else
	echo "Downloading Spark ..."
	wget "http://mirrors.standaloneinstaller.com/apache/spark/spark-${spark_version}/${filename}" -O "${filepath}"
fi
