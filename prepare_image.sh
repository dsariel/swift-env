
export IMAGE=$1
sudo chown dsariel $IMAGE
sudo chgrp dsariel $IMAGE
virt-customize --ssh-inject root -a $IMAGE
virt-customize --root-password password:PASSWORD -a $IMAGE
virt-customize --install epel-release,fuse-sshfs -a $IMAGE
virt-customize --copy-in /home/dsariel/projects/swift/run/swift-env/swiftPrepare.sh:/root -a $IMAGE
virt-customize --copy-in /home/dsariel/projects/swift/run/swift-env/swiftRun.sh:/root -a $IMAGE
virt-customize --copy-in /home/dsariel/projects/swift/run/swift-env/testBuilderContent.py:/root -a $IMAGE
virt-customize --copy-in /home/dsariel/projects/swift/run/swift-env/testMemcache.py:/root -a $IMAGE

#resize image: https://fatmin.com/2016/12/20/how-to-resize-a-qcow2-image-and-filesystem-with-virt-resize/
#TMP=tmp_file
#qemu-img info $IMAGE
#qemu-img resize $IMAGE +20G
#cp $IMAGE $TMP
#virt-resize --expand /dev/sda1 $TMP $IMAGE
#qemu-img info $IMAGE
#virt-filesystems --long -h --all -a $IMAGE
#rm $TMP
