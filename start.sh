#!/bin/bash

# VM Coniguration
VM_VCPUS=2
VM_MEMORY=2048
VM_DISK_SPACE="100G"

# OS Type
OS_VARIANT=centos7.0
#OS_VARIANT=ubuntu19.04

# Change this to point to a new Cloud image base
CLOUD_IMG_PATH="/app/image-builder/images/cloud/CentOS-8-GenericCloud-8.1.1911-20200113.3.x86_64.qcow2"


function create_img {
  # Create a CoW Snapshot of cloud Image to use as a base
  qemu-img create -f qcow2 \
    -o backing_file=$CLOUD_IMG_PATH \
    $LIBVIRT_VM_IMG_PATH
}

function resize_img {
  # Resize img
  qemu-img resize ${LIBVIRT_VM_IMG_PATH} ${VM_DISK_SPACE}
}

function create_cloud_init {
  # Generate a Cloud Init ISO to execute on boot
  genisoimage -input-charset utf-8 \
    -output \
    ${CLOUD_INIT_ISO_PATH} \
    -volid cidata \
    -joliet \
    -rock cloud-init/user-data cloud-init/${VM_NAME}/meta-data
}

function start_img {
  # Start the VM
  virt-install \
    --memory ${VM_MEMORY} \
    --vcpus ${VM_VCPUS} \
    --name ${VM_NAME} \
    --disk ${LIBVIRT_VM_IMG_PATH},device=disk \
    --disk ${CLOUD_INIT_ISO_PATH},device=cdrom \
    --os-type Linux \
    --os-variant ${OS_VARIANT} \
    --virt-type kvm \
    --graphics vnc,listen=0.0.0.0 \
    --network type='direct',trustGuestRxFilters='no',source='eno1',source.mode='bridge' \
    --import \
    --noautoconsole
}

# Full VM Name
VM_NAME=${1}
# Full VM Name without digits
VM_NAME_ALPHA=${VM_NAME//[[:digit:]]/}

# Libvirt image pathing information
LIBVIRT_VM_DIR="/var/lib/libvirt/images/${VM_NAME}/"
LIBVIRT_VM_IMG_PATH="/var/lib/libvirt/images/${VM_NAME}/${VM_NAME}.qcow2"
CLOUD_INIT_ISO_PATH="/var/lib/libvirt/images/${VM_NAME}/${VM_NAME}-cidata.iso"

# Ensure directory exists
mkdir -p $LIBVIRT_VM_DIR

### main
if [[ $VM_NAME == "destroy" ]]; then
  virsh destroy $2
  virsh undefine $2
else
  create_img
  resize_img
  create_cloud_init
  start_img
fi
