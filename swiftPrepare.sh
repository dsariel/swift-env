# sevral unit tests depend on ipv6. Docker daemon configures the container network for IPv4 only.
# One can enable IPv4/IPv6 dualstack support:
# https://docs.docker.com/v17.09/engine/userguide/networking/default_network/ipv6/#how-ipv6-works-on-docker


##################################################################################
# Install Development Tools and libs
  yum -y groupinstall 'Development Tools' \
  yum -y install byobu curl git htop man unzip vim wget vim sudo crudini 

# according to http://zuul.openstack.org/job/swift-probetests-centos-7
yum install -y wget
wget https://raw.githubusercontent.com/cloudrouter/centos-repo/master/CentOS-Base.repo; cp CentOS-Base.repo /etc/yum.repos.d

yum -y install epel-release
yum clean all
yum makecache
yum update -y
yum install -y git git-core zlib zlib-devel gcc-c++ patch readline readline-devel
yum install -y libyaml-devel libffi-devel openssl-devel make bzip2 autoconf automake
yum install -y libtool bison curl sqlite-devel telnet vim links
yum install -y initscripts net-tools wget htop tree
yum install -y rsyslog
yum install -y libffi-devel libxml2-devel libxslt-devel memcached openssl-devel xfsprogs
yum install -y python-pip man
RUN python -m pip install --upgrade pip
RUN pip install tox --upgrade
###################################################################################




##########################################################################################
# Swift setup - start
##########################################################################################
# Swift Dependencies
yum install -y git curl gcc memcached rsync sqlite xfsprogs git-core \
            libffi-devel xinetd python-setuptools python-coverage \
            python-devel python-nose python-simplejson pyxattr \
            python-eventlet python-greenlet python-paste-deploy \
            python-netifaces python-pip python-dns python-mock

# Installing the Swift CLI (python-swiftclient)
cd /opt && \
    git clone --single-branch --branch stable/rocky https://github.com/openstack/python-swiftclient.git && \
    cd /opt/python-swiftclient && \
    pip install -r requirements.txt && \
    python setup.py install;

yum install -y sudo crudini
# Installing Swift
cd /opt && \
    git clone --single-branch --branch stable/rocky https://github.com/openstack/swift.git && \
    cd /opt/swift && \ 
    sed -i "s/-xe/-x/g" /opt/swift/tools/test-setup.sh && \
    /opt/swift/tools/test-setup.sh
cd /opt/swift && pip install pip --upgrade && pip install setuptools --upgrade && \
    pip install --ignore-installed -r requirements.txt && \
    python setup.py install;
#  remove -e - no mount during the build
#  installs OpenStack and liberasurecode libs (of the current release)

mkdir /root/shared; sshfs dsariel@10.35.206.78:/home/dsariel/projects/swift/run/swift-env /root/shared

# python-urllib3 install on CentOS 7.6 is 1.21 while swift services require > 1.25 (which is installed
# by pip
yum remove -y python-urllib3
