#!/bin/bash

if [ ! -n "$1" ]; then
	echo "usage: $0 BENCHNAME"
	exit 0
fi

BENCH=$1

GRAPH_DIR=~/workspace/gpgpu-bench/GraphBench
GRAPH_BIN=~/workspace/gpgpu-bench/GraphBench/benchmarks
GRAPH_DATA=~/workspace/gpgpu-bench/GraphBench/input

# making symbolic links
#ln -sf ${GRAPH_BIN} benchmarks
#ln -sf ${GRAPH_DATA} datasets
#ln -sf ${GRAPH_COMMON} common

BIN=""
DSET=""
IDATA=""
ODATA=""
PAR=""

case "$BENCH" in
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
mst)
	BIN=${GRAPH_BIN}/MST/mst
	IDATA="${GRAPH_DATA}/MST/rmat12.sym.gr"
	#IDATA="${GRAPH_DATA}/MST/USA-road-d.FLA.sym.gr"
	;;
sss)
	BIN=${GRAPH_BIN}/SSSP/sssp
	IDATA="${GRAPH_DATA}/SSSP/rmat20.gr"
	#IDATA="${GRAPH_DATA}/SSSP/USA-road-d.FLA.gr"
	;;
*)
	echo "Invalid benchmark name!!"
	;;
esac

echo "${BIN} ${IDATA} ${ODATA} ${PAR}"
${BIN} ${IDATA} ${ODATA} ${PAR} >> gpugj.rpt
