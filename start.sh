#!/bin/bash

function guest_mount {
  # Mount a guest image at a local mount point
  guestmount -a /var/lib/libvirt/images/${1}.img -m /dev/sda1 /mnt
}

function convert_img {
  # Convert img to qcow2 with progress bar
  qemu-img convert -p images/${OS_FAMILY}-images/${OS_FAMILY}-base.img /var/lib/libvirt/images/jenkins1.img
}

function download_img {
  #if [[ ! -f ${BASE_IMG_PATH} ]]; then
  #  echo "Downloading image ${IMG_NAME}"
  #  # Download ubuntu
  #  curl -o $BASE_IMG_DIR/${IMG_NAME} https://cloud-images.ubuntu.com/daily/server/focal/current/focal-server-cloudimg-amd64.img
  #else
  #  echo "Image found at ${BASE_IMG_DIR}/${IMG_NAME}. Skipping download"
  #fi
  echo

}

function create_cloud_init_iso {
  # Create cloud-init ISO
  genisoimage -input-charset utf-8 \
    -output \
    ${LIBVIRT_BUILD_IMG_DIR}/${VM_NAME}-cidata.iso \
    -volid cidata \
    -joliet \
    -rock cloud-init/*

}

function create_img_resize {
  # Create base img
  qemu-img create -f qcow2 -o backing_file=${BUILD_IMG_PATH} ${LIBVIRT_BUILD_IMG_PATH}

  # Resize img
  qemu-img resize ${BUILD_IMG_PATH} 20G
}

function install_img {
  VM_NAME=${1}

  virt-install \
    --memory 2048 \
    --vcpus 2 \
    --name ${VM_NAME} \
    --disk /var/lib/libvirt/images/${VM_NAME}/${VM_NAME}.qcow2,device=disk \
    --disk /var/lib/libvirt/images/${VM_NAME}/${VM_NAME}-cidata.iso,device=cdrom \
    --os-type Linux \
    --os-variant ${OS_VARIANT} \
    --virt-type kvm \
    --graphics none \
    --network type='direct',trustGuestRxFilters='no',source='eno1',source.mode='bridge' \
    --import \
    --noautoconsole

  dig ${VM_NAME}.home +short

}

#TODO: Map this later using OS_FAMILY
OS_VARIANT=centos7.0
#OS_VARIANT=ubuntu19.04
#OS_FAMILY=ubuntu
OS_FAMILY=redhat

# Args
VM_NAME=${1}
BUILD_IMAGE="${2}"

# Path to base img dir and VM image dir
BUILD_IMG_DIR="images/jenkins/${VM_NAME}"
BUILD_IMG_PATH="${BUILD_IMG_DIR}/${BUILD_IMAGE}"

# Path to base image and VM image
LIBVIRT_IMG_DIR="/var/lib/libvirt/images"
LIBVIRT_BUILD_IMG_DIR="/var/lib/libvirt/images/${VM_NAME}"
LIBVIRT_BUILD_IMG_PATH="${LIBVIRT_BUILD_IMG_DIR}/${VM_NAME}.qcow2"

# Create libvirt img dirs
mkdir -p $LIBVIRT_BUILD_IMG_DIR

#download_img "jenkins1"
#install_img "jenkins1"

