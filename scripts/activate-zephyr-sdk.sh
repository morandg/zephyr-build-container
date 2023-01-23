#!/bin/sh

set -e

usage() {
  echo "${0} -S <sdk_version> [-h] [-d]"
  echo "-h|--help         Show this help"
  echo "-S|--sdk-version  Version of the SDK to activate"
  echo "-i|--install-dir  SDK installation directory"
}

this_script=${0}
install_dir="/opt"
sdk_version="latest"
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
    -i|--install-dir)
      if [ -z ${2} ] ; then
        echo "No installation directory given"
        usage ${this_script}
        exit 1
      fi
      install_dir=${2}
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

if [ ${sdk_version} = "latest" ] ; then
  sdk_version=$(ls /opt/ | grep zephyr-sdk | sed -e 's/zephyr-sdk-//' | sort -Vr | head -n1)
fi

if [ ! -e ${install_dir}/zephyr-sdk-${sdk_version} ] ; then
  echo "Zephyr SDK ${sdk_version} not available, trying to install it ..."
  install-zephyr-sdk.sh --sdk-version ${sdk_version} --dest-dir ${install_dir}
fi

echo "Acvitating Zephyr SDK ${sdk_version}"
rm -f ${install_dir}/zephyr-sdk
ln -s ${install_dir}/zephyr-sdk-${sdk_version} ${install_dir}/zephyr-sdk
