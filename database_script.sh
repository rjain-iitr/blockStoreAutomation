$DATABASE_POOL_NAME=mysqldb
$DATABASE_IMAGE_NAME=mysqldbimage
$DOWN_DIR


set -x
source cinder_with_ceph.conf
echo "start"
#<<1
sudo cat > ceph.list <<EOF
deb http://ceph.com/debian-hammer/ trusty main
EOF

sudo cp -f ceph.list /etc/apt/sources.list.d/ceph.list
cat /etc/apt/sources.list.d/ceph.list

rm ceph.list
wget -q -O- 'https://download.ceph.com/keys/release.asc' | sudo apt-key add -

#1

#<<2
sudo apt-get update

sudo apt-get install python-rbd ceph-common -y
#2

sudo cp $DOWN_DIR/ceph.ceph /etc/ceph/ceph.conf





