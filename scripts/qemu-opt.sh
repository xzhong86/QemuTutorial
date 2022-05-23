#!/bin/bash

_smp=${smp:-4}

opt_base_a=(-M virt -cpu cortex-a72 -smp $_smp -m 8G -nographic)
opt_base="${opt_base_a[@]}"

opt_os_a=(-kernel $KERNEL_IMG -drive file=$OS_DISK)
opt_os_a+=(-append 'console=ttyAMA0 root=/dev/vda2 rw earlycon')
opt_os="${opt_os_a[@]}"

_share=${share:-$PWD}
opt_9p_a=(-fsdev local,security_model=passthrough,id=fsdev0,path=$_share)
opt_9p_a+=(-device virtio-9p-device,id=fs0,fsdev=fsdev0,mount_tag=hosttag)
opt_9p="${opt_9p_a[@]}"

mon_telnet="-monitor telnet:localhost:5556,server,nowait"
# use `telnet localhost 5556` to connect

mon_unix="-monitor unix:qemu-monitor-socket,server,nowait"
# use `socat - unix-connext:qemu-monitor-socket`
# use `socat -,echo=0,icanon=0 unix-connext:qemu-monitor-socket`

con_unix="-serial unix:qemu-serial-socket,server,nowait"

fwd_ssh="-net user,hostfwd=tcp::51022-:22 -net nic"
# use `ssh usr@localhost -p 51022` to connect

# $qemu $opt_base_a[@] $opt_os_a[@] $opt_9p_a[@]

