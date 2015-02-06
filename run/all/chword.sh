#!/bin/bash

if [ -z "${1}" ]; then
	echo "Input an appropriate word to be changed"
	exit 0
fi

read -r -p "${1} will be changed to ${2}. Are you sure? [y/N] " RESP
case ${RESP} in
	[yY])
#		echo "grep -rl ${1} * | xargs sed -i 's/${1}/${2}/g'"
#		grep -rl ${1} * | xargs sed -i 's/${1}/${2}/g'
		;;
	*)
		exit 0
		;;
esac

for i in `grep -l ${1} *`; do
	echo "sed -i 's/${1}/${2}/g' ${i}"
	sed -i "s/${1}/${2}/g" ${i}
done
