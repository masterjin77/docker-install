####################################################################################
### Pre Job
####################################################################################
# vi /etc/hosts
#    172.30.0.201  a220

# vi /etc/fstab 
#    a220:/tools     /tools          nfs defaults    0 0
#    a220:/docker    /docker         nfs defaults    0 0 

# mkdir -v /tools /docker
# mount -a

####################################################################################
### 1. setting file copy
####################################################################################
\cp -rpf /tools/env/std/crontab/root 	/var/spool/cron/root	## 2-1. Crontab
\cp -rpf /tools/env/std/rc.local 	/etc/rc.d/rc.local 	## 2-2. rc.local
\cp -rpf /tools/env/std/hosts 		/etc/hosts		## 2-3. hosts
## echo $?   ### last command success(0) or fail(1~255 Error Code)

####################################################################################
# 2. CentOS7.7 Everything  Repo Set
####################################################################################
\rm -f /etc/yum.repos.d/*.repo  
\cp -rp /tools/env/std/repo/centos7.7.repo /etc/yum.repos.d/
\cp -rp /tools/env/std/repo/docker.repo    /etc/yum.repos.d/
yum clean all
yum repolist
yum list 

########################################
### 3. Docker Install
########################################
#yum -y localinstall /tools/env/pkg/dockerRepo/container-selinux-2.107-3.el7.noarch.rpm
#yum install containerd.io-1.2.6-3.3.el7.x86_64 docker-ce.x86_64 docker-ce-selinux.noarch docker-ce-cli.x86_64

yum -y install /tools/env/pkg/docker/dockerRepo/container-selinux-2.107-3.el7.noarch.rpm
yum -y install containerd.io.x86_64 docker-ce.x86_64 docker-ce-cli.x86_64
#yum -y instatll docker-ce-selinux.noarch

# default path change 
#mkdir /docker/default /docker/data
#\cp -rp /tools/env/pkg/docker/docker.service  /usr/lib/systemd/system/docker.service

systemctl start   docker
#systemctl daemon-reload
#systemctl restart docker
systemctl enable  docker

########################################
### 4. Docker-Compose Setting
########################################
\cp -rpf /tools/env/pkg/docker/docker-compose   /usr/local/bin/docker-compose
\cp -rpf /tools/env/pkg/docker/daemon.json      /etc/docker/daemon.json ## local Registry set
systemctl restart docker
####################################################################################
# 4. Packages install (Util)  
####################################################################################
yum -y install net-tools  					        ## 4-0. network command
#yum -y install ypbind.x86_64 yp-tools					## 4-1. nis_client 
yum -y install ntpdate; /usr/sbin/ntpdate 172.30.0.82 && /sbin/clock -w ## 4-2. ntpdate 
yum -y install vim vim-X11					        ## 4-3. gvim
#yum -y install firefox  						## 4-4. firefox
#rpm -Uvh  /tools/env/util/gftp-2.0.19-20.el7.x86_64.rpm			## 4-5. gftp

## 4-5. node exporter
tar zxvf /tools/env/util/node_exporter-0.17.0.linux-amd64.tar.gz -C /  	## 1) tar
ln -s    /node_exporter-0.17.0.linux-amd64/   /node_exporter	       	## 2) Symbolic link
/node_exporter/node_exporter & 					       	## 3) Exec ( rc.local )

echo '1. Docker Server Init & Packages Seting Complete!!'

####################################################################################
### 11. SSH 
####################################################################################
#echo '1. Start SSH '
#\cp -rpf /tools/env/std/sshd_config.centos7	/etc/ssh/sshd_config ## 1-1. sftp Deny
#chmod 700 /usr/bin/ssh					             			 ## 1-2. root Only

####################################################################################
### 12. SELinux Disable
####################################################################################
echo '2. Start SELinux Disable'
\cp -rpf /tools/env/std/security/selinux_config 		/etc/selinux/config  ## 2-1. selinux Disable

####################################################################################
### 13. Firewalld Disable (CentOS7)
####################################################################################
echo '3. Start Firewalld Disable '
systemctl stop firewalld
systemctl mask firewalld 
systemctl status firewalld 

####################################################################################
### 14. Iptables Setting
####################################################################################
#echo '4. Start Iptablse'
#yum -y install iptables-services

#\cp -rpf /tools/env/std/security/iptables 		/etc/sysconfig/iptables ## 4-1. iptables Policy
#\cp -rpf /etc/rsyslog.conf 				/etc/rsyslog.conf_ORG	## 4-2. iptables log Backup
#\cp -rpf /tools/env/std/security/rsyslog.conf	        /etc/rsyslog.conf       ## 4-3. iptables log Setting

#systemctl enable iptables
#systemctl start  iptables
#systemctl status iptables 
#iptables -nL

echo '2. Docker Server Security Seting Complete!!'
yum clean all

