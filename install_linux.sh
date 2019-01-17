#!/bin/bash
# ******************************************
#	Scripts for installing GPGPU-Sim on Linux
#	 by Gunjae Koo (gunjae.koo@gmail.com)
# ******************************************
# This script is made for automate installing GPGPU-Sim, based on install_linux.txt
# Installation process is tested on Linux Mint 17.3 64-bits (based on Ubuntu 14.04 LTS)

# --------------------------------------------------
# Install appropriate version of C/C++ compilers
# --------------------------------------------------
mkdir -p ~/bin
sudo apt-get install g++
sudo apt-get install gcc-4.4 g++-4.4
echo ""
echo "Replace the default compiler links (4.8 is the pre-installed version)"
echo ""
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.4 10
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 20
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.4 10
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 20
sudo update-alternatives --install /usr/bin/cc cc /usr/bin/gcc 30
sudo update-alternatives --set cc /usr/bin/gcc
sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++ 30
sudo update-alternatives --set c++ /usr/bin/g++

echo ""
echo "Select the appropriate version"
echo ""
sudo update-alternatives --config gcc
sudo update-alternatives --config g++

# -------------------------------------------------
# Install dependent libraries
# -------------------------------------------------
echo ""
echo "Install required libraries"
echo ""
sudo apt-get install libxi-dev libxmu-dev freeglut3-dev
sudo apt-get install libcuda1-346 libcudart5.5

# -------------------------------------------------
# Install CUDA Toolkit and CUDA SDK
# -------------------------------------------------
# GPGPU-Sim 3.2.2 supports up to 4.2 version of CUDA SDK
echo ""
echo "Download CUDA Toolkit and SDK"
echo ""
wget http://developer.download.nvidia.com/compute/cuda/4_2/rel/toolkit/cudatoolkit_4.2.9_linux_64_ubuntu11.04.run
wget http://developer.download.nvidia.com/compute/cuda/4_2/rel/sdk/gpucomputingsdk_4.2.9_linux.run
chmod 755 *.run

echo ""
echo "Install CUDA Toolkit for nvcc. (target = /usr/local/cuda)"
echo ""
sudo ./cudatoolkit_4.2.9_linux_64_ubuntu11.04.run

echo ""
echo "Install CUDA SDK (target = ~/bin/NVIDIA_GPU_Computing_SDK4)"
echo ""
./gpucomputingsdk_4.2.9_linux.run

# -------------------------------------------------
# Install GPGPU-Sim
# -------------------------------------------------
echo ""
echo "Apps for GPGPU-Sim"
echo ""
sudo apt-get install build-essential xutils-dev bison zlib1g-dev flex libglu1-mesa-dev
echo ""
echo "Apps for doxygen"
echo ""
sudo apt-get install doxygen graphviz
echo ""
echo "Apps for AerialVision"
echo ""
sudo apt-get install python-pmw python-ply python-numpy libpng12-dev python-matplotlib

# ------------------------------------------------
# Before compiling GPGPU-Sim
# ------------------------------------------------
echo ""
echo "==========================================================="
echo "Add environment settings in your .bashrc"
echo "For example..."
echo "PATH=$PATH:/usr/local/cuda/bin"
echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/lib"
echo "export CUDA_INSTALL_PATH=/usr/local/cuda"
echo "export NVIDIA_COMPUTE_SDK_LOCATION=~/bin/NVIDIA_GPU_Computing_SDK4"
echo "==========================================================="
echo ""
echo "Then, make!!!"
