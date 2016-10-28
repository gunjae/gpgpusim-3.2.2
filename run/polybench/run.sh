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
#CONFIG_LIST="gto_sc1 lrr_sc1 2lv_sc1"
#CONFIG_LIST="lrr_dl164k"
CONFIG_LIST="lrr"
#CONFIG_LIST="gtx780"
#CONFIG_LIST="2lv_sc1 gto_sc1 lrr_sc1"
L1D_CONFIG="s16k"
#BENCH_LIST="BFS LPS MUM NQU RAY WP"
BENCH_LIST="2mm"
#BENCH_LIST="dit"
#BENCH_LIST="RAY"
#BENCH_LIST="MUM"
#BENCH_LIST="CP LIB"
#BENCH_LIST="LPS MUM"
#BENCH_LIST="NQU RAY"
#BENCH_LIST="STO WP"
ICNT_CONFIG="config_fermi_islip.icnt"


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
		#cat ${CONFIG_DIR}/l1d_${L1D_CONFIG}.config >> ./${RUN_DIR}/gpgpusim.config
		echo "-inter_config_file ${ICNT_CONFIG}" >> ./${RUN_DIR}/gpgpusim.config
		echo "-gpgpu_max_cycle 100000" >> ./${RUN_DIR}/gpgpusim.config
		#echo "-gpgpu_max_cycle 1200000" >> ./${RUN_DIR}/gpgpusim.config
		cp ${CONFIG_DIR}/*.icnt ./${RUN_DIR}/.
		cp ${CONFIG_DIR}/*.xml ./${RUN_DIR}/.
		cp rename_rpt.sh ./${RUN_DIR}/.
		cp run_polybench.sh ./${RUN_DIR}/.

		echo " + Run benchmarks in ${RUN_DIR} ..."
		(cd ${RUN_DIR} && run_polybench.sh ${i})
		echo " + Running of ${i}_${j}  has been completed ..."
	done
done
