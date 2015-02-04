#!/bin/bash

rpm -ivh http://ftp.cuhk.edu.hk/pub/linux/fedora-epel/6/i386/epel-release-6-8.noarch.rpm
yum -y --enablerepo=epel update

YUM_PKGS="docker-io python-pip"
PIP_PKGS="docker-py==0.5.0"

if [ ! -f "/var/docker_setup" ]; then
  echo "Install docker"
  yum -y --enablerepo=epel install $YUM_PKGS
  pip install $PIP_PKGS
  chkconfig docker on
  service docker start
  touch /var/docker_setup
fi