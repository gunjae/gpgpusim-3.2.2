#!/bin/bash
# ******************************************
#  Script for grep data from the 'stderr' outputs of clusters
#	Gunjae Koo (gunjae.koo@gmail.com)
# ******************************************

## list of benchmarks to be simulated
BN1="BFI CP LIB LPS MUM NQU RAY STO WP"
BN2="bpr bfs btr dwt gaf gas htw hsp hsr kmn lud myo nw pff pth sr1 sr2 scg"
#BN2="bpr bfs gaf gas hsp lud pff pth htw kmn"
BN3="cut his lbm mrg mrq sad sge spm ste tpc"
#BN3="bf1 cut his lbm mrg mrq sad sge spm ste tpc"
#BN4="alt asy blk cnt cnv dct dxt eig hst mca red scn sbq spd tfr vad wal"
BN4="alt asy bin blk cnv cnt dct dxt eig hst mam mca red spd scn sao sbq tfr vad wal"
#BN4="alt asy bin blk cnv cnt dct dxt eig hst mgs mt mca qsr red spd scn sao sbq snt tfr vad wal"
#BN4="alt asy bin blk cnv cnt dct dxt eig hst mgs mt mca qsr red spd scn sao sbq snt tfr txp vad wal"
BN5="ii km pvc pvr sm ss wc"
#BN5="ii km mm pvc pvr sm ss wc"
BN6="cor cov 2mm 3mm dit gmm gmv gsm mvt syr sy2 grm lu cv2 fdt jc1 jc2"
#BN6="cor cov 2mm 3mm atx bic dit gmm gmv gsm mvt syr sy2 grm lu adi cv2 cv3 fdt jc1 jc2"
BN7="blc bne mce rpe"
BN8="bf2 fft md md5 rdc s3d sca sor spv trd qtc rdt sct stn"
BN9="aps ccl ccn ccd clu gco gcu mis mst sss"

#BENCH_LIST="${BN1} ${BN2} ${BN3} ${BN4} ${BN5} ${BN6} ${BN7} ${BN8} ${BN9}"
BENCH_LIST="2mm gaf ga0 ga1 ga2 ga3 grm lu spm sp0 sp1"
BENCH_LIST="${BENCH_LIST} htw mrq mrr dwt dw0 dw1 dw2 dw3 dw4 bpr sr2 pff"
BENCH_LIST="${BENCH_LIST} bfs b00 b01 b02 b03 b04 b05 b06 b07 b08 b09 b10 sss ss0 ccl ccn ccd mst ms0 mis mi0 qtc"
BENCH_LIST="${BENCH_LIST} cut cu0 lbm lb0 hsp hs0 hs1 myo md lav"

CONFIG_LIST="lrr_m2050"
#CONFIG_LIST="gto_sc1_mshr16 lrr_sc1_mshr16 2lv_sc1_mshr16"
#CONFIG_LIST="gto_sc1_mshr64 lrr_sc1_mshr64 2lv_sc1_mshr64"
#CONFIG_LIST="gto_sc1_dlat001 lrr_sc1_dlat001 2lv_sc1_dlat001"
#CONFIG_LIST="gto_byp lrr_byp 2lv_byp"
#CONFIG_LIST="gto gto_w08 gto_w16 gto_w32"
#CONFIG_LIST="gto_mshr32 lrr_mshr32 2lv_mshr32 gto_mshr64 lrr_mshr64 2lv_mshr64"

## necessary to modify this information
## get date
if [ -n "$1" ]; then
	RUN_DATE=$1
else
	RUN_DATE=`date +%Y%m%d`
fi
#RUN_DATE="20141210"
DST_DIR="RES_${RUN_DATE}"
RUN_DIR="RUN"
CMPS_FILE="${PWD##*/}_${RUN_DATE}.tar.gz"

## parameters (dont' modify this)
SM_SPACE="00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15"
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

		if ! [ -d ${RUN_DIR} ]; then
			echo " + Folder ${RUN_DIR} is not found. Will be skipped"
			continue
		fi
		
		echo " + Extracting data from the stderr files in ${RUN_DIR} ..."
		BASE_FILE=${i}_${j}_${RUN_DATE}
		## general information (stdout file)
		DST_FILE=${DST_DIR}/${i}_${j}_${RUN_DATE}.rpt
		for k in $( ls ${RUN_DIR}/run_${i}.pbs.o*); do
			echo "cp -f ${k} ${DST_FILE}"
			cp -f ${k} ${DST_FILE}
		done
		#(cd ${RUN_DIR} && grep gpu_tot_sim_cycle run_${i}.pbs.o* >> ${DST_FILE}
		
		DST_FILE=${DST_DIR}/${i}_${j}_GK_${RUN_DATE}.dat
		echo "grep GK ${RUN_DIR}/run_${i}.pbs.o* >> ${DST_FILE}"
		grep GK ${RUN_DIR}/run_${i}.pbs.o* >> ${DST_FILE}
		
		## Instruction dependency information
