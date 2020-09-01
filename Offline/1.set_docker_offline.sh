####################################################################################
############# 2. Storage Volumn이 없는 경우
####################################################################################
### << 인터넷이 안되는 환경에서 Docker 설치 및 Monitoring 솔루션 적용하는 방법 >>
####################################################################################
### docker-set.tar 파일을 제공한다.
### 루트 경로에 압축을 해제한다. 
###       tar xvf ./docker-set.tar -C /
####################################################################################
########################################
### 1. Docker Install
########################################
### 1-1) RPM 설치 
rpm -Uvh /docker/dockerRepo/firefox-68.5.0-2.el7.centos.x86_64.rpm             	## firefox 하위버전에서는 Grafana 로그인 안됨
rpm -Uvh /docker/dockerRepo/container-selinux-2.107-3.el7.noarch.rpm           	## container-selinux
rpm -Uvh /docker/dockerRepo/Packages/containerd.io-1.2.13-3.1.el7.x86_64.rpm   	## containerd.io
rpm -Uvh /docker/dockerRepo/Packages/docker-ce-cli-19.03.8-3.el7.x86_64.rpm    	## docker-ce-cli
rpm -Uvh /docker/dockerRepo/Packages/docker-ce-19.03.8-3.el7.x86_64.rpm        	## docker-ce

#yum localinstall -y /docker/dockerRepo/firefox-68.5.0-2.el7.centos.x86_64.rpm            ## firefox 하위버전에서는 Grafana 로그인 안됨
#yum localinstall -y /docker/dockerRepo/container-selinux-2.107-3.el7.noarch.rpm          ## container-selinux
#yum localinstall -y /docker/dockerRepo/Packages/containerd.io-1.2.13-3.1.el7.x86_64.rpm  ## containerd.io
#yum localinstall -y /docker/dockerRepo/Packages/docker-ce-cli-19.03.8-3.el7.x86_64.rpm   ## docker-ce-cli
#yum localinstall -y /docker/dockerRepo/Packages/docker-ce-19.03.8-3.el7.x86_64.rpm       ## docker-ce

### 1-2) Docker 서비스 
systemctl start   docker
systemctl enable  docker

### 1-3) Docker-Compose 파일
\cp -rpf /docker/dockerRepo/docker-compose   /usr/local/bin/docker-compose

echo '1. Docker Server Init & Packages Seting Complete!!'

########################################
### 2. Monitoring Container 
########################################
### 2-1) Docker Image Load 
docker load < /docker/dockerRepo/image/prometheus.tar
docker load < /docker/dockerRepo/image/grafana.tar
docker images ## image 확인

### 2-2) Docker-Compose Up & Down -- /docker/volumes/monitoring 생성 
cd /docker/container/monitoring
docker-compose up -d
docker-compose down

### 2-3) Docker Volumes 권한 설정 
chmod -R 777 /docker/volumes/monitoring/prometheus
chmod -R 777 /docker/volumes/monitoring/grafana

### 2-4) Docker-Compose Up
\cp -rpf /docker/container/monitoring/prometheus.yml /docker/volumes/monitoring/prometheus/prometheus.yml
docker-compose up -d
docker ps

### 2-5) Docker Environment Setting 
source /docker/docker_bashrc

########################################
### 3. Node Exporter Install 
########################################
tar zxvf /docker/dockerRepo/node_exporter-0.17.0.linux-amd64.tar.gz -C /   ## 1) tar
ln -s    /node_exporter-0.17.0.linux-amd64/   /node_exporter               ## 2) Symbolic link
/node_exporter/node_exporter &                                             ## 3) Exec ( rc.local )

