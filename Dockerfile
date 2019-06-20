# sevral unit tests depend on ipv6. Docker daemon configures the container network for IPv4 only.
# One can enable IPv4/IPv6 dualstack support:
# https://docs.docker.com/v17.09/engine/userguide/networking/default_network/ipv6/#how-ipv6-works-on-docker

FROM centos:7 

# Install.
RUN \
  yum -y groupinstall 'Development Tools' \
  yum -y install byobu curl git htop man unzip vim wget 

#RUN yum install -y https://centos7.iuscommunity.org/ius-release.rpm
#RUN yum update -y
#RUN yum install -y python36u python36u-libs python36u-devel python36u-pip
RUN yum install -y vim 
RUN yum install -y sudo

# according to http://zuul.openstack.org/job/swift-probetests-centos-7
RUN yum install -y wget
RUN wget https://raw.githubusercontent.com/cloudrouter/centos-repo/master/CentOS-Base.repo; cp CentOS-Base.repo /etc/yum.repos.d

RUN yum -y install epel-release
RUN yum clean all
RUN yum makecache
RUN yum update -y
RUN yum install -y git git-core zlib zlib-devel gcc-c++ patch readline readline-devel
RUN yum install -y libyaml-devel libffi-devel openssl-devel make bzip2 autoconf automake
RUN yum install -y libtool bison curl sqlite-devel telnet vim links
RUN yum install -y initscripts net-tools wget htop tree
RUN yum install -y rsyslog
RUN yum install -y libffi-devel libxml2-devel libxslt-devel memcached openssl-devel xfsprogs
RUN yum install -y python-pip man
RUN python -m pip install --upgrade pip
RUN pip install tox --upgrade


# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root

# Define default command.
CMD ["bash"]
