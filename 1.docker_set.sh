#-----------------------------------------------------------------------------------
#--    Pre Job   
#-----------------------------------------------------------------------------------
# vi /etc/hosts
#    172.30.0.201  a220

# vi /etc/fstab
#    a220:/tools     /tools          nfs defaults    0 0

# mkdir -v /tools
# mount -a

#-----------------------------------------
# 2. Docker Disk add - VMware 30G HDD 
#-----------------------------------------
# fdisk -l

# fdisk /dev/sdb
#    n  > Enter > Enter > Enter 
#    p  > w 

# mkfs -t ext4 /dev/sdb1 

#mkdir /docker
#mount /dev/sdb1   /docker

#vi /etc/fstab
#   /dev/sdb1   /docker ext4  defaults 0 0

####################################################################################
### 0. setting file copy
####################################################################################
\cp -rpf /tools/env/std/crontab/root    /var/spool/cron/root    ## 2-1. Crontab
\cp -rpf /tools/env/std/rc.local        /etc/rc.d/rc.local      ## 2-2. rc.local
\cp -rpf /tools/env/std/hosts           /etc/hosts              ## 2-3. hosts

#############################################################
### 1. CentOS7.7 Everything  Repo Set
########################################
\rm -f /etc/yum.repos.d/*.repo  
\cp -rp /tools/env/std/repo/centos7.7.repo /etc/yum.repos.d/
\cp -rp /tools/env/std/repo/docker.repo    /etc/yum.repos.d/
yum clean all
yum repolist
yum list 

########################################
### 2. Docker Install 
########################################
#yum -y localinstall /tools/env/pkg/dockerRepo/container-selinux-2.107-3.el7.noarch.rpm
#yum install containerd.io-1.2.6-3.3.el7.x86_64 docker-ce.x86_64 docker-ce-selinux.noarch docker-ce-cli.x86_64

yum -y install /tools/env/pkg/docker/dockerRepo/container-selinux-2.107-3.el7.noarch.rpm
yum -y install containerd.io.x86_64 docker-ce.x86_64 docker-ce-cli.x86_64
#yum -y instatll docker-ce-selinux.noarch

mkdir /docker/default /docker/data
\cp -rp /tools/env/pkg/docker/docker.service  /usr/lib/systemd/system/docker.service

systemctl start   docker 
systemctl daemon-reload 
systemctl restart docker 
systemctl enable  docker 

########################################
### 3. Docker-Compose Setting 
########################################
\cp -rp /tools/env/pkg/docker/docker-compose   /usr/local/bin/docker-compose

########################################
### 4. Packages install (Util)  
########################################
## 3-1. ntpdate 
yum -y install ntpdate					
/usr/sbin/ntpdate 172.30.0.82 && /sbin/clock -w

#yum -y install vim-X11							## 3-2. gvim 
#rpm -Uvh  /tools/env/util/gftp-2.0.19-20.el7.x86_64.rpm		## 3-4. gftp

## 3-5. node exporter
tar zxvf /tools/env/util/node_exporter-0.17.0.linux-amd64.tar.gz -C /  	## 1) tar
ln -s    /node_exporter-0.17.0.linux-amd64/   /node_exporter	       	## 2) Symbolic link
/node_exporter/node_exporter & 					       	## 3) Exec ( rc.local )

