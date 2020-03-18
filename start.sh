#!/bin/bash

VM_NAME=${1}

virsh define domains/${VM_NAME}.xml

