#!/bin/bash

#приступаем
mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh
yum install -y mdadm smartmontools hdparm gdisk mc xfsdump lvm2
echo "Посмотрим диски"
lsblk
echo "Посмотрим существующие Физические тома"
sudo pvscan
echo "Посмотрим существующие Группы томов"
sudo vgscan
echo "Посмотрим существующие Логические тома"
sudo lvscan
echo "Посмотрим целевой Логический том"
sudo lvdisplay /dev/VolGroup00/LogVol00
echo "Попробуем размонтировать /dev/VolGroup00/LogVol00"
sudo umount /dev/VolGroup00/LogVol00
echo "Размонтировать не получилось поэтому попробуем его перенести на другой PV"
sudo fdisk -l
echo "Инициализируем самый крупный Физическиq том"
sudo pvcreate /dev/sdb
echo "Посмотрим, к какой Группе томов его прикрепить"
sudo pvdisplay
echo "Цепляем к новой группе VolGroup01"
sudo vgcreate VolGroup01 /dev/sdb
echo "Посмотрим что получилось"
sudo pvdisplay
echo "Создадим подменный том"
sudo lvcreate -n LogVol01 -l +100%FREE /dev/VolGroup01
echo "Создадим файловую систему XFS"
sudo mkfs.xfs /dev/VolGroup01/LogVol01
echo "Создадим подменный том"
sudo mount /dev/VolGroup01/LogVol01 /mnt
echo "Смотрим расположение корневого раздела"
sudo lvdisplay
echo "Сдампим содержимое текущего корневого раздела в наш временный"
sudo xfsdump -J - /dev/VolGroup00/LogVol00 | sudo xfsrestore -J - /mnt
echo "Подмонтируем в chroot каталоги"
mount --bind /proc/ /mnt/proc/
mount --bind /sys/ /mnt/sys/
mount --bind /dev/ /mnt/dev/
mount --bind /run/ /mnt/run/
mount --bind /boot /mnt/boot/
echo "Посмотрим монтирование"
mount
echo "Заходим в окружение chroot нашего временного корня"
chroot /mnt/ /bin/bash << EOT
grub2-mkconfig -o /boot/grub2/grub.cfg
cd /boot ; for i in `ls initramfs-*img`; do dracut -v $i `echo $i|sed "s/initramfs-//g; s/.img//g"` --force; done
sed -i 's|rd.lvm.lv=VolGroup00/LogVol00|rd.lvm.lv=VolGroup01/LogVol01|g' /boot/grub2/grub.cfg
exit
EOT

echo "Посмотрим диски перед первым ребутом"
lsblk