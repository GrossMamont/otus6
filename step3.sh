#!/bin/bash

echo "Создаем зеркало"
pvcreate /dev/sdc /dev/sdd
vgcreate vg_var /dev/sdc /dev/sdd
echo "Создаем логический том под var"
lvcreate -y -n lv_var -L 950M -m1 vg_var
echo "Создаем на нем ФС"
mkfs.ext4 /dev/vg_var/lv_var
echo "Подмонтируем новый var"
mkdir /mnt
mount /dev/vg_var/lv_var /mnt
echo "Посмотрим сколько весит /var"
du -sh /var
echo "Почистим мусор"
yum clean all
pkcon refresh force -c -1
journalctl --vacuum-time=1h
rm -rf /var/tmp/*
echo "Посмотрим сколько весит после очистки /var"
du -sh /var
echo "Перемещаем туда /var"
cp -aR /var/* /mnt/
echo "сохраняем содержимое старого var"
mkdir /tmp/oldvar && mv /var/* /tmp/oldvar
echo "монтируем новый var в каталог /var"
umount /mnt
mount /dev/vg_var/lv_var /var
echo "Правим fstab для автоматического монтирования /var"
echo "`blkid | grep var: | awk '{print $2}'` /var ext4 defaults 0 0" >> /etc/fstab
echo "Посмотрим диски перед третьим ребутом"
lsblk