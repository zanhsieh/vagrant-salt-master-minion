FROM centos:centos6
MAINTAINER Ming Hsieh <zanhsieh@gmail.com>

# Do Salt install stuff and squeeze in a master.conf snippet that tells the minion
# to contact the master specified.

RUN rpm -Uvh http://ftp.cuhk.edu.hk/pub/Linux/fedora-epel/6Server/x86_64/epel-release-6-8.noarch.rpm
RUN yum -y install salt-minion --enablerepo=epel-testing && yum -y update && yum clean all
RUN [ ! -d /etc/salt/minion.d ] && mkdir -p /etc/salt/minion.d
ADD ./master.conf /etc/salt/minion.d/master.conf

RUN chkconfig salt-minion on

CMD /sbin/init
