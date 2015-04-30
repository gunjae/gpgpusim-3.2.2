#!/bin/bash

if [ ! -n "$1" ]; then
	echo "usage: $0 BENCHNAME"
	exit 0
fi

BENCH=$1

ISPASS_DIR=~/workspace/gpgpu-bench/ispass2009
ISPASS_BIN=~/workspace/gpgpu-bench/ispass2009/bin/release

RODINIA_DIR=~/workspace/gpgpu-bench/rodinia_3.0/cuda
RODINIA_DATA=~/workspace/gpgpu-bench/rodinia_3.0/data
RODINIA_BIN=~/workspace/gpgpu-bench/rodinia_3.0/bin/linux/cuda
#RODINIA_DIR=~/workspace/gpgpu-bench/rodinia_2.4/cuda
#RODINIA_DATA=~/workspace/gpgpu-bench/rodinia_2.4/data
#RODINIA_BIN=~/workspace/gpgpu-bench/rodinia_2.4/bin/linux/cuda

PARBOIL_DIR=~/workspace/gpgpu-bench/parboil/parboil
PARBOIL_BIN=~/workspace/gpgpu-bench/parboil/benchmarks
PARBOIL_DATA=~/workspace/gpgpu-bench/parboil/datasets
PARBOIL_COMMON=~/workspace/gpgpu-bench/parboil/common

SDK_DIR=~/workspace/gpgpu-bench/sdk4/src
SDK_BIN=~/workspace/gpgpu-bench/sdk4/bin/linux/release

MARS_BIN=~/workspace/gpgpu-bench/Mars/bin
MARS_DATA=~/workspace/gpgpu-bench/Mars/sample_apps/BIN_TMPL

POLYBENCH_DIR=~/workspace/gpgpu-bench/PolyBench-ACC/CUDA
POLYBENCH_BIN=~/workspace/gpgpu-bench/PolyBench-ACC/CUDA

FINANCEBENCH_DIR=~/workspace/gpgpu-bench/FinanceBench
FINANCEBENCH_BIN=~/workspace/gpgpu-bench/FinanceBench

SHOC_DIR=~/workspace/gpgpu-bench/shoc
SHOC_BIN=~/workspace/gpgpu-bench/shoc/bin
SHOC_DATA=~/workspace/gpgpu-bench/shoc/bin

GRAPH_DIR=~/workspace/gpgpu-bench/GraphBench
GRAPH_BIN=~/workspace/gpgpu-bench/GraphBench/benchmarks
GRAPH_DATA=~/workspace/gpgpu-bench/GraphBench/input

BIN=""
DSET=""
IDATA=""
ODATA=""
PAR=""

case "$BENCH" in
##
## ISPASS
##
AES) 
	BIN="${ISPASS_BIN}/AES"
	IDATA="e 128 ${ISPASS_DIR}/AES/data/output.bmp ${ISPASS_DIR}/AES/data/key128.txt"
	;;
BFI)
	BIN="${ISPASS_BIN}/BFS"
	IDATA="${ISPASS_DIR}/BFS/data/graph4096.txt"
	;;
CP)
	BIN="${ISPASS_BIN}/CP"
	;;
LIB)
	BIN="${ISPASS_BIN}/LIB"
	;;
LPS)
	BIN="${ISPASS_BIN}/LPS"
	;;
MUM)
	BIN="${ISPASS_BIN}/MUM"
	IDATA="${ISPASS_DIR}/MUM/data/NC_003997.20k.fna ${ISPASS_DIR}/MUM/data/NC_003997_q25bp.50k.fna"
	;;
NN)
	BIN="${ISPASS_BIN}/NN"
	PAR="28"
	;;
NQU)
	BIN="${ISPASS_BIN}/NQU"
	;;
RAY)
	BIN="${ISPASS_BIN}/RAY"
	PAR="1024 1024"
	;;
STO)
	BIN="${ISPASS_BIN}/STO"
	;;
WP)
	echo "10 ${ISPASS_DIR}/WP/data/" | ${ISPASS_BIN}/WP
	;;
##
## RODINIA
##
bpr)
	BIN="${RODINIA_BIN}/backprop"
	PAR="65536"
	;;
