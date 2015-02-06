#!/bin/bash

if [ -z "$1" ]; then
	echo "Input an appropriate word to be changed"
	exit 0
fi

read -r -p "${1} will be changed to ${2}. Are you sure? [y/N] " RESP
case ${RESP} in
	[yY])
		grep -rl ${1} | xargs sed -i 's/${1}/${2}/g'
		;;
	*)
		exit 0
		;;
esac
