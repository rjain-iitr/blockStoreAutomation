
set-x 
echo "start"
source cinder_with_ceph.conf

echo "create keyring"

ceph auth get-or-create $CLIENT_CINDER mon 'allow r' osd 'allow class-read object_prefix rbd_children, allow rwx pool=$STORAGE_POOL'
ceph auth get-or-create $CLIENT_GLANCE mon 'allow r' osd 'allow class-read object_prefix rbd_children, allow rwx pool=$BACKUP_POOL'
ceph auth get-or-create $CLIENT_BACKUP mon 'allow r' osd 'allow class-read object_prefix rbd_children, allow rwx pool=$IMAGES_POOL'

echo "copy conf file"

sudo cat $CEPH_FILE_LOCATION |ssh $CINDER_CONTROLLER_NODE sudo  tee $CEPH_FILE_LOCATION


echo "copy keyring files"
slwwp 2
ceph auth get-or-create $CLIENT_CINDER | ssh $CINDER_CONTROLLER_NODE sudo tee $CINDER_KEYRING_FILE_LOCATION
ceph auth get-or-create $CLIENT_CINDER | ssh $CINDER_CONTROLLER_NODE sudo tee  $CINDER_BACKUP_KEYRING_FILE_LOCATION

ssh $CINDER_CONTROLLER_NODE sudo useradd cinder
ssh $CINDER_CONTROLLER_NODE sudo chown cinder:cinder $CINDER_BACKUP_KEYRING_FILE_LOCATION
ssh $CINDER_CONTROLLER_NODE sudo chown cinder:cinder $CINDER_KEYRING_FILE_LOCATION
ech0 "end"
