FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04

## apt
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update  && \
    apt-get upgrade -y  && \
    apt-get install -y gcc g++ libeigen3-dev libboost-all-dev libopencv-dev libglew-dev libgl1-mesa-dev cmake python-pip python git qt5-default libxkbcommon-dev python-tk

## pangolin
RUN git clone https://github.com/stevenlovegrove/Pangolin.git /Pangolin && \
    mkdir /Pangolin/build  && \
    cd  /Pangolin/build  && \
    cmake ..  && \
    make -j16 && \
    make install -j16 && \
    rm /Pangolin -r

## dynaslam pip deps
RUN pip install cython && \
    pip install numpy && \
    pip install tensorflow && \
    pip install tensorflow-gpu && \
    pip install keras && \
    pip install scikit-image && \
    pip install pycocotools


COPY . /DynaSLAM
WORKDIR /DynaSLAM

RUN rm -r build Thirdparty/g2o/build Thirdparty/DBoW2/build && \
    ./build.sh RelWithDebInfo
