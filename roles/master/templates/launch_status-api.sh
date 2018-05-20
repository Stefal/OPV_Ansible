#!/bin/bash

source /home/opv/venvs/opv/bin/activate
export LC_CTYPE="en_US.UTF-8"

opv-status-api &>> /home/opv/logs/opv-status-api.log
