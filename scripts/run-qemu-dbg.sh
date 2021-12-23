#!/bin/sh

# boot from ram disk to check disk image

model=/home/zpzhong/model
qemu=$model/qemu/qemu-6.2.0/build/qemu-system-aarch64
kernel=$model/kernel/linux-5.10.88/arch/arm64/boot/Image
initrd=$model/qemu/rootfs/initramfs.cpio.gz
image=$model/qemu/rootfs/linaro-lamp.qcow2

$qemu -M virt -cpu max -m 2G -nographic \
    -kernel $kernel -initrd $initrd \
    -drive file=$image \
    -append "console=ttyAMA0 rootfstype=ramfs rdinit=/sbin/init earlycon"

