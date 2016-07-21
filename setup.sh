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

echo "Prepping docker"
yum install -y wget
wget -qO- https://get.docker.com/ | sh
sudo usermod -aG docker $(whoami)
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo yum install -y epel-release
sudo yum install -y python-pip
/usr/bin/yes | sudo pip install docker-compose
sudo yum upgrade python*

docker-compose build
docker-compose run app bundle install --path /remote_gems --without test
docker-compose run app bundle exec rake assets:precompile
docker-compose run app bundle exec rake db:create db:migrate
docker-compose run app bundle exec rake db:seed
docker-compose up
