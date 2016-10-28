#!/bin/bash
# ******************************************
#  Script for running qsub in server farm
#	Gunjae Koo (gunjae.koo@gmail.com)
# ******************************************

CONFIG_DIR=~/workspace/gpgpu-svc/run/config

## list of benchmarks to be simulated
source bench_sel.list
source bench_skip.list

BENCH_LIST="${BN1} ${BN2} ${BN3} ${BN4} ${BN5} ${BN6} ${BN7} ${BN8} ${BN9}"
#BENCH_LIST="BFI"

## list of benchmarks which will end in long time
BENCH_LONG="gaf ga0 htw scg b10 b11 b12 b13 b14 lav sr2"
BENCH_LONG="${BENCH_LONG} bf1 cut cu0 lbm lb0 mrg ste tpc"
BENCH_LONG="${BENCH_LONG} alt bin blk cnt cnv dxt eig hst red scn txp"
BENCH_LONG="${BENCH_LONG} ii km mm pvc pvr ss wc"
BENCH_LONG="${BENCH_LONG} cor cov 2mm atx gmv gsm mvt syr sy2 grm lu fdt"
BENCH_LONG="${BENCH_LONG} blc bne mce rpe"
BENCH_LONG="${BENCH_LONG} spv trd qtc rdt sct stn md5 s3d rdc md"
BENCH_LONG="${BENCH_LONG} aps gcu ccn ccd sss ss0 mst ms0 gco"
BENCH_LONG_KMN="kmn"

## list of configs to be simulated
CONFIG_LIST="lrr"
#L1D_CONFIG="s16k"
ICNT_CONFIG="config_fermi_islip.icnt"
#ICNT_CONFIG="config_fermi_islip_fs320.icnt"
#ICNT_CONFIG="config_kepler_islip.icnt"

function list_contains {
	local list="$1"
	local item="$2"
	if [[ $list =~ (^|[[:space:]])"$item"($|[[:space:]]) ]] ; then
		result=0
	else
		result=1
	fi
	return $result
}

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
		#echo " + L1 data cache configuration ${L1D_CONFIG} is added ..."
		#cat ${CONFIG_DIR}/l1d_${L1D_CONFIG}.config >> ./${RUN_DIR}/gpgpusim.config
		#echo " + ACE configuration ${ACE_CONFIG} is added ..."
		#cat ${CONFIG_DIR}/ace_${ACE_CONFIG}.config >> ./${RUN_DIR}/gpgpusim.config
		echo " + Interconnection configuration ${ICNT_CONFIG} is added ..."
		echo "-inter_config_file ${ICNT_CONFIG}" >> ./${RUN_DIR}/gpgpusim.config
		if `list_contains "${BENCH_LONG}" "${i}"`; then
			echo " + Long benchmark. Simulation is limited ..."
			cat ${CONFIG_DIR}/opt_sim_limit.config >> ./${RUN_DIR}/gpgpusim.config
		fi
		if `list_contains "${BENCH_LONG_KMN}" "${i}"`; then
			echo " + Long benchmark. Simulation is limited...  (KMN)"
			cat ${CONFIG_DIR}/opt_sim_limit_kmn.config >> ./${RUN_DIR}/gpgpusim.config
		fi
		cp ${CONFIG_DIR}/*.icnt ./${RUN_DIR}/.
		cp ${CONFIG_DIR}/*.xml ./${RUN_DIR}/.
		#cp rename_rpt.sh ./${RUN_DIR}/.

		echo " + Copying the run script run_${i}.pbs to ${RUN_DIR} ..."
		cat run_header.pbs > ./${RUN_DIR}/run_${i}.pbs
		cat run_gpuenv.pbs >> ./${RUN_DIR}/run_${i}.pbs
		echo "BENCH=${i}" >> ./${RUN_DIR}/run_${i}.pbs
		cat run_all.pbs >> ./${RUN_DIR}/run_${i}.pbs
		echo " + Run ... Good luck!!"
		(cd ${RUN_DIR} && qsub run_${i}.pbs)
	done
done
