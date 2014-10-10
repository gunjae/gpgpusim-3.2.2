#!/bin/bash

if [ ! -n "$1" ]; then
	echo "usage: $0 BENCHNAME"
	exit 0
fi

BENCH=$1
SDK_DIR=~/workspace/gpgpu-bench/sdk4/src
SDK_BIN=~/workspace/gpgpu-bench/sdk4/bin/linux/release

BIN=""
DSET=""
IDATA=""
ODATA=""
PAR=""

case "$BENCH" in
alt)
	BIN="${SDK_BIN}/alignedTypes"
	;;
asy)
	BIN="${SDK_BIN}/asyncAPI"
	;;
bin)
	BIN="${SDK_BIN}/binomialOptions"
	;;
blk)
	BIN="${SDK_BIN}/BlackScholes"
	;;
#box)
#	${SDK_BIN}/boxFilter ${SDK_DIR}/boxFilter
#	;;
cnv)
	BIN="${SDK_BIN}/convolutionSeparable"
	;;
cnt)
	BIN="${SDK_BIN}/convolutionTexture"
	;;
dct)
	BIN="${SDK_BIN}/dct8x8"
	IDATA="${SDK_DIR}/dct8x8/data/barbara.ppm"
	;;
dxt)
	cp ${SDK_DIR}/dxtc/data/* .
	BIN="${SDK_BIN}/dxtc >> gpugj.rpt"
	;;
eig)
	BIN="${SDK_BIN}/eigenvalues"
	;;
hst)
	BIN="${SDK_BIN}/histogram"
	;;
mrg)
	BIN="${SDK_BIN}/mergeSort"
	;;
mst)
	cp ${SDK_DIR}/MersenneTwister/data/* .
	BIN="${SDK_BIN}/MersenneTwister"
	;;
mca)
	BIN="${SDK_BIN}/MonteCarlo"
	;;
qsr)
	BIN="${SDK_BIN}/quasirandomGenerator"
	;;
red)
	BIN="${SDK_BIN}/reduction"
	;;
spd)
	BIN="${SDK_BIN}/scalarProd"
	;;
scn)
	BIN="${SDK_BIN}/scan"
	;;
sao)
	BIN="${SDK_BIN}/SingleAsianOptionP"
	;;
sbq)
	BIN="${SDK_BIN}/SobolQRNG"
	;;
snt)
	BIN="${SDK_BIN}/sortingNetworks"
	;;
tfr)
	BIN="${SDK_BIN}/threadFenceReduction"
	;;
txp)
	BIN="${SDK_BIN}/transpose"
	;;
vad)
	BIN="${SDK_BIN}/vectorAdd"
	;;
wal)
	BIN="${SDK_BIN}/fastWalshTransform"
	;;
*)
	echo "Invalid benchmark name!!"
	;;
esac

echo "${BIN} ${IDATA} ${ODATA} ${PAR}"
${BIN} ${IDATA} ${ODATA} ${PAR} >> gpugj.rpt
