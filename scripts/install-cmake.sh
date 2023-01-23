#!/bin/sh
set -e

SRC_DIR=/tmp/cmake

if [ -z ${1} ] ; then
  echo "No cmake version defined"
  exit 1
fi

git clone --progress https://github.com/Kitware/CMake.git ${SRC_DIR}
cd ${SRC_DIR}
git checkout ${1}
./configure --parallel=$(nproc)
make -j$(nproc)
make install
cd -
rm -rf ${SRC_DIR}
