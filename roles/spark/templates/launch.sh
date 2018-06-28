#!/bin/bash

/opt/spark-2.2.1-bin-hadoop2.7/bin/spark-submit --master spark://{% for host in groups[spark_master_group] %}{{ hostvars[host]['ansible_default_ipv4']['address'] }}:7077{%- if not loop.last %},{% endif -%}{% endfor %} make_campaign.py $*
