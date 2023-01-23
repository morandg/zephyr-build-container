#!/bin/bash
# Use bash explicitely, Zephyr is not dash compatible

set -e

usage() {
  echo "${0}  [-h] [-S <sdk_version>] [-b <board>] [-a <app>]"
  echo "-h|--help         Show this help"
  echo "-S|--sdk-version  SDK verison to use"
  echo "-t|--tests        Path to tests to run"
  echo "-w|--workspace    Path to Zephyr workspace"
  echo "-o|--output-dir   Path to build directory"
}

this_script=${0}
zephyr_sdk_version=0.15.2
zephyr_workspace=/workspace
output_dir=/workspace/build-docker

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
      zephyr_sdk_version=${2}
      shift 2
      ;;
    -a|--app)
      if [ -z ${2} ] ; then
        echo "No Zephyr app given"
        usage ${this_script}
        exit 1
      fi
      zephyr_app=${2}
      shift 2
      ;;
    -t|--tests)
      if [ -z ${2} ] ; then
        echo "No twister tests given"
        usage ${this_script}
        exit 1
      fi
      twister_tests=${2}
      shift 2
      ;;
    -w|--workspace)
      if [ -z ${2} ] ; then
        echo "No Zephyr workspace given"
        usage ${this_script}
        exit 1
      fi
      zephyr_workspace=${2}
      shift 2
      ;;
    -o|--output-dir)
      if [ -z ${2} ] ; then
        echo "No build directory given"
        usage ${this_script}
        exit 1
      fi
      output_dir=${2}
      shift 2
      ;;
    *)
      echo "Unnkown argument ${1}"
      exit 1
      ;;
  esac
done

if [ -z ${twister_tests} ] ; then
  echo "No twister tests defined!"
  exit 1
fi

mkdir -p ${output_dir}
cd ${output_dir}

activate-zephyr-sdk.sh --sdk-version ${zephyr_sdk_version}

echo "Updating python requirements"
pip3 install --requirement ${zephyr_workspace}/zephyr/scripts/requirements.txt

echo "Running twister test in ${zephyr_workspace}/${twister_tests}"
. ${zephyr_workspace}/zephyr/zephyr-env.sh
twister -vv -T ${zephyr_workspace}/${twister_tests}

# Make sure files are accessible for normal use outside of container
chmod ugo+rwX -R ${output_dir}

echo "Compilation done"
