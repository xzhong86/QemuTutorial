
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

 - create qcow2 disk image:
   - google "access qcow2 disk image" or refer to [page](https://www.jamescoyle.net/how-to/1818-access-a-qcow2-virtual-disk-image-from-the-host).
   - create image: `qemu-img create -f qcow2 linaro-lamp.qcow2 5G`
   - attach image: `sudo modprobe nbd && sudo qemu-nbd -c /dev/nbd0 linaro-lamp.qcow2`, need to install `sudo apt install emu-utils`
   - create partion: `sudo fdisk /dev/nbd0`, refer to fdisk usage.
   - format partion: `sudo mkfs.ext4 /dev/nbd0p1`
   - mount  partion: `sudo mount /dev/nbd0p1 /mnt/tmp`
   - extra files: `cd /mnt/tmp && sudo tar xf /path/to/linaro-image-lamp-genericarmv8-20150618-754.rootfs.tar.gz`
   - detach image: `sudo qemu-nbd -d /dev/nbd0 && sudo rmmod nbd`

 - or use raw disk image. refer to [page](https://azeria-labs.com/emulate-raspberry-pi-with-qemu/)
 - Another choice is use [libguestfs tools (chinese)](/doc/guestfish-usage-zh.md).

## Run QEMU

 - run qemu with init ram disk. [run-qemu-rd.sh](/scripts/run-qemu-rd.sh)

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

 - run with ramdisk and qcow2 disk. [run-qemu-dbg.sh](/scripts/run-qemu-dbg.sh). we boot from ramdisk and check the disk image.
 - run with qcow2 disk. [run-qemu-disk.sh](/scripts/run-qemu-disk.sh)
   - with Paravirtualization disk. simple and faster. refer to [page](https://serverfault.com/questions/803388/what-is-the-difference-between-dev-vda-and-dev-sda)
 - run with shared folder on host: refer to scripts/run-qemu-disk-9p.sh .

