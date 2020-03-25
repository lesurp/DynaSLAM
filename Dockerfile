FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

## apt
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update  && \
    apt-get upgrade -y  && \
    apt-get install -y gcc g++ libeigen3-dev libboost-all-dev libglew-dev libgl1-mesa-dev cmake python-pip python git qt5-default libxkbcommon-dev python-tk libcudnn7 libcudnn7-dev --allow-change-held-packages

## pangolin
RUN git clone https://github.com/stevenlovegrove/Pangolin.git /Pangolin && \
    mkdir /Pangolin/build  && \
    cd  /Pangolin/build  && \
    cmake ..  && \
    make -j16 && \
    make install -j16 && \
    rm /Pangolin -r

############### THIS DOESN'T SEEM NECESSARY ACTUALLY
## opencv **2**
RUN git clone --depth 1 https://github.com/lesurp/opencv -b support_cuda_10 /opencv && \
    mkdir /opencv/build && \
    cd /opencv/build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    make -j16 && \
    make install -j16

RUN ln -s /usr/local/cuda/lib64/libcudart.so    /usr/lib/libopencv_dep_cudart.so && \
    ln -s /usr/local/cuda/lib64/libnppial.so    /usr/local/lib/libopencv_dep_nppial.so && \
    ln -s /usr/local/cuda/lib64/libnppicc.so    /usr/local/lib/libopencv_dep_nppicc.so && \
    ln -s /usr/local/cuda/lib64/libnppicom.so   /usr/local/lib/libopencv_dep_nppicom.so && \
    ln -s /usr/local/cuda/lib64/libnppidei.so   /usr/local/lib/libopencv_dep_nppidei.so && \
    ln -s /usr/local/cuda/lib64/libnppif.so     /usr/local/lib/libopencv_dep_nppif.so && \
    ln -s /usr/local/cuda/lib64/libnppig.so     /usr/local/lib/libopencv_dep_nppig.so && \
    ln -s /usr/local/cuda/lib64/libnppim.so     /usr/local/lib/libopencv_dep_nppim.so && \
    ln -s /usr/local/cuda/lib64/libnppist.so    /usr/local/lib/libopencv_dep_nppist.so && \
    ln -s /usr/local/cuda/lib64/libnppisu.so    /usr/local/lib/libopencv_dep_nppisu.so && \
    ln -s /usr/local/cuda/lib64/libnppitc.so    /usr/local/lib/libopencv_dep_nppitc.so

COPY . /DynaSLAM
WORKDIR /DynaSLAM

ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/DynaSLAM/TensorRT-6.0.1.5/lib"
ENV DTSETS=/data

## Note: pip sucks so we have to install all packages manually
## https://github.com/pypa/pip/issues/2083
RUN pip install --upgrade pip &&\
    grep -v "^#" requirements.txt | xargs -I{} pip install {} && \
    tar xf TensorRT-6.0.1.5.Ubuntu-16.04.x86_64-gnu.cuda-10.1.cudnn7.6.tar.gz && \
    rm -r build Thirdparty/g2o/build Thirdparty/DBoW2/build TensorRT-6.0.1.5.Ubuntu-16.04.x86_64-gnu.cuda-10.1.cudnn7.6.tar.gz && \
    pip install TensorRT-6.0.1.5/python/tensorrt-6.0.1.5-cp27-none-linux_x86_64.whl TensorRT-6.0.1.5/uff/uff-0.6.5-py2.py3-none-any.whl TensorRT-6.0.1.5/graphsurgeon/graphsurgeon-0.4.1-py2.py3-none-any.whl && \
    ./build.sh RelWithDebInfo
