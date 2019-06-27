

# Copying in Swift Configuration Files
mkdir -p /etc/swift
cd /opt/swift/etc
cp account-server.conf-sample /etc/swift/account-server.conf
cp container-server.conf-sample /etc/swift/container-server.conf
cp object-server.conf-sample /etc/swift/object-server.conf
cp proxy-server.conf-sample /etc/swift/proxy-server.conf
cp drive-audit.conf-sample /etc/swift/drive-audit.conf
cp swift.conf-sample /etc/swift/swift.conf


# Mounting drives
for i in {1..4}
do
   truncate -s 1GB /srv/node/1G_xfs_file$i
   /sbin/mkfs.xfs -f /srv/node/1G_xfs_file$i
   mkdir -p /srv/node/xfstmp$i
   sudo mknod -m660 /dev/loop$i b 7 $i
   /bin/chown root:disk /dev/loop$i
   sudo mount -o loop,noatime,nodiratime /srv/node/1G_xfs_file$i /srv/node/xfstmp$i
   sudo chmod 777 /srv/node/xfstmp$i
done


# Swift user
useradd swift
chown -R swift:swift /srv/node

# Creating the Ring Builder Files
cd /etc/swift
swift-ring-builder account.builder create 17 3 1
swift-ring-builder container.builder create 17 3 1
swift-ring-builder object.builder create 17 3 1
swift-ring-builder object-1.builder create 17 4 1
pushd /root/run/swift-env
python testBuilderContent.py
popd 

# Adding Devices to the Builder Files
cd /etc/swift
for i in {1..4}
do
    swift-ring-builder account.builder add r1z1-127.0.0.1:6002/xfstmp$i 100
    swift-ring-builder container.builder add r1z1-127.0.0.1:6001/xfstmp$i 100
    swift-ring-builder object.builder add r1z1-127.0.0.1:6000/xfstmp$i 100
    swift-ring-builder object-1.builder add r1z1-127.0.0.1:6000/xfstmp$i 100
done


# Building the Rings
cd /etc/swift
swift-ring-builder account.builder rebalance
swift-ring-builder container.builder rebalance
swift-ring-builder object.builder rebalance
swift-ring-builder object-1.builder rebalance


# Configuring Swift Logging
echo "local0.* /var/log/swift/all.log" > /etc/rsyslog.d/0-swift.conf
mkdir /var/log/swift
chown -R root:adm /var/log/swift
chmod -R g+w /var/log/swift
service rsyslog restart # TODO find how start the service in Docker container


# Setting the Hash Path Prefix and Suffix
sed -i '0,/changeme/{s/changeme/ACbO0g5Ry96CE7UqIkYbd4ZL3SVs7gkkItrnv1riiog/}' swift.conf
sed -i '0,/changeme/{s/changeme/4mx7zVcgiAbmXdZiJR8z1ydKm393TcO47L9Ng6hnK+Y/}' swift.conf


# Install remaining deps for Proxy Server

#   mount 1G file on loop0 (note that loop1-4 were occupied before)
#   install Openstack and liberasurecode (current release)
#/opt/swift/tools/test-setup.sh

#   install pyeclib and xattr
#pip install pyeclib
#pip install xattr
#pip install dnspython>=1.14.0 --upgrade
#pip install lxml

# Adding Users to proxy-server.conf
crudini --set /etc/swift/proxy-server.conf "filter:tempauth" user_test_tester3 testing3
crudini --set /etc/swift/proxy-server.conf "filter:tempauth" user_myaccount_me "secretpassword .admin .reseller_admin <storage URL:8080>"
crudini --set /etc/swift/proxy-server.conf "app:proxy-server" allow_account_management true
crudini --set /etc/swift/proxy-server.conf "app:proxy-server" account_autocreate true

# yum install -y python2-pyeclib.x86_64
# Starting the Proxy Server
swift-init proxy start

# Starting the Servers and Restarting the Proxy
swift-init account start
swift-init container start
swift-init object start
swift-init proxy restart
