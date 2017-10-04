#!/usr/bin/env bash

# To limit the number of worker by host
SPARK_WORKER_CORES={{ spark_max_container }}

# Choose the virtualenv as default interpretor for PySpark
PYSPARK_PYTHON=/home/opv/venvs/opv/bin/python3.5
