
set -x
source cinder_deploy.conf
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

#<<3
sudo cat <<EOT >> $CEPH_FILE_LOCATION
[client]
rbd cache = true
rbd cache writethrough until flush = true
rbd default format = 2

[client.cinder]
keyring = $CINDER_KEYRING_FILE_LOCATION

[client.cinder-backup]
keyring = $CINDER_BACKUP_KEYRING_FILE_LOCATION
EOT

#3

#<<4
UUID_TEXT=`uuidgen`
echo $UUID_TEXT
cat > secret.xml <<EOF
<secret ephemeral='no' private='no'>
  <uuid>$UUID_TEXT</uuid>
  <usage type='ceph'>
    <name>$CLIENT_CINDER secret</name>
  </usage>
</secret>
EOF
cat secret.xml
cat >  uuidtext.txt <<EOF
$UUID_TEXT
EOF
#4


#<<6


sudo cat <<EOT >> $CINDER_FILE_LOCATION

backup_driver = cinder.backup.drivers.ceph
backup_ceph_conf = $CEPH_FILE_LOCATION
backup_ceph_user = cinder-backup
backup_ceph_chunk_size = 134217728
backup_ceph_pool = $BACKUP_POOL
backup_ceph_stripe_unit = 0
backup_ceph_stripe_count = 0
restore_discard_excess_bytes = true

[ceph]
volume_driver=cinder.volume.drivers.rbd.RBDDriver
volume_backend_name=ceph
rbd_pool=$STORAGE_POOL
rbd_ceph_conf=$CEPH_FILE_LOCATION
rbd_flatten_volume_from_snapshot=false
rbd_max_clone_depth=5
rbd_store_chunk_size=4
rados_connect_timeout=-1
rbd_user=$CINDER_USER
rbd_secret_uuid=$UUID_TEXT
EOT

#6




<<7
cinder type-create ceph
cinder type-key ceph set volume_backend_name=ceph
cinder service-list
7

<<part10

 sudo service cinder-scheduler restart
 sudo service cinder-api restart
 sudo service cinder-volume restart
part10



echo "end"
