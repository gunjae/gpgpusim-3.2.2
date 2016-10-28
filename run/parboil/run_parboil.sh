#!/bin/bash

if [ ! -n "$1" ]; then
	echo "usage: $0 BENCHNAME"
	exit 0
fi

BENCH=$1

PARBOIL_DIR=~/workspace/gpgpu-bench/parboil/parboil
PARBOIL_BIN=~/workspace/gpgpu-bench/parboil/benchmarks
PARBOIL_DATA=~/workspace/gpgpu-bench/parboil/datasets
PARBOIL_COMMON=~/workspace/gpgpu-bench/parboil/common

# making symbolic links
#ln -sf ${PARBOIL_BIN} benchmarks
#ln -sf ${PARBOIL_DATA} datasets
#ln -sf ${PARBOIL_COMMON} common

BIN=""
DSET=""
IDATA=""
ODATA=""
PAR=""

case "$BENCH" in
bf1)
	BIN=${PARBOIL_BIN}/bfs/build/cuda_default/bfs
	DSET=${PARBOIL_DATA}/bfs/1M/input
	IDATA="-i ${DSET}/graph_input.dat"
	ODATA="-o bfs.out"
#	${PARBOIL_DIR} run bfs cuda 1M
	;;
bfn)
	BIN=${PARBOIL_BIN}/bfs/build/cuda_default/bfs
	DSET=${PARBOIL_DATA}/bfs/NY/input
	IDATA="-i ${DSET}/graph_input.dat"
	ODATA="-o bfs.out"
#	${PARBOIL_DIR} run bfs cuda NY
	;;
bff)
	BIN=${PARBOIL_BIN}/bfs/build/cuda_default/bfs
	DSET=${PARBOIL_DATA}/bfs/SF/input
	IDATA="-i ${DSET}/graph_input.dat"
	ODATA="-o bfs.out"
#	${PARBOIL_DIR} run bfs cuda SF
	;;
bfu)
	BIN=${PARBOIL_BIN}/bfs/build/cuda_default/bfs
	DSET=${PARBOIL_DATA}/bfs/UT/input
	IDATA="-i ${DSET}/graph_input.dat"
	ODATA="-o bfs.out"
#	${PARBOIL_DIR} run bfs cuda UT
	;;
cut)
	BIN=${PARBOIL_BIN}/cutcp/build/cuda_default/cutcp
	DSET=${PARBOIL_DATA}/cutcp/small/input
	IDATA="-i ${DSET}/watbox.sl40.pqr"
	ODATA="-o lattice.dat"
	;;
his)
	BIN=${PARBOIL_BIN}/histo/build/cuda_default/histo
	DSET=${PARBOIL_DATA}/histo/default/input
	IDATA="-i ${DSET}/img.bin"
	ODATA="-o ref.bmp"
	PAR="-- 20 4"
	;;
lbm)
	BIN=${PARBOIL_BIN}/lbm/build/cuda_default/lbm
	DSET=${PARBOIL_DATA}/lbm/short/input
	IDATA="-i ${DSET}/120_120_150_ldc.of"
	ODATA="-o reference.dat"
	PAR="-- 100"
	#PAR="-- 3000"
	;;
mrg)
	BIN=${PARBOIL_BIN}/mri-gridding/build/cuda_default/mri-gridding
	DSET=${PARBOIL_DATA}/mri-gridding/small/input
	IDATA="-i ${DSET}/small.uks"
	ODATA="-o output.txt"
	PAR="-- 32 0"
	;;
mrq)
	BIN=${PARBOIL_BIN}/mri-q/build/cuda_default/mri-q
	DSET=${PARBOIL_DATA}/mri-q/small/input
	IDATA="-i ${DSET}/32_32_32_dataset.bin"
	ODATA="-o 32_32_32_dataset.out"
	;;
sad)
	BIN=${PARBOIL_BIN}/sad/build/cuda_default/sad
	DSET=${PARBOIL_DATA}/sad/default/input
	IDATA="-i ${DSET}/reference.bin,${DSET}/frame.bin"
	ODATA="-o out.bin"
	;;
sge)
	BIN=${PARBOIL_BIN}/sgemm/build/cuda_default/sgemm
	DSET=${PARBOIL_DATA}/sgemm/medium/input
	IDATA="-i ${DSET}/matrix1.txt,${DSET}/matrix2t.txt,${DSET}/matrix2t.txt"
	ODATA="-o matrix3.txt"
	;;
spm)
	BIN=${PARBOIL_BIN}/spmv/build/cuda_default/spmv
	DSET=${PARBOIL_DATA}/spmv/medium/input
	IDATA="-i ${DSET}/bcsstk18.mtx,${DSET}/vector.bin"
	ODATA="-o bcsstk18.out"
	;;
