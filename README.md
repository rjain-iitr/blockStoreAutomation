# blockStoreAutomation
Cinder Controller nodes
1)copy new cinder packages on the noce
2)update the cinder_deploy.conf


2) run networkadd.sh (this add host entry of the nodes )
 sudo networkadd.sh

3) run cinder_deploy_newpackaes.sh
sudo cinder_deploy_newpackages.sh

4)
run ceph_shellfile.sh on ceph node

sudo ./ceph_shellfile.sh

5)run cinder_with_ceph_deploy.sh on cinder node

sudo ./cinder_with_ceph_deploy.sh
