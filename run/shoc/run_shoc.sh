#!/bin/bash

if [ ! -n "$1" ]; then
	echo "usage: $0 BENCHNAME"
	exit 0
fi

BENCH=$1

SHOC_DIR=~/workspace/gpgpu-bench/shoc
SHOC_BIN=~/workspace/gpgpu-bench/shoc/bin
SHOC_DATA=~/workspace/gpgpu-bench/shoc/bin
#SHOC_COMMON=~/workspace/gpgpu-bench/shoc/common

# making symbolic links
#ln -sf ${SHOC_BIN} benchmarks
#ln -sf ${SHOC_DATA} datasets
#ln -sf ${SHOC_COMMON} common

BIN=""
DSET=""
IDATA=""
ODATA=""
PAR=""

case "$BENCH" in
bf2)
	BIN=${SHOC_BIN}/EP/CUDA/BFS
	;;
fft)
	BIN=${SHOC_BIN}/EP/CUDA/FFT
	;;
gem)
	BIN=${SHOC_BIN}/EP/CUDA/GEMM
#	PAR="-v"
	;;
md)
	BIN=${SHOC_BIN}/EP/CUDA/MD
#	PAR="-v"
	;;
md5)
	BIN=${SHOC_BIN}/EP/CUDA/MD5Hash
#	PAR="-v"
	;;
nen)
	BIN=${SHOC_BIN}/EP/CUDA/NeuralNet
#	PAR="-v"
	;;
rdc)
	BIN=${SHOC_BIN}/EP/CUDA/Reduction
#	PAR="-v"
	;;
s3d)
	BIN=${SHOC_BIN}/EP/CUDA/S3D
#	PAR="-v"
	;;
sca)
	BIN=${SHOC_BIN}/EP/CUDA/Scan
#	PAR="-v"
	;;
sor)
	BIN=${SHOC_BIN}/EP/CUDA/Sort
#	PAR="-v"
	;;
spv)
	BIN=${SHOC_BIN}/EP/CUDA/Spmv
#	PAR="-v"
	;;
trd)
	BIN=${SHOC_BIN}/EP/CUDA/Triad
#	PAR="-v"
	;;
qtc)
	BIN=${SHOC_BIN}/TP/CUDA/QTC
#	PAR="-v"
	;;
rdt)
	BIN=${SHOC_BIN}/TP/CUDA/Reduction
#	PAR="-v"
	;;
sct)
	BIN=${SHOC_BIN}/TP/CUDA/Scan
#	PAR="-v"
	;;
stn)
	BIN=${SHOC_BIN}/TP/CUDA/Stencil2D
#	PAR="-v"
	;;
*)
	echo "Invalid benchmark name!!"
	;;
esac

echo "${BIN} ${IDATA} ${ODATA} ${PAR}"
${BIN} ${IDATA} ${ODATA} ${PAR} >> gpugj.rpt