sp1)
	BIN=${PARBOIL_BIN}/spmv/build/cuda_default/spmv
	DSET=${PARBOIL_DATA}/spmv/large/input
	IDATA="-i ${DSET}/Dubcova3.mtx.bin,${DSET}/vector.bin"
	ODATA="-o Dubcova3.out"
	;;
ste)
	BIN=${PARBOIL_BIN}/stencil/build/cuda_default/stencil
	DSET=${PARBOIL_DATA}/stencil/default/input
	IDATA="-i ${DSET}/512x512x64x100.bin"
	ODATA="-o 512x512x64.out"
	PAR="-- 512 512 64 100"
	;;
tpc)
	BIN=${PARBOIL_BIN}/tpacf/build/cuda_default/tpacf
	DSET=${PARBOIL_DATA}/tpacf/medium/input
	IDATA="-i ${DSET}/Datapnts.1,${DSET}/Randompnts.1,${DSET}/Randompnts.2,${DSET}/Randompnts.3,${DSET}/Randompnts.4,${DSET}/Randompnts.5,${DSET}/Randompnts.6,${DSET}/Randompnts.7,${DSET}/Randompnts.8,${DSET}/Randompnts.9,${DSET}/Randompnts.10,${DSET}/Randompnts.11,${DSET}/Randompnts.12,${DSET}/Randompnts.13,${DSET}/Randompnts.14,${DSET}/Randompnts.15,${DSET}/Randompnts.16,${DSET}/Randompnts.17,${DSET}/Randompnts.18,${DSET}/Randompnts.19,${DSET}/Randompnts.20,${DSET}/Randompnts.21,${DSET}/Randompnts.22,${DSET}/Randompnts.23,${DSET}/Randompnts.24,${DSET}/Randompnts.25,${DSET}/Randompnts.26,${DSET}/Randompnts.27,${DSET}/Randompnts.28,${DSET}/Randompnts.29,${DSET}/Randompnts.30,${DSET}/Randompnts.31,${DSET}/Randompnts.32,${DSET}/Randompnts.33,${DSET}/Randompnts.34,${DSET}/Randompnts.35,${DSET}/Randompnts.36,${DSET}/Randompnts.37,${DSET}/Randompnts.38,${DSET}/Randompnts.39,${DSET}/Randompnts.40,${DSET}/Randompnts.41,${DSET}/Randompnts.42,${DSET}/Randompnts.43,${DSET}/Randompnts.44,${DSET}/Randompnts.45,${DSET}/Randompnts.46,${DSET}/Randompnts.47,${DSET}/Randompnts.48,${DSET}/Randompnts.49,${DSET}/Randompnts.50,${DSET}/Randompnts.51,${DSET}/Randompnts.52,${DSET}/Randompnts.53,${DSET}/Randompnts.54,${DSET}/Randompnts.55,${DSET}/Randompnts.56,${DSET}/Randompnts.57,${DSET}/Randompnts.58,${DSET}/Randompnts.59,${DSET}/Randompnts.60,${DSET}/Randompnts.61,${DSET}/Randompnts.62,${DSET}/Randompnts.63,${DSET}/Randompnts.64,${DSET}/Randompnts.65,${DSET}/Randompnts.66,${DSET}/Randompnts.67,${DSET}/Randompnts.68,${DSET}/Randompnts.69,${DSET}/Randompnts.70,${DSET}/Randompnts.71,${DSET}/Randompnts.72,${DSET}/Randompnts.73,${DSET}/Randompnts.74,${DSET}/Randompnts.75,${DSET}/Randompnts.76,${DSET}/Randompnts.77,${DSET}/Randompnts.78,${DSET}/Randompnts.79,${DSET}/Randompnts.80,${DSET}/Randompnts.81,${DSET}/Randompnts.82,${DSET}/Randompnts.83,${DSET}/Randompnts.84,${DSET}/Randompnts.85,${DSET}/Randompnts.86,${DSET}/Randompnts.87,${DSET}/Randompnts.88,${DSET}/Randompnts.89,${DSET}/Randompnts.90,${DSET}/Randompnts.91,${DSET}/Randompnts.92,${DSET}/Randompnts.93,${DSET}/Randompnts.94,${DSET}/Randompnts.95,${DSET}/Randompnts.96,${DSET}/Randompnts.97,${DSET}/Randompnts.98,${DSET}/Randompnts.99,${DSET}/Randompnts.100"
	ODATA="-o tpacf.out"
	PAR="-- -n 100 -p 4096"
	;;
*)
	echo "Invalid benchmark name!!"
	;;
esac

echo "${BIN} ${IDATA} ${ODATA} ${PAR}"
${BIN} ${IDATA} ${ODATA} ${PAR} >> gpugj.rpt
