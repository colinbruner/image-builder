#!/bin/bash

	#--network=bridge=virbr0,model=virtio \
	#--disk path=/app/libvirt/images/centos8.qcow2,size=30,bus=virtio,format=qcow2 \
	#--virt-type=kvm \

#name=${1}
#os_type=${2}
#if [[ ! ${name} ]] || [[ ! ${os_type}  ]]; then
#    echo "Please provide a VM name and OS Type (rhel8|ubuntu1804)"
#    exit 1
#fi

#--check-cpu \
#--accelerate \
#--nographics
#--hvm \

sudo virt-install \
	--name app1 \
	--disk=/var/lib/libvirt/images/app1.qcow2 \
	--ram 2048 \
	--vcpus=2 \
	--network type='direct',trustGuestRxFilters='no',source='eno1',source.mode='bridge'
	--graphics vnc,listen=0.0.0.0 --noautoconsole \
	--os-type=linux --os-variant=centos7.0
