docker build -t swift .

docker run -d -t -i --privileged=true  -v /home/dsariel/projects/swift/run:/root/run swift

# something strange: docker run --rm -e container=docker --tmpfs /run  --tmpfs /tmp -v /sys/fs/cgroup:/sys/fs/cgroup:ro -ti --cap-add SYS_ADMIN  --privileged=true swift-ubuntu /sbin/init
