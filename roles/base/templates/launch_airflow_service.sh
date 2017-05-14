#!/bin/bash

if [ $# -ne 1 ] ; then
	echo "usage ./launch_airflow_service.sh SERVICE_NAME"
	exit 1
fi

service=$1

source ~/venvs/opv/bin/activate

airflow ${service} &>> ~/logs/${service}.log
