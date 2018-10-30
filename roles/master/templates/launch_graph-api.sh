#!/bin/bash

source /home/opv/venvs/opv/bin/activate
export LC_CTYPE="en_US.UTF-8"

gunicorn --bind 0.0.0.0:5015 opv.graphe.__main__:app -w 8 &>> /home/opv/logs/opv-graph-api.log
