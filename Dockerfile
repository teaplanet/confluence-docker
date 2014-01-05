FROM ubuntu:12.04
MAINTAINER Ken(@teaplanet)

# locale
RUN locale-gen ja_JP.UTF-8
RUN update-locale LANG=ja_JP.UTF-8
ENV LANG ja_JP.UTF-8

# upstart on Docker
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl

# mount
RUN cat /proc/mounts > /etc/mtab

# OS
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y install vim curl pwgen unzip less supervisor ntpdate python-software-properties sudo

## timezone
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime


# install & setup
## ssh
RUN apt-get -y install ssh
RUN update-rc.d ssh defaults
RUN mkdir /var/run/sshd
ADD ./supervisor/sshd.conf /etc/supervisor/conf.d/sshd.conf

## MySQL
RUN echo mysql-server mysql-server/root_password password '' | debconf-set-selections
RUN echo mysql-server mysql-server/root_password_again password '' | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server
RUN service mysql stop
RUN update-rc.d mysql disable

RUN sed -i "/^innodb_buffer_pool_size*/ s|=.*|= 128M|" /etc/mysql/my.cnf
RUN sed -i "s/log_slow_verbosity/#log_slow_verbosity/" /etc/mysql/my.cnf
ADD ./supervisor/mysql.conf /etc/supervisor/conf.d/mysql.conf

# Confluence
ADD http://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-5.4.1-x64.bin /atlassian-confluence-5.4.1-x64.bin
ADD ./supervisor/confluence.conf /etc/supervisor/conf.d/confluence.conf

## user
RUN useradd -d /home/ken -g users -k /etc/skel -m -s /bin/bash ken
RUN yes password | passwd ken
RUN echo "ken	ALL=(ALL:ALL) ALL" > /etc/sudoers.d/ken
RUN chmod 440 /etc/sudoers.d/ken

ADD ./start.sh /
ADD ./startup /startup

CMD ["/bin/sh", "/start.sh"]
