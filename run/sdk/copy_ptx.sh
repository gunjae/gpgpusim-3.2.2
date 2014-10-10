#!/bin/bash
# ******************************************
#  Script for PTX codes
#	Gunjae Koo (gunjae.koo@gmail.com)
# ******************************************

## list of benchmarks to be simulated
BENCH_LIST="bpr bfs gaf gas hsp lud pff pth"
#CONFIG_LIST="mc_fifo mc_frfcfs"
#CONFIG_LIST="gto_dl11 lrr_dl11 2lv_dl11 gto_dl12 lrr_dl12 2lv_dl12"
#CONFIG_LIST="gto_ml1 lrr_ml1 2lv_ml1 gto_ml2 lrr_ml2 2lv_ml2"
#CONFIG_LIST="gto_pfm lrr_pfm 2lv_pfm"
#CONFIG_LIST="gto lrr 2lv"
CONFIG_LIST="2lv_sc1"
#CONFIG_LIST="gto_byp lrr_byp 2lv_byp"
#CONFIG_LIST="gto gto_w08 gto_w16 gto_w32"
#CONFIG_LIST="gto_mshr32 lrr_mshr32 2lv_mshr32 gto_mshr64 lrr_mshr64 2lv_mshr64"

## necessary to modify this information
RUN_DATE="20140211"
DST_DIR="../../res/ptx_codes"

## start of loops
for i in ${BENCH_LIST}; do
	for j in ${CONFIG_LIST}; do
		## 
		RUN_DIR=${i}_${j}_${RUN_DATE}
		echo " + Working folder is ${RUN_DIR} ..."

		PTX_FILES=`ls ${RUN_DIR}/_cuobjdump_complete*`

		for k in ${PTX_FILES}; do
			cp -f ${k} ${DST_DIR}/${i}.ptx
		done
		echo " + Done ... Hope results are good!!"
	done
done
