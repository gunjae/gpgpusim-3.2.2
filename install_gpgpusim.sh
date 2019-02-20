#!/bin/bash
# ******************************************
#	Scripts for installing GPGPU-Sim on Linux
#	 by Gunjae Koo (gunjae.koo@gmail.com)
# ******************************************
# This script for automating the installation process of GPGPU-Sim.
# The installation process is tested on Linux Mint 17.3 64-bits (based on Ubuntu 14.04 LTS)

# -------------------------------------
# Installing C/C++ compilers
# -------------------------------------
echo " -------------------------------------------------- "
echo " Installing appropriate version of C/C++ compilers     "
echo " -------------------------------------------------- "
mkdir -p ~/bin
sudo apt-get install g++
sudo apt-get install gcc-4.4 g++-4.4
echo " -------------------------------------------------- "
echo " Replacie the default compiler links (4.8 is the pre-installed version)"
echo " -------------------------------------------------- "
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.4 10
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 20
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.4 10
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 20
sudo update-alternatives --install /usr/bin/cc cc /usr/bin/gcc 30
sudo update-alternatives --set cc /usr/bin/gcc
sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++ 30
sudo update-alternatives --set c++ /usr/bin/g++

echo " -------------------------------------------------- "
echo " Select the appropriate version of gcc/g++"
echo " -------------------------------------------------- "
sudo update-alternatives --config gcc
sudo update-alternatives --config g++

# -------------------------------------------------
# Installing dependent libraries
# -------------------------------------------------
echo " -------------------------------------------------- "
echo " Installing required libraries"
echo " -------------------------------------------------- "
sudo apt-get install libxi-dev libxmu-dev freeglut3-dev
sudo apt-get install libcuda1-346 libcudart5.5

# -------------------------------------------------
# Installing CUDA Toolkit and CUDA SDK
# -------------------------------------------------
# GPGPU-Sim 3.2.2 supports up to 4.2 version of CUDA SDK
echo " -------------------------------------------------- "
echo " Downloadiing CUDA Toolkit and SDK"
echo " -------------------------------------------------- "
wget http://developer.download.nvidia.com/compute/cuda/4_2/rel/toolkit/cudatoolkit_4.2.9_linux_64_ubuntu11.04.run
wget http://developer.download.nvidia.com/compute/cuda/4_2/rel/sdk/gpucomputingsdk_4.2.9_linux.run
chmod 755 *.run

echo " -------------------------------------------------- "
echo " Installing CUDA Toolkit for nvcc. (target = /usr/local/cuda)"
echo " -------------------------------------------------- "
sudo ./cudatoolkit_4.2.9_linux_64_ubuntu11.04.run

echo " -------------------------------------------------- "
echo " Installing CUDA SDK (target = ~/bin/NVIDIA_GPU_Computing_SDK4)"
echo " -------------------------------------------------- "
./gpucomputingsdk_4.2.9_linux.run

# -------------------------------------------------
# Install GPGPU-Sim
# -------------------------------------------------
echo " -------------------------------------------------- "
echo " Installing apps for GPGPU-Sim"
echo " -------------------------------------------------- "
sudo apt-get install build-essential xutils-dev bison zlib1g-dev flex libglu1-mesa-dev
echo " -------------------------------------------------- "
echo " Installing apps for doxygen"
echo " -------------------------------------------------- "
sudo apt-get install doxygen graphviz
echo " -------------------------------------------------- "
echo " Installing apps for AerialVision"
echo " -------------------------------------------------- "
sudo apt-get install python-pmw python-ply python-numpy libpng12-dev python-matplotlib

# ------------------------------------------------
# Before compiling GPGPU-Sim
# ------------------------------------------------
echo ""
echo " ==========================================================="
echo " Source setup_gpgpusim"
echo " ==========================================================="
echo ""
echo " Then, make!!!"
