#!/bin/bash

echo "Посмотрим диски после первого ребута"
lsblk
echo "удаляем старый LV в 40G"
lvremove -y /dev/VolGroup00/LogVol00
echo "Смотрим расположение корневого раздела"
sudo lvdisplay
echo "создаем новый на 8G"
lvcreate -y -n LogVol00 -L 8G VolGroup00
echo "Смотрим, что получилось"
sudo lvdisplay
echo "Создадим ФС на разделе"
mkfs.xfs /dev/VolGroup00/LogVol00
echo "Подмонтируем"
mount /dev/VolGroup00/LogVol00 /mnt
echo "Сдампим root"
xfsdump -J - /dev/VolGroup01/LogVol01 | xfsrestore -J - /mnt
echo "Подмонтируем в chroot каталоги"
for i in /proc/ /sys/ /dev/ /run/ /boot/; do mount --bind $i /mnt/$i; done

echo "Заходим в окружение chroot нашего временного корня"
chroot /mnt/ /bin/bash << EOT
grub2-mkconfig -o /boot/grub2/grub.cfg
cd /boot ; for i in `ls initramfs-*img`; do dracut -v $i `echo $i|sed "s/initramfs-//g; s/.img//g"` --force; done
sed -i 's|rd.lvm.lv=VolGroup01/LogVol01|rd.lvm.lv=VolGroup00/LogVol00|g' /boot/grub2/grub.cfg
exit
EOT

echo "Посмотрим диски перед вторым ребутом"
lsblk