####################################################################################
############# 2. Storage Volumn이 없는 경우
####################################################################################
####################################################################################
### << 인터넷이 안되는 환경에서 Docker 설치 및 Monitoring 솔루션 삭제하는 방법 >>
####################################################################################
### 1. Monitoring Container Stop 
########################################
cd /docker/container/monitoring
docker-compose down
cd /
########################################
### 2. Docker Image Remove
########################################
docker rmi prom/prometheus
docker rmi grafana/grafana

########################################
### 3. Docker-Compose Remove
########################################
\rm -rf /usr/local/bin/docker-compose

########################################
### 4. Docker Service Stop
########################################
systemctl diable docker
systemctl stop   docker

########################################
### 5. Docker RPM Remove
########################################
rpm -e firefox-68.5.0-2.el7.centos.x86_64	## firefox 하위버전에서는 Grafana 로그인 안됨
## docker-ce && docker-ce-cli      		## container-selinux의 의존성 대상
## container-selinux && containerd.io
rpm -e docker-ce-cli-19.03.8-3.el7.x86_64 docker-ce-19.03.8-3.el7.x86_64
rpm -e containerd.io-1.2.13-3.1.el7.x86_64 container-selinux-2.107-3.el7.noarch

#yum remove -y firefox                    ## firefox 하위버전에서는 Grafana 로그인 안됨
#yum remove -y container-selinux.noarch   ## container-selinux
#yum remove -y containerd.io.x86_64       ## containerd.io
#yum remove -y docker-ce-cli.x86_64       ## docker-ce-cli
#yum remove -y docker-ce.x86_64           ## docker-ce

########################################
### 6. Node Exporter Remove
########################################
killall -9 /node_exporter/node_exporter         ## 1) NodeExporter Process kill
\rm -rf /node_exporter                          ## 2) Symbolic link Remove
\rm -rf /node_exporter-0.17.0.linux-amd64       ## 3) Install File Remove

########################################
### 7. Docker Folder Remove
########################################
\rm -rf /docker

echo '2. Docker Server & Packages Remove Complete!!'
