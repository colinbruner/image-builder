#!/bin/bash

# Sanity
if [[ $(command -v "packer.io" &>/dev/null) ]]; then
    echo "Please download packer.io and place the binary in your PATH."
fi

# rhel/centos and ubuntu supported
BUILD_TYPE=${1}

if [[ "${BUILD_TYPE,,}" =~ ^(rhel|centos|ubuntu)$ ]]; then
    echo "yes"
else
    echo "OS: ${BUILD_TYPE} is not suported. Try, rhel/centos/ubuntu."
fi