bfs)
	BIN="${RODINIA_BIN}/bfs"
	IDATA="${RODINIA_DATA}/bfs/graph1MW_6.txt"
	;;
b00)
	BIN="${RODINIA_BIN}/bfs"
	IDATA="${RODINIA_DATA}/bfs/graph1k.txt"
	;;
b01)
	BIN="${RODINIA_BIN}/bfs"
	IDATA="${RODINIA_DATA}/bfs/graph2k.txt"
	;;
b02)
	BIN="${RODINIA_BIN}/bfs"
	IDATA="${RODINIA_DATA}/bfs/graph4k.txt"
	;;
b03)
	BIN="${RODINIA_BIN}/bfs"
	IDATA="${RODINIA_DATA}/bfs/graph8k.txt"
	;;
b04)
	BIN="${RODINIA_BIN}/bfs"
	IDATA="${RODINIA_DATA}/bfs/graph16k.txt"
	;;
b05)
	BIN="${RODINIA_BIN}/bfs"
	IDATA="${RODINIA_DATA}/bfs/graph32k.txt"
	;;
b06)
	BIN="${RODINIA_BIN}/bfs"
	IDATA="${RODINIA_DATA}/bfs/graph64k.txt"
	;;
b07)
	BIN="${RODINIA_BIN}/bfs"
	IDATA="${RODINIA_DATA}/bfs/graph128k.txt"
	;;
b08)
	BIN="${RODINIA_BIN}/bfs"
	IDATA="${RODINIA_DATA}/bfs/graph256k.txt"
	;;
b09)
	BIN="${RODINIA_BIN}/bfs"
	IDATA="${RODINIA_DATA}/bfs/graph512k.txt"
	;;
b10)
	BIN="${RODINIA_BIN}/bfs"
	IDATA="${RODINIA_DATA}/bfs/graph1M.txt"
	;;
b11)
	BIN="${RODINIA_BIN}/bfs"
	IDATA="${RODINIA_DATA}/bfs/graph2M.txt"
	;;
b12)
	BIN="${RODINIA_BIN}/bfs"
	IDATA="${RODINIA_DATA}/bfs/graph4M.txt"
	;;
b13)
	BIN="${RODINIA_BIN}/bfs"
	IDATA="${RODINIA_DATA}/bfs/graph8M.txt"
	;;
b14)
	BIN="${RODINIA_BIN}/bfs"
	IDATA="${RODINIA_DATA}/bfs/graph16M.txt"
	;;
btr)
	BIN="${RODINIA_BIN}/b+tree"
	IDATA="file ${RODINIA_DATA}/b+tree/mil.txt command ${RODINIA_DATA}/b+tree/command.txt"
	;;
dwt)
	BIN="${RODINIA_BIN}/dwt2d"
	IDATA="${RODINIA_DATA}/dwt2d/rgb.bmp"
	PAR="-d 1024x1024 -f -5 -l 3"
	;;
dw0)
	BIN="${RODINIA_BIN}/dwt2d"
	IDATA="${RODINIA_DATA}/dwt2d/4.bmp"
	PAR="-d 4x4 -f -5 -l 3"
	;;
dw1)
	BIN="${RODINIA_BIN}/dwt2d"
	IDATA="${RODINIA_DATA}/dwt2d/8.bmp"
	PAR="-d 8x8 -f -5 -l 3"
	;;
dw2)
	BIN="${RODINIA_BIN}/dwt2d"
	IDATA="${RODINIA_DATA}/dwt2d/16.bmp"
	PAR="-d 16x16 -f -5 -l 3"
	;;
dw3)
	BIN="${RODINIA_BIN}/dwt2d"
	IDATA="${RODINIA_DATA}/dwt2d/64.bmp"
	PAR="-d 64x64 -f -5 -l 3"
	;;
dw4)
	BIN="${RODINIA_BIN}/dwt2d"
	IDATA="${RODINIA_DATA}/dwt2d/192.bmp"
	PAR="-d 192x192 -f -5 -l 3"
	;;
dw5)
	BIN="${RODINIA_BIN}/dwt2d"
	IDATA="${RODINIA_DATA}/dwt2d/ray.bmp"
	PAR="-d 2048x2048 -f -5 -l 3"
	;;
