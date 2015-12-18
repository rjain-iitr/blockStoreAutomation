


source cinder_deploy.conf


sudo cat <<EOT >> /etc/hosts

$GLANCE_NODE_IP $GLANCE_NODE
$KEYSTONE_NODE_IP $KEYSTONE_NODE
$CINDER_NODE_IP $CINDER_HOST
EOT