#		DST_FILE=${DST_DIR}/${i}_${j}_InstDep_${RUN_DATE}.dat
#		echo "grep GK_InstDep ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
#		grep GK_InstDep ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}
#
#		## Warp time information
#		DST_FILE=${DST_DIR}/${i}_${j}_WarpTime_${RUN_DATE}.dat
#		echo "grep GK_WarpEnd ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
#		grep GK_WarpEnd ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}

		## Load divergency data
		DST_FILE=${DST_DIR}/${i}_${j}_LdDivr_${RUN_DATE}.dat
		echo "grep GK_LdDivr ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
		grep GK_LdDivr ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}

		## LD issue data
		for k in ${SM_SPACE}; do
			DST_FILE=${DST_DIR}/${i}_${j}_MshrLog${k}_${RUN_DATE}.dat
			echo "grep GK_MshrLog${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
			grep GK_MshrLog${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}
		done
			
		DST_FILE=${DST_DIR}/${i}_${j}_LdTime_${RUN_DATE}.dat
		echo "grep GK_LdTime ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
		grep GK_LdTime ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}

		DST_FILE=${DST_DIR}/${i}_${j}_L2qLen_${RUN_DATE}.dat
		echo "grep GK_L2qLen ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
		grep GK_L2qLen ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}
		
		DST_FILE=${DST_DIR}/${i}_${j}_MshrLen_${RUN_DATE}.dat
		echo "grep GK_MshrLen ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
		grep GK_Mshren ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}
		
		DST_FILE=${DST_DIR}/${i}_${j}_MemPat_${RUN_DATE}.dat
		echo "grep GK_MemPat ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
		grep GK_MemPat ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}
		
#%		for k in ${SM_SPACE}; do
#%			DST_FILE=${DST_DIR}/${i}_${j}_LdTime${k}_${RUN_DATE}.rpt
#%			echo "grep GK_LdTime${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
#%			grep GK_LdTime${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}
#%		done
		
#		## LD issue data
#		for k in ${MEM_SPACE}; do
#			DST_FILE=${DST_DIR}/${i}_${j}_LdIss${k}_${RUN_DATE}.rpt
#			echo "grep GK_LdIss${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
#			grep GK_LdIss${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}
#		done
#
#		## LD latency data
#		for k in ${MEM_SPACE}; do
#			DST_FILE=${DST_DIR}/${i}_${j}_LdLat${k}_${RUN_DATE}.rpt
#			echo "grep GK_LdLat${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
#			grep GK_LdLat${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}
#		done
#		
#		## Gap between prefetching and real-issue
#		for k in ${MEM_SPACE}; do
#			DST_FILE=${DST_DIR}/${i}_${j}_PftGap${k}_${RUN_DATE}.rpt
#			echo "grep GK_PftGap${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
#			grep GK_PftGap${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}
#		done
#
#		## Memory fetch info from L2 cache
#		for k in ${L2C_SPACE}; do
#			DST_FILE=${DST_DIR}/${i}_${j}_Rop${k}_${RUN_DATE}.rpt
#			echo "grep GK_ROP${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
#			grep GK_ROP${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}
#		done
#		
#		for k in ${L2C_SPACE}; do
#			DST_FILE=${DST_DIR}/${i}_${j}_L2Dram${k}_${RUN_DATE}.rpt
#			echo "grep GK_L2DRAM${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
#			grep GK_L2DRAM${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}
#		done
#		
#		for k in ${L2C_SPACE}; do
#			DST_FILE=${DST_DIR}/${i}_${j}_DramL2${k}_${RUN_DATE}.rpt
#			echo "grep GK_DRAML2${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
#			grep GK_DRAML2${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}
#		done
#		
#		for k in ${L2C_SPACE}; do
#			DST_FILE=${DST_DIR}/${i}_${j}_L2Icnt${k}_${RUN_DATE}.rpt
#			echo "grep GK_L2ICNT${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
#			grep GK_L2ICNT${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}
#		done
#		
#		for k in ${L2C_SPACE}; do
#			DST_FILE=${DST_DIR}/${i}_${j}_IcntL2${k}_${RUN_DATE}.rpt
#			echo "grep GK_ICNTL2${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
#			grep GK_ICNTL2${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}
#		done
#
#		for k in ${L2C_SPACE}; do
#			DST_FILE=${DST_DIR}/${i}_${j}_MC${k}_${RUN_DATE}.rpt
#			echo "grep GK_SCHED${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
#			grep GK_SCHED${k} ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}
#		done

#		## Memory latency
#		DST_FILE=${DST_DIR}/${i}_${j}_MfLat_${RUN_DATE}.rpt
#		echo "grep GK_MfLat ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
#		grep GK_MfLat ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}
#		
#		## Memory access patterns
#		DST_FILE=${DST_DIR}/${i}_${j}_MemPat_${RUN_DATE}.rpt
#		echo "grep GK_MemPat ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
#		grep GK_MemPat ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}
#		
#		## LD ready data (all)
#		DST_FILE=${DST_DIR}/${i}_${j}_LdRdy_${RUN_DATE}.rpt
#		echo "grep GK_LdRdy ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
#		grep GK_LdRdy ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}
#
#		## LD ready warp (when load issued)
#		DST_FILE=${DST_DIR}/${i}_${j}_LdRdy_${RUN_DATE}.rpt
#		echo "grep GK_LdRdy2 ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
#		grep GK_LdRdy2 ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}
#		
#		## LD issue gap data
#		DST_FILE=${DST_DIR}/${i}_${j}_LdIssGap_${RUN_DATE}.rpt
#		echo "grep GK_LdIssGap ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}"
#		grep GK_LdIssGap ${RUN_DIR}/run_${i}.pbs.e* >> ${DST_FILE}

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
