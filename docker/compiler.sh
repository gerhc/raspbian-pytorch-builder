#!/bin/bash

IMAGE="/pytorch_install/raspbian.img"
LOOP_DEVICE=$(losetup -f)

if [[ ! -f "raspbian.gz" ]]
then
  wget -O raspbian.gz https://downloads.raspberrypi.org/raspbian_lite_latest
fi

if [[ ! -f "raspbian.img" ]]
then
    unzip raspbian.gz && mv *-raspbian-*.img raspbian.img
    SECTOR=$(fdisk -lu $IMAGE | grep ^/pytorch_install/raspbian.img2 |  awk -F" "  '{ print $2 }')
    OFFSET=$(( $SECTOR * 512 ))
    dd if=/dev/zero bs=1M count=2048 >> $IMAGE
    sync
    losetup -o $OFFSET $LOOP_DEVICE $IMAGE
    parted $LOOP_DEVICE resizepart 1 100%
    sync
    e2fsck -f $LOOP_DEVICE
    resize2fs $LOOP_DEVICE
else
    SECTOR=$(fdisk -lu $IMAGE | grep ^/pytorch_install/raspbian.img2 |  awk -F" "  '{ print $2 }')
    OFFSET=$(( $SECTOR * 512 ))
    losetup -o $OFFSET $LOOP_DEVICE $IMAGE
fi

mount $LOOP_DEVICE /mnt
mount --bind /dev /mnt/dev/
mount --bind /sys /mnt/sys/
mount --bind /proc /mnt/proc
mount --bind /dev/pts /mnt/dev/pts
sed -i 's/^/#/g' /mnt/etc/ld.so.preload
cp /usr/bin/qemu-arm-static /mnt/usr/bin/
chroot /mnt sh -c "apt update && apt upgrade -y && apt install -y git libopenblas-dev libblas-dev m4 cmake cython python3-dev python3-yaml python3-setuptools"
chroot /mnt sh -c "if [ ! -d \"/home/pi/pytorch\" ]; cd /home/pi; then git clone --single-branch --branch v1.1.0 --recursive https://github.com/pytorch/pytorch; cd pytorch; git submodule sync; git submodule update --init --recursive; git submodule update --remote third_party/protobuf; fi"
chroot /mnt sh -c "cd /home/pi/pytorch; NO_CUDA=1 NO_DISTRIBUTED=1 NO_MKLDNN=1 NO_NNPACK=1 NO_QNNPACK=1 python3 setup.py build; NO_CUDA=1 NO_DISTRIBUTED=1 NO_MKLDNN=1 NO_NNPACK=1 NO_QNNPACK=1 python3 setup.py install"
sync

umount /mnt/sys/
umount /mnt/proc
umount /mnt/dev/pts
umount /mnt/dev/
umount /mnt
losetup -d $LOOP_DEVICE