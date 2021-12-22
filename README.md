
# QEMU AArch64 Setup

  This repo is used to describe how to setup environment for AArch64 with QEMU.

## Download Resource

 - download kernel: `wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.10.88.tar.xz`
 - download qemu: `wget https://download.qemu.org/qemu-6.2.0.tar.xz`
 - download rootfs: 
   - *precompiled rootfs*
   - `wget https://releases.linaro.org/archive/15.06/openembedded/aarch64/linaro-image-minimal-genericarmv8-20150618-754.rootfs.tar.gz`
   - `wget https://releases.linaro.org/archive/15.06/openembedded/aarch64/linaro-image-lamp-genericarmv8-20150618-754.rootfs.tar.gz`


## Compile

### Prepare
On fedora:
 - for qemu compiling: `dnf install ninja-build glib2-devel meson pixman-devel`
 - for kernel compiling: `dnf install gcc-g++-aarch64-linux-gnu`

### Compile QEMU
 - `cd qemu-6.2.0 && mkdir build && cd build`
 - `../configure --target-list=aarch64-linux-user,aarch64-softmmu`
 - `make -j`

### Compile Kernel
 - `make defconfig ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-`
   - with answer no for questions.
 - `make Image -j  ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-`


## Rootfs

 - create init ram disk:
```sh
$ fakeroot
# mkdir tmp && cd tmp
# tar xf ../linaro-image-minimal-genericarmv8-20150618-754.rootfs.tar.gz
# find . -print0 | cpio --null --create --verbose --format=newc | gzip --best > ../initramfs.cpio.gz
# exit
```

## Run QEMU

 - run qemu with init ram disk. [run-qemu-rd.sh](scripts/run-qemu-rd.sh)
```sh
#!/bin/sh

model=/home/zpzhong/model
qemu=$model/qemu/qemu-6.2.0/build/qemu-system-aarch64
kernel=$model/kernel/linux-5.10.88/arch/arm64/boot/Image
initrd=$model/qemu/rootfs/initramfs.cpio.gz

$qemu -M virt -cpu max -m 2G -nographic \
    -kernel $kernel -initrd $initrd \
    -append "console=ttyAMA0 rootfstype=ramfs rdinit=/sbin/init earlycon"
```

