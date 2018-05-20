#!/bin/bash

source /home/opv/venvs/opv/bin/activate
export LC_CTYPE="en_US.UTF-8"

#hug -m --db-location=postgresql+psycopg2://opv:{{ postgresPasswdOPV }}@{{ OPVMaster }}/opv &>> /home/opv/logs/opv-api.log
opv-api run --db-location="postgres://opv:{{ postgresPasswdOPV }}@{{ OPVMaster }}/opv" --IDMalette="{{ idMallette }}" --port=5000 &>> /home/opv/logs/opv-api.log
