#!/bin/sh

set -e

SDK_BASE_URL=https://github.com/zephyrproject-rtos/sdk-ng/releases/download

usage() {
  echo "${0} -S <sdk_version> [-h] [-d]"
  echo "-h|--help         Show this help"
  echo "-S|--sdk-version  Version of the SDK to install"
  echo "-d|--dest-dir     SDK installation directory"
}

this_script=${0}
dest_dir="/opt"
while [ ${#} -gt 0 ] ; do
  case ${1} in
    -h|--help)
      usage ${this_script}
      exit 0
      ;;
    -S|--sdk-version)
      if [ -z ${2} ] ; then
        echo "No SDK version given!"
        usage ${this_script}
        exit 1
      fi
      sdk_version=${2}
      shift 2
      ;;
    -d|--dest-dir)
      if [ -z ${2} ] ; then
        echo "No destination path given"
        usage ${this_script}
        exit 1
      fi
      dest_dir=${2}
      shift 2
      ;;
    *)
      echo "Unnkown argument ${1}"
      exit 1
      ;;
  esac
done

if [ -z ${sdk_version} ] ; then
  echo "Please specify a SDK version to install"
  usage ${this_script}
  exit 1
fi

sdk_filename=zephyr-sdk-${sdk_version}_linux-x86_64.tar.gz
wget ${SDK_BASE_URL}/v${sdk_version}/${sdk_filename}
echo "Checking shasum ..."
wget --quiet -O - ${SDK_BASE_URL}/v${sdk_version}/sha256.sum | shasum --check --ignore-missing
echo "Extracting Zephyr SDK ..."
mkdir -p ${dest_dir}
tar xzf ${sdk_filename} -C ${dest_dir}
echo "Running Setup"
${dest_dir}/zephyr-sdk-${sdk_version}/setup.sh -h
rm ${sdk_filename}
echo "SDK ${sdk_version} ready!"
