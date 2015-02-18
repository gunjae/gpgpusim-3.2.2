#!/bin/bash

if [ ! -n "$1" ]; then
	echo "usage: $0 BENCHNAME"
	exit 0
fi

BENCH=$1

FINANCEBENCH_DIR=~/workspace/gpgpu-bench/FinanceBench
FINANCEBENCH_BIN=~/workspace/gpgpu-bench/FinanceBench
#FINANCEBENCH_BIN=~/workspace/gpgpu-bench/PolyBench-ACC/CUDA
#FINANCEBENCH_DATA=~/workspace/gpgpu-bench/PolyBench-ACC/CUDA
#FINANCEBENCH_COMMON=~/workspace/gpgpu-bench/parboil/common

# making symbolic links
#ln -sf ${FINANCEBENCH_BIN} benchmarks
#ln -sf ${FINANCEBENCH_DATA} datasets
#ln -sf ${FINANCEBENCH_COMMON} common

BIN=""
DSET=""
IDATA=""
ODATA=""
PAR=""

case "$BENCH" in
blc)
	BIN=${FINANCEBENCH_BIN}/Black-Scholes/CUDA/blackScholesEngine.exe
	;;
bne)
	BIN=${FINANCEBENCH_BIN}/Bonds/CUDA/bondsEngine.exe
	;;
mce)
	BIN=${FINANCEBENCH_BIN}/Monte-Carlo/CUDA/monteCarloEngine.exe
	;;
rpe)
	BIN=${FINANCEBENCH_BIN}/Repo/CUDA/repoEngine.exe
	;;
*)
	echo "Invalid benchmark name!!"
	;;
esac

echo "${BIN} ${IDATA} ${ODATA} ${PAR}"
${BIN} ${IDATA} ${ODATA} ${PAR} >> gpugj.rpt
