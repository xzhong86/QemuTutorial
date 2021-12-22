#!/bin/sh

model=/home/zpzhong/model
qemu=$model/qemu/qemu-6.2.0/build/qemu-system-aarch64
kernel=$model/kernel/linux-5.10.88/arch/arm64/boot/Image
initrd=$model/qemu/rootfs/initramfs.cpio.gz

$qemu -M virt -cpu max -m 2G -nographic \
    -kernel $kernel -initrd $initrd \
    -append "console=ttyAMA0 rootfstype=ramfs rdinit=/sbin/init earlycon"

