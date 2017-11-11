#!/bin/bash

source /home/opv/venvs/opv/bin/activate

opv-db-migrate --db-uri="postgres://opv:{{ postgresPasswdOPV }}@{{ OPVMaster }}/opv" >> /home/opv/logs/opv-db-migrate.log
