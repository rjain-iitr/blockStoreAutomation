<<0
CINDER_FILE_LOCATION=/etc/cinder/cinder.conf
CINDER_API_FILE_LOCATION=/etc/cinder/api-paste.ini
CEPH_FILE_LOCATION=/etc/ceph/ceph.conf
RABBIT_MQ_PASSWORD=test123
CINDER_USER=cinder
ROOT_USER=root
ADMIN_USER=admin
CINDER_DB_PASS=test123
GLANCE_NODE=glance
GLANCE_NODE_IP=172.31.23.177
KEYSTONE_NODE=keystone
KEYSTONE_AUTH_PORT=35357
KEYSTONE_NODE_IP=172.31.23.177
CINDER_NODE_IP=172.31.23.177
MYSQL_CONF_FILE=/etc/mysql/my.cnf
DATABASE_NAME=cinder
CINDER_HOST=cinderController
RABBIT_MQ_HOST=$CINDER_HOST
RABBIT_MQ_USER=stackrabbit
DATABASE_HOST=$CINDER_HOST
ADMIN_USER=admin
ADMIN_PASS=password
0

set -x
source cinder_deploy.conf
echo "start" 
sudo apt-get update
sudo apt-get install mariadb-server python-mysqldb -y
sleep 60
sudo cat $MYSQL_CONF_FILE |grep "bind-address"
sudo sed -i 's@bind-address.*@bind-address = '"$CINDER_NODE_IP"'@g' $MYSQL_CONF_FILE
sudo cat $MYSQL_CONF_FILE |grep "bind-address"
sudo service mysql restart
echo "add rabitMq"
sleep 10
sudo apt-get install rabbitmq-server -y

sudo rabbitmqctl add_user $RABBIT_MQ_USER $RABBIT_MQ_PASSWORD
sudo rabbitmqctl set_permissions $RABBIT_MQ_USER ".*" ".*" ".*"



echo " run these commands in mysql shell

CREATE DATABASE $DATABASE_NAME;

GRANT ALL PRIVILEGES ON cinder.* TO '$CINDER_USER'@'$DATABASE_HOST' \
                          IDENTIFIED BY '$CINDER_DB_PASS';
GRANT ALL PRIVILEGES ON cinder.* TO '$CINDER_USER'@'%' \
                          IDENTIFIED BY '$CINDER_DB_PASS';

GRANT ALL PRIVILEGES ON cinder.* TO '$ROOT_USER'@'$DATABASE_HOST' \
                          IDENTIFIED BY '$CINDER_DB_PASS';
GRANT ALL PRIVILEGES ON cinder.* TO '$ROOT_USER'@'%' \
                          IDENTIFIED BY '$CINDER_DB_PASS';
GRANT ALL PRIVILEGES ON cinder.* TO '$ADMIN_USER'@'$DATABASE_HOST' \
                          IDENTIFIED BY '$CINDER_DB_PASS';
GRANT ALL PRIVILEGES ON cinder.* TO '$ADMIN_USER'@'%' \
                          IDENTIFIED BY '$CINDER_DB_PASS';








"

 mysql -u root -p



sudo  apt-get install cinder-api cinder-scheduler cinder-volume python-cinderclient -y



sudo cat <<EOT >> $CINDER_FILE_LOCATION

rpc_backend = rabbit
auth_strategy = keystone
my_ip = $CINDER_NODE_IP
glance_host=$GLANCE_NODE_IP
os_region_name = RegionOne
#enabled_backends = ceph

[keystone_authtoken]
auth_uri = http://$KEYSTONE_NODE:5000
auth_host = $KEYSTONE_NODE
auth_port = $KEYSTONE_AUTH_PORT
auth_protocol = http

username = $ADMIN_USER
password = $ADMIN_PASS
#cafile = /tmp/signing_cert.pem
project_name = service


[database]
connection = mysql://$ROOT_USER:$CINDER_DB_PASS@$DATABASE_HOST/$DATABASE_NAME

[oslo_messaging_rabbit]
rabbit_host = $RABBIT_MQ_HOST
rabbit_userid = $RABBIT_MQ_USER
rabbit_password = $RABBIT_MQ_PASSWORD


[oslo_concurrency]
lock_path = /var/lock/cinder


EOT


sudo cat <<EOT >> $CINDER_API_FILE_LOCATION
auth_host = $KEYSTONE_NODE
auth_port = $KEYSTONE_AUTH_PORT
auth_protocol = http
auth_uri = http://$KEYSTONE_NODE:5000/v2.0
admin_user = $ADMIN_USER
admin_password = $ADMIN_PASS
auth_tenant_name = service
EOT


#<<7

sleep 5
sudo service cinder-api stop
sudo service cinder-scheduler stop
sudo service cinder-volume stop
sleep 3
sudo /bin/sh -c "cinder-manage db sync" $DATABASE_NAME

sleep 10

sudo apt-get install qemu-utils -y


 sudo service cinder-scheduler restart
 sudo service cinder-api restart
 sudo service cinder-volume restart
#7


