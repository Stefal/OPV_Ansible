#!/bin/bash

source /home/opv/venvs/opv/bin/activate

#hug -m --db-location=postgresql+psycopg2://opv:{{ postgresPasswdOPV }}@{{ OPVMaster }}/opv &>> /home/opv/logs/opv-api.log
hug -m dbrest.api -p 5000 &>> /home/opv/logs/opv-api.log
