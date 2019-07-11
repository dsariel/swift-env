# sevral unit tests depend on ipv6. Docker daemon configures the container network for IPv4 only.
# One can enable IPv4/IPv6 dualstack support:
# https://docs.docker.com/v17.09/engine/userguide/networking/default_network/ipv6/#how-ipv6-works-on-docker

FROM centos:7 

##################################################################################
# Install Development Tools and libs
RUN \
  yum -y groupinstall 'Development Tools' \
  yum -y install byobu curl git htop man unzip vim wget vim sudo crudini 

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
###################################################################################


###################################################################################
# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root
###################################################################################


##########################################################################################
# Swift setup - start
##########################################################################################
# Swift Dependencies
RUN yum install -y git curl gcc memcached rsync sqlite xfsprogs git-core \
            libffi-devel xinetd python-setuptools python-coverage \
            python-devel python-nose python-simplejson pyxattr \
            python-eventlet python-greenlet python-paste-deploy \
            python-netifaces python-pip python-dns python-mock

# Installing the Swift CLI (python-swiftclient)
RUN cd /opt && \
    git clone --single-branch --branch stable/rocky https://github.com/openstack/python-swiftclient.git && \
    cd /opt/python-swiftclient && \
    pip install -r requirements.txt && \
    python setup.py install;

RUN yum install -y sudo crudini
# Installing Swift
RUN cd /opt && \
    git clone --single-branch --branch stable/rocky https://github.com/openstack/swift.git && \
    cd /opt/swift && \ 
    sed -i "s/-xe/-x/g" /opt/swift/tools/test-setup.sh && \
    /opt/swift/tools/test-setup.sh
RUN cd /opt/swift && pip install pip --upgrade && pip install setuptools --upgrade && \
    pip install -r requirements.txt && \
    python setup.py install;
#  remove -e - no mount during the build
#  installs OpenStack and liberasurecode libs (of the current release)

##########################################################################################
# Swift setup - end 
##########################################################################################

# Define default command.
CMD ["bash"]

