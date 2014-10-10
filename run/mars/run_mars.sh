#!/bin/bash

if [ ! -n "$1" ]; then
	echo "usage: $0 BENCHNAME"
	exit 0
fi

BENCH=$1

MARS_BIN=~/workspace/gpgpu-bench/Mars/bin
MARS_DATA=~/workspace/gpgpu-bench/Mars/sample_apps/BIN_TMPL

# making symbolic links
#ln -sf ${MARS_BIN} benchmarks
#ln -sf ${MARS_DATA} datasets
#ln -sf ${BENCH_COMMON} common

BIN=""
DSET=""
IDATA=""
ODATA=""
PAR=""

case "$BENCH" in
ii)
	echo "generating 28MB data..."
	mkdir data
	for ((i=0; i<1024; i++)) do
		cat ${MARS_DATA}/II_BIN/sample/1.html >> data/1.html
		cat ${MARS_DATA}/II_BIN/sample/2.html >> data/2.html
		cat ${MARS_DATA}/II_BIN/sample/3.html >> data/3.html
	done
	BIN=${MARS_BIN}/InvertedIndex
	IDATA="data/"
	;;
km)
	BIN=${MARS_BIN}/Kmeans
	PAR="30000 3 24"
	;;
mm)
	BIN=${MARS_BIN}/MatrixMul
	PAR="1024 1024"
	;;
pvc)
	echo "generating data..."
	cp ${MARS_DATA}/GenWebLogSrc/Gen .
	chmod +x Gen
	Gen data 1000000 count
	BIN=${MARS_BIN}/PageViewCount
	IDATA="data"
	;;
pvr)
	echo "generating data..."
	cp ${MARS_DATA}/GenWebLogSrc/Gen .
	chmod +x Gen
	Gen data 1000000 rank
	BIN=${MARS_BIN}/PageViewRank
	IDATA="data"
	;;
sm)
	echo "generating data..."
	for ((i=0; i<1024; i++)) do
		cat ${MARS_DATA}/SM_BIN/sample.txt >> data.txt
	done
	BIN=${MARS_BIN}/StringMatch
	IDATA="data.txt org"
	;;
ss)
	BIN=${MARS_BIN}/SimilarityScore
	PAR="1024 256"
	;;
wc)
	echo "generating data..."
	for ((i=0; i<1024; i++)) do
		cat ${MARS_DATA}/WC_BIN/sample >> data
	done
	BIN=${MARS_BIN}/WordCount
	IDATA="data"
	;;
*)
	echo "Invalid benchmark name!!"
	;;
esac

echo "${BIN} ${IDATA} ${ODATA} ${PAR}"
${BIN} ${IDATA} ${ODATA} ${PAR} >> gpugj.rpt
