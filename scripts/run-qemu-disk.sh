#!/bin/sh

# boot from qcow2 disk in Paravirtualization mode.

model=/home/zpzhong/model
qemu=$model/qemu/qemu-6.2.0/build/qemu-system-aarch64
kernel=$model/kernel/linux-5.10.88/arch/arm64/boot/Image
image=$model/qemu/rootfs/linaro-lamp.qcow2

$qemu -M virt -cpu max -m 2G -nographic \
    -kernel $kernel  \
    -drive file=$image \
    -append "console=ttyAMA0 root=/dev/vda1 init=/sbin/init earlycon"

