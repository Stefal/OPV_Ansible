#!/bin/bash

path=$(dirname $0)
${path}/launch_install.sh

if [ $? -ne 0 ] ; then
	echo "FAILED!"
fi

${path}/launch_configuration.sh
