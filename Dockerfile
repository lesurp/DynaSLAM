FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu16.04

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

## opencv **2**
RUN git clone --depth 1 https://github.com/lesurp/opencv -b support_cuda_10 /opencv && \
    mkdir /opencv/build && \
    cd /opencv/build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    make -j16 && \
    make install -j16

## dynaslam pip deps
RUN pip install --upgrade pip &&\
    pip install cython && \
    pip install numpy && \
    pip install tensorflow && \
    pip install tensorflow-gpu && \
    pip install keras && \
    pip install scikit-image && \
    pip install pycocotools

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

#RUN ln -s /usr/local/cuda/lib64/libcudart.so /usr/local/lib && \
#    ln -s /usr/local/cuda-10.1/targets/x86_64-linux/lib/libnppial.so /usr/local/lib/libopencv_dep_nppial.so && \
#    ln -s /usr/local/cuda-10.1/targets/x86_64-linux/lib/libnppicc.so /usr/local/lib/libopencv_dep_nppicc.so && \
#    ln -s /usr/local/cuda-10.1/targets/x86_64-linux/lib/libnppicom.so /usr/local/lib/libopencv_dep_nppicom.so && \
#    ln -s /usr/local/cuda-10.1/targets/x86_64-linux/lib/libnppidei.so /usr/local/lib/libopencv_dep_nppidei.so && \
#    ln -s /usr/local/cuda-10.1/targets/x86_64-linux/lib/libnppif.so /usr/local/lib/libopencv_dep_nppif.so && \
#    ln -s /usr/local/cuda-10.1/targets/x86_64-linux/lib/libnppig.so /usr/local/lib/libopencv_dep_nppig.so && \
#    ln -s /usr/local/cuda-10.1/targets/x86_64-linux/lib/libnppim.so /usr/local/lib/libopencv_dep_nppim.so && \
#    ln -s /usr/local/cuda-10.1/targets/x86_64-linux/lib/libnppist.so /usr/local/lib/libopencv_dep_nppist.so && \
#    ln -s /usr/local/cuda-10.1/targets/x86_64-linux/lib/libnppisu.so /usr/local/lib/libopencv_dep_nppisu.so && \
#    ln -s /usr/local/cuda-10.1/targets/x86_64-linux/lib/libnppitc.so /usr/local/lib/libopencv_dep_nppitc.so


COPY . /DynaSLAM
WORKDIR /DynaSLAM

RUN rm -r build Thirdparty/g2o/build Thirdparty/DBoW2/build && \
    ./build.sh RelWithDebInfo
