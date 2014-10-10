#!/bin/bash

if [ -n "$1" ]; then
    TODAY=$1
else
    TODAY=`date +%Y%m%d`
fi

for i in `ls -d *_${TODAY}`; do
	OUTFILE=`ls ${i}/*pbs.o*`
	if [ -z ${OUTFILE} ]; then
		echo " + not yet for ${i}"
	fi
done