gaf)
	BIN="${RODINIA_BIN}/gaussian"
	IDATA="-f ${RODINIA_DATA}/gaussian/matrix1024.txt"
	;;
ga0)
	BIN="${RODINIA_BIN}/gaussian"
	IDATA="-f ${RODINIA_DATA}/gaussian/matrix208.txt"
	;;
ga1)
	BIN="${RODINIA_BIN}/gaussian"
	IDATA="-f ${RODINIA_DATA}/gaussian/matrix16.txt"
	;;
ga2)
	BIN="${RODINIA_BIN}/gaussian"
	IDATA="-f ${RODINIA_DATA}/gaussian/matrix4.txt"
	;;
ga3)
	BIN="${RODINIA_BIN}/gaussian"
	IDATA="-f ${RODINIA_DATA}/gaussian/matrix3.txt"
	;;
gas)
	BIN="${RODINIA_BIN}/gaussian"
	PAR="-s 16"
	;;
htw)
	BIN="${RODINIA_BIN}/heartwall"
	IDATA="${RODINIA_DATA}/heartwall/test.avi"
	PAR="20"
	#PAR="5"
	;;
hsp)
	BIN="${RODINIA_BIN}/hotspot"
	IDATA="512 2 2 ${RODINIA_DATA}/hotspot/temp_512 ${RODINIA_DATA}/hotspot/power_512"
	ODATA="output.out"
	;;
hs0)
	BIN="${RODINIA_BIN}/hotspot"
	IDATA="64 2 2 ${RODINIA_DATA}/hotspot/temp_64 ${RODINIA_DATA}/hotspot/power_64"
	ODATA="output.out"
	;;
hs1)
	BIN="${RODINIA_BIN}/hotspot"
	IDATA="1024 2 2 ${RODINIA_DATA}/hotspot/temp_1024 ${RODINIA_DATA}/hotspot/power_1024"
	ODATA="output.out"
	;;
hsr)
	BIN="${RODINIA_BIN}/hybridsort"
	IDATA="${RODINIA_DATA}/hybridsort/500000.txt"
	#PAR="r"
	;;
kmn)
	BIN="${RODINIA_BIN}/kmeans"
	IDATA="-o -i ${RODINIA_DATA}/kmeans/kdd_cup" 
	;;
lud)
	BIN="${RODINIA_BIN}/lud_cuda"
	IDATA="-i ${RODINIA_DATA}/lud/2045.dat" 
	#PAR="-s 256 -v"
	;;
mmg)
	BIN="${RODINIA_BIN}/mummergpu"
	IDATA="${RODINIA_DATA}/mummergpu/NC_003997.fna ${RODINIA_DATA}/mummergpu/NC_003997_q100bp.fna"
	ODATA="> NC_00399.out"
	;;
	myo)
	BIN="${RODINIA_BIN}/myocyte"
	PAR="100 1 0"
	;;
nn)
	echo "${RODINIA_DATA}/nn/cane4_0.db" >> filelist_4
	echo "${RODINIA_DATA}/nn/cane4_1.db" >> filelist_4
	echo "${RODINIA_DATA}/nn/cane4_2.db" >> filelist_4
	echo "${RODINIA_DATA}/nn/cane4_3.db" >> filelist_4
	BIN="${RODINIA_BIN}/nn"
	IDATA="filelist_4"
	PAR="-r 5 -lat 30 -lng 90"
	;;
nw)
	BIN="${RODINIA_BIN}/needle"
	PAR="2048 10"
	;;
pfn)
	BIN="${RODINIA_BIN}/particlefilter_naive"
	PAR="-x 128 -y 128 -z 10 -np 1000"
	;;
pff)
	BIN="${RODINIA_BIN}/particlefilter_float"
	PAR="-x 128 -y 128 -z 10 -np 1000"
	;;
pth)
	BIN="${RODINIA_BIN}/pathfinder"
	PAR="100000 100 20"
	;;
sr1)
	BIN="${RODINIA_BIN}/srad_v1"
	PAR="100 0.5 502 458"
	;;
sr2)
	BIN="${RODINIA_BIN}/srad_v2"
	PAR="2048 2048 0 127 0 127 0.5 2"
	;;
