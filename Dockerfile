FROM tensorflow/tensorflow:latest-gpu-jupyter

RUN DEBIAN_FRONTEND="noninteractive" apt-get update && apt-get -y install tzdata

## C++ Compiler and Utils

RUN apt-get update \
  && apt-get install -y \
    build-essential \
    gcc \
    g++ \
    gdb \
    clang \
    make \
    ninja-build \
    cmake \
    autoconf \
    automake \
    locales-all \
    dos2unix \
    rsync \
    tar \
    wget \
    sudo \
    git \
    zip \
    unzip \
    pkg-config \
    && apt-get clean

### VCPKG
RUN wget --max-redirect 3 -O vcpkg.tar.gz https://github.com/microsoft/vcpkg/archive/master.tar.gz
RUN mkdir /opt/vcpkg
RUN tar xf vcpkg.tar.gz --strip-components=1 -C /opt/vcpkg
RUN /opt/vcpkg/bootstrap-vcpkg.sh
RUN ln -s /opt/vcpkg/vcpkg /usr/local/bin/vcpkg
RUN rm -rf vcpkg.tar.gz
RUN vcpkg integrate install
#
#
### BOOST
#RUN apt-get install -y \
#  build-base \
#  boost boost-dev \
#  && apt-get clean

#RUN vcpkg install boost

## PYBIND11
#RUN apt-get install -y python-pybind11

## CMAKE

### cmake=3.16.8  == version that works with CLion
#RUN wget https://github.com/Kitware/CMake/releases/download/v3.16.8/cmake-3.16.8-Linux-x86_64.sh -O /tmp/cmake.sh
#
## Install cmake globally for all users to /usr/bin
## and the exclude-subdir option is to get rid of the extra directory that is produced while extracting the .tar.gz archive.
#RUN bash /tmp/cmake.sh --prefix=/usr/ --exclude-subdir
## clean up tmp folder
#RUN rm /tmp/cmake.sh

### BOOST ###

# We pass the boost version as argument



#ENV BOOST_VERSION=1.79.0
#ENV BOOST_VERSION_="1_79_0"
#ENV BOOST_ROOT="/usr/include/boost"
#
#RUN apt-get -qq update && apt-get install -q -y software-properties-common
#RUN add-apt-repository ppa:ubuntu-toolchain-r/test -y
#
#RUN wget --max-redirect 3 https://boostorg.jfrog.io/artifactory/main/release/${BOOST_VERSION}/source/boost_${BOOST_VERSION_}.tar.gz
#RUN mkdir -p /usr/include/boost && tar  \
#    zxf \
#    boost_${BOOST_VERSION_}.tar.gz -C /usr/include/boost
##    boost_${BOOST_VERSION_}.tar.gz -C /usr/include/boost --strip-components=1
#
#RUN echo ${BOOST_ROOT}

### PYTHON ##

RUN apt-get install -y \
    software-properties-common

## to stop asking for tz info
#ENV DEBIAN_FRONTEND noninteractive
#
#RUN add-apt-repository ppa:deadsnakes/ppa
#RUN apt-get update \
#  && apt-get install -y \
#    python3.9-dev \
#    python3.9-distutils \
#    python3-pip \
#  && apt-get clean
#
## relink python to use the new version as default 'python'
#RUN unlink /usr/bin/python; exit 0;
#RUN unlink /usr/local/bin/python; exit 0;
#RUN ln -s /usr/bin/python3.9 /usr/bin/python; exit 0;
#RUN ln -s /usr/bin/python3.9 /usr/local/bin/python; exit 0;
## relink pip3 to 'pip'
#RUN unlink /usr/bin/pip; exit 0;
#RUN unlink /usr/local/bin/pip; exit 0;
#RUN ln -s /usr/bin/pip3 /usr/bin/pip; exit 0;
#RUN ln -s /usr/bin/pip3 /usr/local/bin/pip; exit 0;

## When using pip you must use "python -m pip ..." instead of "pip .."

RUN python -m pip install six
RUN python -m pip install --upgrade pip
RUN python -m pip install --upgrade setuptools
RUN python -m pip install --upgrade distlib
#
#ENV PYTHONPATH "${PYTHONPATH}:/usr/bin/python3.9"


### SSH ###

## SETUP USER FOR SSH
# user = 'user', password = 'password'
RUN useradd -m user && yes password | passwd user

RUN apt-get install -y \
    openssh-server \
 && apt-get clean

RUN service ssh start


EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]

