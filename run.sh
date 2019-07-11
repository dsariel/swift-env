#!/bin/sh
export IMAGE=$1
sudo chown dsariel $IMAGE
sudo chgrp dsariel $IMAGE
qemu-system-x86_64 -enable-kvm -m 6144 -smp 4 -hda $IMAGE -redir tcp:2222::22  -redir tcp:8080::80  #-spice tls-port=60101,disable-ticketing,x509-dir=/etc/pki/tls/certs/ #-nographic
