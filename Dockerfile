# Docker image to use with Vagrant
# Aims to be as similar to normal Vagrant usage as possible
# Adds Puppet, SSH daemon, Systemd
# Adapted from https://github.com/BashtonLtd/docker-vagrant-images/blob/master/ubuntu1404/Dockerfile

FROM ubuntu:20.04
ENV container docker
ENV TZ=Asia/Seoul
ARG DEBIAN_FRONTEND=noninteractive

# kakao mirror 
RUN sed -i -e 's/archive\.ubuntu\.com/mirror\.kakao\.com/' /etc/apt/sources.list

RUN apt update \
  && apt install -qq -y init systemd \
  && apt install -qq -y build-essential \
  && apt install -qq -y tzdata \
  && apt install -qq -y vim curl \
  && apt-get clean autoclean \
  && apt-get autoremove -y \
  && rm -rf /var/lib/{apt,dpkg,cache,log}

# Install system dependencies, you may not need all of these
RUN apt-get install -y --no-install-recommends ssh sudo libffi-dev systemd openssh-client
RUN apt update && apt-get -y install net-tools iputils-ping git
# RUN  apt-get -y install git libssl-dev libpam0g-dev zlib1g-dev dh-autoreconf shellinabox

# Add vagrant user and key for SSH
RUN useradd --create-home -s /bin/bash vagrant
RUN echo -n 'vagrant:vagrant' | chpasswd
RUN echo 'vagrant ALL = NOPASSWD: ALL' > /etc/sudoers.d/vagrant
RUN chmod 440 /etc/sudoers.d/vagrant
RUN mkdir -p /home/vagrant/.ssh
RUN chmod 700 /home/vagrant/.ssh
RUN echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ==" > /home/vagrant/.ssh/authorized_keys
RUN chmod 600 /home/vagrant/.ssh/authorized_keys
RUN chown -R vagrant:vagrant /home/vagrant/.ssh
RUN sed -i -e 's/Defaults.*requiretty/#&/' /etc/sudoers
RUN sed -i -e 's/\(UsePAM \)yes/\1 no/' /etc/ssh/sshd_config

# Start SSH
RUN mkdir /var/run/sshd
EXPOSE 22
RUN /usr/sbin/sshd

# Start shellinabox
EXPOSE 4200
RUN apt-get -y install cmake libjson-c-dev libwebsockets-dev
RUN git clone https://github.com/tsl0922/ttyd.git
RUN cd ttyd && mkdir build && cd build && cmake .. && make && make install
RUN nohup ttyd -p 4200 /bin/bash > /dev/null 2>&1 &
# RUN sed -i -e 's/SHELLINABOX_ARGS="--no-beep"/SHELLINABOX_ARGS="--no-beep --disable-ssl"/' /etc/default/shellinabox
# RUN service shellinabox start

# Start Systemd (systemctl)
CMD ["/sbin/init"]