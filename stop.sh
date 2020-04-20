#!/bin/bash

# NOTE: Quick script to clean and rebuild for testing.

virsh destroy unificon1
virsh undefine unificon1
rm -rf /var/lib/libvirt/images/unificon1
