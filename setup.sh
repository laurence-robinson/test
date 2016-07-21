#/bin/bash

#Setup Git
echo "Setting up Git..."
mkdir ~/.ssh
cd ~/.ssh
touch id_rsa
touch id_rsa.pub
echo "Please enter the private ssh key for Git: "
read private
echo $private > id_rsa
echo "Please enter the public ssh key for Git: "
read public
echo $public > id_rsa.pub
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
git config --add user.email $email
git clone git@github.com:riotgameseurope/rgts.git
cd rgts

echo "Please copy in your application.yml: "
read application
touch config/application.yml
echo $application > config/application.yml

echo "Prepping docker"
tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF 
