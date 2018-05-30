#!/bin/bash

source /home/opv/venvs/opv/bin/activate
export LC_CTYPE="en_US.UTF-8"

opv_dm_web.py -c /home/opv/conf/directory_manager.conf -o {{ OPVMaster }} -p 5005 &>> /home/opv/logs/directory_manager.log
