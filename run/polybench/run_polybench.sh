#!/bin/bash

if [ ! -n "$1" ]; then
	echo "usage: $0 BENCHNAME"
	exit 0
fi

BENCH=$1

POLYBENCH_DIR=~/workspace/gpgpu-bench/PolyBench-ACC/CUDA
POLYBENCH_BIN=~/workspace/gpgpu-bench/PolyBench-ACC/CUDA
#POLYBENCH_DATA=~/workspace/gpgpu-bench/PolyBench-ACC/CUDA
#POLYBENCH_COMMON=~/workspace/gpgpu-bench/parboil/common

# making symbolic links
#ln -sf ${POLYBENCH_BIN} benchmarks
#ln -sf ${POLYBENCH_DATA} datasets
#ln -sf ${POLYBENCH_COMMON} common

BIN=""
DSET=""
IDATA=""
ODATA=""
PAR=""

case "$BENCH" in
cor)
	BIN=${POLYBENCH_BIN}/datamining/correlation/correlation.exe
	;;
cov)
	BIN=${POLYBENCH_BIN}/datamining/covariance/covariance.exe
	;;
2mm)
	BIN=${POLYBENCH_BIN}/linear-algebra/kernels/2mm/2mm.exe
	;;
3mm)
	BIN=${POLYBENCH_BIN}/linear-algebra/kernels/3mm/3mm.exe
	;;
atx)
	BIN=${POLYBENCH_BIN}/linear-algebra/kernels/atax/atax.exe
	;;
bic)
	BIN=${POLYBENCH_BIN}/linear-algebra/kernels/bicg/bicg.exe
	;;
dit)
	BIN=${POLYBENCH_BIN}/linear-algebra/kernels/doitgen/doitgen.exe
	;;
gmm)
	BIN=${POLYBENCH_BIN}/linear-algebra/kernels/gemm/gemm.exe
	;;
gmv)
	BIN=${POLYBENCH_BIN}/linear-algebra/kernels/gemver/gemver.exe
	;;
gsm)
	BIN=${POLYBENCH_BIN}/linear-algebra/kernels/gesummv/gesummv.exe
	;;
mvt)
	BIN=${POLYBENCH_BIN}/linear-algebra/kernels/mvt/mvt.exe
	;;
syr)
	BIN=${POLYBENCH_BIN}/linear-algebra/kernels/syrk/syrk.exe
	;;
sy2)
	BIN=${POLYBENCH_BIN}/linear-algebra/kernels/syr2k/syr2k.exe
	;;
grm)
	BIN=${POLYBENCH_BIN}/linear-algebra/solvers/gramschmidt/gramschmidt.exe
	;;
lu)
	BIN=${POLYBENCH_BIN}/linear-algebra/solvers/lu/lu.exe
	;;
adi)
	BIN=${POLYBENCH_BIN}/stencils/adi/adi.exe
	;;
cv2)
	BIN=${POLYBENCH_BIN}/stencils/convolution-2d/2DConvolution.exe
	;;
cv3)
	BIN=${POLYBENCH_BIN}/stencils/convolution-3d/3DConvolution.exe
	;;
fdt)
	BIN=${POLYBENCH_BIN}/stencils/fdtd-2d/fdtd2d.exe
	;;
jc1)
	BIN=${POLYBENCH_BIN}/stencils/jacobi-1d-imper/jacobi1D.exe
	;;
jc2)
	BIN=${POLYBENCH_BIN}/stencils/jacobi-2d-imper/jacobi2D.exe
	;;
*)
	echo "Invalid benchmark name!!"
	;;
esac

echo "${BIN} ${IDATA} ${ODATA} ${PAR}"
${BIN} ${IDATA} ${ODATA} ${PAR} >> gpugj.rpt
