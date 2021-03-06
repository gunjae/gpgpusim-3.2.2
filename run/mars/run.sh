#!/bin/bash
# ***************************************************
# Script for running ispass2009 GPGPU benchmarks
#	Gunjae Koo (gunjae.koo@gmail.com)
# ***************************************************

# -------------------------------------------
# Environments

# GPGPU-sim
GPGPUSIM_DIR=~/workspace/gpgpu-svc

# Configs
CONFIG_DIR=~/workspace/gpgpu-svc/run/config
#CONFIG_LIST="gto lrr 2lv"
CONFIG_LIST="gto"
#CONFIG_LIST="lrr_sc1_mshr64"
#CONFIG_LIST="2lv_sc1 gto_sc1 lrr_sc1"
BENCH_LIST="pvc"

# Running directory
TODAY=`date +%Y%m%d`
RUN_DIR="RUN"

# -------------------------------------------
# Running

source ${GPGPUSIM_DIR}/setup_environment $1

for i in ${BENCH_LIST}; do
	for j in ${CONFIG_LIST}; do
		##
		RUN_DIR=${i}_${j}_${TODAY}
		echo " + Making ${RUN_DIR} folder ..."
		mkdir ${RUN_DIR}

		echo " + Copying configuration files to ${RUN_DIR} ..."
		cp ${CONFIG_DIR}/gpgpusim_${j}.config ./${RUN_DIR}/gpgpusim.config
		cp ${CONFIG_DIR}/*.icnt ./${RUN_DIR}/.
		cp ${CONFIG_DIR}/*.xml ./${RUN_DIR}/.
		cp rename_rpt.sh ./${RUN_DIR}/.
		cp run_mars.sh ./${RUN_DIR}/.

		echo " + Run benchmarks in ${RUN_DIR} ..."
		(cd ${RUN_DIR} && run_mars.sh ${i})
		echo " + Running of ${i}_${j}  has been completed ..."
	done
done
