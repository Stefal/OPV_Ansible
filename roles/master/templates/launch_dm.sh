#!/bin/bash

source /home/opv/venvs/opv/bin/activate

opv_dm_web.py -c /home/opv/conf/directory_manager.conf -o {{ OPVMaster }} -p 5005 &>> /home/opv/logs/directory_manager.log
