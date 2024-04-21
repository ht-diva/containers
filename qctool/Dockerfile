# hadolint global ignore=SC2086,DL3033,SC1091
# Dockerfile

# https://hub.docker.com/_/rockylinux
FROM rockylinux:8
ENV container docker

WORKDIR "/lib/systemd/system/sysinit.target.wants/"
RUN (for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]

RUN yum -y install wget ca-certificates gcc lapack; yum clean all;

# Install qctool 2
WORKDIR "/tmp/"
RUN  wget -q https://www.well.ox.ac.uk/~gav/resources/qctool_v2.2.0-CentOS_Linux7.8.2003-x86_64.tgz \
&&   tar -xvf qctool_v2.2.0-CentOS_Linux7.8.2003-x86_64.tgz && rm -f qctool_v2.2.0-CentOS_Linux7.8.2003-x86_64.tgz \
&&   mv qctool_v2.2.0-CentOS\ Linux7.8.2003-x86_64/qctool /usr/local/bin/ && chmod a+rwx /usr/local/bin/qctool \
&&   rm -rf qctool_v2.2.0-CentOS\ Linux7.8.2003-x86_64

ENV PATH=/usr/local/bin:$PATH

CMD ["/usr/sbin/init"]
