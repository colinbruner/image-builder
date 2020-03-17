#!/bin/bash

qemu-system-x86_64 -name centos-packer \
           -netdev user,id=user.0,hostfwd=tcp::4141-:22 \
           -device virtio-net,netdev=user.0 \
           -drive file=centos7-base-img/centos7-base,if=virtio,cache=writeback,discard=ignore,format=qcow2 \
           -machine type=pc,accel=kvm \
           -smp cpus=2,sockets=2 \
           -m 2048M \
	   -vnc 0.0.0.0:0,to=99,id=default
