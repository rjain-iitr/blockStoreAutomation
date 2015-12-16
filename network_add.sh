
source cinder_deploy.conf


sudo cat <<EOT >> /etc/hosts


$CINDER_NODE_IP $CINDER_HOST
EOT
