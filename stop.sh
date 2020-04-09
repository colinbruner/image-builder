#!/bin/bash

virsh destroy jenkins1
virsh undefine jenkins1
#if [[ $2 == 'kill' ]]; then
rm -rf /var/lib/libvirt/images/jenkins1
