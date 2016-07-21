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

cd ~/rgts

touch config/application.yml
vi config/application.yml

touch /etc/yum.repos.d/docker.repo
echo "Prepping docker"
echo "[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg" > /etc/yum.repos.d/docker.repo
yum install -y epel-release python-pip
yum install -y docker-engine
service docker start
/usr/bin/yes | pip install virtualenv
mkdir /tmp/virtualenv
cd /tmp/virtualenv
virtualenv -p /usr/bin/python2.7 venv
source venv/bin/activate
pip freeze > requirements.txt
/usr/bin/yes | pip install docker-compose
yum upgrade python

cd ~/rgts

docker-compose build
docker-compose run app bundle install --path /remote_gems --without test
docker-compose run app bundle exec rake assets:precompile
docker-compose run app bundle exec rake db:create db:migrate
docker-compose run app bundle exec rake db:seed
docker-compose up
