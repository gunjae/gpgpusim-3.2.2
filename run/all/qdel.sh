#!/bin/bash

JID_START=$1
JID_END=$2

for i in `seq $1 $2`; do
	echo "qdel ${i}"
	qdel ${i}
done
