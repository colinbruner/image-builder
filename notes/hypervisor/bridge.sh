#!/bin/bash

nmcli c show --active | grep br0 &>/dev/null
if [[ $? != 0 ]]; then
  echo "Connection will now break if connected over SSH."
  nmcli con down eno1
  nmcli con up br0
else
  echo "Doing nothing?"
fi

#nmcli c show --active | grep br0 &>/dev/null
#if [[ $? != 0 ]]; then
#  echo "Creating Bridge definition."
#  cat << EOF > bridge.xml
#<network>
#    <name>br0</name>
#    <forward mode="bridge"/>
#    <bridge name="br0" />
#</network>
#EOF
#
#  virsh net-define ./bridge.xml
#  virsh net-start br0
#  virsh net-autostart br0
#fi
