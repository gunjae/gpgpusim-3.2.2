#!/bin/bash
# ******************************************
#  Script for running qsub in server farm
#	Gunjae Koo (gunjae.koo@gmail.com)
# ******************************************

CONFIG_DIR=~/workspace/gpgpu-msh/run/config

## list of benchmarks to be simulated
#BENCH_LIST="bf1 cut his lbm mrg mrq sad sge spm ste tpc"
#BENCH_LIST="bf1 cut his mrq sad sge spm"
#BENCH_LIST="cut his mrq sad sge spm"
BENCH_LIST="cut mrq sad sge spm"

#CONFIG_LIST="gto lrr 2lv"
#CONFIG_LIST="gto_sc1_dlat001 lrr_sc1_dlat001 2lv_sc1_dlat001"
#CONFIG_LIST="c01_w48 c02_w48 c03_w48 c04_w48 c05_w48 c06_w48 c07_w48 c08_w48 c09_w48 c10_w48 c11_w48 c12_w48 c13_w48 c14_w48 c15_w48 c16_w48"
CONFIG_LIST="gto_sc1 lrr_sc1 2lv_sc1"
#CONFIG_LIST="mc_fifo mc_frfcfs"
#CONFIG_LIST="gto_dl11 lrr_dl11 2lv_dl11 gto_dl12 lrr_dl12 2lv_dl12"
#CONFIG_LIST="gto_ml1 lrr_ml1 2lv_ml1 gto_ml2 lrr_ml2 2lv_ml2"
#CONFIG_LIST="gto_pfm lrr_pfm 2lv_pfm"
#CONFIG_LIST="gto_byp lrr_byp 2lv_byp"
#CONFIG_LIST="gto gto_w08 gto_w16 gto_w32"
#CONFIG_LIST="gto_mshr32 lrr_mshr32 2lv_mshr32 gto_mshr64 lrr_mshr64 2lv_mshr64"

## get date
if [ -n "$1" ]; then
    TODAY=$1
else
    TODAY=`date +%Y%m%d`
fi
RUN_DIR="RUN"

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

		echo " + Copying the run script run_${i}.pbs to ${RUN_DIR} ..."
		#cp run_${i}.pbs ./${RUN_DIR}/.
		cat run_header.pbs > ./${RUN_DIR}/run_${i}.pbs
		cat run_gpuenv.pbs >> ./${RUN_DIR}/run_${i}.pbs
		echo "BENCH=${i}" >> ./${RUN_DIR}/run_${i}.pbs
		cat run_parboil.pbs >> ./${RUN_DIR}/run_${i}.pbs
		echo " + Run ... Good luck!!"
		(cd ${RUN_DIR} && qsub run_${i}.pbs)
	done
done
