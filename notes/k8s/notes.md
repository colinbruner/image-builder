# Setting up the kubemaster

add "cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory" to 
/etc/default/grub then `update-grub` and reboot

verify /proc/cmdline on post boot
