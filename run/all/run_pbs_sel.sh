#!/bin/bash
# ******************************************
#  Script for running qsub in server farm
#	Gunjae Koo (gunjae.koo@gmail.com)
# ******************************************

CONFIG_DIR=~/workspace/gpgpu-msh/run/config

## list of benchmarks to be simulated
#BENCH_LIST="AES BFI CP MUM RAY"
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
BN6="cor cov 2mm 3mm atx bic dit gmm gmv gsm mvt syr sy2 grm lu adi cv2 cv3 fdt jc1 jc2"
BN7="blc bne mce rpe"
BN8="bf2 fft md md5 rdc s3d sca sor spv trd qtc rdt sct stn"
BN9="aps ccl ccn ccd clu gco gcu mis mst sss"

BENCH_LIST="2mm gaf ga0 ga1 ga2 ga3 grm lu spm sp0 sp1"
BENCH_LIST="${BENCH_LIST} htw mrq mrr dwt dw0 dw1 dw2 dw3 dw4 bpr sr2"
BENCH_LIST="${BENCH_LIST} bfs b00 b01 b02 b03 b04 b05 b06 b07 b08 b09 b10 sss ss0 ccl ccn ccd mst ms0 mis mi0"
BENCH_LIST="${BENCH_LIST} cut cu0 lbm lb0 hsp hs0 hs1 md lav"
#BENCH_LIST="${BN1} ${BN2} ${BN3} ${BN4} ${BN5} ${BN6} ${BN7} ${BN8} ${BN9}"
#BENCH_LIST="${BN8}"

## list of benchmarks which will end in long time
BENCH_LONG="gaf ga0 htw kmn scg b10 b11 b12 b13 b14 lav sr2"
BENCH_LONG="${BENCH_LONG} bf1 cut cu0 lbm lb0 mrg ste tpc"
BENCH_LONG="${BENCH_LONG} alt bin blk cnt cnv dxt eig hst red scn txp"
BENCH_LONG="${BENCH_LONG} ii km mm pvc pvr ss wc"
BENCH_LONG="${BENCH_LONG} cor cov 2mm atx gmv gsm mvt syr sy2 grm lu fdt"
BENCH_LONG="${BENCH_LONG} blc bne mce rpe"
BENCH_LONG="${BENCH_LONG} spv trd qtc rdt sct stn md5 s3d rdc md"
BENCH_LONG="${BENCH_LONG} aps gcu ccn ccd sss ss0 mst ms0"
#BENCH_LONG="alt bf1 bin blk cnt cnv cut dxt eig hst htw lbm km kmn ii mm mrg pvc pvr red ss scn ste tpc txp wc cor cov 2mm atx gmv gsm mvt syr sy2 grm lu fdt blc bne mce rpe spv trd qtc rdt sct stn md5 s3d rdc md"

## list of configs to be simulated
CONFIG_LIST="lrr_m2050"
#CONFIG_LIST="gto_sc1 lrr_sc1 2lv_sc1"
#CONFIG_LIST="gto lrr 2lv"
#CONFIG_LIST="gto_sc1_dlat001 lrr_sc1_dlat001 2lv_sc1_dlat001"
#CONFIG_LIST="c01_w48 c02_w48 c03_w48 c04_w48 c05_w48 c06_w48 c07_w48 c08_w48 c09_w48 c10_w48 c11_w48 c12_w48 c13_w48 c14_w48 c15_w48 c16_w48"

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
		if `list_contains "${BENCH_LONG}" "${i}"`; then
			echo " * Long benchmark. Simulation is limited ..."
			cat ${CONFIG_DIR}/opt_sim_limit.config >> ./${RUN_DIR}/gpgpusim.config
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
