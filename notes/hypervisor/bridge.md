##
Setup single physical interface linux bridge

### Create Bridge
nmcli con add ifname br0 type bridge con-name br0

### Define Slaves
nmcli con add type bridge-slave ifname eno1 master br0

### Down and start bridge

``` bash
cat << EOF > bridge.sh

#!/bin/bash
nmcli con down eno1
nmcli con up br0

EOF

# Over SSH Connection, may need to wait long or bounce box
sh ./bridge.sh &
```

### Define bridge network
```
cat << EOF > bridge.xml
<network>
    <name>br0</name>
    <forward mode="bridge"/>
    <bridge name="br0" />
</network>
EOF

virsh net-define ./bridge.xml
virsh net-start br0
virsh net-autostart br0
```

