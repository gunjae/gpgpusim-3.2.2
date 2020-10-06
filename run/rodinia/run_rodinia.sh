#!/bin/bash

if [ ! -n "$1" ]; then
    echo "usage: $0 BENCHNAME"
    exit 0
fi

BENCH=$1
RODINIA_DIR=~/workspace/gpgpu-bench/rodinia_3.1/cuda
RODINIA_DATA=~/workspace/gpgpu-bench/rodinia_3.1/data
RODINIA_BIN=~/workspace/gpgpu-bench/rodinia_3.1/bin/linux/cuda

BIN=""
DSET=""
IDATA=""
ODATA=""
PAR=""

case "$BENCH" in
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
b15)
	BIN="${RODINIA_BIN}/bfs"
	IDATA="${RODINIA_DATA}/bfs/graph32k500kedges_SV.txt"
	;;
b16)
	BIN="${RODINIA_BIN}/bfs"
	IDATA="${RODINIA_DATA}/bfs/graph32k5MEdges.txt"
	;;
b17)
	BIN="${RODINIA_BIN}/bfs"
	IDATA="${RODINIA_DATA}/bfs/graph8knodes300kedges.txt"
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
	IDATA="10 20 256 655360 655360 1000 none"
	ODATA="output.txt"
	PAR="1"
	;;
lav)
	BIN="${RODINIA_BIN}/lavaMD"
	PAR="-boxes1d 10"
	;;
*)
	echo "Invalid benchmark name!!!"
	;;
esac

echo "${BIN} ${IDATA} ${ODATA} ${PAR}"
${BIN} ${IDATA} ${ODATA} ${PAR} >> gpugj.rpt