scg)
	BIN="${RODINIA_BIN}/sc_gpu"
	IDATA="10 20 256 65536 65536 1000 none"
	ODATA="output.txt"
	PAR="1"
	;;
lav)
	BIN="${RODINIA_BIN}/lavaMD"
	PAR="-boxes1d 10"
	;;
##
## PARBOIL
##
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
cu0)
	BIN=${PARBOIL_BIN}/cutcp/build/cuda_default/cutcp
	DSET=${PARBOIL_DATA}/cutcp/large/input
	IDATA="-i ${DSET}/watbox.sl100.pqr"
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
lb0)
	BIN=${PARBOIL_BIN}/lbm/build/cuda_default/lbm
	DSET=${PARBOIL_DATA}/lbm/long/input
	IDATA="-i ${DSET}/120_120_150_ldc.of"
	ODATA="-o reference.dat"
	#PAR="-- 100"
	PAR="-- 3000"
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
mrr)
	BIN=${PARBOIL_BIN}/mri-q/build/cuda_default/mri-q
	DSET=${PARBOIL_DATA}/mri-q/large/input
	IDATA="-i ${DSET}/64_64_64_dataset.bin"
	ODATA="-o 64_64_64_dataset.out" 
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
sp0)
	BIN=${PARBOIL_BIN}/spmv/build/cuda_default/spmv
	DSET=${PARBOIL_DATA}/spmv/small/input
	IDATA="-i ${DSET}/1138_bus.mtx,${DSET}/vector.bin"
	ODATA="-o 1138_bus.out"
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
##
## NVIDIA SDK
##
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
mam)
	BIN="${SDK_BIN}/matrixMul"
	;;
mgs)
	BIN="${SDK_BIN}/mergeSort"
	;;
mt)
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
##
## MARS
##
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
	chmod +x ./Gen
	./Gen data 1000000 count
	BIN=${MARS_BIN}/PageViewCount
	IDATA="data"
	;;
pvr)
	echo "generating data..."
	cp ${MARS_DATA}/GenWebLogSrc/Gen .
	chmod +x ./Gen
	./Gen data 1000000 rank
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
##
## POLYBENCH 
##
cor)
	BIN=${POLYBENCH_BIN}/datamining/correlation/correlation.exe
	;;
cov)
	BIN=${POLYBENCH_BIN}/datamining/covariance/covariance.exe
	;;
2mm)
	BIN=${POLYBENCH_BIN}/linear-algebra/kernels/2mm/2mm.exe
	;;
3mm)
	BIN=${POLYBENCH_BIN}/linear-algebra/kernels/3mm/3mm.exe
	;;
atx)
	BIN=${POLYBENCH_BIN}/linear-algebra/kernels/atax/atax.exe
	;;
bic)
	BIN=${POLYBENCH_BIN}/linear-algebra/kernels/bicg/bicg.exe
	;;
dit)
	BIN=${POLYBENCH_BIN}/linear-algebra/kernels/doitgen/doitgen.exe
	;;
gmm)
	BIN=${POLYBENCH_BIN}/linear-algebra/kernels/gemm/gemm.exe
	;;
gmv)
	BIN=${POLYBENCH_BIN}/linear-algebra/kernels/gemver/gemver.exe
	;;
gsm)
	BIN=${POLYBENCH_BIN}/linear-algebra/kernels/gesummv/gesummv.exe
	;;
mvt)
	BIN=${POLYBENCH_BIN}/linear-algebra/kernels/mvt/mvt.exe
	;;
syr)
	BIN=${POLYBENCH_BIN}/linear-algebra/kernels/syrk/syrk.exe
	;;
sy2)
	BIN=${POLYBENCH_BIN}/linear-algebra/kernels/syr2k/syr2k.exe
	;;
grm)
	BIN=${POLYBENCH_BIN}/linear-algebra/solvers/gramschmidt/gramschmidt.exe
	;;
lu)
	BIN=${POLYBENCH_BIN}/linear-algebra/solvers/lu/lu.exe
	;;
adi)
	BIN=${POLYBENCH_BIN}/stencils/adi/adi.exe
	;;
cv2)
	BIN=${POLYBENCH_BIN}/stencils/convolution-2d/2DConvolution.exe
	;;
