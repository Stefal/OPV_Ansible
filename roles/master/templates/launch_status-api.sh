#!/bin/bash

source /home/opv/venvs/opv/bin/activate

opv-status-api &>> /home/opv/logs/status-api.log
