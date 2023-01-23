FROM debian:bullseye

RUN \
  apt-get update && \
  apt-get upgrade --yes && \
  apt-get install --yes \
    device-tree-compiler \
    dfu-util \
    file \
    gcc \
    gcc-multilib \
    git \
    g++-multilib \
    gperf \
    libmagic1 \
    libsdl2-dev \
    libssl-dev \
    make \
    ninja-build \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-tk \
    python3-wheel \
    wget \
    xz-utils

# Install west
RUN pip3 install --upgrade west

# Zephyr needs a recent version of cmake
COPY scripts/install-cmake.sh /usr/bin
RUN install-cmake.sh v3.25.1

# For SDK compatibility list, see:
# https://docs.google.com/spreadsheets/d/1wzGJLRuR6urTgnDFUqKk7pEB8O6vWu6Sxziw_KROxMA
COPY scripts/install-zephyr-sdk.sh /bin/install-zephyr-sdk.sh
RUN install-zephyr-sdk.sh --sdk-version 0.14.2 --dest-dir /opt
RUN install-zephyr-sdk.sh --sdk-version 0.15.2 --dest-dir /opt

# Install initial python requirements from latest zephyr
RUN git clone --progress https://github.com/zephyrproject-rtos/zephyr.git && \
  pip3 install --requirement zephyr/scripts/requirements.txt && \
  rm zephyr -rf

# Configure Zephyr SDK
RUN echo export ZEPHYR_TOOLCHAIN_VARIANT=zephyr > ~/.zephyrrc && \
  echo export ZEPHYR_SDK_INSTALL_DIR=/opt/zephyr-sdk >> ~/.zephyrrc

COPY scripts/activate-zephyr-sdk.sh /bin/activate-zephyr-sdk.sh
COPY scripts/build-zephyr-app.sh /bin/build-zephyr-app.sh
COPY scripts/run-twiset-tests.sh /bin/run-twiset-tests.sh
