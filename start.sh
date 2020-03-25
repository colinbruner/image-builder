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

  # Downloaded image and VM names
  VM_NAME=${1}
  IMG_NAME="ubunut.img"
  # Standard libvirt image directory, BASE and VM image directories built off this.
  IMG_DIR="/var/lib/libvirt/images"
  # Path to base img dir and VM image dir
  BASE_IMG_DIR="/var/lib/libvirt/images/base"
  VM_IMG_DIR="/var/lib/libvirt/images/${VM_NAME}"
  # Path to base image and VM image
  BASE_IMG_PATH="${BASE_IMG_DIR}/${IMG_NAME}"
  VM_IMG_PATH="${VM_IMG_DIR}/${VM_NAME}.qcow2"

  # Create base/vm img dirs
  mkdir -p $VM_IMG_DIR
  mkdir -p $BASE_IMG_DIR

  if [[ ! -f ${BASE_IMG_PATH} ]]; then
    echo "Downloading image ${IMG_NAME}"
    # Download ubuntu
    curl -o $BASE_IMG_DIR/${IMG_NAME} https://cloud-images.ubuntu.com/daily/server/focal/current/focal-server-cloudimg-amd64.img
  else
    echo "Image found at ${BASE_IMG_DIR}/${IMG_NAME}. Skipping download"
  fi

  # Create base img
  qemu-img create -f qcow2 -o backing_file=${BASE_IMG_PATH} ${VM_IMG_PATH}

  # Resize img
  qemu-img resize ${VM_IMG_PATH} 20G

  echo $VM_IMG_DIR $VM_NAME
  # Create cloud-init ISO
  genisoimage -input-charset utf-8 \
    -output \
    ${VM_IMG_DIR}/${VM_NAME}-cidata.iso \
    -volid cidata \
    -joliet \
    -rock cloud-init/*

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
  virsh domifaddr ${1}
}

#TODO: Map this later using OS_FAMILY
#OS_VARIANT=centos7.0
OS_VARIANT=ubuntu19.04
OS_FAMILY=ubuntu

download_img "jenkins1"
install_img "jenkins1"

