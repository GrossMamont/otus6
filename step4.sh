
echo "Создаем логический том под home"
lvcreate -n LogVol_Home -L 2G /dev/VolGroup00
echo "Создаем на нем ФС"
mkfs.xfs /dev/VolGroup00/LogVol_Home
mount /dev/VolGroup00/LogVol_Home /mnt/
cp -aR /home/* /mnt/
rm -rf /home/*
umount /mnt
mount /dev/VolGroup00/LogVol_Home /home/
echo "Правим fstab для автоматического монтирования /home"
echo "`blkid | grep Home | awk '{print $2}'` /home xfs defaults 0 0" >> /etc/fstab
echo "Сгенерируем файлы в /home/"
touch /home/file{1..20}
echo "Посмотрим файлы в /home/"
ls /home/
echo "Снимаем снапшот"
lvcreate -L 100MB -s -n home_snap /dev/VolGroup00/LogVol_Home
echo "Удаляем часть файлов"
rm -f /home/file{11..20}
echo "Посмотрим файлы в /home/"
ls /home/
echo "Восстановливаем со снапшота"
umount /home
lvconvert --merge /dev/VolGroup00/home_snap
mount /home
echo "Посмотрим файлы в /home/"
ls /home/
echo "Посмотрим, что подмонтировалось"
mount
echo "Посмотрим, что в fstab"
cat /etc/fstab
echo "Посмотрим диски"
lsblk
echo "Посмотрим диски перед четвертым ребутом"
lsblk