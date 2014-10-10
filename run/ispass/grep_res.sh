#!/bin/bash
# ******************************************
#  Script for grep data from the 'stderr' outputs of clusters
#	Gunjae Koo (gunjae.koo@gmail.com)
# ******************************************

## list of benchmarks to be simulated
#BENCH_LIST="BFS LPS MUM NQU RAY WP"
BENCH_LIST="BFS CP LIB LPS MUM NQU RAY STO WP"
#BENCH_LIST="LIB LPS NQU STO WP"
#BENCH_LIST="BFS CP MUM RAY"
#CONFIG_LIST="mc_fifo mc_frfcfs"
#CONFIG_LIST="gto_dl11 lrr_dl11 2lv_dl11 gto_dl12 lrr_dl12 2lv_dl12"
#CONFIG_LIST="gto_ml1 lrr_ml1 2lv_ml1 gto_ml2 lrr_ml2 2lv_ml2"
#CONFIG_LIST="gto_pfm lrr_pfm 2lv_pfm"
#CONFIG_LIST="gto lrr 2lv"
#CONFIG_LIST="c01_w48 c02_w48 c03_w48 c04_w48 c05_w48 c06_w48 c07_w48 c08_w48 c09_w48 c10_w48 c11_w48 c12_w48 c13_w48 c14_w48 c15_w48 c16_w48"
#CONFIG_LIST="gto_sc1_wc1 lrr_sc1_wc1 2lv_sc1_wc1"
CONFIG_LIST="gto_sc1 lrr_sc1 2lv_sc1"
#CONFIG_LIST="gto_sc1_mshr16 lrr_sc1_mshr16 2lv_sc1_mshr16"
#CONFIG_LIST="gto_sc1_mshr64 lrr_sc1_mshr64 2lv_sc1_mshr64"
#CONFIG_LIST="gto_sc1_dlat001 lrr_sc1_dlat001 2lv_sc1_dlat001"
#CONFIG_LIST="gto_byp lrr_byp 2lv_byp"
#CONFIG_LIST="gto gto_w08 gto_w16 gto_w32"
#CONFIG_LIST="gto_mshr32 lrr_mshr32 2lv_mshr32 gto_mshr64 lrr_mshr64 2lv_mshr64"

## necessary to modify this information
RUN_DATE="20140522"
DST_DIR="RES_${RUN_DATE}"
RUN_DIR="RUN"
CMPS_FILE="${PWD##*/}_${RUN_DATE}.tar.gz"

## parameters (dont' modify this)
MEM_SPACE="00 01 02 03 04 05 06 07 08 09 10 11"
L2C_SPACE="00 01 02 03 04 05 06 07 08 09 10 11"

echo " + Making result folder ..."
mkdir ${DST_DIR}

## start of loops
for i in ${BENCH_LIST}; do
	for j in ${CONFIG_LIST}; do
		## 
		RUN_DIR=${i}_${j}_${RUN_DATE}
		echo " + Working folder is ${RUN_DIR} ..."
		
		echo " + Extracting data from the stderr files in ${RUN_DIR} ..."
		BASE_FILE=${i}_${j}_${RUN_DATE}
		## general information (stdout file)
		DST_FILE=${DST_DIR}/${i}_${j}_${RUN_DATE}.rpt
		for k in $( ls ${RUN_DIR}/run_${i}.pbs.o*); do
			echo "cp -f ${k} ${DST_FILE}"
			cp -f ${k} ${DST_FILE}
		done
		#(cd ${RUN_DIR} && grep gpu_tot_sim_cycle run_${i}.pbs.o* >> ${DST_FILE}
		
		## LD issue data
		for k in ${MEM_SPACE}; do
			DST_FILE=${DST_DIR}/${i}_${j}_LdIss${k}_${RUN_DATE}.rpt
			echo "grep GK_LdIss${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
			grep GK_LdIss${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}
		done

		## LD latency data
		for k in ${MEM_SPACE}; do
			DST_FILE=${DST_DIR}/${i}_${j}_LdLat${k}_${RUN_DATE}.rpt
			echo "grep GK_LdLat${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
			grep GK_LdLat${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}
		done
		
		## Gap between prefetching and real-issue
		for k in ${MEM_SPACE}; do
			DST_FILE=${DST_DIR}/${i}_${j}_PftGap${k}_${RUN_DATE}.rpt
			echo "grep GK_PftGap${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
			grep GK_PftGap${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}
		done

		## Memory fetch info from L2 cache
		for k in ${L2C_SPACE}; do
			DST_FILE=${DST_DIR}/${i}_${j}_Rop${k}_${RUN_DATE}.rpt
			echo "grep GK_ROP${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
			grep GK_ROP${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}
		done
		
		for k in ${L2C_SPACE}; do
			DST_FILE=${DST_DIR}/${i}_${j}_L2Dram${k}_${RUN_DATE}.rpt
			echo "grep GK_L2DRAM${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
			grep GK_L2DRAM${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}
		done
		
		for k in ${L2C_SPACE}; do
			DST_FILE=${DST_DIR}/${i}_${j}_DramL2${k}_${RUN_DATE}.rpt
			echo "grep GK_DRAML2${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
			grep GK_DRAML2${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}
		done
		
		for k in ${L2C_SPACE}; do
			DST_FILE=${DST_DIR}/${i}_${j}_L2Icnt${k}_${RUN_DATE}.rpt
			echo "grep GK_L2ICNT${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
			grep GK_L2ICNT${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}
		done
		
		for k in ${L2C_SPACE}; do
			DST_FILE=${DST_DIR}/${i}_${j}_IcntL2${k}_${RUN_DATE}.rpt
			echo "grep GK_ICNTL2${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
			grep GK_ICNTL2${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}
		done

		for k in ${L2C_SPACE}; do
			DST_FILE=${DST_DIR}/${i}_${j}_MC${k}_${RUN_DATE}.rpt
			echo "grep GK_SCHED${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
			grep GK_SCHED${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}
		done

		## Memory latency
		DST_FILE=${DST_DIR}/${i}_${j}_MfLat_${RUN_DATE}.rpt
		echo "grep GK_MfLat ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
		grep GK_MfLat ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}
		
		## LD ready data (all)
		DST_FILE=${DST_DIR}/${i}_${j}_LdRdy_${RUN_DATE}.rpt
		echo "grep GK_LdRdy ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
		grep GK_LdRdy ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}

		## LD ready warp (when load issued)
		DST_FILE=${DST_DIR}/${i}_${j}_LdRdy_${RUN_DATE}.rpt
		echo "grep GK_LdRdy2 ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
		grep GK_LdRdy2 ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}
		
		## LD issue gap data
		DST_FILE=${DST_DIR}/${i}_${j}_LdIssGap_${RUN_DATE}.rpt
		echo "grep GK_LdIssGap ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
		grep GK_LdIssGap ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}

		echo " + Done ... Hope results are good!!"
	done
done

## compress
echo "compressing files..."
echo "tar -cvzf ${CMPS_FILE} ${DST_DIR}"
tar -cvzf ${CMPS_FILE} ${DST_DIR}

## delete destination directory
echo "removing ${DST_DIR}..."
rm -rf ${DST_DIR}
