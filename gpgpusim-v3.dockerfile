
FROM ubuntu:14.04

# Dockerfile for gpgpusim-3.2.2 build

MAINTAINER Gunjae Koo <gunjae.koo@gmail.com>
LABEL description="GPGPU-Sim v3.2.2"

# --------------------------------------
# Installing basic applications
# --------------------------------------
RUN apt-get update -y
RUN apt-get install -y wget vim gcc g++

# --------------------------------------
# Change links for gcc/g++
# --------------------------------------
RUN apt-get install -y gcc-4.4 g++-4.4
RUN rm /usr/bin/gcc && ln -s /usr/bin/gcc-4.4 /usr/bin/gcc
RUN rm /usr/bin/g++ && ln -s /usr/bin/g++-4.4 /usr/bin/g++

# --------------------------------------
# Installing CUDA Toolkit and CUDA SDK
# --------------------------------------
WORKDIR /root
RUN apt-get install -y libxi-dev libxmu-dev freeglut3-dev
#RUN apt-get install -y libxi-dev libxmu-dev freeglut3-dev libcuda1-346 libcudart5.5
RUN wget http://developer.download.nvidia.com/compute/cuda/4_2/rel/toolkit/cudatoolkit_4.2.9_linux_64_ubuntu11.04.run
RUN wget http://developer.download.nvidia.com/compute/cuda/4_2/rel/sdk/gpucomputingsdk_4.2.9_linux.run
RUN chmod 755 *.run

RUN ./cudatoolkit_4.2.9_linux_64_ubuntu11.04.run
RUN ./gpucomputingsdk_4.2.9_linux.run
RUN rm *.run

# SDK will be installed in /root/NVIDIA_GPU_Computing_SDK

# --------------------------------------
# Installing GPGPU-Sim
# --------------------------------------
RUN apt-get install -y build-essential xutils-dev bison zlib1g-dev flex libglu1-mesa-dev

RUN echo "# setup for CUDA and GPGPU-Sim" > /root/setup_gpgpusim
RUN echo "PATH=$PATH:/usr/local/cuda/bin" >> /root/setup_gpgpusim
RUN echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/lib" >> /root/setup_gpgpusim
RUN echo "export CUDA_INSTALL_PATH=/usr/local/cuda" >> /root/setup_gpgpusim
RUN echo "export NVIDIA_COMPUTE_SDK_LOCATION=/root/NVIDIA_GPU_Computing_SDK" >> /root/setup_gpgpusim

RUN echo "source /root/setup_gpgpusim" >> /root/.bashrc


## DONE
