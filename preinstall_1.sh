#!/bin/bash

#приступаем
echo "Перейдем на Альмалинукс"
sudo curl -o /etc/yum.repos.d/CentOS-Base.repo https://el7.repo.almalinux.org/centos/CentOS-Base.repo
sudo yum upgrade -y