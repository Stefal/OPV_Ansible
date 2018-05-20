#!/bin/bash

source /home/opv/venvs/opv/bin/activate
export LC_CTYPE="en_US.UTF-8"

opv-db-migrate --db-uri="postgres://opv:{{ postgresPasswdOPV }}@{{ OPVMaster }}/opv" >> /home/opv/logs/opv-db-migrate.log
