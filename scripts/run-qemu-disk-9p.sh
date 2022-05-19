#!/bin/sh

# boot from qcow2 disk in Paravirtualization mode.

model=/home/zpzhong/model
qemu=$model/qemu/qemu-6.2.0/build/qemu-system-aarch64
kernel=$model/kernel/linux-5.10.88/arch/arm64/boot/Image
image=$model/qemu/rootfs/linaro-lamp.qcow2

$qemu -M virt -cpu max -m 4G -smp 8 -nographic \
    -kernel $kernel  \
    -drive file=$image \
    -fsdev local,security_model=passthrough,id=fsdev0,path=$PWD \
    -device virtio-9p-device,id=fs0,fsdev=fsdev0,mount_tag=hosttag \
    -append "console=ttyAMA0 root=/dev/vda1 init=/sbin/init earlycon"


# run command to mount 9p fs
#  mount -t 9p hosttag /mnt -oversion=9p2000.L,posixacl,msize=1024M,cache=loose
# or
#  mount -t 9p hosttag /mnt -omsize=1024M
#

