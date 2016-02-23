sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
yum -y install gcc make gcc-c++ kernel-devel-`uname -r` perl

rpm --import https://s3.amazonaws.com/download.draios.com/DRAIOS-GPG-KEY.public
curl -s -o /etc/yum.repos.d/draios.repo http://download.draios.com/stable/rpm/draios.repo
yum -y install kernel-devel-$(uname -r)
yum -y install sysdig

# Install jq to parse json
yum install -y jq vim emacs

# Turn off firewall
systemctl status firewalld
service firewalld stop

# Update Yum repo for docker-engine on RHEL 7.0
cat >/etc/yum.repos.d/docker.repo <<-EOF
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

# Install docker-engine
yum install -y docker-engine

# Start at boot, and run now
# sudo systemctl enable docker.service
chkconfig docker on
systemctl start docker.service

# Add current user to docker group
gpasswd -a ${USER} docker
gpasswd -a vagrant docker

# Get Docker-compose
sudo -i curl -L https://github.com/docker/compose/releases/download/1.6.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
sudo -i chmod +x /usr/local/bin/docker-compose

# Get Docker-machine
sudo curl -L https://github.com/docker/machine/releases/download/v0.6.0/docker-machine-`uname -s`-`uname -m` > /usr/local/bin/docker-machine && \
sudo chmod +x /usr/local/bin/docker-machine

# Install Nodejs & NPM
sudo yum install epel-release
sudo yum install nodejs
sudo yum install npm

