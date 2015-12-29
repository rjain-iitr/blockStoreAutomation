
set -x
source cinder_with_ceph.conf
echo "start"
#<<1
echo "*************INSTalling Ceph hammer upstream************"
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




echo "
Run these commands

sudo rbd map $DATABASE_POOL_NAME/$DATABASE_IMAGE_NAME --id admin --keyfile client.admin
mkfs.xfs /dev/rbd0
sudo mount /dev/rbd0
sudo mount /dev/rbd1 $DATABASE_MOUNT_PATH
sudo service mysql stop
sudo service cinder-api stop
sudo service cinder-scheduler stop
sudo service cinder-backup stop
sudo service cinder-volume stop

update /etc/mysql/my.cnf :
 	datadir =$DATABASE_MOUNT_PATH

 cp -R -p old-path $DATABASE_MOUNT_PATH
sudo chown mysql:mysql -R PATH

sudo service mysql restart
	

"



