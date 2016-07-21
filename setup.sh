#/bin/bash

#Setup Git
echo "Setting up Git..."
mkdir ~/.ssh
cd ~/.ssh
touch id_rsa
touch id_rsa.pub
vi id_rsa
vi id_rsa.pub
chmod 400 id_rsa

cd ~

echo "Installing Git"
yum install git -y
mkdir ~/.git
touch ~/.git/config
echo "Enter your Git username: "
read username
git config --add user.name $username
echo "Enter your Git email: "
read email
git config --add user.email $email
git clone git@github.com:riotgameseurope/rgts.git
cd rgts

touch config/application.yml
vi config/application.yml

echo "Prepping docker"
tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF 