cv3)
	BIN=${POLYBENCH_BIN}/stencils/convolution-3d/3DConvolution.exe
	;;
fdt)
	BIN=${POLYBENCH_BIN}/stencils/fdtd-2d/fdtd2d.exe
	;;
jc1)
	BIN=${POLYBENCH_BIN}/stencils/jacobi-1d-imper/jacobi1D.exe
	;;
jc2)
	BIN=${POLYBENCH_BIN}/stencils/jacobi-2d-imper/jacobi2D.exe
	;;
##
## FINANCEBENCH
##	
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
##
## SHOC
##
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
##
## GRAPH
##	
aps)
	cp ${GRAPH_BIN}/APSP/rmat.txt .
	BIN=${GRAPH_BIN}/APSP/apsp
	;;
ccl)
	BIN=${GRAPH_BIN}/CCL/ccl_le_gpu
	IDATA="${GRAPH_BIN}/CCL/trojan.dat"
	#IDATA="${GRAPH_BIN}/CCL/logo.dat"
	;;
ccn)
	BIN=${GRAPH_BIN}/CCL/ccl_np_gpu
	IDATA="${GRAPH_BIN}/CCL/trojan.dat"
	#IDATA="${GRAPH_BIN}/CCL/logo.dat"
	;;
ccd)
	BIN=${GRAPH_BIN}/CCL/ccl_dpl_gpu
	IDATA="${GRAPH_BIN}/CCL/trojan.dat"
	#IDATA="${GRAPH_BIN}/CCL/logo.dat"
	;;
clu)
	BIN=${GRAPH_BIN}/CLU/build/bin/clu
	IDATA="-a 6 -m 2 ${GRAPH_DATA}/CLU/belgium.osm.graph.bz2"
	#IDATA="-a 6 -m 2 ${GRAPH_DATA}/CLU/coAuthorsCiteseer.graph.bz2"
	#IDATA="-a 6 -m 2 ${GRAPH_DATA}/CLU/email.graph.bz2"
	#IDATA="-a 6 -m 2 ${GRAPH_DATA}/CLU/in-2004.graph.bz2"
	;;
gco)
	BIN=${GRAPH_BIN}/GCO/gc
	IDATA="0 0 0 0 0 0 0 14 128 ${GRAPH_DATA}/GCO/hood.mtx"
	#IDATA="0 0 0 0 0 0 0 14 128 ${GRAPH_DATA}/GCO/pwtk.mtx"
	PAR="y n"
	;;
gcu)
	BIN=${GRAPH_BIN}/GCU/cudaCuts
	IDATA="${GRAPH_DATA}/GCU/debug.txt"
	;;
mis)
	BIN=${GRAPH_BIN}/MIS/maximal_independent_set
	PAR="128"
	;;
mi0)
	BIN=${GRAPH_BIN}/MIS/maximal_independent_set
	PAR="512"
	;;
mst)
	BIN=${GRAPH_BIN}/MST/mst
	IDATA="${GRAPH_DATA}/MST/rmat12.sym.gr"
	#IDATA="${GRAPH_DATA}/MST/USA-road-d.FLA.sym.gr"
	;;
ms0)
	BIN=${GRAPH_BIN}/MST/mst
	#IDATA="${GRAPH_DATA}/MST/rmat12.sym.gr"
	IDATA="${GRAPH_DATA}/MST/USA-road-d.FLA.sym.gr"
	;;
sss)
	BIN=${GRAPH_BIN}/SSSP/sssp
	IDATA="${GRAPH_DATA}/SSSP/rmat20.gr"
	#IDATA="${GRAPH_DATA}/SSSP/USA-road-d.FLA.gr"
	;;
ss0)
	BIN=${GRAPH_BIN}/SSSP/sssp
	#IDATA="${GRAPH_DATA}/SSSP/rmat20.gr"
	IDATA="${GRAPH_DATA}/SSSP/USA-road-d.FLA.gr"
	;;
*)
	echo "Invalid benchmark name!!"
	;;
esac

echo "${BIN} ${IDATA} ${ODATA} ${PAR}"
${BIN} ${IDATA} ${ODATA} ${PAR}
