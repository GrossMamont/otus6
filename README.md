# 6 OTUS Работа с LVM
Работа с LVM

Цель:
создавать и работать с логическими томами;


Описание/Пошаговая инструкция выполнения домашнего задания:
Для выполнения домашнего задания используйте методичку

Работа с LVM

Что нужно сделать?
на имеющемся образе (centos/7 1804.2)
https://gitlab.com/otus_linux/stands-03-lvm

/dev/mapper/VolGroup00-LogVol00 38G 738M 37G 2% /

уменьшить том под / до 8G
выделить том под /home
выделить том под /var (/var - сделать в mirror)
для /home - сделать том для снэпшотов
прописать монтирование в fstab (попробовать с разными опциями и разными файловыми системами на выбор)
Работа со снапшотами:
сгенерировать файлы в /home/
снять снэпшот
удалить часть файлов
восстановиться со снэпшота

(залоггировать работу можно утилитой script, скриншотами и т.п.)

Задание со звездочкой*
на нашей куче дисков попробовать поставить btrfs/zfs:
с кешем и снэпшотами
разметить здесь каталог /opt

_Для удобства вынес команды в отдельные скрипты.
Centos 7 уже перенесена в легаси, поэтому пришлось немного костылить с репами от АльмаЛинукс.
После последней перезагрузки скрипт просто выводит выводится инвормация о дисковой подсистеме и содержимое файла fstab._

Итоговый выхлоп
```
    lvm: Посмотрим диски в итоге
    lvm: NAME                       MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    lvm: sda                          8:0    0   40G  0 disk
    lvm: ├─sda1                       8:1    0    1M  0 part
    lvm: ├─sda2                       8:2    0    1G  0 part /boot
    lvm: └─sda3                       8:3    0   39G  0 part
    lvm:   ├─VolGroup00-LogVol00    253:0    0    8G  0 lvm  /
    lvm:   ├─VolGroup00-LogVol01    253:1    0  1.5G  0 lvm  [SWAP]
    lvm:   └─VolGroup00-LogVol_Home 253:2    0    2G  0 lvm  /home
    lvm: sdb                          8:16   0   10G  0 disk
    lvm: └─VolGroup01-LogVol01      253:8    0   10G  0 lvm
    lvm: sdc                          8:32   0    2G  0 disk
    lvm: ├─vg_var-lv_var_rmeta_0    253:3    0    4M  0 lvm
    lvm: │ └─vg_var-lv_var          253:7    0  952M  0 lvm  /var
    lvm: └─vg_var-lv_var_rimage_0   253:4    0  952M  0 lvm
    lvm:   └─vg_var-lv_var          253:7    0  952M  0 lvm  /var
    lvm: sdd                          8:48   0    1G  0 disk
    lvm: ├─vg_var-lv_var_rmeta_1    253:5    0    4M  0 lvm
    lvm: │ └─vg_var-lv_var          253:7    0  952M  0 lvm  /var
    lvm: └─vg_var-lv_var_rimage_1   253:6    0  952M  0 lvm
    lvm:   └─vg_var-lv_var          253:7    0  952M  0 lvm  /var
    lvm: sde                          8:64   0    1G  0 disk
    lvm: Посмотрим, что в fstab
    lvm: 
    lvm: #
    lvm: # /etc/fstab
    lvm: # Created by anaconda on Sat May 12 18:50:26 2018
    lvm: #
    lvm: # Accessible filesystems, by reference, are maintained under '/dev/disk'
    lvm: # See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
    lvm: #
    lvm: /dev/mapper/VolGroup00-LogVol00 /                       xfs     defaults        0 0
    lvm: UUID=570897ca-e759-4c81-90cf-389da6eee4cc /boot                   xfs     defaults        0 0
    lvm: /dev/mapper/VolGroup00-LogVol01 swap                    swap    defaults        0 0
    lvm: UUID="6e84bbb2-db53-4e76-87f9-8e57cae91ffa" /var ext4 defaults 0 0
    lvm: UUID="ee8a4204-066e-4226-8269-4442d50fb9d5" /home xfs defaults 0 0
```
