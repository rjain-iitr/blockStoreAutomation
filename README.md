# blockStoreAutomation


1)copy new cinder packages on the cinder node

2)update the cinder_deploy.conf


3) run networkadd.sh on cinder node (this add host entry of the nodes )
 sudo ./networkadd.sh

4) run cinder_deploy_newpackaes.sh
sudo cinder_deploy_newpackages.sh

5)
run ceph_shellfile.sh on ceph node

sudo ./ceph_shellfile.sh

6) run database.sh (most steps are not automated here)

7)run cinder_with_ceph_deploy.sh on cinder node

sudo ./cinder_with_ceph_deploy.sh

