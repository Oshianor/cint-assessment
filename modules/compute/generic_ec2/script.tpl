#!/bin/bash
DEVICE=/dev/xvdf
IS_NITRO=`lsblk | grep nvme | wc -l`
if (( $IS_NITRO > 0 )); then
 DEVICE=/dev/nvme1n1
fi
mkfs -t ext4 $DEVICE
mkdir /apps
sudo echo "$DEVICE   /apps  ext4 defaults,nofail 0 2" >> /etc/fstab
mount -a
mkdir /apps/opt
chown -R gse:gse /apps/opt
