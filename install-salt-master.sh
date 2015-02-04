#!/bin/bash

if [ ! `grep -q '4505\|4506' /etc/sysconfig/iptables` ]; then
  echo "Open port 4505, 4506, 5000"
  sed -i 's|--dport 22 -j ACCEPT|--dport 22 -j ACCEPT\n-A INPUT -p tcp -m state --state NEW -m tcp --dport 4505 -j ACCEPT\n-A INPUT -p tcp -m state --state NEW -m tcp --dport 4506 -j ACCEPT\n-A INPUT -p tcp -m state --state NEW -m tcp --dport 4506 -j ACCEPT\n|' /etc/sysconfig/iptables
  service iptables restart
  service iptables save
fi

if [ ! -f "/var/salt_master_setup" ]; then
  echo "Install salt-master"
  yum -y --enablerepo=epel install salt-master
  chkconfig salt-master on
  sed -i 's|#interface: 0.0.0.0|#interface: 0.0.0.0\ninterface: 192.168.40.11|' /etc/salt/master
  service salt-master start
  #sed -i 's|^other_args=$|other_args="--insecure-registry master:5000"|' /etc/sysconfig/docker
  service docker restart
  touch /var/salt_master_setup
fi

echo "Check host resolution to /etc/hosts"
if [ ! `grep -q 192.168.40.11 /etc/hosts` ]; then
  echo "192.168.40.11  master" >> /etc/hosts
fi

if [ ! `grep -q 192.168.40.12 /etc/hosts` ]; then
  echo "192.168.40.12  minion1" >> /etc/hosts
fi

if [ ! `grep -q 192.168.40.13 /etc/hosts` ]; then
  echo "192.168.40.13  minion2" >> /etc/hosts
fi
