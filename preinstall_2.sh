#!/bin/bash

#приступаем
echo "Подключим репозиторий"
sudo yum install -y http://repo.almalinux.org/elevate/elevate-release-latest-el$(rpm --eval %rhel).noarch.rpm